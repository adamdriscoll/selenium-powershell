function Wait-SeDriver {
    [Cmdletbinding()]
    param(
        [ArgumentCompleter([SeDriverConditionsCompleter])]
        [ValidateScript( { Get-SeDriverConditionsValidation -Condition $_ })]
        [Parameter(Mandatory = $true)]
        $Condition,
        [ValidateScript( { Get-SeDriverConditionsValueValidation -Condition $Condition -Value $_ })]
        [ValidateNotNull()]
        $Value,
        #Specifies a time out
        [Parameter(Position = 2)]
        [Int]$Timeout = 3,
        #The driver or Element where the search should be performed.
        [Parameter(Position = 3, ValueFromPipeline = $true)]
        $Driver

    )
    Begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    process {
        if ($Condition -eq 'ScriptBlock') {
            $SeCondition =  [System.Func[OpenQA.Selenium.IWebDriver, Bool]]$Value
        }
        else {
            $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition($Value)
        }
        $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, (New-TimeSpan -Seconds $Timeout))
              
        try {
            [void]($WebDriverWait.Until($SeCondition))
            return $true
        }
        catch {
            Write-Error $_
            return $false
        }
    }
}