#TODO parameter set hell
function Clear-SeSelectValue {
    param (
        [OpenQA.Selenium.IWebElement]$Element
    )
    [SeleniumSelection.Option]::DeselectAll($Element)        
  
}

