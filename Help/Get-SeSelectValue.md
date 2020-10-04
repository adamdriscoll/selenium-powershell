---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Get-SeSelectValue

## SYNOPSIS
Get Select element selected value.

## SYNTAX

```
Get-SeSelectValue [-Element] <IWebElement> [-IsMultiSelect <PSReference>] [-All] [<CommonParameters>]
```

## DESCRIPTION
Get Select element selected value.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-SeSelectValue -Element $Select 
```

Get the selected value for the specified element.

## PARAMETERS

### -All
Get All selected values (only available when the Select element accept multiple values)

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

### -Element
{{ Fill Element Description }}

```yaml
Type: IWebElement
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -IsMultiSelect
Set the referenced variable to a boolean representing whether or not the current Select element accept multiple selections.

```yaml
Type: PSReference
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

### OpenQA.Selenium.IWebElement

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
