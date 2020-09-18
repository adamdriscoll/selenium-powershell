function Get-SeHtml {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [switch]$Inner
        
    )
    if ($Inner) { return $Element.GetAttribute('innerHTML') }
    return $Element.GetAttribute('outerHTML')
}

