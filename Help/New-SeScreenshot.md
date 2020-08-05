---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# New-SeScreenshot

## SYNOPSIS
Take a screenshot of the current page

## SYNTAX

### Path (Default)
```
New-SeScreenshot [-Path] <Object> [[-ImageFormat] <ScreenshotImageFormat>] [-Target <Object>]
 [<CommonParameters>]
```

### PassThru
```
New-SeScreenshot [[-Path] <Object>] [[-ImageFormat] <ScreenshotImageFormat>] [-Target <Object>] [-PassThru]
 [<CommonParameters>]
```

### Base64
```
New-SeScreenshot [-Target <Object>] [-AsBase64EncodedString] [<CommonParameters>]
```

## DESCRIPTION
Take a screenshot of the current page

## EXAMPLES

### Example 1
```powershell
PS C:\> New-SeScreenshot -Path 'c:\temp\Screenshot.png' -ImageFormat Png
```

Save a screenshot in PNG format at the specified location

## PARAMETERS

### -AsBase64EncodedString
Return image as base64 string

```yaml
Type: SwitchParameter
Parameter Sets: Base64
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImageFormat
Set the image format

```yaml
Type: ScreenshotImageFormat
Parameter Sets: Path, PassThru
Aliases:
Accepted values: Png, Jpeg, Gif, Tiff, Bmp

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Return the screenshot element

```yaml
Type: SwitchParameter
Parameter Sets: PassThru
Aliases: PT

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Filepath where the image iwll be saved to.

```yaml
Type: Object
Parameter Sets: Path
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Object
Parameter Sets: PassThru
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
Target webdriver

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Driver

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
