---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Switch-SeFrame

## SYNOPSIS
Instructs the driver to send future commands to a different frame

## SYNTAX

### Frame
```
Switch-SeFrame [-Frame] <Object> [-Target <Object>] [<CommonParameters>]
```

### Parent
```
Switch-SeFrame [-Parent] [-Target <Object>] [<CommonParameters>]
```

### Root
```
Switch-SeFrame [-Root] [-Target <Object>] [<CommonParameters>]
```

## DESCRIPTION
Instructs the driver to send future commands to a different frame

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Frame
{{ Fill Frame Description }}

```yaml
Type: Object
Parameter Sets: Frame
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Parent
{{ Fill Parent Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Parent
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Root
{{ Fill Root Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Root
Aliases: defaultContent

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Target
{{ Fill Target Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
