function Remove-SeCookie {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = 'All')]
        [switch]$All,

        [Parameter(Mandatory = $true, ParameterSetName = 'NamedCookie')] 
        [string]$Name
    )
    Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    if ($All) {
        $Driver.Manage().Cookies.DeleteAllCookies()
    }
    else {
        $Driver.Manage().Cookies.DeleteCookieNamed($Name)
    }
}