---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Invoke-SeClick

## SYNOPSIS
Perform a click in the browser window or specified element.

## SYNTAX

```
Invoke-SeClick [[-Action] <Object>] [[-Element] <IWebElement>] [-Sleep <Double>] [-Driver <IWebDriver>]
 [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Perform a click in the browser window or specified element.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-SeClick
```

Perform a click in the browser at the current position

### Example 2
```powershell
PS C:\> Invoke-SeClick -Action Click_JS -Element $Element
```

Perform a javascript click on the specified element. 

## PARAMETERS

### -Action
test

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Driver
Target WebDriver

```yaml
Type: IWebDriver
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Element
Target IWebElement.

```yaml
Type: IWebElement
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PassThru
Return the IWebElement.

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

### -Sleep
Sleep time in second after performing the click action.

```yaml
Type: Double
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
