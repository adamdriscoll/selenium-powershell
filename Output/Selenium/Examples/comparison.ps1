
<#
public void testClass() throws Exception {
    driver.get("http://www.wikipedia.org/") ;
    Assert.assertequals("wikipedia", driver.getTitle());
    Assert.assertequals("English", driver.findElement(By.cssselector("strong")).getText())
    driver.findElement(By.cssSetector("strong")).click() ;
    Assert.assertEquals("Wikipedia. the free encyclopedia", driver.getTitle());
}
#>
Start-SeDriver -Browser Chrome -StartURL  "https://www.wikipedia.org/"
SeShouldHave -Title eq Wikipedia
SeShouldHave 'strong' -By CssSelector -With  Text eq 'English' -PassThru | Invoke-SeClick
SeShouldHave -Title eq 'Wikipedia, the free encyclopedia'

<#
line 2                 ##  SeShouldHave -Title eq Wikipedia
is actutally short for ##  SeShouldHave -Title -Operator 'eq' -Value Wikipedia
other values for -operator will translate to "eq", and parameters are defined so you can use -eq -contains, -match etc
so you can use         ##  SeShouldHave -Title equalTo Wikipedia
or                     ##  SeShouldHave -Title -eq Wikipedia
line 3                 ##  SeShouldHave 'strong' -By CssSelector  Text eq 'English'
This is short for     ##  SeShouldHave -Selection 'strong' -By CssSelector -With Text -operator "eq" -value  'English'
if the selector is an xPath the -By parameter can be omitted; but if used -By must specified explicitly
The first unnamed parameter will be treated as selection, the second as "with" , the third as operator and the fourth as value.
SeShouldhave can take a -passthru parameter allowing the original lines 3 and 4 to be merged,

The last line 5 is similar to line 2 but the parameter value has a sppace so must be wrapped in quotes
#>

<#https://www.guru99.com/first-webdriver-script.html had this
public static void main(String[] args) {
    System.setProperty("webdriver.gecko.driver","C:\\geckodriver.exe");
    WebDriver driver = new FirefoxDriver();
    //comment the above 2 lines and uncomment below 2 lines to use Chrome
    //System.setProperty("webdriver.chrome.driver","G:\\chromedriver.exe");
    //WebDriver driver = new ChromeDriver();

    String baseUrl = "http://demo.guru99.com/test/newtours/";
    driver.get(baseUrl);

    String expectedTitle = "Welcome: Mercury Tours";
    String actualTitle = "";
    actualTitle = driver.getTitle();
    if (actualTitle.contentEquals(expectedTitle)){
        System.out.println("Test Passed!");
    } else {
        System.out.println("Test Failed");
    }

    driver.close();
}
#>

Start-SeDriver -Browser Firefox -StartURL "http://demo.guru99.com/test/newtours/"  
SeShouldHave -Title eq "Welcome: Mercury Tours"

#Stop opened drivers 
Get-SeDriver | Stop-SeDriver

