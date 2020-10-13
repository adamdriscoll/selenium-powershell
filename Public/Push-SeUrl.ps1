function Push-SeUrl {
    <#
    .SYNOPSIS
    Stores the current URL in the driver's location stack and optionally
    navigate to a new URL.

    .DESCRIPTION
    The current driver URL is added to the stack, and if a URL is provided, the
    driver navigates to the new URL.

    .EXAMPLE
    Push-SeUrl

    The current driver URL is added to the location stack.

    .EXAMPLE
    Push-SeUrl 'https://google.com/'

    The current driver URL is added to the location stack, and the driver then
    navigates to the provided target URL.

    .NOTES
    A separate internal location stack is maintained for each driver instance
    by the module. This stack is completely separate from the driver's internal
    Back/Forward history logic.

    To utilise a driver's Back/Forward functionality, instead use Set-SeUrl.
    #>
    [CmdletBinding()]
    param(
        # The new URL to navigate to after storing the current location.
        [Parameter(Position = 0, ParameterSetName = 'url')]
        [ValidateURIAttribute()]
        [string]
        $Url
    )
    $Driver = Init-SeDriver  -ErrorAction Stop
    if (-not $Script:SeLocationMap.ContainsKey($Driver)) {
        $script:SeLocationMap[$Driver] = [System.Collections.Generic.Stack[string]]@()
    }

    # Push the current location to the stack
    $script:SeLocationMap[$Driver].Push($Driver.Url)

    if ($Url) {
        # Change the driver current URL to provided URL
        Set-SeUrl -Url $Url -Driver $Driver
    }
}
