# Instructions

## Prerequisites
- InvokeBuild module
- PlatyPS module

## How to

### Debug

To load the debugging version, simply load the Selenium.psd1 located at the root of this directory.

`import-module "$ProjectPath\Selenium.psd1" -Force`

To load the compiled version, load the psd1 located in the output directory instead. 

`import-module "$ProjectPath\output\selenium\Selenium.psd1" -Force`

When developping, you should always load the development version of the module. Never work in the files from the **output** directory directly as these will be wiped out whenever you compile the module again.

### Compile the module
The module is scaffolded into multiple files for convenience and compiled into a psm1 file when ready to be published. 

Alongside this, additional tasks are performed suche as basic Powershell validation, self-updating Markdown documentation, embedded help file generation, psd1 function replace based on Public folder content, etc. 

To perform these tasks and produce a compiled (but not packaged) version of the module, run the following

`invoke-build -File "$ProjectPath\Selenium.build.ps1"`


See the debug.ps1 file in this directory to get started.