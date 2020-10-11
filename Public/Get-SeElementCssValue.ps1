function Get-SeElementCssValue {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Parameter(Mandatory = $true)]
        [string[]]$Name
    )
    Begin {
        $ScriptAllValues = @'
 var items = {};
var o = getComputedStyle(arguments[0]);
for(var i = 0; i < o.length; i++){
    items[o[i]] =  o.getPropertyValue(o[i])
}
return items;
'@
    }
    Process {
        $AllValues = $Name.Count -eq 1 -and $Name[0] -eq '*'
        $ManyValues = $Name.Count -gt 1


        if ($AllValues) {

            $AllCSSNames = $Element.WrappedDriver.ExecuteScript($ScriptAllValues, $Element)
            $Output = @{}
            
            Foreach ($Att in $AllCSSNames.Keys) {
                $value = $Element.GetCssValue($Att)
                if ($value -ne "") {
                    $Output.$Att = $value
                }
            }
            [PSCustomObject]$Output 
        }
        elseif ($ManyValues) {
            $Output = @{}
            Foreach ($Item in $Name) {
                $Value = $Element.GetCssValue($Item)
                if ($Value -ne "") {
                    $Output.$Item = $Value
                }
            }
            [PSCustomObject]$Output
        }
        else {
            $Element.GetCssValue($Name)
        }


    }
}
