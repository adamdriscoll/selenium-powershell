function Select-SeElement {
    param (
        [ValidateIsWebDriverAttribute()]
        $Driver = $Script:SeDriversCurrent,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebElement]
        $Element
        
    )
    $Driver.SeSelectedElements = $Element

}