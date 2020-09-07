function Clear-SeSelectValue {
    [Cmdletbinding()]
    param (
        [OpenQA.Selenium.IWebElement]$Element = $Driver.SeSelectedElements
    )
    if ( (_IsSet-SeElement -Driver $Driver -Element ([ref]$Element)) -eq $false) { Write-Error -Message "An element must be set"; return }
    [SeleniumSelection.Option]::DeselectAll($Element)        
  
}

