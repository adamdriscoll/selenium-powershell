function Remove-SeCookie {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]
        $Target = $Script:SeDriversCurrent,
 
        [Parameter(Mandatory = $true, ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory = $true, ParameterSetName = 'NamedCookie')] 
        [string]$Name
    )

    if ($All) {
        $Target.Manage().Cookies.DeleteAllCookies()
    }
    else {
        $Target.Manage().Cookies.DeleteCookieNamed($Name)
    }
}