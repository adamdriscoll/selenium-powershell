function Get-SeHtml {
    param(
        [OpenQA.Selenium.IWebElement]$Element = $Driver.SeSelectedElements,
        [switch]$Inner
        
    )
    if ($Inner) { return $Element.GetAttribute('innerHTML') }
    return $Element.GetAttribute('outerHTML')
}

