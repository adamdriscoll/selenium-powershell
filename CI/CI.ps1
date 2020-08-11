param (
    [string[]]$BrowserList = @('Chrome', 'Firefox')
)
#Get the OS/PS version info for later. On Linux run headless On windows and PS 6 (but not 7)  add WindowsPowershell to the module path.
$Platform = ([environment]::OSVersion.Platform).ToString() + ' PS' + $PSVersionTable.PSVersion.Major
if ($Platform -notlike 'win*') { $env:AlwaysHeadless = $true }
if ($Platform -like 'win*6') {
    $env:PSModulePath -split ';' | Where-Object { $_ -match "\w:\\Prog.*PowerShell\\modules" } | ForEach-Object {
        $env:PSModulePath = ($_ -replace "PowerShell", "WindowsPowerShell") + ";" + $env:PSModulePath
    }
}

#Make sure we have the modules we need
Import-Module .\Output\Selenium\Selenium.psd1 -Force -ErrorAction Stop
$checkImportExcel = Get-Module -ListAvailable ImportExcel
if (-not ($checkImportExcel)) {
    Write-Verbose -Verbose 'Installing ImportExcel'
    Install-Module ImportExcel -Force -SkipPublisherCheck
}
else { $checkImportExcel | Out-Host }
$checkPester = Get-Module -ListAvailable Pester | Where-Object { $_.version.major -ge 4 -and $_.version.minor -ge 4 }
if (-not $checkPester) {
    Write-Verbose -Verbose 'Installing Pester'
    Install-Module Pester -Force -SkipPublisherCheck
}
else { $checkPester | Out-Host }

# #Run the test and results export to an Excel file for current OS - Test picks up the selected browser from an environment variable.
$RunParameters = @{
    XLFile = '{0}/results/Results-{1}.xlsx' -f $env:BUILD_ARTIFACTSTAGINGDIRECTORY, [environment]::OSVersion.Platform.ToString()
    Script = Join-Path -Path (Join-Path $pwd 'Examples') -ChildPath 'Combined.tests.ps1'
}
# foreach ( $b   in $BrowserList) {
#     $env:DefaultBrowser = $b
#     $RunParameters['OutputFile'] = Join-Path $pwd "TestResults-$platform$b.xml"
#     $RunParameters['WorkSheetName'] = "$B $Platform"
#     $RunParameters | Out-Host
#     & "$PSScriptRoot\Pester-To-XLSx.ps1"  @RunParameters
# }

# #Merge the results sheets into a sheet named 'combined'.
# $excel = Open-ExcelPackage $RunParameters.XLFile
# $wslist = $excel.Workbook.Worksheets.name
# Close-ExcelPackage -NoSave $excel
# Merge-MultipleSheets -path  $RunParameters.XLFile -WorksheetName $wslist -OutputSheetName combined -OutputFile $RunParameters.XLFile -HideRowNumbers -Property name, result

# #Hide everything on 'combined' except test name, results for each browser, and test group, Set column widths, tweak titles, apply conditional formatting.
# $excel = Open-ExcelPackage $RunParameters.XLFile
# $ws = $excel.combined
# 2..$ws.Dimension.end.Column | ForEach-Object {
#     if ($ws.Cells[1, $_].value -notmatch '^Name|Result$|PS\dGroup$') {
#         Set-ExcelColumn -Worksheet $ws -Column $_ -Hid
#     }
#     elseif ($ws.Cells[1, $_].value -match 'Result$' ) {
#         Set-ExcelColumn -Worksheet $ws -Column $_ -Width 17
#         Set-ExcelRange $ws.Cells[1, $_] -WrapText
#     }
#     if ($ws.cells[1, $_].value -match 'PS\dGroup$') {
#         Set-ExcelRange $ws.Cells[1, $_] -WrapText -Value 'Group'
#     }
#     if ($ws.cells[1, $_].value -match '^Name|PS\dGroup$' -and ($ws.Column($_).Width -gt 80)) {
#         $ws.Column($_).Width = 80
#     }
# }
# Set-ExcelRow -Worksheet $ws -Height 28.5
# $cfRange = [OfficeOpenXml.ExcelAddress]::new(2, 3, $ws.Dimension.end.Row, (3 * $wslist.count - 2)).Address
# Add-ConditionalFormatting -WorkSheet $ws -range $cfRange -RuleType ContainsText -ConditionValue "Failure" -BackgroundPattern None -ForegroundColor Red   -Bold
# Add-ConditionalFormatting -WorkSheet $ws -range $cfRange -RuleType ContainsText -ConditionValue "Success" -BackgroundPattern None -ForeGroundColor Green
# Close-ExcelPackage $excel
