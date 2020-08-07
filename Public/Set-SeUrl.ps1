function Set-SeUrl {
    <#
    .SYNOPSIS
    Navigates to the targeted URL with the selected or default driver.

    .DESCRIPTION
    Used for webdriver navigation commands, either to specific target URLs or
    for history (Back/Forward) navigation or refreshing the current page.

    .EXAMPLE
    Set-SeUrl 'https://www.google.com/'

    Directs the default driver to navigate to www.google.com.

    .EXAMPLE
    Set-SeUrl -Refresh

    Reloads the current page for the default driver.

    .EXAMPLE
    Set-SeUrl -Target $Driver -Back

    Directs the targeted webdriver instance to navigate Back in its history.

    .EXAMPLE
    Set-SeUrl -Forward

    Directs the default webdriver to navigate Forward in its history.

    .NOTES
    The Back/Forward/Refresh logic is handled by the webdriver itself. If you
    need a more granular approach to handling which locations are saved or
    retrieved, use Push-SeUrl or Pop-SeUrl to utilise a separately managed
    location stack.
    #>
    [CmdletBinding(DefaultParameterSetName = 'default')]
    [Alias('SeNavigate', 'Enter-SeUrl', 'Set-SeLocation', 'Open-SeUrl')]
    param(
        # The target URL for the webdriver to navigate to.
        [Parameter(Mandatory = $true, position = 0, ParameterSetName = 'url')]
        [ValidateURIAttribute()]
        [string]$Url,

        # Trigger the Back history navigation action in the webdriver.
        [Parameter(Mandatory = $true, ParameterSetName = 'back')]
        [switch]$Back,

        # Trigger the Forward history navigation action in the webdriver.
        [Parameter(Mandatory = $true, ParameterSetName = 'forward')]
        [switch]$Forward,

        # Refresh the current page in the webdriver.
        [Parameter(Mandatory = $true, ParameterSetName = 'refresh')]
        [switch]$Refresh,

        # The target webdriver to manage navigation for. Will utilise the
        # default driver if left unset.
        [Parameter(ValueFromPipeline = $true)]
        [Alias("Driver")]
        [ValidateIsWebDriverAttribute()]
        $Target = $Global:SeDriver
    )

    switch ($PSCmdlet.ParameterSetName) {
        'url' { $Target.Navigate().GoToUrl($Url); break }
        'back' { $Target.Navigate().Back(); break }
        'forward' { $Target.Navigate().Forward(); break }
        'refresh' { $Target.Navigate().Refresh(); break }

        default { throw 'Unexpected ParameterSet' }
    }
}
