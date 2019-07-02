# Selenium PowerShell Module

- Wraps the C# WebDriver for Selenium
- Easily execute web-based tests
- Works well with Pester

# Installation

```powershell
Install-Module Selenium
```

OR

```
Import-Module "{FullPath}\selenium-powershell\Selenium.psm1"
```

# Usage

## Navigate to a URL

```powershell
$Driver = Start-SeFirefox 
Enter-SeUrl https://www.poshud.com -Driver $Driver
```

## Find an element

```powershell
$Driver = Start-SeFirefox 
Enter-SeUrl https://www.poshud.com -Driver $Driver
$Element = Find-SeElement -Driver $Driver -Id "myControl"
```

## Click on a button

```powershell
$Driver = Start-SeFirefox 
Enter-SeUrl https://www.poshud.com -Driver $Driver
$Element = Find-SeElement -Driver $Driver -Id "btnSend"
Invoke-SeClick -Element $Element
```

## Send Keystrokes

```powershell
$Driver = Start-SeFirefox 
Enter-SeUrl https://www.poshud.com -Driver $Driver
$Element = Find-SeElement -Driver $Driver -Id "txtEmail"
Send-SeKeys -Element $Element -Keys "adam@poshtools.com"
```

## Run Chrome with options

```powershell
$Driver = Start-SeChrome -Arguments "headless","incognito" 
```

## Wait for an element
```powershell
$Driver = Start-SeChrome
Enter-SeUrl https://www.google.com -Driver $Driver
Wait-SeElementExists -Driver $Driver -Timeout 3 -Id "q"
Wait-SeElementExists -Driver $Driver -Timeout 3 -Name "q"
```