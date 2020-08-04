---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Start-SeInternetExplorer

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Default (Default)
```
Start-SeInternetExplorer [[-StartURL] <String>] [-Quiet] [-AsDefaultDriver] [-Headless] [-PrivateBrowsing]
 [-IgnoreProtectedModeSettings] [-ImplicitWait <Int32>] [-WebDriverDirectory <Object>] [<CommonParameters>]
```

### Maximized
```
Start-SeInternetExplorer [[-StartURL] <String>] [-Quiet] [-AsDefaultDriver] [-Maximized] [-Headless]
 [-PrivateBrowsing] [-IgnoreProtectedModeSettings] [-ImplicitWait <Int32>] [-WebDriverDirectory <Object>]
 [<CommonParameters>]
```

### Minimized
```
Start-SeInternetExplorer [[-StartURL] <String>] [-Quiet] [-AsDefaultDriver] [-Minimized] [-Headless]
 [-PrivateBrowsing] [-IgnoreProtectedModeSettings] [-ImplicitWait <Int32>] [-WebDriverDirectory <Object>]
 [<CommonParameters>]
```

### Fullscreen
```
Start-SeInternetExplorer [[-StartURL] <String>] [-Quiet] [-AsDefaultDriver] [-FullScreen] [-Headless]
 [-PrivateBrowsing] [-IgnoreProtectedModeSettings] [-ImplicitWait <Int32>] [-WebDriverDirectory <Object>]
 [<CommonParameters>]
```

### Headless
```
Start-SeInternetExplorer [[-StartURL] <String>] [-Quiet] [-AsDefaultDriver] [-Headless] [-PrivateBrowsing]
 [-IgnoreProtectedModeSettings] [-ImplicitWait <Int32>] [-WebDriverDirectory <Object>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AsDefaultDriver
{{ Fill AsDefaultDriver Description }}

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

### -FullScreen
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
Parameter Sets: Default, Maximized, Minimized, Fullscreen
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

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

### -IgnoreProtectedModeSettings
{{ Fill IgnoreProtectedModeSettings Description }}

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

### -Maximized
Driver will open browser in a maximized state

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

### -Minimized
Driver will open browser in a minimized state

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

### -WebDriverDirectory
{{ Fill WebDriverDirectory Description }}

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
