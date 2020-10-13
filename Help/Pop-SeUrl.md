---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Pop-SeUrl

## SYNOPSIS
Navigate back to the most recently pushed URL in the location stack.

## SYNTAX

```
Pop-SeUrl [<CommonParameters>]
```

## DESCRIPTION
Retrieves the most recently pushed URL from the location stack and navigates
to that URL with the specified or default driver.

## EXAMPLES

### EXAMPLE 1
```
Pop-SeUrl
```

Retrieves the most recently pushed URL and navigates back to that URL.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
A separate internal location stack is maintained for each driver instance
by the module.
This stack is completely separate from the driver's internal
Back/Forward history logic.

To utilise a driver's Back/Forward functionality, instead use Set-SeUrl.

## RELATED LINKS
