
Function Get-OptionsSwitchValue($Switches, $Name) {
    if ($null -eq $Switches -or -not $Switches.Contains($Name)) { Return $false }
    return $True
}