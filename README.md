# Selenium PowerShell Module

- Wraps the C# WebDriver for Selenium
- Easily execute web-based tests
- Works well with Pester

# Installation
`Note: Firefox's Latest Gecko Driver on Windows requires Microsoft Visual Studio Redistributables for the binary to run get them `[Here](https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads)


```powershell
Install-Module Selenium
```

OR

```
Import-Module "{FullPath}\selenium-powershell\Selenium.psm1"
```

# Usage
`Note: in order to use a specific driver you will need to have the brower of the driver installed on your system.
For example if you use Start-SeChrome you will need to have either a Chrome or Chromium browser installed
`

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

## Find an Element

```powershell
$Driver = Start-SeFirefox 
Enter-SeUrl https://www.poshud.com -Driver $Driver
$Element = Find-SeElement -Driver $Driver -Id "myControl"
```

## Click on an Element/Button

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
$Driver = Start-SeChrome -Incognito

# Run Chrome with alternative download folder
$Driver = Start-SeChrome -DefaultDownloadPath C:\Temp

# Run Chrome and go to a URL in one command
$Driver = Start-SeChrome -StartURL 'https://www.google.com/ncr'

# Run Chrome with multiple Arguments
$Driver = Start-SeChrome -Arguments @('Incognito','start-maximized')

# Run Chrome with an existing profile.
# The default profile paths are as follows:
# Windows: C:\Users\<username>\AppData\Local\Google\Chrome\User Data
# Linux: /home/<username>/.config/google-chrome
# MacOS: /Users/<username>/Library/Application Support/Google/Chrome
$Driver = Start-SeChrome -ProfileDirectoryPath '/home/<username>/.config/google-chrome'

```

## Find and Wait for an element
```powershell
$Driver = Start-SeChrome
Enter-SeUrl 'https://www.google.com/ncr' -Driver $Driver

# Please note that with the -Wait parameter only one element can be returned at a time.
Find-SeElement -Driver $d -Wait -Timeout 10 -Css input[name='q'] 
Find-SeElement -Driver $d -Wait -Timeout 10 -Name q 
```

# Maintainers 

- [Adam Driscoll](https://github.com/adamdriscoll)
- [Avri Chen-Roth](https://github.com/the-mentor)