function Get-SeHtml {
    param(
        [OpenQA.Selenium.IWebElement]$Element,
        [switch]$Inner
        
    )
    if ($Inner) { return $Element.GetAttribute('innerHTML') }
    return $Element.GetAttribute('outerHTML')
}

