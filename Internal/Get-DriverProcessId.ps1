function Get-DriverProcessId {
    [CmdletBinding()]
    param (
        $ServiceProcessId
    )

    $IsWindowsPowershell = $PSVersionTable.PSVersion.Major -lt 6

    if ($IsWindowsPowershell) {
        $Processes = Get-CimInstance -Class Win32_Process 
        $BrowserProcess = $Processes.Where( { $_.ParentProcessId -eq $ServiceProcessId -and $_.Name -ne 'conhost.exe' }, 'first').ProcessId
    }
    else {
        $BrowserProcess = (Get-Process).Where( { { $_.Parent.id -eq $ServiceProcessId -and $_.Name -ne 'conhost' } }, 'first').Id
    }
    return $BrowserProcess

}