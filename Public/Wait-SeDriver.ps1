function Wait-SeDriver {
    [Cmdletbinding(DefaultParameterSetName = 'Condition')]
    param(
        [ArgumentCompleter([SeDriverConditionsCompleter])]
        [ValidateScript( { Get-SeDriverConditionsValidation -Condition $_ })]
        [Parameter(Mandatory = $true, Position = 0, ParameterSetName = 'Condition')]
        $Condition,
        [Parameter(Mandatory = $true, Position = 1, ParameterSetName = 'Condition')]
        [ValidateScript( { Get-SeDriverConditionsValueValidation -Condition $Condition -Value $_ })]
        [ValidateNotNull()]
        $Value,
        [Parameter(Mandatory = $true, Position = 4, ParameterSetName = 'Script')]
        [ValidateNotNull()]
        [System.Func[OpenQA.Selenium.IWebDriver, Bool]]$Script,

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

        $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, (New-TimeSpan -Seconds $Timeout))
        if ($PSBoundParameters.ContainsKey('Condition')) {
            $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition($Value)
        }
        else {
            $SeCondition = $Script
        }
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





Register-ArgumentCompleter -CommandName Command-Name -ParameterName Name -ScriptBlock $MyArgumentCompletion