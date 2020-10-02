function Invoke-SeJavascript {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]$Driver,
        [String]$Script,
        [Object[]]$ArgumentList
        
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    Process {
        $Driver.ExecuteScript($Script, $ArgumentList)
    }
    End {}
}

