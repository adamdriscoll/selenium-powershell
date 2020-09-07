function Send-SeClick {
    param(
        [Parameter( ValueFromPipeline = $true, Position = 0)]
        [OpenQA.Selenium.IWebElement]$Element = $Driver.SeSelectedElements,
        [Switch]$JavaScript,
        $SleepSeconds = 0 ,
        $Driver = $script:SeDriversCurrent,
        [switch]$PassThru
    )
    Process {
        if ( (_IsSet-SeElement -Driver $Driver -Element ([ref]$Element)) -eq $false) { Write-Error -Message "An element must be set"; return }
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