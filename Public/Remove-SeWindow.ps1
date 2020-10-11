function Remove-SeWindow {
    [CmdletBinding()]
    param(
        [String]$SwitchToWindow
    )
    begin {
        Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    }
    process {
        try {
            $Windows = @(Get-SeWindow)
            if ($Windows.Count -eq 1) { Write-Warning -Message 'The driver has only one window left. Operation aborted. Use Stop-Driver instead.' }    

            $Driver.Close()
            if ($PSBoundParameters.ContainsKey('SwitchTo')) {
                Switch-SeWindow -Window $SwitchToWindow
            }
            else {
                $Windows = @(Get-SeWindow)
                if ($Windows.count -gt 0) {
                    Switch-SeWindow -Window $Windows[0]
                }
            }
        }
        catch {
            Write-Error $_
        }
        
        
    }
}