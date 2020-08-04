function Get-SeCookie {
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [Alias("Driver")]
        [ValidateIsWebDriverAttribute()]
        $Target = $Global:SeDriver
    )
    $Target.Manage().Cookies.AllCookies.GetEnumerator()
}