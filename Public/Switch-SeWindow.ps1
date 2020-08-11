function Switch-SeWindow {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Target = $Script:SeDriversCurrent,

        [Parameter(Mandatory = $true)]$Window
    )

    process {
        $Target.SwitchTo().Window($Window) | Out-Null
    }
}