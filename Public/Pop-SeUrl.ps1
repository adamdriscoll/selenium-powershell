function Pop-SeUrl {
    <#
    .SYNOPSIS
    Navigate back to the most recently pushed URL in the location stack.

    .DESCRIPTION
    Retrieves the most recently pushed URL from the location stack and navigates
    to that URL with the specified or default driver.

    .EXAMPLE
    Pop-SeUrl

    Retrieves the most recently pushed URL and navigates back to that URL.

    .NOTES
    A separate internal location stack is maintained for each driver instance
    by the module. This stack is completely separate from the driver's internal
    Back/Forward history logic.

    To utilise a driver's Back/Forward functionality, instead use Set-SeUrl.
    #>
    [CmdletBinding()]
    [Alias('Pop-SeLocation')]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [Alias("Driver")]
        [ValidateIsWebDriverAttribute()]
        $Target = $Script:SeDriversCurrent
    )
    process {
        if ($Script:SeLocationMap[$Target].Count -gt 0) {
            Set-SeUrl -Url $Script:SeLocationMap[$Target].Pop() -Target $Target
        }
    }
}
