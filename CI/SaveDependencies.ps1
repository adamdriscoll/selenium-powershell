New-Item -ItemType Directory -Path './Modules'
$Params = @{Path = './Modules'; Repository = 'PSGallery' }
Save-Module -Name Pester -RequiredVersion 4.10.1 @Params
Save-Module -Name ImportExcel -RequiredVersion 7.1.1 @Paramsb