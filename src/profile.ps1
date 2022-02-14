<#
.NAME
    myPosh_Profile
.SYNOPSIS
    The myPosh profile for Powershell adds useful functions to the system.
.DESCRIPTION
    The myPosh profile for Powershell adds useful functions to the system.
    For example, it improves the look and feel of Powershell when working with Git. Also some functions and aliases are added.
.FUNCTIONALITY
    when Powershell is started, this profile is loaded.
.NOTES
    Author: nox309
    Email: support@inselmann.it
    Git: https://github.com/nox309
    DateCreated: 2022/01/01
.LINK
    https://github.com/nox309/myPosh
#>

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
# Function to test if the current host is being run as an administrator.
$WID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$Prp = New-Object System.Security.Principal.WindowsPrincipal($WID)
$Adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$IsAdmin = $Prp.IsInRole($Adm)

#define all variables
$myPosh_Version = Get-Content $env:ProgramData/myPosh/version.txt
$GlobalReleaseVersion = 'Get-Content -Path $env:TMP\version.txt'

#prepair Variables for global use 
Set-Variable -Name GlobalReleaseVersion -Option AllScope
Set-Variable -Name IsAdmin -Option AllScope
Set-Variable -Name myPosh_Version -Option AllScope

Import-Module posh-git
Import-Module oh-my-posh
Import-Module Terminal-Icons



#---------------------------------------------------------[Config]-----------------------------------------------------------------

If (-Not (Test-Path Variable:PSise)) {  # Only run this in the console and not in the ISE
    Import-Module Get-ChildItemColor
    Set-Alias l Get-ChildItem -option AllScope
    Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
}

#Set alias
Set-Alias ip 'ipconfig'

#---------------------------------------------------------[Functions]--------------------------------------------------------------
# System Functions for profil
function get-MoD {
    ##Build the MoD/banner
    #Referenz https://artii.herokuapp.com/
    $Font = @(
        "whimsy",
        "rounded",
        "nancyj"
    )
    $MoD_Font = $Font | Get-Random -Count 1 #get one Random Front
    $URL = 'https://artii.herokuapp.com/make?text=myPhosh&font='+$MoD_Font #sets the URL for the banner together
    
    #Runtime optimization, only if Api is reachable the banner is displayed
    if (Test-Connection github.com -Count 1 -TimeoutSeconds 2) {
        invoke-restmethod $URL -TimeoutSec 5
    }
}

function Get-Uptime {
    $LastBootUpTime=Get-WinEvent -ProviderName eventlog | Where-Object {$_.Id -eq 6005} | Select-Object TimeCreated -First 1
    $LastBootUpTime.TimeCreated
}
function prompt{
    #creates and updates the pormt interface and title.
	$host.ui.RawUI.WindowTitle = $(get-location)
	"[PS7] [$env:username] $(get-location)>"
	if ($IsAdmin)
	{
		"[PS7] [$env:username] $(get-location)>"
		$host.ui.RawUI.WindowTitle = "Administrator:" + " " + $(get-location)
	}
}
#"public" functions for users
function Start-asAdmin {
    param (
        [Parameter(mandatory=$true)]
        [string] $applicaton
    )
    Start-Process $applicaton -Verb runAs
     <#
        .DESCRIPTION
        Starts an application with admin rights or with user login

        .PARAMETER applicaton
        Enter the full path to the .exe

        .EXAMPLE
        PS> Start-asAdmin -applicaton notepad.exe

        .EXAMPLE
        PS> Start-asAdmin -applicaton "C:\Program Files\Mozilla Firefox\firefox.exe"

        .EXAMPLE
        PS> Start-asAdmin -applicaton .\firefox.exe
    #>
}

function Start-PSasAdmin {
    Start-Process wt -Verb runAs
     }
function Get-Profil {
    Write-Host -Foregroundcolor Green "Profil Version is" $myPosh_Version
    Write-Host -Foregroundcolor Green "With 'get-myPoshUpdate' can be check for updates."
    Write-Host -Foregroundcolor Green "List of all profil path:"
    $Profile | Select-Object *
 }

#---------------------------------------------------------[Logic]-------------------------------------------------------------------
Clear-Host

if( $IsAdmin ){
    Write-Host 
    Write-Host -ForegroundColor Red "Powershell started with admin rights!"
    Write-Host 
    }

get-MoD
Write-Host
Write-Host -Foregroundcolor Green 'Systemname:' "$env:computername" 
Write-Host -Foregroundcolor Green "Login User:" "$env:username"
Write-Host -Foregroundcolor Green "Date: " (Get-Date)
Write-Host -Foregroundcolor Green "System IP Adresse:" (Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias Ethernet*).IPAddress
Write-Host -Foregroundcolor Green "System is up since:" (Get-Uptime)
Set-Location c:\
# Not Workinfg for the moment / Set-PoshPrompt -Theme Paradox
#oh-my-posh --init --shell pwsh --config $env:ProgramData/myPosh/config/OMP_config.json | Invoke-Expression
Set-PoshPrompt -Theme $env:ProgramData/myPosh/config/OMP_config.json