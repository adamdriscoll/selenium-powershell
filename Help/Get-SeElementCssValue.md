---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Get-SeElementCssValue

## SYNOPSIS
Get CSS value for the specified name of targeted element.

## SYNTAX

```
Get-SeElementCssValue [-Element] <IWebElement> [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Get CSS value for the specified name of targeted element.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-SeElementCssValue -Element $Element -Name 'padding'
```

Get padding css value for the targeted element.

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
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
Name of the CSS attribute to query

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OpenQA.Selenium.IWebElement

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
