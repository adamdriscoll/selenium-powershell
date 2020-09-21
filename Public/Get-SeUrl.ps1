function Get-SeUrl {
    <#
    .SYNOPSIS
    Retrieves the current URL of a target webdriver instance.

    .DESCRIPTION
    Retrieves the current URL of a target webdriver instance, or the currently
    stored internal location stack.

    .EXAMPLE
    Get-SeUrl

    Retrieves the current URL of the default webdriver instance.

    .NOTES
    When using -Stack, the retrieved stack will not contain any of the driver's
    history (Back/Forward) data. It only handles locations added with
    Push-SeUrl.

    To utilise a driver's Back/Forward functionality, instead use Set-SeUrl.
    #>
    [CmdletBinding()]
    param(
        # Optionally retrieve the stored URL stack for the target or default
        # webdriver instance.
        [Parameter()]
        [switch]
        $Stack,

        # The webdriver instance for which to retrieve the current URL or
        # internal URL stack.
        [Parameter(ValueFromPipeline = $true)]
        [ValidateIsWebDriverAttribute()]
        $Driver
    )
    Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    
    if ($Stack) {
        if ($Script:SeLocationMap[$Driver].Count -gt 0) {
            $Script:SeLocationMap[$Driver].ToArray()
        }
    }
    else {
        $Driver.Url
    }
}
