function Get-SeHtml {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [switch]$Inner        
    )
    Begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    Process {
        if ($PSBoundParameters.ContainsKey('Element')) {
            if ($Inner) { return $Element.GetAttribute('innerHTML') }
            return $Element.GetAttribute('outerHTML')
        }
        else {
            $Driver.PageSource
        }
        
    }
}

