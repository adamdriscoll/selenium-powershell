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
        $MyAttributes = @{Attributes = [System.Collections.Generic.List[String]]::new()}
        $SelectedAttribute = ""
        $LoadAllAttributes = $false

        if ($PSBoundParameters.Remove('Attributes')) {
            $MyAttributes = @{Attributes = [System.Collections.Generic.List[String]]$Attributes }
            $LoadAllAttributes = $Attributes.Count -eq 1 -and  $Attributes[0] -eq '*'
            if ($Attributes[0] -ne '*') { $SelectedAttribute = $MyAttributes.Attributes[0] }
        }

        if (!$LoadAllAttributes){
            if ($PSBoundParameters.Remove('Type')) {
                if (-not $MyAttributes.Attributes.Contains('type')) { $MyAttributes.Attributes.add('type') }
            }
            if (-not $MyAttributes.Attributes.Contains('placeholder')) { $MyAttributes.Attributes.add('placeholder') }
            if (-not $MyAttributes.Attributes.Contains('value')) { $MyAttributes.Attributes.add('value') }
        }


        [void]($PSBoundParameters.Remove('Value'))

        $Filter = [scriptblock]::Create(@"
            if ("" -ne "$Type") { if (`$_.Attributes.type -ne "$type") { return } }
            if ("" -ne "$Text") { if (`$_.Text -ne "$Text" ) { return } }
            if ("" -ne "$Value" -and "" -ne "$SelectedAttribute") { if (`$_.Attributes."$SelectedAttribute" -ne "$Value" ) { return } }
            `$_
"@)

        Get-SeElement -By TagName -Value input @PSBoundParameters @MyAttributes -Filter $Filter | ForEach-Object {
            $_.Psobject.TypeNames.Insert(0, 'selenium-powershell/SeInput')
            $_
        } 

    }
}

