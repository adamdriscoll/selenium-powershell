function Get-SeSelectValue {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param (
        [Parameter( ValueFromPipeline = $true, Position = 1)]
        [OpenQA.Selenium.IWebElement]$Element = $Driver.SeSelectedElements,
        [ref]$IsMultiSelect,
        [Switch]$All
    )
    try {
     
        $IsMultiSelectResult = [SeleniumSelection.Option]::IsMultiSelect($Element)
        
        if ($PSBoundParameters.ContainsKey('IsMultiSelect')) { $IsMultiSelect.Value = $IsMultiSelectResult }

        if ($All) {
            return  ([SeleniumSelection.Option]::GetOptions($Element)).Text
        }
        elseif ($IsMultiSelectResult) {
            return [SeleniumSelection.Option]::GetAllSelectedOptions($Element).text
        }
        else {
            return [SeleniumSelection.Option]::GetSelectedOption($Element).text
        }

        
               

    }
    catch {
        throw "An error occured checking the selection box, the message was:`r`n $($_.exception.message)"
    }
}