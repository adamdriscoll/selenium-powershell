function Get-SeElementCssValue {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebElement]$Element = $Driver.SeSelectedElements,
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    Process {
        if ( (_IsSet-SeElement -Driver $Driver -Element ([ref]$Element)) -eq $false) { Write-Error -Message "An element must be set"; return }
        $Element.GetCssValue($Name)
    }
}