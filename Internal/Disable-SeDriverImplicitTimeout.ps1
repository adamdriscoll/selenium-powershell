<#
.SYNOPSIS
   Disable Implicitt wait on the specidifed driver
.DESCRIPTION
    This cmdlet is used alongside the corresponding Enable cmdlet to temporarily disable
    Implicit wait whenever explicit wait are used.
.EXAMPLE
    PS C:\> $ImpTimeout = Disable-SeDriverImplicitTimeout -Driver $Driver
    Disable implicit wait on the specified driver and return the old timespan.
.INPUTS
    Inputs (if any)
.OUTPUTS
    Implicit wait Timespan obtained before setting it to 0
.NOTES
    These cmdlet are used because mixing ImplicitWait and ExplicitWait can have unintended consequences.
    Thus, implicit wait should always temporarily be disabled when using explicit wait statements.
#>
function Disable-SeDriverImplicitTimeout {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [OpenQA.Selenium.IWebDriver]$Driver
    )
    $Output = $Driver.Manage().Timeouts().ImplicitWait
    $Driver.Manage().Timeouts().ImplicitWait = 0
    return $Output
}

