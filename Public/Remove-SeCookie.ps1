function Remove-SeCookie {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory = $true, ParameterSetName = 'NamedCookie')] 
        [string]$Name
    )
    $Driver = Init-SeDriver  -ErrorAction Stop
    if ($All) {
        $Driver.Manage().Cookies.DeleteAllCookies()
    }
    else {
        $Driver.Manage().Cookies.DeleteCookieNamed($Name)
    }
}