<#
.SYNOPSIS
    Enable ImplicitWait on the specified driver.
.DESCRIPTION
    Enable ImplicitWait on the specified driver. See the corresponding Disable cmdlet for more information.
.EXAMPLE
    PS C:\> Enable-SeDriverImplicitTimeout -Driver $Driver -Timeout $ImpTimeout
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
function Enable-SeDriverImplicitTimeout {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]$Driver,
        [timespan]$Timeout
    )
    $Driver.Manage().Timeouts().ImplicitWait = $Timeout
}

