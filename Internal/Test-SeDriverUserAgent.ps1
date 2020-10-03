function Test-SeDriverUserAgent {
    [CmdletBinding()]
    param (
        $Browser, [ref]$UserAgent,
        $Boundparameters
    )

    $SupportedBrowsers = @('Chrome', 'Firefox')
    if ($Browser -in $SupportedBrowsers) { 
        return 
    }
    else {
        Throw ([System.NotImplementedException]::new(@"
UserAgent parameter is only supported by the following browser: $($SupportedBrowsers -join ',')
Selected browser: $Browser
"@))
    }
}