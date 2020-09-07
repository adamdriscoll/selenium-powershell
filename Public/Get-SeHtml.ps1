function Get-SeHtml {
    param(
        [OpenQA.Selenium.IWebElement]$Element,
        [switch]$Inner
        
    )
    if ( (_IsSet-SeElement -Driver $Driver -Element ([ref]$Element)) -eq $false) { Write-Error -Message "An element must be set"; return }
   
    if ($Inner) { return $Element.GetAttribute('innerHTML') }
    return $Element.GetAttribute('outerHTML')
}

