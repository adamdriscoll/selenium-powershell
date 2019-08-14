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

## Start a Browser Driver
```powershell
# Start a driver for a browser of your choise (Chrome/Firefox/Edge/InternetExplorer)
# To start a Firefox Driver
$Driver = Start-SeFirefox 

# To start a Chrome Driver
$Driver = Start-SeChrome

# To start an Edge Driver
$Driver = Start-SeEdge
```

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
# Run Chrome in Headless mode 
$Driver = Start-SeChrome -Headless

# Run Chrome in incognito mode
$Driver = Start-SeChrome -Arguments "incognito" 

# Run Chrome with alternative download folder
$Driver = Start-SeChrome -DefaultDownloadPath  c:\temp
```

## Wait for an element
```powershell
$Driver = Start-SeChrome
Enter-SeUrl https://www.google.com -Driver $Driver
Wait-SeElementExists -Driver $Driver -Timeout 3 -Id "q"
Wait-SeElementExists -Driver $Driver -Timeout 3 -Name "q"
```