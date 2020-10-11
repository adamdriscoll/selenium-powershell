function Get-SeCookie {
    [CmdletBinding()]
    param()
    $Driver = Init-SeDriver -ErrorAction Stop
    $Driver.Manage().Cookies.AllCookies.GetEnumerator()
}