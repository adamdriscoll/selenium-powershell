---
external help file: Selenium-help.xml
Module Name: Selenium
online version:
schema: 2.0.0
---

# Start-SeRemote

## SYNOPSIS
Start a remote driver session.

## SYNTAX

```
Start-SeRemote [-RemoteAddress <String>] [-DesiredCapabilities <Hashtable>] [[-StartURL] <String>]
 [-ImplicitWait <Double>] [-Size <Size>] [-Position <Point>] [<CommonParameters>]
```

## DESCRIPTION
Start a remote driver session.
you can a remote testing account with testing bot at https://testingbot.com/users/sign_up

## EXAMPLES

### Example 1
```powershell
#Set $key and $secret and then ...
        #see also https://crossbrowsertesting.com/freetrial / https://help.crossbrowsertesting.com/selenium-testing/getting-started/c-sharp/
        #and https://www.browserstack.com/automate/c-sharp
        $RemoteDriverURL = [uri]"http://$key`:$secret@hub.testingbot.com/wd/hub"
        #See https://testingbot.com/support/getting-started/csharp.html for values for different browsers/platforms
        $caps = @{
          platform     = 'HIGH-SIERRA'
          version      = '11'
          browserName  = 'safari'
        }
        Start-SeRemote -RemoteAddress $remoteDriverUrl -DesiredCapabilties $caps
```


## PARAMETERS

### -DesiredCapabilities
{{ Fill DesiredCapabilities Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImplicitWait
{{ Fill ImplicitWait Description }}

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

### -Position
{{ Fill Position Description }}

```yaml
Type: Point
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoteAddress
{{ Fill RemoteAddress Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Size
{{ Fill Size Description }}

```yaml
Type: Size
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartURL
{{ Fill StartURL Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
