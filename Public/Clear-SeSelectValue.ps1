function Clear-SeSelectValue {
    [Cmdletbinding()]
    param (
        [OpenQA.Selenium.IWebElement]$Element = $Driver.SeSelectedElements
    )


    
    

    [SeleniumSelection.Option]::DeselectAll($Element)        
  
}

