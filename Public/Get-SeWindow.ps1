function Get-SeWindow {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Driver = $Script:SeDriversCurrent
    )

    process {
        $Driver.WindowHandles
    }
}