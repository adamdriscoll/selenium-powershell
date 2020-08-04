---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Start-SeFirefox

## SYNOPSIS
Initializes a new instance of the **FirefoxDriver** class.

## SYNTAX

### default (Default)
```
Start-SeFirefox [[-StartURL] <String>] [-Arguments <Array>] [-DefaultDownloadPath <FileInfo>]
 [-PrivateBrowsing] [-SuppressLogging] [-Quiet] [-AsDefaultDriver] [-ImplicitWait <Int32>]
 [-WebDriverDirectory <Object>] [<CommonParameters>]
```

### Headless
```
Start-SeFirefox [[-StartURL] <String>] [-Arguments <Array>] [-DefaultDownloadPath <FileInfo>]
 [-PrivateBrowsing] [-Headless] [-SuppressLogging] [-Quiet] [-AsDefaultDriver] [-ImplicitWait <Int32>]
 [-WebDriverDirectory <Object>] [<CommonParameters>]
```

### Minimized
```
Start-SeFirefox [[-StartURL] <String>] [-Arguments <Array>] [-DefaultDownloadPath <FileInfo>]
 [-PrivateBrowsing] [-Maximized] [-SuppressLogging] [-Quiet] [-AsDefaultDriver] [-ImplicitWait <Int32>]
 [-WebDriverDirectory <Object>] [<CommonParameters>]
```

### Maximized
```
Start-SeFirefox [[-StartURL] <String>] [-Arguments <Array>] [-DefaultDownloadPath <FileInfo>]
 [-PrivateBrowsing] [-Minimized] [-SuppressLogging] [-Quiet] [-AsDefaultDriver] [-ImplicitWait <Int32>]
 [-WebDriverDirectory <Object>] [<CommonParameters>]
```

### Fullscreen
```
Start-SeFirefox [[-StartURL] <String>] [-Arguments <Array>] [-DefaultDownloadPath <FileInfo>]
 [-PrivateBrowsing] [-Fullscreen] [-SuppressLogging] [-Quiet] [-AsDefaultDriver] [-ImplicitWait <Int32>]
 [-WebDriverDirectory <Object>] [<CommonParameters>]
```

## DESCRIPTION
Initializes a new instance of the **FirefoxDriver** class.

## EXAMPLES

### Example 1
```powershell
$Driver = Start-SeFirefox
```

### Example 2
```powershell
$Driver = Start-SeFirefox -PrivateBrowsing -DefaultDownloadPath 'c:\temp' -StartURL 'https://www.google.ca/ncr'
```

Run Firefox in a private widnow using an alternate download path and set the starting URL

## PARAMETERS

### -Arguments
Adds arguments to be appended to the Firefox.exe command line.

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
Set $Global:SeDriver ot the current Driver and dispose previously set driver.

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
Driver will open browser in a minimized state

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

### -PrivateBrowsing
Driver will open a private session

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: Incognito

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

### -SuppressLogging
Set GeckoDriver log level to Fatal.

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
