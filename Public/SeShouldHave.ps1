function SeShouldHave {
    [cmdletbinding(DefaultParameterSetName = 'DefaultPS')]
    param(
        [Parameter(ParameterSetName = 'DefaultPS', Mandatory = $true , Position = 0, ValueFromPipeline = $true)]
        [Parameter(ParameterSetName = 'Element' , Mandatory = $true , Position = 0, ValueFromPipeline = $true)]
        [string[]]$Selection,

        [Parameter(ParameterSetName = 'DefaultPS', Mandatory = $false)]
        [Parameter(ParameterSetName = 'Element' , Mandatory = $false)]
        [ArgumentCompleter( { [Enum]::GetNames([SeBySelector]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBySelector]) })]
        [string]$By = [SeBySelector]::XPath,

        [Parameter(ParameterSetName = 'Element' , Mandatory = $true , Position = 1)]
        [string]$With,

        [Parameter(ParameterSetName = 'Alert' , Mandatory = $true)]
        [switch]$Alert,
        [Parameter(ParameterSetName = 'NoAlert' , Mandatory = $true)]
        [switch]$NoAlert,
        [Parameter(ParameterSetName = 'Title' , Mandatory = $true)]
        [switch]$Title,
        [Parameter(ParameterSetName = 'URL' , Mandatory = $true)]
        [switch]$URL,
        [Parameter(ParameterSetName = 'Element' , Mandatory = $false, Position = 3)]
        [Parameter(ParameterSetName = 'Alert' , Mandatory = $false, Position = 3)]
        [Parameter(ParameterSetName = 'Title' , Mandatory = $false, Position = 3)]
        [Parameter(ParameterSetName = 'URL' , Mandatory = $false, Position = 3)]
        [ValidateSet('like', 'notlike', 'match', 'notmatch', 'contains', 'eq', 'ne', 'gt', 'lt')]
        [OperatorTransformAttribute()]
        [String]$Operator = 'like',

        [Parameter(ParameterSetName = 'Element' , Mandatory = $false, Position = 4)]
        [Parameter(ParameterSetName = 'Alert' , Mandatory = $false, Position = 4)]
        [Parameter(ParameterSetName = 'Title' , Mandatory = $true , Position = 4)]
        [Parameter(ParameterSetName = 'URL' , Mandatory = $true , Position = 4)]
        [Alias('contains', 'like', 'notlike', 'match', 'notmatch', 'eq', 'ne', 'gt', 'lt')]
        [AllowEmptyString()]
        $Value,

        [Parameter(ParameterSetName = 'DefaultPS')]
        [Parameter(ParameterSetName = 'Element')]
        [Parameter(ParameterSetName = 'Alert')]
        [switch]$PassThru,

        [Double]$Timeout = 0
    )
    begin {
        $endTime = [datetime]::now.AddMilliseconds($Timeout * 1000)
        $lineText = $MyInvocation.Line.TrimEnd("$([System.Environment]::NewLine)")
        $lineNo = $MyInvocation.ScriptLineNumber
        $file = $MyInvocation.ScriptName
        Function expandErr {
            param ($message)
            [Management.Automation.ErrorRecord]::new(
                [System.Exception]::new($message),
                'PesterAssertionFailed',
                [Management.Automation.ErrorCategory]::InvalidResult,
                @{
                    Message  = $message
                    File     = $file
                    Line     = $lineNo
                    Linetext = $lineText
                }
            )
        }
        function applyTest {
            param(
                $Testitems,
                $Operator,
                $Value
            )
            Switch ($Operator) {
                'Contains' { return ($testitems -contains $Value) }
                'eq' { return ($TestItems -eq $Value) }
                'ne' { return ($TestItems -ne $Value) }
                'like' { return ($TestItems -like $Value) }
                'notlike' { return ($TestItems -notlike $Value) }
                'match' { return ($TestItems -match $Value) }
                'notmatch' { return ($TestItems -notmatch $Value) }
                'gt' { return ($TestItems -gt $Value) }
                'le' { return ($TestItems -lt $Value) }
            }
        }

        #if operator was not passed, allow it to be taken from an alias for the -value
        if (-not $PSBoundParameters.ContainsKey('operator') -and $lineText -match ' -(eq|ne|contains|match|notmatch|like|notlike|gt|lt) ') {
            $Operator = $matches[1]
        }
        $Success = $false
        $foundElements = [System.Collections.Generic.List[PSObject]]::new()
    }
    process {
        #If we have been asked to check URL or title get them from the driver. Otherwise call Get-SEElement.
        if ($URL) {
            do {
                $Success = applyTest -testitems $Script:SeDriversCurrent.Url -operator $Operator -value $Value
                Start-Sleep -Milliseconds 500
            }
            until ($Success -or [datetime]::now -gt $endTime)
            if (-not $Success) {
                throw (expandErr "PageURL was $($Script:SeDriversCurrent.Url). The comparison '-$operator $value' failed.")
            }
        }
        elseif ($Title) {
            do {
                $Success = applyTest -testitems $Script:SeDriversCurrent.Title -operator $Operator -value $Value
                Start-Sleep -Milliseconds 500
            }
            until ($Success -or [datetime]::now -gt $endTime)
            if (-not $Success) {
                throw (expandErr "Page title was $($Script:SeDriversCurrent.Title). The comparison '-$operator $value' failed.")
            }
        }
        elseif ($Alert -or $NoAlert) {
            do {
                try {
                    $a = $Script:SeDriversCurrent.SwitchTo().alert()
                    $Success = $true
                }
                catch {
                    Start-Sleep -Milliseconds 500
                }
                finally {
                    if ($NoAlert -and $a) { throw (expandErr "Expected no alert but an alert of '$($a.Text)' was displayed") }
                }
            }
            until ($Success -or [datetime]::now -gt $endTime)

            if ($Alert -and -not $Success) {
                throw (expandErr "Expected an alert but but none was displayed")
            }
            elseif ($value -and -not (applyTest -testitems $a.text -operator $Operator -value $value)) {
                throw (expandErr "Alert text was $($a.text). The comparison '-$operator $value' failed.")
            }
            elseif ($PassThru) { return $a }
        }
        else {
            foreach ($s in $Selection) {
                $GSEParams = @{By = $By; Value = $s }
                if ($Timeout) { $GSEParams['Timeout'] = $Timeout }
                try { $e = Get-SeElement @GSEParams -All }
                catch { throw (expandErr $_.Exception.Message) }

                #throw if we didn't get the element; if were only asked to check it was there, return gracefully
                if (-not $e) { throw (expandErr "Didn't find '$s' by $by") }
                else {
                    Write-Verbose "Matched element(s) for $s"
                    $foundElements.add($e)
                }
            }
        }
    }
    end {
        if ($PSCmdlet.ParameterSetName -eq "DefaultPS" -and $PassThru) { return $e }
        elseif ($PSCmdlet.ParameterSetName -eq "DefaultPS") { return }
        else {
            foreach ($e in $foundElements) {
                switch ($with) {
                    'Text' { $testItem = $e.Text }
                    'Displayed' { $testItem = $e.Displayed }
                    'Enabled' { $testItem = $e.Enabled }
                    'TagName' { $testItem = $e.TagName }
                    'X' { $testItem = $e.Location.X }
                    'Y' { $testItem = $e.Location.Y }
                    'Width' { $testItem = $e.Size.Width }
                    'Height' { $testItem = $e.Size.Height }
                    'Choice' { $testItem = (Get-SeSelectValue -Element $e -All) }
                    default { $testItem = $e.GetAttribute($with) }
                }
                if (-not $testItem -and ($Value -ne '' -and $foundElements.count -eq 1)) {
                    throw (expandErr "Didn't find '$with' on element")
                }
                if (applyTest -testitems $testItem -operator $Operator -value $Value) {
                    $Success = $true
                    if ($PassThru) { $e }
                }
            }
            if (-not $Success) {
                if ($foundElements.count -gt 1) {
                    throw (expandErr "$Selection match $($foundElements.Count) elements, none has a value for $with which passed the comparison '-$operator $value'.")
                }
                else {
                    throw (expandErr "$with had a value of $testitem which did not pass the the comparison '-$operator $value'.")
                }
            }
        }
    }
}