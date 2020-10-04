---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Invoke-SeKeyAction

## SYNOPSIS
Perform a key down or key up in the browser or specified element.

## SYNTAX

```
Invoke-SeKeyAction [[-Element] <IWebElement>] [[-Action] <Object>] [[-Key] <String[]>] [-RightKey]
 [[-Driver] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Perform a key down or key up in the browser or specified element.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-SeKeyAction -Element $Element -Action KeyDown -Key CTRL
PS C:\> Invoke-SeKeys -Element $Element -Keys 's'
PS C:\> Invoke-SeKeyAction -Element $Element -Action KeyUp -Key CTRL
```

Perform a CTRL + S action on the specified element

## PARAMETERS

### -Action
Action to be perfomed

```yaml
Type: Object
Parameter Sets: (All)
Aliases:
Accepted values: KeyDown, KeyUp

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Driver
Target WebDriver

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Element
Target IWebElement.

```yaml
Type: IWebElement
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Key
Modifier key

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:
Accepted values: CTRL, Alt, Shift

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RightKey
Use right modifier key.

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

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
