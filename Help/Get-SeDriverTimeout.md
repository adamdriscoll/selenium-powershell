---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Get-SeDriverTimeout

## SYNOPSIS
Get the specified driver timeout value.

## SYNTAX

```
Get-SeDriverTimeout [[-TimeoutType] <Object>] [-Driver <IWebDriver>] [<CommonParameters>]
```

## DESCRIPTION
Get the specified driver timeout value.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-SeDriverTimeout
```

Return the currently selected driver implicit wait timeout.

### Example 2
```powershell
PS C:\> Get-SeDriverTimeout -TimeoutType PageLoad -Driver $Driver
```

Return the specified driver PageLoad timeout.

## PARAMETERS

### -Driver
{{ Fill Driver Description }}

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

### -TimeoutType
{{ Fill TimeoutType Description }}

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
