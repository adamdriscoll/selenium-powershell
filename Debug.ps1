import-module Platyps
import-module InvokeBuild

# Just a line to replace $PsScriptRoot since the former does not work when debugging with F8
$ScriptFullPath, $ScriptRoot, $ScriptName, $ScriptNameShort = @('', '', '', ''); $ScriptFullPath = if (-not [String]::IsNullOrEmpty($PSCommandPath)) { $PSCommandPath } elseif ($psEditor -ne $null) { $psEditor.GetEditorContext().CurrentFile.Path } elseif ($psise -ne $null) { $psise.CurrentFile.FullPath }; $ScriptRoot = Split-Path -Path $ScriptFullPath -Parent; $ScriptName = Split-Path -Path $ScriptFullPath -Leaf; $ScriptNameShort = ([System.IO.Path]::GetFileNameWithoutExtension($ScriptFullPath))


# Load Debug version
import-module "$ScriptRoot\Selenium.psd1" -Force

#Load Compiled version
#import-module "$ScriptRoot\output\selenium\Selenium.psd1" -Force


# Build module
#invoke-build -File "$ScriptRoot\Selenium.build.ps1"