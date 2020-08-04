---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Open-SeUrl

## SYNOPSIS
Navigate to URL

## SYNTAX

### default (Default)
```
Open-SeUrl [-Target <Object>] [<CommonParameters>]
```

### url
```
Open-SeUrl [-Url] <String> [-Target <Object>] [<CommonParameters>]
```

### back
```
Open-SeUrl [-Back] [-Target <Object>] [<CommonParameters>]
```

### forward
```
Open-SeUrl [-Forward] [-Target <Object>] [<CommonParameters>]
```

### refresh
```
Open-SeUrl [-Refresh] [-Target <Object>] [<CommonParameters>]
```

## DESCRIPTION
Navigate to URL

## EXAMPLES

### Example 1
```powershell
PS C:\> Open-SeUrl -Url 'https://www.google.com'
```

Open URL into currently selected Driver 

## PARAMETERS

### -Back
Enables the web browser to click on the back button in the existing browser window.

```yaml
Type: SwitchParameter
Parameter Sets: back
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Forward
enables the web browser to click on the forward button in the existing browser window.

```yaml
Type: SwitchParameter
Parameter Sets: forward
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Refresh
enables the web browser to click on the refresh button in the existing browser window.

```yaml
Type: SwitchParameter
Parameter Sets: refresh
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
Target webdriver

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Driver

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Url
Url to navigate to

```yaml
Type: String
Parameter Sets: url
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

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
