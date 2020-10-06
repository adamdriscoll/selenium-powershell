function Get-SeSelectValueInfo {
    [cmdletbinding()]
    param (
        [Parameter( ValueFromPipeline = $true, Mandatory = $true, Position = 1)]
        [OpenQA.Selenium.IWebElement]$Element
    )
    try {

        $Index = 0
        $Options = Get-SeElement -Element $Element -By Tagname -Value option -Attributes value
        $Values = foreach ($Opt in $Options) {
            [PSCustomObject]@{
                PSTypeName = 'SeSelectValueInfo'
                Index      = $Index
                Text       = $Opt.text
                Value      = $opt.Attributes.value
            }
            $Index += 1
        }
        return  [PSCustomObject]@{
            PSTypeName    = 'SeSelectValueInfo'
            IsMultiSelect = [SeleniumSelection.Option]::IsMultiSelect($Element)
            Items         = $Values
        }
    }
    catch {
        Write-Error $_
    }

}