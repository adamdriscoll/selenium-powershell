## Start a Browser Driver for the browser of your choice (Chrome/Firefox/Edge/InternetExplorer)
```powershell
# Start a driver
#Either store the driver in your own variable
$Driver = Start-SeChrome

#Or save it to $global:SeDriver
Start-SeChrome           -AsDefaultDriver  # alias Chrome
Start-SeFirefox          -AsDefaultDriver  # alias Firefox
Start-SeEdge             -AsDefaultDriver  # alias MsEdge
Start-SeNewEdge          -AsDefaultDriver  # alias CrEdge / NewEdge
Start-SeInternetExplorer -AsDefaultDriver  # alias IE / InternetExplorer

#or shortcut for browser & AsDefault
SeOpen -In Chrome
```

## Navigate to a URL
```powershell
#Use a saved driver and the original name
Enter-SeUrl https://www.poshud.com -Driver $Driver

#Use the default driver and the new name
Open-SeUrl https://www.poshud.com           #alias SeNavigate

#or Start the driver and navigate in one
Start-SeChrome -AsDefaultDriver -StartURL https://www.poshud.com

#or using SeOpen
SeOpen -URL https://www.poshud.com -In Chrome
```

## Find an Element
```powershell
#Using the saved driver and the old syntax
$Element = Find-SeElement -Driver $Driver -ClassName 'center-align'

#Using the default driver and the new syntax
$Element = Get-SeElement -By ClassName 'center-align'     #alias SeElement

#xpath is selected by default -can specify a timeout to wait for the element to appear.
$Element = Get-SeElement '/html/body/div[1]/div/main/div/div[2]/div[3]/div[1]/div/div/div[2]/a' -Timeout 10
```

## Click on an Element/Button

```powershell
#send to saved element with old syntax
Invoke-SeClick -Element $Element

#pipe element using new syntax
Get-SeElement '/html/body/div[1]/div/main/div/div[2]/div[3]/div[1]/div/div/div[2]/a' | Send-SeClick -SleepSeconds 2 #alias SeClick
```
## Send Keystrokes

```powershell
$Element = Find-SeElement -Driver $Driver -Id "txtEmail"
Send-SeKeys -Element $Element -Keys "adam@poshtools.com"

#or using the pipeline
$Element | Send-SeKeys -Keys "adam@poshtools.com"
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
