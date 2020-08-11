function Stop-SeDriver { 
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Target
    )
    $TextInfo = (Get-Culture).TextInfo

    if (! $PSBoundParameters.ContainsKey('Target')) {
        $Target = $script:SeDriversCurrent
    }


    if ($null -ne $Target) {
        $BrowserName = $TextInfo.ToTitleCase($Target.Capabilities.browsername)

        if ($null -eq $Target.SessionId) {
            Write-Warning "$BrowserName Driver already closed"
            return $null
        }

        Write-Verbose -Message "Closing $BrowserName $($Target.SeFriendlyName )..."
        [void]($script:SeDrivers.Remove($Target))
        $Target.Close()
        $Target.Dispose()    
        

        
       
    }
    else { Write-Warning 'A valid <IWebDriver> must be provided.' }
}