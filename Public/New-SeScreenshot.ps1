function New-SeScreenshot {
    
    [cmdletbinding(DefaultParameterSetName = 'Path')]
    param(
        [Parameter(DontShow, ValueFromPipeline = $true, ParameterSetName = 'Pipeline')]
        [ValidateScript( {
                $Types = @([OpenQA.Selenium.IWebDriver], [OpenQA.Selenium.IWebElement])
                $Found = $false
                Foreach ($t in $Types) { if ($_ -is $t) { $Found = $true; break } }
                if ($found) { return $true } else { Throw "Input must be of one of the following types $($Types -join ',')" }
            })]
        $InputObject,
        [Switch]$AsBase64EncodedString,
        [Parameter(ParameterSetName = 'Element')]
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebElement]$Element
    )
    Begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    Process {
        switch ($PSCmdlet.ParameterSetName) {
            'Pipeline' {
                switch ($InputObject) {
                    { $_ -is [OpenQA.Selenium.IWebElement] } { $Screenshot = $InputObject.GetScreenshot() }
                    { $_ -is [OpenQA.Selenium.IWebDriver] } { $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($InputObject) }
                }                
            }
            'Element' { $Screenshot = $Element.GetScreenshot() }
            'Driver' { $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($Driver) }
        }

        if ($AsBase64EncodedString) { 
            return $Screenshot.AsBase64EncodedString 
        }
        else {
            return $Screenshot
        }
    }
    End {}
    
    
}