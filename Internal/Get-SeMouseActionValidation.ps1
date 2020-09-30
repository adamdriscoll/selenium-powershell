function Get-SeMouseActionValidation {
    Param(
        $Action 
    )
    
    return $Action -in $Script:SeMouseAction.Text
    
}