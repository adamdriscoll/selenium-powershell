---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Clear-SeAlert

## SYNOPSIS
Accept and clear alert popup

## SYNTAX

### Alert
```
Clear-SeAlert [[-Alert] <Object>] [-Action <Object>] [-PassThru] [<CommonParameters>]
```

### Driver
```
Clear-SeAlert [-Target <Object>] [-Action <Object>] [-PassThru] [<CommonParameters>]
```

## DESCRIPTION
Accept and clear alert popup

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

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
Parameter Sets: Alert
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
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

### -Target
Target webdriver

```yaml
Type: Object
Parameter Sets: Driver
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
