function Save-SeScreenshot {
    [CmdletBinding(DefaultParameterSetName = 'Driver')]
    param(
        [Parameter(DontShow, ValueFromPipeline = $true, ParameterSetName = 'Pipeline')]
        [ValidateScript( {
                $Types = @([OpenQA.Selenium.IWebDriver], [OpenQA.Selenium.IWebElement], [OpenQA.Selenium.Screenshot])
                $Found = $false
                Foreach ($t in $Types) { if ($_ -is $t) { $Found = $true; break } }
                if ($found) { return $true } else { Throw "Input must be of one of the following types $($Types -join ',')" }
            })]
        $InputObject,
        [Parameter( Mandatory = $true, ParameterSetName = 'Screenshot')]
        [OpenQA.Selenium.Screenshot]$Screenshot,
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [OpenQA.Selenium.ScreenshotImageFormat]$ImageFormat = [OpenQA.Selenium.ScreenshotImageFormat]::Png,
        [Parameter(Mandatory = $true, ParameterSetName = 'Element')]
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebElement]$Element
    )

    begin {
        if ($PSCmdlet.ParameterSetName -eq 'Driver') {
            Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
        }
    }
    process {

        switch ($PSCmdlet.ParameterSetName) {
            'Pipeline' {
                switch ($InputObject) {
                    { $_ -is [OpenQA.Selenium.IWebElement] } { $Screenshot = $InputObject.GetScreenshot() }
                    { $_ -is [OpenQA.Selenium.IWebDriver] } { $Screenshot = [OpenQA.Selenium.Support.Extensions.WebDriverExtensions]::TakeScreenshot($InputObject) }
                    { $_ -is [OpenQA.Selenium.Screenshot] } { $Screenshot = $InputObject }
                }    
            }
            'Driver' { $Screenshot = New-SeScreenshot -Driver $Driver }
            'Element' { $Screenshot = New-SeScreenshot -Element $Element }
        }
        
        $Screenshot.SaveAsFile($Path, $ImageFormat)
    }
}
