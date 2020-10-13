---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Get-SeHtml

## SYNOPSIS
Get outer html of the specified element or driver.

## SYNTAX

```
Get-SeHtml [[-Element] <IWebElement>] [-Inner] [<CommonParameters>]
```

## DESCRIPTION
Get outer html of the specified element or driver.
Driver is used by default if no element is specified.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Element = Get-SeElement -By ClassName -Value 'homeitem'
PS C:\> $Element | Get-SeHtml -Inner
```

Get inner html for all specified elements.

### Example 2
```powershell
PS C:\> Get-SeHtml
```

Get html of the current page. Equivalent to $Driver.PageSource

## PARAMETERS

### -Element
Target IWebElement.

```yaml
Type: IWebElement
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Inner
Return inner html instead.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
