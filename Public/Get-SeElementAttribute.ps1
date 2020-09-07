function Get-SeElementAttribute {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebElement]$Element = $Driver.SeSelectedElements,
        [Parameter(Mandatory = $true)]
        [string]$Attribute
    )
    process {
        if ( (_IsSet-SeElement -Driver $Driver -Element ([ref]$Element)) -eq $false) { Write-Error -Message "An element must be set"; return }
        $Element.GetAttribute($Attribute)
    }
}