---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Get-SeUrl

## SYNOPSIS
Retrieves the current URL of a target webdriver instance.

## SYNTAX

```
Get-SeUrl [-Stack] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the current URL of a target webdriver instance, or the currently
stored internal location stack.

## EXAMPLES

### EXAMPLE 1
```
Get-SeUrl
```

Retrieves the current URL of the default webdriver instance.

## PARAMETERS

### -Stack
Optionally retrieve the stored URL stack for the target or default
webdriver instance.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
When using -Stack, the retrieved stack will not contain any of the driver's
history (Back/Forward) data.
It only handles locations added with
Push-SeUrl.

To utilise a driver's Back/Forward functionality, instead use Set-SeUrl.

## RELATED LINKS
