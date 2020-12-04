function Get-DriverProcessId {
    [CmdletBinding()]
    param (
        $ServiceProcessId
    )

    $IsWindowsPowershell = $PSVersionTable.PSVersion.Major -lt 6

    if ($IsWindowsPowershell) {
        $Processes = Get-CimInstance -Class Win32_Process -Filter "ParentProcessId=$ServiceProcessId"
        $BrowserProcess = $Processes | Where-Object  { $_.Name -ne 'conhost.exe' } | Select-Object -First 1 -ExpandProperty ProcessId
    }
    else {
        $BrowserProcess = (Get-Process).Where( { { $_.Parent.id -eq $ServiceProcessId -and $_.Name -ne 'conhost' } }, 'first').Id
    }
    return $BrowserProcess

}