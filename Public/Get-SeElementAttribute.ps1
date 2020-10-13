function Get-SeElementAttribute {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Parameter(Mandatory = $true)]
        [string[]]$Name
    )
    Begin {
        $Script = 'var items = {}; for (index = 0; index < arguments[0].attributes.length; ++index) { items[arguments[0].attributes[index].name] = arguments[0].attributes[index].value }; return items;'
    }
    process {
        $AllAttributes = $Name.Count -eq 1 -and $Name[0] -eq '*'
        $ManyAttributes = $Name.Count -gt 1

        if ($AllAttributes) {
            $AllAttributes = $Element.WrappedDriver.ExecuteScript($Script, $Element)
            $Output = @{}
            
            Foreach ($Att in $AllAttributes.Keys) {
                $value = $Element.GetAttribute($Att)
                if ($value -ne "") {
                    $Output.$Att = $value
                }
            }
            [PSCustomObject]$Output 
        }
        elseif ($ManyAttributes) {
            $Output = @{}
            Foreach ($Att in $Name) {
                $value = $Element.GetAttribute($Att)
                if ($value -ne "") {
                    $Output.$Att = $value
                }
            }
            [PSCustomObject]$Output
        }
        else {
            $Element.GetAttribute($Name)
        }

        
    }
}