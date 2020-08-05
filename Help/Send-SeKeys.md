---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Send-SeKeys

## SYNOPSIS
Simulates typing text into the element

## SYNTAX

```
Send-SeKeys [-Element] <IWebElement> [-Keys] <String> [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Simulates typing text into the element.

The text to be typed may include special characters like arrow keys, backspaces, function keys, and so on. Valid special keys are defined in Keys.  [OpenQA_Selelnium_Keys](https://www.selenium.dev/selenium/docs/api/dotnet/html/T_OpenQA_Selenium_Keys.htm)

## EXAMPLES

### Example 1
```powershell
PS C:\> SeType -Keys 'Powershell-Selenium{{Enter}}' -PassThru
```

ype the defined text and a special key - Enter - defined in the special keys.

## PARAMETERS

### -Element
Specify the element where the keys will be typed to

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

### -Keys
Text to be typed. Special keys (Enter, arrow down, etc...) can be typed using double brackets (eg: `{{Enter}}`). See cmdlet description for complete list of keys

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

### -PassThru
Return `$Element`

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: PT

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
