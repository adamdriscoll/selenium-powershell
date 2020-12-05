function Get-SeInput {
    [CmdletBinding()]
    param(
        [ArgumentCompleter( { @('button', 'checkbox', 'color', 'date', 'datetime-local', 'email', 'file', 'hidden', 'image', 'month', 'number', 'password', 'radio', 'range', 'reset', 'search', 'submit', 'tel', 'text', 'time', 'url', 'week') })]
        [String]$Type,
        [Switch]$Single,
        [String]$Text,
        [Double]$Timeout,
        [Switch]$All,
        [String[]]$Attributes,
        [String]$Value

    
    )
    Begin {
        $Driver = Init-SeDriver -ErrorAction Stop
    }
    Process {
        $MyAttributes = @{}
        $SelectedAttribute = ""

        if ($PSBoundParameters.Remove('Attributes')) {
            $MyAttributes = @{Attributes = [System.Collections.Generic.List[String]]$Attributes }
            if ($Attributes[0] -ne '*') { $SelectedAttribute = $MyAttributes.Attributes[0] }
        }
        if ($PSBoundParameters.Remove('Type')) {
            if ($null -eq $Attributes) {
                $MyAttributes = @{Attributes = 'type' }
            }
            else {
                if (-not $Attributes.contains('type') -and -not $Attributes.contains('*')) {
                    $MyAttributes.Attributes.add('type') 
                }
            }

            
        }
        [void]($PSBoundParameters.Remove('Value'))

        $Filter = [scriptblock]::Create(@"
            if ("" -ne "$Type") { if (`$_.Attributes.type -ne "$type") { return } }
            if ("" -ne "$Text") { if (`$_.Text -ne "$Text" ) { return } }
            if ("" -ne "$Value" -and "" -ne "$SelectedAttribute") { if (`$_.Attributes."$SelectedAttribute" -ne "$Value" ) { return } }
            `$_
"@)
        Get-SeElement -By TagName -Value input @PSBoundParameters @MyAttributes -Filter $Filter

    }
}

