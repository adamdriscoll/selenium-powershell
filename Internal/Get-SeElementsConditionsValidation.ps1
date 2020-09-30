Function Get-SeElementsConditionsValidation {
    [CmdletBinding()]
    Param($By, $Condition) 

    $SearchBy = 2
    if ($null -ne $By) { $SearchBy = 1 }
   
    return $Script:SeElementsConditions.where( { $_.Text -like $Condition -and $_.By_Element -in @(0, $SearchBy) }).count -eq 1
}