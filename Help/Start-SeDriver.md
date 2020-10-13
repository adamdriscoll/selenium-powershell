---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Start-SeDriver

## SYNOPSIS
Launch the specified browser.

## SYNTAX

### default (Default)
```
Start-SeDriver [[-StartURL] <String>] [-State <SeWindowState>] [-DefaultDownloadPath <FileInfo>]
 [-PrivateBrowsing] [-ImplicitWait <Double>] [-Size <Size>] [-Position <Point>] [-WebDriverPath <Object>]
 [-BinaryPath <Object>] [-Arguments <String[]>] [-ProfilePath <Object>] [-LogLevel <LogLevel>] [-Name <Object>]
 [-UserAgent <String>] [<CommonParameters>]
```

### DriverOptions
```
Start-SeDriver [-Browser <Object>] [[-StartURL] <String>] [-State <SeWindowState>]
 [-DefaultDownloadPath <FileInfo>] [-PrivateBrowsing] [-ImplicitWait <Double>] [-Size <Size>]
 [-Position <Point>] [-WebDriverPath <Object>] [-BinaryPath <Object>] [-Service <DriverService>]
 -Options <DriverOptions> [-Arguments <String[]>] [-ProfilePath <Object>] [-LogLevel <LogLevel>]
 [-Name <Object>] [-UserAgent <String>] [<CommonParameters>]
```

### Default
```
Start-SeDriver [-Browser <Object>] [[-StartURL] <String>] [-State <SeWindowState>]
 [-DefaultDownloadPath <FileInfo>] [-PrivateBrowsing] [-ImplicitWait <Double>] [-Size <Size>]
 [-Position <Point>] [-WebDriverPath <Object>] [-BinaryPath <Object>] [-Switches <String[]>]
 [-Arguments <String[]>] [-ProfilePath <Object>] [-LogLevel <LogLevel>] [-Name <Object>] [-UserAgent <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Launch a driver instance of the specified browser.

## EXAMPLES

### Example 1
```powershell
PS C:\> Start-SeDriver -Browser Chrome -Position 1920x0 -StartURL 'google.com'
```

Start a Chrome browser at the specified position and starting URL

## PARAMETERS

### -Arguments
Command line arguments to be passed to the browser.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BinaryPath
{{ Fill BinaryPath Description }}

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

### -Browser
Browser to be started.

```yaml
Type: Object
Parameter Sets: DriverOptions, Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultDownloadPath
{{ Fill DefaultDownloadPath Description }}

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

### -ImplicitWait
Maximum time that the browser will implicitely wait between operations

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogLevel
{{ Fill LogLevel Description }}

```yaml
Type: LogLevel
Parameter Sets: (All)
Aliases:
Accepted values: All, Debug, Info, Warning, Severe, Off

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Friendly name of the browser.

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

### -Options
Driver Options object 

```yaml
Type: DriverOptions
Parameter Sets: DriverOptions
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Position
Position of the browser to be set on or after launch. Some browser might not support position to be set prior launch and will have their position set after launch.

```yaml
Type: Point
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateBrowsing
Launch the browser in a private session

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

### -ProfilePath
{{ Fill ProfilePath Description }}

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

### -Service
DriverService object to be used.

```yaml
Type: DriverService
Parameter Sets: DriverOptions
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Size
Size of the browser to be set on or after launch. Some browser might not support size to be set prior launch and will have their size set after launch. 

```yaml
Type: Size
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartURL
Start URL to be set immediately after launch. If no protocol is specified, https will be assumed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -State
Window state of the browser.

```yaml
Type: SeWindowState
Parameter Sets: (All)
Aliases:
Accepted values: Headless, Default, Minimized, Maximized, Fullscreen

Required: False
Position: Named
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -Switches
Special switches (additional legacy options that might appear for some browser )

```yaml
Type: String[]
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserAgent
UserAgent to be set. Supported by Chrome & Firefox

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebDriverPath
Location of the web driver to be used.

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

### OpenQA.Selenium.IWebDriver

## NOTES

## RELATED LINKS
