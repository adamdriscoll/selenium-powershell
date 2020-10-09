function Get-SeSelectValue {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param (
        [Parameter( ValueFromPipeline = $true, Mandatory = $true, Position = 1)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Switch]$All
    )
    try {
        $IsMultiSelectResult = [SeleniumSelection.Option]::IsMultiSelect($Element)
        
        
        $SelectStatement = if ($IsMultiSelectResult) { 'GetAllSelectedOptions' } else { 'GetSelectedOption' }
        $Selected = [SeleniumSelection.Option]::$SelectStatement($Element) 
        $Items = @(foreach ($item in $Selected) {
                [PSCustomObject]@{
                    Text  = $Item.text
                    Value = Get-SeElementAttribute -Element $Item -Name value
                }
            })

        if (-not $All) {
            return $Items
        }
        else {
               
            $Index = 0
            $Options = Get-SeElement -Element $Element -By Tagname -Value option -Attributes value
            $Values = foreach ($Opt in $Options) {
                [PSCustomObject]@{
                    Index    = $Index
                    Text     = $Opt.text
                    Value    = $opt.Attributes.value
                    Selected = $Null -ne $Items.Value -and $Items.Value.Contains($opt.Attributes.value)
                }
                $Index += 1
            }
            return  [PSCustomObject]@{
                PSTypeName    = 'selenium-powershell/SeSelectValueInfo'
                IsMultiSelect = [SeleniumSelection.Option]::IsMultiSelect($Element)
                Items         = $Values
            }
        }



    }
    catch {
        throw "An error occured checking the selection box, the message was:`r`n $($_.exception.message)"
    }
}