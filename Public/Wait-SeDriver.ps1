function Wait-SeDriver {
    [Cmdletbinding()]
    param(
        [ArgumentCompleter([SeDriverConditionsCompleter])]
        [ValidateScript( { Get-SeDriverConditionsValidation -Condition $_ })]
        [Parameter(Mandatory = $true, Position = 0)]
        $Condition,
        [Parameter(Mandatory = $true, Position = 1)]
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
     
        $WebDriverWait = [OpenQA.Selenium.Support.UI.WebDriverWait]::new($Driver, (New-TimeSpan -Seconds $Timeout))
        $SeCondition = [OpenQA.Selenium.Support.UI.ExpectedConditions]::$Condition($Value)
        
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