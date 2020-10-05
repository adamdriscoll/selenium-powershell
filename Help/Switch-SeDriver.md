---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Switch-SeDriver

## SYNOPSIS
Select a driver, making it the default to be used with any ulterior calls whenever the driver parameter is not specified.

## SYNTAX

### ByName (Default)
```
Switch-SeDriver [-Name] <String> [<CommonParameters>]
```

### ByDriver
```
Switch-SeDriver [-Driver] <IWebDriver> [<CommonParameters>]
```

## DESCRIPTION
Select a driver, making it the default to be used with any ulterior calls whenever the driver parameter is not specified.

## EXAMPLES

### Example 1
```powershell
PS C:\> $Driver = Start-SeDriver -Browser Chrome 
# Chrome is the only and default driver
PS C:\> Get-SeDriver -Current
PS C:\> Start-SeDriver -Browser Firefox
# Firefox is now the default browser
PS C:\> Get-SeDriver -Current
PS C:\> Switch-SeDriver -Driver $Driver
# Chrome is the default browser again
PS C:\> Get-SeDriver -Current
```

This examples show the default browser changing from Chrome to Firefox when the second instance is launched, then set back to Chrome through Switch-SeDriver

## PARAMETERS

### -Driver
Target WebDriver

```yaml
Type: IWebDriver
Parameter Sets: ByDriver
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
SeFriendlyName of the browser to select.

```yaml
Type: String
Parameter Sets: ByName
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
