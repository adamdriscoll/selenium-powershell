---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Set-SeDriverTimeout

## SYNOPSIS
Set the various driver timeouts default.

## SYNTAX

```
Set-SeDriverTimeout [[-TimeoutType] <Object>] [[-Timeout] <Double>] [-Driver <IWebDriver>] [<CommonParameters>]
```

## DESCRIPTION
Set the various driver timeouts default.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-SeDriverTimeout -TimeoutType ImplicitWait -Timeout 0
```

Set Implicit wait timeout to 0 

## PARAMETERS

### -Driver
Target IWebDriver

```yaml
Type: IWebDriver
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Timeout
Value in seconds

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutType
Type of timeout to change.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: ImplicitWait, PageLoad, AsynchronousJavaScript

Required: False
Position: 0
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
