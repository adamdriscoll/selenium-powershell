---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Invoke-SeClick

## SYNOPSIS
Select an element then send a click action on it.

## SYNTAX

### Default (Default)
```
Invoke-SeClick -Element <IWebElement> [<CommonParameters>]
```

### JavaScript
```
Invoke-SeClick -Element <IWebElement> [-JavaScriptClick] [-Driver <Object>] [<CommonParameters>]
```

## DESCRIPTION
Select an element then send a click action on it.

## EXAMPLES

## PARAMETERS

### -Driver
Target webdriver

```yaml
Type: Object
Parameter Sets: JavaScript
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Element
Element for which the click will be performed upon

```yaml
Type: IWebElement
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -JavaScriptClick
Use Javascript to perform the click

```yaml
Type: SwitchParameter
Parameter Sets: JavaScript
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

### OpenQA.Selenium.IWebElement

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
