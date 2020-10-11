$functionFolders = @('Classes', 'Public', 'Internal')
. (Join-Path -Path $PSScriptRoot -ChildPath 'Internal/init.ps1')
ForEach ($folder in $functionFolders) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    
    If (Test-Path -Path $folderPath) {
        
        Write-Verbose -Message "Importing from $folder"
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1' 
        ForEach ($function in $functions) {
            Write-Verbose -Message "  Importing $($function.BaseName)"
            . $($function.FullName)
        }
    }    
}

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = { 
    Get-SeDriver | Stop-SeDriver
}

$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter '*.ps1').BaseName
Export-ModuleMember -Function $publicFunctions
