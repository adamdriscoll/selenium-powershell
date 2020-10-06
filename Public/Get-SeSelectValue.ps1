function Get-SeSelectValue {
    [cmdletbinding(DefaultParameterSetName = 'default')]
    param (
        [Parameter( ValueFromPipeline = $true, Mandatory = $true, Position = 1)]
        [OpenQA.Selenium.IWebElement]$Element
    )
    try {
        $IsMultiSelectResult = [SeleniumSelection.Option]::IsMultiSelect($Element)
        
        if ($IsMultiSelectResult) {
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