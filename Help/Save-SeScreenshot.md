---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Save-SeScreenshot

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Default
```
Save-SeScreenshot [-Driver <Object>] -Path <String> [-ImageFormat <ScreenshotImageFormat>] [<CommonParameters>]
```

### Screenshot
```
Save-SeScreenshot -Screenshot <Screenshot> -Path <String> [-ImageFormat <ScreenshotImageFormat>]
 [<CommonParameters>]
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

### -Driver
{{ Fill Driver Description }}

```yaml
Type: Object
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -ImageFormat
{{ Fill ImageFormat Description }}

```yaml
Type: ScreenshotImageFormat
Parameter Sets: (All)
Aliases:
Accepted values: Png, Jpeg, Gif, Tiff, Bmp

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
{{ Fill Path Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Screenshot
{{ Fill Screenshot Description }}

```yaml
Type: Screenshot
Parameter Sets: Screenshot
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

### OpenQA.Selenium.Screenshot

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
