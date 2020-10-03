function ValidateURL {
    param(
        [Parameter(Mandatory = $true)]
        $URL
    )
    $Out = $null
    [uri]::TryCreate($URL, [System.UriKind]::Absolute, [ref]$Out)
}