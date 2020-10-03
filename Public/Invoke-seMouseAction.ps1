function Invoke-SeMouseAction {
    [CmdletBinding()]
    param (
        $Driver,
        [ArgumentCompleter([SeMouseActionCompleter])]
        [ValidateScript( { $_ -in $Script:SeMouseAction.Text })]
        $Action,
        $Value
    )
    Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    Test-SeMouseActionValueValidation -Action $Action -ConditionValue $Value -ErrorAction Stop


    $Value2 = $null
    if ($Action -in @('DragAndDropToOffset', 'MoveByOffset', 'MoveToElement') -and $Value -is [String]) {
        $Value2 = $Value -split '[,x]'
    }


    $Interaction = [OpenQA.Selenium.Interactions.Actions]::new($Driver)

    $HasElement = $PSBoundParameters.ContainsKey('Element')
    $HasValue = $PSBoundParameters.ContainsKey('Value')

    if ($HasElement) {
        if ($HasValue) {
            if ($null -ne $value2) {
                try { $Interaction.$Action($Element, $Value2[0], $value2[1]).Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }
            }
            else {
                try { $Interaction.$Action($Element, $Value).Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }
            }
        }
        else {
            try { $Interaction.$Action($Element).Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }
        }
    }
    else {
        if ($HasValue) {
            if ($null -ne $value2) {
                try { $Interaction.$Action($Value2[0], $Value2[1]).Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }
            }
            else {
                try { $Interaction.$Action($Value).Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }    
            }

            
        }
        else {
            try { $Interaction.$Action().Perform() }catch { $PSCmdlet.ThrowTerminatingError($_) }
        }
    }
    


    

}