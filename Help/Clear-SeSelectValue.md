---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Clear-SeSelectValue

## SYNOPSIS
Clear all selected entries of a SELECT element.

## SYNTAX

```
Clear-SeSelectValue [-Element] <IWebElement> [<CommonParameters>]
```

## DESCRIPTION
Clear all selected entries of a SELECT element.

## EXAMPLES

### Example 1
```powershell
PS C:\> Clear-SeSelectValue -Element $Select
```

Clear the selected value from the specified SELECT element.

## PARAMETERS

### -Element
Target IWebElement

```yaml
Type: IWebElement
Parameter Sets: (All)
Aliases:

Required: True
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
