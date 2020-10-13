function Get-SeHtml {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [switch]$Inner        
    )
    Begin {
        $Driver = Init-SeDriver -ErrorAction Stop
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

