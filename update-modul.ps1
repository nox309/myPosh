$Params = @{ 
    "Path" 				    = '.\src\myPosh\myPosh.psd1' 
    "Author" 			    = 'Torben Inselmann'
    "CompanyName"           = ' '
    "PowerShellVersion"     = '7.0'
    "RootModule" 			= 'myPosh.psm1'
    "ModuleVersion" 		= '0.2.0' 
    "CompatiblePSEditions" 	= @('Desktop','Core') 
    "FunctionsToExport" 	= @('start-myPoshUpdate','get-myPoshUpdate','Write-Log') 
    # "CmdletsToExport" 		= ''
    # "VariablesToExport" 	= '' 
    # "AliasesToExport" 		= @() 
    "Description"           = 'Powershell helper module for myPosh'
    "HelpInfoURI"           = 'https://github.com/nox309/myPosh'
} 
#New-ModuleManifest @Params
Update-ModuleManifest @Params