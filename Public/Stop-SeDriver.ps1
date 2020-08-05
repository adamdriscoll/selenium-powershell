function Stop-SeDriver { 
    [alias('SeClose')]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [Alias('Driver')]
        [ValidateNotNullOrEmpty()]
        [OpenQA.Selenium.IWebDriver]
        $Target = $Global:SeDriver
    )

    if (($null -ne $Target) -and ($Target -is [OpenQA.Selenium.IWebDriver])) {
        Write-Verbose -Message "Closing $($Target.Capabilities.browsername)..."
        $Target.Close()
        $Target.Dispose()
        if ($Target -eq $Global:SeDriver) { Remove-Variable -Name SeDriver -Scope global }
    }
    else { throw "A valid <IWebDriver> Target must be provided." }
}