function Get-SeElementAttribute {
    param(
        [Parameter(ValueFromPipeline = $true, Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [Parameter(Mandatory = $true)]
        [string]$Attribute
    )
    process {
        $Element.GetAttribute($Attribute)
    }
}