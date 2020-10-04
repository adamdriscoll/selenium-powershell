function Invoke-SeJavascript {
    param(
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [String]$Script,
        [Parameter(Position = 1)]
        [Object[]]$ArgumentList,
        [OpenQA.Selenium.IWebDriver]$Driver
        
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    Process {
        $Driver.ExecuteScript($Script, $ArgumentList)
    }
    End {}
}

