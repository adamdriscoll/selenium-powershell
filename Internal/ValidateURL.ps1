function ValidateURL {
    param(
        [Parameter(Mandatory = $true)]
        $URL
    )
    $Out = $null
    #TODO Support for URL without https (www.google.ca) / add it ?
    [uri]::TryCreate($URL, [System.UriKind]::Absolute, [ref]$Out)
}