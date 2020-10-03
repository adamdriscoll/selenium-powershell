using namespace System.Collections.Generic

Function New-Condition {
    Param([Parameter(Mandatory = $true)]$Text, [Type]$ValueType, $Tooltip, [Switch]$OptionalValue, $ElementRequired = $true )
    return [PSCustomObject]@{
        Text            = $Text
        ValueType       = $ValueType
        Tooltip         = $Tooltip
        ElementRequired = $ElementRequired
    }
}

$Script:SeMouseAction = @(
    New-Condition -Text 'DragAndDrop' -ValueType ([OpenQA.Selenium.IWebElement]) -Tooltip 'Performs a drag-and-drop operation from one element to another.'
    New-Condition -Text 'DragAndDropToOffset'  -ValueType ([System.Drawing.Point]) -Tooltip 'Performs a drag-and-drop operation on one element to a specified offset.'
    New-Condition -Text 'MoveByOffset' -ValueType ([System.Drawing.Point]) -ElementRequired $null -Tooltip 'Moves the mouse to the specified offset of the last known mouse coordinates.'
    New-Condition -Text 'MoveToElement'  -ValueType ([System.Drawing.Point]) -OptionalValue -Tooltip 'Moves the mouse to the specified element with offset of the top-left corner of the specified element.'
    New-Condition -Text 'Release' -ValueType $null -Tooltip 'Releases the mouse button at the last known mouse coordinates or specified element.'
)

$Script:SeKeys = [OpenQA.Selenium.Keys] | Get-Member -MemberType Property -Static |
    Select-Object -Property Name, @{N = "ObjectString"; E = { "[OpenQA.Selenium.Keys]::$($_.Name)" } }

[Dictionary[object, Stack[string]]] $Script:SeLocationMap = [Dictionary[object, Stack[string]]]::new()

#region Set path to assemblies on Linux and MacOS and Grant Execution permissions on them
if ($IsLinux) {
    $AssembliesPath = "$PSScriptRoot/assemblies/linux"
}
elseif ($IsMacOS) {
    $AssembliesPath = "$PSScriptRoot/assemblies/macos"
}

# Grant Execution permission to assemblies on Linux and MacOS
if ($AssembliesPath) {
    # Check if powershell is NOT running as root
    Get-Item -Path "$AssembliesPath/chromedriver", "$AssembliesPath/geckodriver" | ForEach-Object {
        if ($IsLinux) { $FileMod = stat -c "%a" $_.FullName }
        elseif ($IsMacOS) { $FileMod = /usr/bin/stat -f "%A" $_.FullName }
        Write-Verbose "$($_.FullName) $Filemod"
        if ($FileMod[2] -ne '5' -and $FileMod[2] -ne '7') {
            Write-Host "Granting $($AssemblieFile.fullname) Execution Permissions ..."
            chmod +x $_.fullname
        }
    }
}

$Script:SeDriversAdditionalBrowserSwitches = @{
    Chrome           = @('DisableAutomationExtension', 'EnablePDFViewer')
    Edge             = @()
    Firefox          = @('SuppressLogging')
    InternetExplorer = @('IgnoreProtectedModeSettings')
    MsEdge           = @()
}

# List of suggested command line arguments for each browser
$Script:SeDriversBrowserArguments = @{
    Chrome           = @("--user-agent=Android")
    Edge             = @()
    Firefox          = @()
    InternetExplorer = @()
    MsEdge           = @()
}

$Script:SeDrivers = [System.Collections.Generic.List[PSObject]]::new()
$Script:SeDriversCurrent = $null


$AdditionalOptionsSwitchesCompletion = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
    
    if ($fakeBoundParameters.ContainsKey('Browser')) {
        $Browser = $fakeBoundParameters.Item('Browser')
        
        $Output = $Script:SeDriversAdditionalBrowserSwitches."$Browser"
        $Output | % { [System.Management.Automation.CompletionResult]::new($_) }
        
        
    }
}


$SeDriversBrowserArgumentsCompletion = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    if ($fakeBoundParameters.ContainsKey('Browser')) {
        $Browser = $fakeBoundParameters.Item('Browser')
        $Output = $Script:SeDriversBrowserArguments."$Browser" | Where { $_ -like "*$wordToComplete*" }
        $ptext = [System.Management.Automation.CompletionResultType]::ParameterValue
        $Output | % { [System.Management.Automation.CompletionResult]::new("'$_'", $_, $ptext, $_) }
    }
}

Register-ArgumentCompleter -CommandName Start-SeDriver, New-SeDriverOptions -ParameterName Switches -ScriptBlock $AdditionalOptionsSwitchesCompletion 
Register-ArgumentCompleter -CommandName Start-SeDriver, New-SeDriverOptions -ParameterName Arguments -ScriptBlock $SeDriversBrowserArgumentsCompletion 
