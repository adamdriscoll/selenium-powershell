---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Start-SeEdge

## SYNOPSIS
Initializes a new instance of the EdgeDriver class

## SYNTAX

### default (Default)
```
Start-SeEdge [[-StartURL] <String>] [-PrivateBrowsing] [-Quiet] [-AsDefaultDriver] [-Headless]
 [-ImplicitWait <Int32>] [<CommonParameters>]
```

### Minimized
```
Start-SeEdge [[-StartURL] <String>] [-Maximized] [-PrivateBrowsing] [-Quiet] [-AsDefaultDriver] [-Headless]
 [-ImplicitWait <Int32>] [<CommonParameters>]
```

### Maximized
```
Start-SeEdge [[-StartURL] <String>] [-Minimized] [-PrivateBrowsing] [-Quiet] [-AsDefaultDriver] [-Headless]
 [-ImplicitWait <Int32>] [<CommonParameters>]
```

### Fullscreen
```
Start-SeEdge [[-StartURL] <String>] [-FullScreen] [-PrivateBrowsing] [-Quiet] [-AsDefaultDriver] [-Headless]
 [-ImplicitWait <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Initializes a new instance of the EdgeDriver class

## EXAMPLES

### Example 1
```powershell
PS C:\> $Driver = Start-SeEdge
```

## PARAMETERS

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
