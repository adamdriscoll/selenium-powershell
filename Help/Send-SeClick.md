---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Send-SeClick

## SYNOPSIS
Send a click to the targeted element

## SYNTAX

```
Send-SeClick [-Element] <IWebElement> [-JavaScriptClick] [-SleepSeconds <Object>] [-Driver <Object>]
 [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Send a click to the targeted element

## EXAMPLES

### Example 1
```powershell
PS C:\> (Get-SeElement -By Name -Selection 'ButtonX') | Send-SeClick
```

Select an element then send a click action on it.

## PARAMETERS

### -Driver
Target webdriver

```yaml
Type: Object
Parameter Sets: (All)
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
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -JavaScriptClick
Use Javascript to perform the click

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: JS

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Return the **IWebElement**

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

### -SleepSeconds
Sleep time in seconds after the click

```yaml
Type: Object
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
