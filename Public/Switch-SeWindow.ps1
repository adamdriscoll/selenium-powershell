function Switch-SeWindow {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Driver = $Script:SeDriversCurrent,

        [Parameter(Mandatory = $true)]$Window
    )

    process {
        $Driver.SwitchTo().Window($Window) | Out-Null
    }
}