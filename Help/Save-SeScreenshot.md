---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Save-SeScreenshot

## SYNOPSIS
Save a screenshot on the disk.

## SYNTAX

### Driver (Default)
```
Save-SeScreenshot -Path <String> [-ImageFormat <ScreenshotImageFormat>] [<CommonParameters>]
```

### Pipeline
```
Save-SeScreenshot [-InputObject <Object>] -Path <String> [-ImageFormat <ScreenshotImageFormat>]
 [<CommonParameters>]
```

### Screenshot
```
Save-SeScreenshot -Screenshot <Screenshot> -Path <String> [-ImageFormat <ScreenshotImageFormat>]
 [<CommonParameters>]
```

### Element
```
Save-SeScreenshot -Path <String> [-ImageFormat <ScreenshotImageFormat>] -Element <IWebElement>
 [<CommonParameters>]
```

## DESCRIPTION
Save the screenshot at the specified location.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Screenshot = New-SeScreenshot 
PS C:\> Save-SeScreenshot -Screenshot $Screenshot -Path 'c:\temp\image.png' -ImageFormat Png
```

Create then save a screenshot to disk.

## PARAMETERS

### -Element
{{ Fill Element Description }}

```yaml
Type: IWebElement
Parameter Sets: Element
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImageFormat
Image format for the file to be saved.

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

### -InputObject
{{ Fill InputObject Description }}

```yaml
Type: Object
Parameter Sets: Pipeline
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Path
Filepath where the image will be saved.

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
Screenshot object.

```yaml
Type: Screenshot
Parameter Sets: Screenshot
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
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
