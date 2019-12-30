Import-Module .\Selenium.psd1 -Force -ErrorAction Stop
#. ./SeleniumClasses.ps1

if (-not (Get-Module -ListAvailable ImportExcel)) {

    Install-Module ImportExcel -Force -SkipPublisherCheck -verbose
}

if (-not (Get-Module Pester -ListAvailable | where {$_.version.major -ge 4 -and $_.version.minor -ge 4})) {
       Install-Module Pester -Force -SkipPublisherCheck -verbose
}

$BrowserList = 'Chrome' , 'FireFox'
$Platform    = ([environment]::OSVersion.Platform).ToString() + ' PS' + $PSVersionTable.PSVersion.Major
if ($Platform -like 'win*') {
    $BrowserList = 'InternetExplorer'
}

$cmdParameters = @{
    OutputFile =  ".\testresults-$platform.xml"
    XLFile     = "$env:Build_ArtifactStagingDirectory/results/Results-$Platform.xlsx"
    Script     = '.\Examples\PSGallery_etc.Tests.ps1'
}

foreach ($b in $BrowserList) {
    $env:DefaultBrowser = $b
    Write-Verbose -Verbose $cmdParameters.XLFile
    .\Examples\Pester-To-XLSx.ps1 -WorkSheetName "$B $Platform" @cmdParameters
}
