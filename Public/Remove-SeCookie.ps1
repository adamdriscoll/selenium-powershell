function Remove-SeCookie {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [Alias('Driver')]
        [OpenQA.Selenium.IWebDriver]
        $Target = $Global:SeDriver,
 
        [Parameter(Mandatory = $true, ParameterSetName = 'DeleteAllCookies')]
        [Alias('Purge')]
        [switch]$DeleteAllCookies,

        [Parameter(Mandatory = $true, ParameterSetName = 'NamedCookie')] 
        [string]$Name
    )

    if ($DeleteAllCookies) {
        $Target.Manage().Cookies.DeleteAllCookies()
    }
    else {
        $Target.Manage().Cookies.DeleteCookieNamed($Name)
    }
}