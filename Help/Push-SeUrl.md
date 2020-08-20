---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Push-SeUrl

## SYNOPSIS
Stores the current URL in the driver's location stack and optionally
navigate to a new URL.

## SYNTAX

```
Push-SeUrl [[-Url] <String>] [-Driver <Object>] [<CommonParameters>]
```

## DESCRIPTION
The current driver URL is added to the stack, and if a URL is provided, the
driver navigates to the new URL.

## EXAMPLES

### EXAMPLE 1
```
Push-SeUrl
```

The current driver URL is added to the location stack.

### EXAMPLE 2
```
Push-SeUrl 'https://google.com/'
```

The current driver URL is added to the location stack, and the driver then
navigates to the provided target URL.

## PARAMETERS

### -Url
The new URL to navigate to after storing the current location.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Driver
The webdriver instance that owns the url stack, and will navigate to
a provided new url (if any).

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $Script:SeDriversCurrent
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

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
