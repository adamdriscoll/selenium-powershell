function _IsSet-SeElement {
    [cmdletbinding()]
    param ($Driver, [ref]$Element)
    if ($null -eq $Driver) {$Driver = Get-SeDriver -Current}
    if ($null -ne $Element.Value) { return $true }
    if ($null -ne $Driver.SeSelectedElements) {
        $Element.Value = $Driver.SeSelectedElements
        return $true
    }
    return $false
}