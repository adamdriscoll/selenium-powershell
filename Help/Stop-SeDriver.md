---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Stop-SeDriver

## SYNOPSIS
Quits this driver, closing every associated window.

## SYNTAX

```
Stop-SeDriver [[-Driver] <IWebDriver>] [<CommonParameters>]
```

## DESCRIPTION
Quits this driver, closing every associated window.

## EXAMPLES

### Example 1
```powershell
PS C:\> Stop-SeDriver -Target $Driver
```

Stop the specified driver

### Example 1
```powershell
PS C:\> Start-SeChrome -AsDefaultDriver
PS C:\> Stop-SeDriver
```

Stop the default driver, which was defined using the `-AsDefaultDriver` switch.

## PARAMETERS

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### OpenQA.Selenium.IWebDriver

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
