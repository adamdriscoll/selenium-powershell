---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Wait-SeDriver

## SYNOPSIS
Wait for the driver to be in the desired state.

## SYNTAX

```
Wait-SeDriver [-Condition] <Object> [-Value] <Object> [[-Timeout] <Double>] [<CommonParameters>]
```

## DESCRIPTION
Wait for the driver to be in the desired state.

## EXAMPLES

### Example 1
```powershell
PS C:\> Wait-SeDriver -Condition UrlContains 'next-' -Timeout 5.5
```

Wait 5.5 seconds for the driver URL to contains text "next-"

## PARAMETERS

### -Condition
Condition that is expected to be met.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Time delimiter in second for which the operation should succeed.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Condition value expected to be met.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
