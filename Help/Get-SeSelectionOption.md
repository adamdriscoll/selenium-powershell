---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Get-SeSelectionOption

## SYNOPSIS
Get Selected option from a Select control

## SYNTAX

### default (Default)
```
Get-SeSelectionOption [-Element] <IWebElement> [-Clear] [-ListOptionText] [<CommonParameters>]
```

### byValue
```
Get-SeSelectionOption [-ByValue] <String> [-Element] <IWebElement> [-Clear] [-GetSelected] [-GetAllSelected]
 [-PassThru] [<CommonParameters>]
```

### byText
```
Get-SeSelectionOption [-Element] <IWebElement> -ByFullText <String> [-Clear] [-GetSelected] [-GetAllSelected]
 [-PassThru] [<CommonParameters>]
```

### bypart
```
Get-SeSelectionOption [-Element] <IWebElement> -ByPartialText <String> [-GetSelected] [-GetAllSelected]
 [-PassThru] [<CommonParameters>]
```

### byIndex
```
Get-SeSelectionOption [-Element] <IWebElement> -ByIndex <Int32> [-Clear] [-GetSelected] [-GetAllSelected]
 [-PassThru] [<CommonParameters>]
```

### multi
```
Get-SeSelectionOption [-Element] <IWebElement> [-IsMultiSelect] [<CommonParameters>]
```

### selected
```
Get-SeSelectionOption [-Element] <IWebElement> [-GetSelected] [<CommonParameters>]
```

### allSelected
```
Get-SeSelectionOption [-Element] <IWebElement> [-GetAllSelected] [<CommonParameters>]
```

## DESCRIPTION
Get Selected option from a Select control

## EXAMPLES

## PARAMETERS

### -ByFullText
{{ Fill ByFullText Description }}

```yaml
Type: String
Parameter Sets: byText
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ByIndex
{{ Fill ByIndex Description }}

```yaml
Type: Int32
Parameter Sets: byIndex
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ByPartialText
{{ Fill ByPartialText Description }}

```yaml
Type: String
Parameter Sets: bypart
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ByValue
{{ Fill ByValue Description }}

```yaml
Type: String
Parameter Sets: byValue
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Clear
Deselect the option first

```yaml
Type: SwitchParameter
Parameter Sets: default, byValue, byText, byIndex
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Element
Targeted IwebElement

```yaml
Type: IWebElement
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -GetAllSelected
All selected options belonging to this select tag

```yaml
Type: SwitchParameter
Parameter Sets: byValue, byText, bypart, byIndex
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: allSelected
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GetSelected
Get selected option

```yaml
Type: SwitchParameter
Parameter Sets: byValue, byText, bypart, byIndex
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: SwitchParameter
Parameter Sets: selected
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsMultiSelect
To use with multiselect element

```yaml
Type: SwitchParameter
Parameter Sets: multi
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListOptionText
This parameter is not used

```yaml
Type: SwitchParameter
Parameter Sets: default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Return IWebElement

```yaml
Type: SwitchParameter
Parameter Sets: byValue, byText, bypart, byIndex
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

### System.String

### OpenQA.Selenium.IWebElement

### System.Int32

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
