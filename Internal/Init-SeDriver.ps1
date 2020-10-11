function Init-SeDriver {
    [CmdletBinding()]
    param (
        [ref]$Driver,
        [OpenQA.Selenium.IWebElement[]]$Element
    )
    
    if ($null -ne $Driver.Value) { return }
    if ($null -ne $Element) { $Driver.Value = ($Element | Select -First 1).WrappedDriver }
    if ($null -ne $script:SeDriversCurrent) { $Driver.Value = $script:SeDriversCurrent; return }
    Throw [System.ArgumentNullException]::new("A driver need to be explicitely specified or implicitely available.")

    
    
}


