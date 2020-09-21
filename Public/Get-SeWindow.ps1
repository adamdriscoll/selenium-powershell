function Get-SeWindow {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Driver 
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    process {
        $Driver.WindowHandles
    }
}