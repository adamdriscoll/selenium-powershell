function Get-SeWindow {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Target = $Script:SeDriversCurrent
    )

    process {
        $Target.WindowHandles
    }
}