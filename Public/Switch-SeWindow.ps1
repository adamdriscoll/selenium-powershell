function Switch-SeWindow {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [Alias('Driver')]
        [OpenQA.Selenium.IWebDriver]
        $Target = $Global:SeDriver,

        [Parameter(Mandatory = $true)]$Window
    )

    process {
        $Target.SwitchTo().Window($Window) | Out-Null
    }
}