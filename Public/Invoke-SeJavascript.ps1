function Invoke-SeJavascript {
    [CmdletBinding()]
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
        #Fix #165 
        $MYargumentList = Foreach ($item in $ArgumentList) {
            $Item -as $Item.GetType()
        }
        $Driver.ExecuteScript($Script, $MyArgumentList)
    }
    End {}
}

