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
Get-SeDriverTimeout [[-TimeoutType] <Object>] [<CommonParameters>]
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

### -TimeoutType
Timeout type to be changed

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: ImplicitWait, PageLoad, AsynchronousJavaScript

Required: False
Position: 0
Default value: ImplicitWait
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
