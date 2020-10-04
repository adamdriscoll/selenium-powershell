---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Get-SeWindow

## SYNOPSIS
Gets the window handles of open browser windows

## SYNTAX

```
Get-SeWindow [[-Driver] <IWebDriver>] [<CommonParameters>]
```

## DESCRIPTION
Gets the window handles of open browser windows

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-SeWindow
```

Gets the window handles of open browser windows.

## PARAMETERS

### -Driver
Target WebDriver

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
