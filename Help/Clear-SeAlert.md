---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Clear-SeAlert

## SYNOPSIS
Clear alert popup by dismissing or accepting it.

## SYNTAX

```
Clear-SeAlert [-Driver <Object>] [-Action <Object>] [-Alert <Object>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Clear alert popup by dismissing or accepting it.

## EXAMPLES

### Example 1
```powershell
PS C:\> Clear-SeAlert -Action Dismiss
```

Dismiss an alert on the currently selected driver.

## PARAMETERS

### -Action
Action to be performed on the alert popup

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: Accept, Dismiss

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Alert
Specify alert window. Seems to be ignored in favor of Target / Default Target.

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

### -Driver
{{ Fill Driver Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
{{ Fill PassThru Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
