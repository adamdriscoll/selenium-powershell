---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Set-SeUrl

## SYNOPSIS
Navigates to the targeted URL with the selected or default driver.

## SYNTAX

### default (Default)
```
Set-SeUrl [-Driver <Object>] [<CommonParameters>]
```

### url
```
Set-SeUrl [-Url] <String> [-Driver <Object>] [<CommonParameters>]
```

### back
```
Set-SeUrl [-Back] [-Depth <Int32>] [-Driver <Object>] [<CommonParameters>]
```

### forward
```
Set-SeUrl [-Forward] [-Depth <Int32>] [-Driver <Object>] [<CommonParameters>]
```

### refresh
```
Set-SeUrl [-Refresh] [-Driver <Object>] [<CommonParameters>]
```

## DESCRIPTION
Used for webdriver navigation commands, either to specific target URLs or
for history (Back/Forward) navigation or refreshing the current page.

## EXAMPLES

### EXAMPLE 1
```
Set-SeUrl 'https://www.google.com/'
```

Directs the default driver to navigate to www.google.com.

### EXAMPLE 2
```
Set-SeUrl -Refresh
```

Reloads the current page for the default driver.

### EXAMPLE 3
```
Set-SeUrl -Target $Driver -Back
```

Directs the targeted webdriver instance to navigate Back in its history.

### EXAMPLE 4
```
Set-SeUrl -Forward
```

Directs the default webdriver to navigate Forward in its history.

## PARAMETERS

### -Url
The target URL for the webdriver to navigate to.

```yaml
Type: String
Parameter Sets: url
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Back
Trigger the Back history navigation action in the webdriver.

```yaml
Type: SwitchParameter
Parameter Sets: back
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Forward
Trigger the Forward history navigation action in the webdriver.

```yaml
Type: SwitchParameter
Parameter Sets: forward
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Refresh
Refresh the current page in the webdriver.

```yaml
Type: SwitchParameter
Parameter Sets: refresh
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Depth
Number of time the action should be performed.

```yaml
Type: Int32
Parameter Sets: back, forward
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Driver
The target webdriver to manage navigation for.
Will utilise the
default driver if left unset.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
The Back/Forward/Refresh logic is handled by the webdriver itself.
If you
need a more granular approach to handling which locations are saved or
retrieved, use Push-SeUrl or Pop-SeUrl to utilise a separately managed
location stack.

## RELATED LINKS
