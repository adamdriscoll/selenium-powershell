function Get-SeElementAttribute {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebElement]$Element = $Driver.SeSelectedElements,
        [Parameter(Mandatory = $true)]
        [string]$Attribute
    )
    process {
        
        $Element.GetAttribute($Attribute)
    }
}