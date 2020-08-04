function Get-SeWindow {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [Alias('Driver')]
        [OpenQA.Selenium.IWebDriver]
        $Target = $Global:SeDriver
    )

    process {
        $Target.WindowHandles
    }
}