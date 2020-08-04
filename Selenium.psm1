$functionFolders = @('Public', 'Internal', 'Classes')
ForEach ($folder in $functionFolders) {
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    if ($folder -eq 'Internal') {
        . $folderPath\init.ps1;
    }
    If (Test-Path -Path $folderPath) {
        
        Write-Verbose -Message "Importing from $folder"
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1' 
        ForEach ($function in $functions) {
            Write-Verbose -Message "  Importing $($function.BaseName)"
            . $($function.FullName)
        }
    }    
}
$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter '*.ps1').BaseName
Export-ModuleMember -Function $publicFunctions
