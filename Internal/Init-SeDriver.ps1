function Init-SeDriver {
    [CmdletBinding()]
    param ($Element)
    
    IF ($null -NE $Element) {
        $Driver = ($Element | Select-Object -First 1).WrappedDriver
    }
    $Driver = Get-SeDriver -Current -ErrorAction Stop
       
    if ($null -eq $Driver) {
        Throw [System.ArgumentNullException]::new("An available Driver could not be found.")
    }



    
    
}


