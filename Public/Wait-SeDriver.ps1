function Wait-SeDriver {
    [Cmdletbinding()]
    param(
        [ArgumentCompleter([SeDriverConditionsCompleter])]
        [ValidateScript( { $_ -in $Script:SeDriverConditions.Text })]
        [Parameter(Position = 0, Mandatory = $true)]
        $Condition,
        [Parameter(Position = 1, Mandatory = $true)]
        [ValidateNotNull()]
        $Value,
        #Specifies a time out
        [Parameter(Position = 2)]
        [Double]$Timeout = 3
    )
    Begin {
        $Driver = Init-SeDriver  -ErrorAction Stop
        $ImpTimeout = -1
        Test-SeDriverConditionsValueValidation -Condition $Condition -Value $Value -Erroraction Stop
    }
    process {
        $ImpTimeout = Disable-SeDriverImplicitTimeout -Driver $Driver 
        if ($Condition -eq 'ScriptBlock') {
            $SeCondition = [System.Func[OpenQA.Selenium.IWebDriver, Bool]]$Value
        }
        else {
            $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition($Value)
        }
        $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, ([timespan]::FromMilliseconds($Timeout * 1000)))
            
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