function Get-SeElementCssValue {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element = $Driver.SeSelectedElements,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    Process {
        $Element.GetCssValue($Name)
    }
}