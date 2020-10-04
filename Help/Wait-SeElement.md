---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Wait-SeElement

## SYNOPSIS
Wait for an element condition to be met.

## SYNTAX

### Element (Default)
```
Wait-SeElement -Element <IWebElement> [-Condition <Object>] [-ConditionValue <Object>] [-Timeout <Double>]
 [-Driver <Object>] [<CommonParameters>]
```

### Locator
```
Wait-SeElement [[-By] <SeBySelector>] [-Value] <String> [-Condition <Object>] [-ConditionValue <Object>]
 [-Timeout <Double>] [-Driver <Object>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> Wait-SeElement -Element $Element -Condition StalenessOf
```

Wait for the specified element to not exist anymore in the DOM for 3 seconds (default timeout)

## PARAMETERS

### -By
Locator element.

```yaml
Type: SeBySelector
Parameter Sets: Locator
Aliases:
Accepted values: ClassName, CssSelector, Id, LinkText, PartialLinkText, Name, TagName, XPath

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Condition
Condition expected to be met. Some condition are only available with locator or element.

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

### -ConditionValue
Value of the expected condition to be met.

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

### -Driver
{{ Fill Driver Description }}

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

### -Element
Element that need to meet the condition.

```yaml
Type: IWebElement
Parameter Sets: Element
Aliases:

Required: True
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Value of the locator corresponding to the element that should match the Condition / ConditionValue.

```yaml
Type: String
Parameter Sets: Locator
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
