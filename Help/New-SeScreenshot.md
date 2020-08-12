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
New-SeScreenshot [-Driver <Object>] [<CommonParameters>]
```

### Base64
```
New-SeScreenshot [-Driver <Object>] [-AsBase64EncodedString] [<CommonParameters>]
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

### -Driver
{{ Fill Driver Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

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
