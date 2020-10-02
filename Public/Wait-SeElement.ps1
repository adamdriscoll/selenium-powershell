function Wait-SeElement {
    [Cmdletbinding(DefaultParameterSetName = 'Element')]
    param(
        [ArgumentCompleter( { [Enum]::GetNames([SeBySelector]) })]
        [ValidateScript( { $_ -in [Enum]::GetNames([SeBySelector]) })]
        [Parameter(ParameterSetName = 'Locator', Position = 0, Mandatory = $true)]
        [SeBySelector]$By = [SeBySelector]::XPath,
        [Parameter(Position = 1, Mandatory = $true, ParameterSetName = 'Locator')]
        [string]$Value,

        [Parameter(ParameterSetName = 'Element', Mandatory = $true)]
        [OpenQA.Selenium.IWebElement]$Element,
        [ArgumentCompleter([SeElementsConditionsCompleter])]
        [ValidateScript( { Get-SeElementsConditionsValidation -Condition $_ -By $By })]
        $Condition,
        [ValidateScript( { Get-SeElementsConditionsValueValidation -By $By -Element $Element -Condition $Condition -ConditionValue $_ })]
        [ValidateNotNull()]
        $ConditionValue,
        
     
        #Specifies a time out
        [Double]$Timeout = 3,
        #The driver or Element where the search should be performed.
        [Parameter( ValueFromPipeline = $true)]
        $Driver

    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
        $ImpTimeout = -1 

        $ExpectedValueType = Get-SeElementsConditionsValueType -text $Condition
        #Manage ConditionValue not provided when expected
        if (! $PSBoundParameters.ContainsKey('ConditionValue')) {
            if ($null -ne $ExpectedValueType) {
                Write-Error "The $Condtion condtion does expect a ConditionValue of type $ExpectedValueType (None provided)."
                return $null
            }
        }
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



