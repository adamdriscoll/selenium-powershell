#Chrome and firefox or on Windows and Linux. Get the OS/PS version info for later.
#If we're on Windows add IE  as a browser. If PS 6 (not 7) add WinPowershell to the module path
$BrowserList = 'Chrome' , 'FireFox'
$Platform    = ([environment]::OSVersion.Platform).ToString() + ' PS' + $PSVersionTable.PSVersion.Major
if ($Platform -like 'win*') {
    $BrowserList += 'IE'
    if ($Platform -like '*6') {
        $env:PSModulePath -split ';' | where {$_ -match "\w:\\Prog.*PowerShell\\modules"} | ForEach-Object {
            $env:PSModulePath = ($_ -replace "PowerShell","WindowsPowerShell") + ";" +  $env:PSModulePath
        }
    }
}
#Make sure we have the modules we need
Import-Module .\Selenium.psd1 -Force -ErrorAction Stop

if (-not (Get-Module -ListAvailable ImportExcel)) {
    Write-Verbose -Verbose 'Installing ImportExcel'
    Install-Module ImportExcel -Force -SkipPublisherCheck
}

if (-not (Get-Module Pester -ListAvailable | where {$_.version.major -ge 4 -and $_.version.minor -ge 4})) {
    Write-Verbose -Verbose 'Installing Pester'
    Install-Module Pester -Force -SkipPublisherCheck
}

#Run the test and export to an Excel file for each browser -it will pick up the selected browser from an environment variable.
$RunParameters = @{
    XLFile     = "$env:Build_ArtifactStagingDirectory/results/Results-$Platform.xlsx"
    Script     = Join-Path -Path (Join-Path $pwd 'Examples') -ChildPath 'Combined.tests.ps1'
}
foreach ($b in $BrowserList) {
    $env:DefaultBrowser = $b
    $RunParameters['OutputFile']    = Join-Path $pwd "testresults-$platform$b.xml"
    $RunParameters['WorkSheetName'] =  "$B $Platform"
    $RunParameters | out-host
    .\Examples\Pester-To-XLSx.ps1  @RunParameters
}
