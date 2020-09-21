function Send-SeClick {
    param(
        [Parameter( ValueFromPipeline = $true, Mandatory = $true, Position = 0)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Switch]$JavaScript,
        $SleepSeconds = 0 ,
        $Driver ,
        [switch]$PassThru
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    Process {
        if ($JavaScriptClick) {
            try {
                $Driver.ExecuteScript("arguments[0].click()", $Element)
            }
            catch {
                $PSCmdlet.ThrowTerminatingError($_)
            }
        }
        else {
            $Element.Click()
        }

        if ($SleepSeconds) { Start-Sleep -Seconds $SleepSeconds }
        if ($PassThru) { $Element }
    }
}