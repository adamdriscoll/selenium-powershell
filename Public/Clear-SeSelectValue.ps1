function Clear-SeSelectValue {
    [Cmdletbinding()]
    param (
        [Parameter(Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element 
    )
    [SeleniumSelection.Option]::DeselectAll($Element)        
  
}

