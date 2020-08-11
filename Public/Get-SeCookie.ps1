function Get-SeCookie {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateIsWebDriverAttribute()]
        $Driver = $Script:SeDriversCurrent
    )
    $Driver.Manage().Cookies.AllCookies.GetEnumerator()
}