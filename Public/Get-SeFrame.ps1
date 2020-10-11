function Get-SeFrame {
    [cmdletbinding()]
    param()

    Init-SeDriver -Driver ([ref]$Driver) -ErrorAction Stop
    
    Get-SeElement -By TagName -Value iframe -Attributes name, id -ErrorAction SilentlyContinue | 
        ForEach-Object {
            $_.Psobject.TypeNames.Insert(0, 'selenium-powershell/SeFrame')
            $_
        } 

}

