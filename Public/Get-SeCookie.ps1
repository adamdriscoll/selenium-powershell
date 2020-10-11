function Get-SeCookie {
    [CmdletBinding()]
    param()
    Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    $Driver.Manage().Cookies.AllCookies.GetEnumerator()
}