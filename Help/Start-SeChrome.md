---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Start-SeChrome

## SYNOPSIS
Initializes a new instance of the **ChromeDriver** class. 

## SYNTAX

### default (Default)
```
Start-SeChrome [[-StartURL] <String>] [-Arguments <Array>] [-HideVersionHint] [-DefaultDownloadPath <FileInfo>]
 [-ProfileDirectoryPath <FileInfo>] [-DisableBuiltInPDFViewer <Boolean>] [-EnablePDFViewer] [-Incognito]
 [-DisableAutomationExtension] [-BinaryPath <Object>] [-WebDriverDirectory <Object>] [-Quiet]
 [-AsDefaultDriver] [-ImplicitWait <Int32>] [<CommonParameters>]
```

### Headless
```
Start-SeChrome [[-StartURL] <String>] [-Arguments <Array>] [-HideVersionHint] [-DefaultDownloadPath <FileInfo>]
 [-ProfileDirectoryPath <FileInfo>] [-DisableBuiltInPDFViewer <Boolean>] [-EnablePDFViewer] [-Incognito]
 [-Headless] [-DisableAutomationExtension] [-BinaryPath <Object>] [-WebDriverDirectory <Object>] [-Quiet]
 [-AsDefaultDriver] [-ImplicitWait <Int32>] [<CommonParameters>]
```

### Minimized
```
Start-SeChrome [[-StartURL] <String>] [-Arguments <Array>] [-HideVersionHint] [-DefaultDownloadPath <FileInfo>]
 [-ProfileDirectoryPath <FileInfo>] [-DisableBuiltInPDFViewer <Boolean>] [-EnablePDFViewer] [-Incognito]
 [-Maximized] [-DisableAutomationExtension] [-BinaryPath <Object>] [-WebDriverDirectory <Object>] [-Quiet]
 [-AsDefaultDriver] [-ImplicitWait <Int32>] [<CommonParameters>]
```

### Maximized
```
Start-SeChrome [[-StartURL] <String>] [-Arguments <Array>] [-HideVersionHint] [-DefaultDownloadPath <FileInfo>]
 [-ProfileDirectoryPath <FileInfo>] [-DisableBuiltInPDFViewer <Boolean>] [-EnablePDFViewer] [-Incognito]
 [-Minimized] [-DisableAutomationExtension] [-BinaryPath <Object>] [-WebDriverDirectory <Object>] [-Quiet]
 [-AsDefaultDriver] [-ImplicitWait <Int32>] [<CommonParameters>]
```

### Fullscreen
```
Start-SeChrome [[-StartURL] <String>] [-Arguments <Array>] [-HideVersionHint] [-DefaultDownloadPath <FileInfo>]
 [-ProfileDirectoryPath <FileInfo>] [-DisableBuiltInPDFViewer <Boolean>] [-EnablePDFViewer] [-Incognito]
 [-Fullscreen] [-DisableAutomationExtension] [-BinaryPath <Object>] [-WebDriverDirectory <Object>] [-Quiet]
 [-AsDefaultDriver] [-ImplicitWait <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Initializes a new instance of the **ChromeDriver** class. 

## EXAMPLES

### Example 1
```powershell
PS C:\> $Driver = Start-SeChrome
```

### Example 2
```powershell
PS C:\> $Driver = Start-SeChrome -Incognito
```

 Run Chrome in incognito mode

### Example 3
```powershell
PS C:\> $Driver = Start-SeChrome -DefaultDownloadPath C:\Temp -StartURL 'https://www.google.com/ncr'
```

 Run Chrome with alternative download folder and set  a specific starting URL

### Example 4
```powershell
PS C:\> $Driver = Start-SeChrome -Arguments @('Incognito','start-maximized')
```

  Run Chrome with multiple Arguments

### Example 5
```powershell
PS C:\> $Driver = Start-SeChrome -ProfileDirectoryPath '/home/<username>/.config/google-chrome'
```

 Run Chrome with an existing profile.
 The default profile paths are as follows:

 Windows: C:\Users\<username>\AppData\Local\Google\Chrome\User Data
 
 Linux: /home/<username>/.config/google-chrome
 
 MacOS: /Users/<username>/Library/Application Support/Google/Chrome

## PARAMETERS

### -Arguments
Adds arguments to be appended to the Chrome.exe command line.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsDefaultDriver
Set `$Global:SeDriver` ot the current Driver and dispose previously set driver.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BinaryPath
Set the location of the Chrome browser's binary executable file

```yaml
Type: Object
Parameter Sets: (All)
Aliases: ChromeBinaryPath

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultDownloadPath
Set default download path

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableAutomationExtension
Disable AutomationExtension notification

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableBuiltInPDFViewer
Obsolete. Use `-EnablePDFViewer` instead.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnablePDFViewer
Enable built in PDF Viewer (By default PDF will always open xternally)

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fullscreen
Driver will open browser in a fullscreen state

```yaml
Type: SwitchParameter
Parameter Sets: Fullscreen
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Headless
Start driver without any visual interface

```yaml
Type: SwitchParameter
Parameter Sets: Headless
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HideVersionHint
Hide download proper driver version message

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImplicitWait
Control timeout duration (in seconds)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Incognito
Drive will open an incognito session

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: PrivateBrowsing

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Maximized
Driver will open browser in a maximized state

```yaml
Type: SwitchParameter
Parameter Sets: Minimized
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Minimized
Driver will open  browser in a minimized state

```yaml
Type: SwitchParameter
Parameter Sets: Maximized
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProfileDirectoryPath
Driver will use the specified user profile path

```yaml
Type: FileInfo
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quiet
Hide command prompt window

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartURL
Define Driver starting URL

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebDriverDirectory
Specify web driver custom service location

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
