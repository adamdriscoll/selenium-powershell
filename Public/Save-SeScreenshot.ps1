function Save-SeScreenshot {
    param(
        [ValidateIsWebDriverAttribute()]
        [Parameter(ValueFromPipeline = $true, ParameterSetName = 'Default')]
        $Driver ,
        [Parameter(ValueFromPipeline = $true, Mandatory = $true, ParameterSetName = 'Screenshot')]
        [OpenQA.Selenium.Screenshot]$Screenshot,
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [Parameter()]
        [OpenQA.Selenium.ScreenshotImageFormat]$ImageFormat = [OpenQA.Selenium.ScreenshotImageFormat]::Png)

    begin {
        if ($PSCmdlet.ParameterSetName -eq 'Default') {
            Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
        }
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Default') {

            try {
                $Screenshot = New-SeScreenshot -Driver $Driver
            }
            catch {
                $PSCmdlet.ThrowTerminatingError($_)
            }
            
        }
        $Screenshot.SaveAsFile($Path, $ImageFormat)
    }
}
