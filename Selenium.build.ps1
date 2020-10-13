task . Clean, Build, Tests, UpdateHelp, ExportHelp, Stats
task Tests ImportCompipledModule, Pester
task CreateManifest CopyPSD, UpdatPublicFunctionsToExport, CopyAdditionalFiles
task Build Compile, CreateManifest
task Stats WriteStats

$script:ModuleName = 'Selenium' # Split-Path -Path $PSScriptRoot -Leaf
$script:ModuleRoot = $PSScriptRoot
$script:OutPutFolder = "$PSScriptRoot\Output"
$script:ModuleOutPutFolder = "$PSScriptRoot\Output\$script:ModuleName"
$script:ImportFolders = @('Public', 'Internal', 'Classes')
$script:PsmPath = Join-Path -Path $PSScriptRoot -ChildPath "Output\$($script:ModuleName)\$($script:ModuleName).psm1"
$script:PsdPath = Join-Path -Path $PSScriptRoot -ChildPath "Output\$($script:ModuleName)\$($script:ModuleName).psd1"
$script:HelpPath = Join-Path -Path $PSScriptRoot -ChildPath "Output\$($script:ModuleName)\en-US"

$script:PublicFolder = 'Public'
$script:DSCResourceFolder = 'DSCResources'


task "Clean" {
    if (-not(Test-Path $script:OutPutFolder)) {
        New-Item -ItemType Directory -Path $script:OutPutFolder > $null
    }

    Remove-Item -Path "$($script:OutPutFolder)\*" -Force -Recurse
}

$compileParams = @{
    Inputs = {
        foreach ($folder in $script:ImportFolders) {
            Get-ChildItem -Path $folder -Recurse -File -Filter '*.ps1'
        }
    }

    Output = {
        $script:PsmPath
    }
}

task Compile @compileParams {
    if (Test-Path -Path $script:PsmPath) {
        Remove-Item -Path $script:PsmPath -Recurse -Force
    }
    New-Item -Path $script:PsmPath -Force > $null
    $currentFolder = Join-Path -Path $script:ModuleRoot -ChildPath 'Internal'
    Get-Content -Path "$CurrentFolder\init.ps1" >> $script:PsmPath
    foreach ($folder in $script:ImportFolders) {
        $currentFolder = Join-Path -Path $script:ModuleRoot -ChildPath $folder
        Write-Verbose -Message "Checking folder [$currentFolder]"

        if (Test-Path -Path $currentFolder) {
            $files = Get-ChildItem -Path $currentFolder -File -Filter '*.ps1'
            foreach ($file in $files) {
                if ($file.Name -eq 'init.ps1' -and $folder -eq 'Internal') { continue }
                Write-Verbose -Message "Adding $($file.FullName)"
                Get-Content -Path $file.FullName >> $script:PsmPath
            }
        }
    }

}

task CopyPSD {
    New-Item -Path (Split-Path $script:PsdPath) -ItemType Directory -ErrorAction 0
    $copy = @{
        Path        = "$($script:ModuleName).psd1"
        Destination = $script:PsdPath
        Force       = $true
        Verbose     = $true
    }
    Copy-Item @copy
}

task CopyAdditionalFiles {

    $CopyContainer = @{
        Container = $true
        Recurse   = $true
    }

    $CopyFile = { Param($Name) Copy-Item -Path "$script:ModuleRoot\$Name" -Destination "$script:ModuleOutPutFolder\$Name" -Force -Verbose }
    $CopyFolder = { Param($Name) Copy-Item -Path "$script:ModuleRoot\$Name" -Destination "$script:ModuleOutPutFolder" -Force -Verbose -Container -Recurse }

    & $CopyFolder 'assemblies'
    & $CopyFolder 'types'
    & $CopyFolder 'formats'
    & $CopyFolder 'Examples'

    & $CopyFile 'SeleniumClasses.ps1'
    & $CopyFile 'Selenium-Binary-Updater.ps1'

    & $CopyFile 'ChangeLog.md'
    & $CopyFile 'README.md'
    & $CopyFile 'Selenium.tests.ps1'

}

task UpdatPublicFunctionsToExport -if (Test-Path -Path $script:PublicFolder) {
    $publicFunctions = (Get-ChildItem -Path $script:PublicFolder |
            Select-Object -ExpandProperty BaseName) -join "', '"

    $publicFunctions = "FunctionsToExport = @('{0}')" -f $publicFunctions

    (Get-Content -Path $script:PsdPath) -replace "FunctionsToExport\s*?= '\*'", $publicFunctions |
        Set-Content -Path $script:PsdPath
}



task ImportCompipledModule -if (Test-Path -Path $script:PsmPath) {
    Get-Module -Name $script:ModuleName |
        Remove-Module -Force
    Import-Module -Name $script:PsdPath -Force
}

task Pester {
    $resultFile = "{0}\testResults{1}.xml" -f $script:OutPutFolder, (Get-date -Format 'yyyyMMdd_hhmmss')
    $testFolder = Join-Path -Path $PSScriptRoot -ChildPath 'Tests\*'
    Invoke-Pester -Path $testFolder -OutputFile $resultFile -OutputFormat NUnitxml
}     


task WriteStats {
    $folders = Get-ChildItem -Directory | 
        Where-Object { $PSItem.Name -ne 'Output' }
    
    $stats = foreach ($folder in $folders) {
        $files = Get-ChildItem "$($folder.FullName)\*" -File
        if ($files) {
            Get-Content -Path $files | 
                Measure-Object -Word -Line -Character | 
                    Select-Object -Property @{N = "FolderName"; E = { $folder.Name } }, Words, Lines, Characters
        }
    }
    $stats | ConvertTo-Json > "$script:OutPutFolder\stats.json"
}

task UpdateHelp -if (Test-Path -Path "$Script:ModuleRoot\Help") {
    Update-MarkdownHelpModule -Path "$Script:ModuleRoot\Help" -ModulePagePath "$Script:ModuleRoot\Help\README.MD" -RefreshModulePage
}

task ExportHelp -if (Test-Path -Path "$script:ModuleRoot\Help") {
    New-ExternalHelp -Path "$script:ModuleRoot\Help" -OutputPath $script:HelpPath
}