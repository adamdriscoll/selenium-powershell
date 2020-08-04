---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Save-SeScreenshot

## SYNOPSIS
Take a screenshot of the current page

## SYNTAX

```
Save-SeScreenshot [-Screenshot] <Screenshot> [-Path] <String> [[-ImageFormat] <ScreenshotImageFormat>]
 [<CommonParameters>]
```

## DESCRIPTION
Take a screenshot of the current page

## EXAMPLES

## PARAMETERS

### -ImageFormat
Set the image format

```yaml
Type: ScreenshotImageFormat
Parameter Sets: (All)
Aliases:
Accepted values: Png, Jpeg, Gif, Tiff, Bmp

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Filepath where the image iwll be saved to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Screenshot
Screenshot element

```yaml
Type: Screenshot
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OpenQA.Selenium.Screenshot

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
