---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Invoke-SeMouseAction

## SYNOPSIS
Perform mouse move & drag actions.

## SYNTAX

```
Invoke-SeMouseAction [[-Driver] <Object>] [[-Action] <Object>] [[-Value] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Perform mouse move & drag actions.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-SeMouseAction -Element $SourceElement -Action DragAndDrop -Value $DestinationElement
```

Perform a drag&drop operation from the source element to destination element.

## PARAMETERS

### -Action
Action to be performed. Intellisense tooltip provide details regarding expected value.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Driver
{{ Fill Driver Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Value expected by the specified action.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
