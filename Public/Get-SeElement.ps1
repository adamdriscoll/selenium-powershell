function Get-SeElement {
    [Alias('Find-SeElement', 'SeElement')]
    param(
        #Specifies whether the selction text is to select by name, ID, Xpath etc
        [ValidateSet("CssSelector", "Name", "Id", "ClassName", "LinkText", "PartialLinkText", "TagName", "XPath")]
        [ByTransformAttribute()]
        [string]$By = "XPath",
        #Text to select on
        [Alias("CssSelector", "Name", "Id", "ClassName", "LinkText", "PartialLinkText", "TagName", "XPath")]
        [Parameter(Position = 1, Mandatory = $true)]
        [string]$Selection,
        #Specifies a time out
        [Parameter(Position = 2)]
        [Int]$Timeout = 0,
        #The driver or Element where the search should be performed.
        [Parameter(Position = 3, ValueFromPipeline = $true)]
        [Alias('Element', 'Driver')]
        $Target = $Global:SeDriver,

        [parameter(DontShow)]
        [Switch]$Wait

    )
    process {
        #if one of the old parameter names was used and BY was NIT specified, look for
        # <cmd/alias name> [anything which doesn't mean end of command] -Param
        # capture Param and set it as the value for by
        $mi = $MyInvocation.InvocationName
        if (-not $PSBoundParameters.ContainsKey("By") -and
            ($MyInvocation.Line -match "$mi[^>\|;]*-(CssSelector|Name|Id|ClassName|LinkText|PartialLinkText|TagName|XPath)")) {
            $By = $Matches[1]
        }
        if ($wait -and $Timeout -eq 0) { $Timeout = 30 }

        if ($TimeOut -and $Target -is [OpenQA.Selenium.Remote.RemoteWebDriver]) {
            $TargetElement = [OpenQA.Selenium.By]::$By($Selection)
            $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Target, (New-TimeSpan -Seconds $Timeout))
            $Condition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::ElementExists($TargetElement)
            $WebDriverWait.Until($Condition)
        }
        elseif ($Target -is [OpenQA.Selenium.Remote.RemoteWebElement] -or
            $Target -is [OpenQA.Selenium.Remote.RemoteWebDriver]) {
            if ($Timeout) { Write-Warning "Timeout does not apply when searching an Element" }
            $Target.FindElements([OpenQA.Selenium.By]::$By($Selection))
        }
        else { throw "No valid target was provided." }
    }
}