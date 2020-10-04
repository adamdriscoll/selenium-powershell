---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Set-SeSelectValue

## SYNOPSIS
Set Select element selected value.

## SYNTAX

```
Set-SeSelectValue [-By <SeBySelect>] [-value] <Object> [-Element <IWebElement>] [<CommonParameters>]
```

## DESCRIPTION
Set Select element selected value.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-SeSelectValue -By Text -value 'Hello' -Element $Element
```

Set targeted Select element selected value to 'Hello' (by text)

## PARAMETERS

### -By
Selector to be used to set the value.

```yaml
Type: SeBySelect
Parameter Sets: (All)
Aliases:
Accepted values: Index, Text, Value

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Element
{{ Fill Element Description }}

```yaml
Type: IWebElement
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -value
Value to which the specified element will be set.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OpenQA.Selenium.IWebElement

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
