function Get-SeElementAttribute {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Parameter(Mandatory = $true)]
        [string[]]$Attribute
    )
    process {
        $AllAttributes = $Attribute.Count -eq 1 -and $Attribute[0] -eq '*'
        $ManyAttributes = $Attribute.Count -gt 1

        if ($AllAttributes) {
            $AllAttributes = $Element.WrappedDriver.ExecuteScript('var items = {}; for (index = 0; index < arguments[0].attributes.length; ++index) { items[arguments[0].attributes[index].name] = arguments[0].attributes[index].value }; return items;', $Element)
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
            Foreach ($Att in $Attribute) {
                $value = $Element.GetAttribute($Att)
                if ($value -ne "") {
                    $Output.$Att = $value
                }
            }
            [PSCustomObject]$Output
        }
        else {
            $Element.GetAttribute($Attribute)
        }

        
    }
}