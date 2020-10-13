function Wait-SeElement {
    [Cmdletbinding(DefaultParameterSetName = 'Element')]
    param(
        [ArgumentCompleter( { [Enum]::GetNames([SeBySelector]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBySelector]) })]
        [Parameter(ParameterSetName = 'Locator', Position = 0)]
        [SeBySelector]$By = [SeBySelector]::XPath,
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'Locator')]
        [string]$Value,

        [Parameter(ParameterSetName = 'Element', Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [ArgumentCompleter([SeElementsConditionsCompleter])]
        [ValidateScript( { $_ -in $Script:SeElementsConditions.Text })]
        $Condition,
        [ValidateNotNull()]
        $ConditionValue,
        #Specifies a time out
        [Double]$Timeout = 3

    )
    begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
        Test-SeElementConditionsValueValidation -By $By -Element $Element -Condition $Condition -ConditionValue $ConditionValue -ParameterSetName $PSCmdlet.ParameterSetName @Stop 
        $ImpTimeout = -1 

        $ExpectedValueType = Get-SeElementsConditionsValueType -text $Condition

    }
    process {
        $ImpTimeout = Disable-SeDriverImplicitTimeout -Driver $Driver

        $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, ([timespan]::FromMilliseconds($Timeout * 1000)))
        $NoExtraArg = $null -eq $ExpectedValueType
        
        if ($PSBoundParameters.ContainsKey('Element')) {
            if ($NoExtraArg) {
                $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition($Element)
            }
            else {
                $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition($Element, $ConditionValue)
            }
        }
        else {
            if ($NoExtraArg) {
                $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition([OpenQA.Selenium.By]::$By($Value))
            }
            else {
                $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition([OpenQA.Selenium.By]::$By($Value), $ConditionValue)
            }
        }

        try {
            [void]($WebDriverWait.Until($SeCondition))
            return $true
        }
        catch {
            Write-Error $_
            return $false
        }
        Finally {
            Enable-SeDriverImplicitTimeout -Driver $Driver -Timeout $ImpTimeout
        }
    }
}



