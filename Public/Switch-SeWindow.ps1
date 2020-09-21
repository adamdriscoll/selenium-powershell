function Switch-SeWindow {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Driver,

        [Parameter(Mandatory = $true)]$Window
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    process {
        $Driver.SwitchTo().Window($Window) | Out-Null
    }
}