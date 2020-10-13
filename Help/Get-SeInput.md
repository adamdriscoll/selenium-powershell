---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Get-SeInput

## SYNOPSIS
Get element with an input tagname matching the specified conditions.

## SYNTAX

```
Get-SeInput [[-Type] <String>] [-Single] [[-Text] <String>] [[-Timeout] <Double>] [-All]
 [[-Attributes] <String[]>] [[-Value] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get SeElement with an input Tagname 

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-SeInput -Attributes placeholder,title -All -Single -Value 'Type to search'
```

Get all the input (including hidden) present in the Dom and load the attributes placeholder and title. A single value is expected and it's attribute placeholder should be equals to : "Type to search"

## PARAMETERS

### -All
Return matching hidden items in addition to displayed ones.

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

### -Attributes
Append a list of Attributes (case sensitive) to each element returned. Attributes will be available through a dictionary property of the same name. Is the wildcard `*` character is used, all attributes will be queried and appended.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Single
Expectation that only one element will be returned. An error will be returned if that parameter is set and more than one corresponding element is found.

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

### -Text
Text of the input to return

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timeout
Timeout (in seconds)

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

### -Type
Type of the input

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Expected value of the first attribute present.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
