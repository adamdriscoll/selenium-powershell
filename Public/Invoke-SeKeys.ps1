function Invoke-SeKeys {
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter( Position = 0, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebElement]$Element ,
        [Parameter(Mandatory = $true, Position = 1)]
        [AllowEmptyString()]
        [string]$Keys,
        [switch]$ClearFirst,
        [Double]$Sleep = 0 ,
        [switch]$Submit,
        [switch]$PassThru,
        [ValidateNotNull()]
        [OpenQA.Selenium.IWebDriver]$Driver
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
        
        foreach ($Key in $Script:SeKeys.Name) {
            $Keys = $Keys -replace "{{$Key}}", [OpenQA.Selenium.Keys]::$Key
        }
    }
    process {

        if ($PSBoundParameters.ContainsKey('Element')) {
            if ($ClearFirst) { $Element.Clear() }
            $Element.SendKeys($Keys)
            if ($Submit) { $Element.Submit() }
        }
        else {
            $Action = [OpenQA.Selenium.Interactions.Actions]::new($Driver)
            $Action.SendKeys($Keys).Perform()
        }
       
        if ($Sleep) { Start-Sleep -Milliseconds ($Sleep * 1000) }
        if ($PassThru) { $Element }
    }
}
# #KeyDown
# #KeyUp