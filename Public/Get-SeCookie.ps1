function Get-SeCookie {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateIsWebDriverAttribute()]
        $Driver 
    )
    Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    $Driver.Manage().Cookies.AllCookies.GetEnumerator()
}