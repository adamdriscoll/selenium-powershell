function Test-SeDriverAcceptInsecureCertificates {
    [CmdletBinding()]
    param (
        $Browser, [ref]$AcceptInsecureCertificates,
        $Boundparameters
    )

    $SupportedBrowsers = @('Chrome','Edge','Firefox')
    if ($Browser -in $SupportedBrowsers) { 
        return 
    }
    else {
        Throw ([System.NotImplementedException]::new(@"
AcceptInsecureCertificates parameter is only supported by the following browser: $($SupportedBrowsers -join ',')
Selected browser: $Browser
"@))
    }
}