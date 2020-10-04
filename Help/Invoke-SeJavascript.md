---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Invoke-SeJavascript

## SYNOPSIS
Invoke Javascript in the specified Driver.

## SYNTAX

```
Invoke-SeJavascript [[-Driver] <IWebDriver>] [[-Script] <String>] [[-ArgumentList] <Object[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Invoke Javascript in the specified Driver. arguments will be passed to the javascript as "argument[0]" (where 0 is the argument position)

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-SeJavascript -Script 'arguments[0].click()' -ArgumentList $Element
```

Perform a javascript click on the specified element.

## PARAMETERS

### -ArgumentList
Argument list to be passed down to the script. 

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Driver
{{ Fill Driver Description }}

```yaml
Type: IWebDriver
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Script
Javascript script to be executed. Arguments passed down can be used in the scripts through `arguments[0],arguments[1]`,etc...  

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OpenQA.Selenium.IWebDriver

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
