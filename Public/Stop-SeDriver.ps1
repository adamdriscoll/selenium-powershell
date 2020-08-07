function Stop-SeDriver { 
    [alias('SeClose')]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [Alias('Driver')]
        [ValidateNotNullOrEmpty()]
        [OpenQA.Selenium.IWebDriver]
        $Target = $Global:SeDriver
    )
    $TextInfo = (Get-Culture).TextInfo
    if (($null -ne $Target) -and ($Target -is [OpenQA.Selenium.IWebDriver])) {
        $BrowserName = $TextInfo.ToTitleCase($Target.Capabilities.browsername)

        if ($null -eq $Target.SessionId) {
            Write-Warning "$BrowserName Driver already closed"
            return $null
        }

        Write-Verbose -Message "Closing $BrowserName..."
        $Target.Close()
        $Target.Dispose()    
        
        
        if ($Target -eq $Global:SeDriver) { Remove-Variable -Name SeDriver -Scope global }
    }
    else { Write-Warning 'A valid <IWebDriver> must be provided.' }
}