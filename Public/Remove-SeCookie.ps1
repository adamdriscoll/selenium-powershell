function Remove-SeCookie {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Driver = $Script:SeDriversCurrent,
 
        [Parameter(Mandatory = $true, ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory = $true, ParameterSetName = 'NamedCookie')] 
        [string]$Name
    )

    if ($All) {
        $Driver.Manage().Cookies.DeleteAllCookies()
    }
    else {
        $Driver.Manage().Cookies.DeleteCookieNamed($Name)
    }
}