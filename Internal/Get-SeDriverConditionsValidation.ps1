Function Get-SeDriverConditionsValidation {
    [CmdletBinding()]
    Param($Condition) 
    return $Condition -in $Script:SeDriverConditions.Text
}