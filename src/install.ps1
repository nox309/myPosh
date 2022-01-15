<#
.NAME
    Install_myPosh
.SYNOPSIS
    Install Script for myPosh.
.DESCRIPTION
    This script installs all the dependencies needed to run myPosh.
    This includes PS modules for Git and oh-my-posh.
.NOTES
    Author: nox309
    Email: support@inselmann.it
    Git: https://github.com/nox309
    Version: 1.0
    DateCreated: 2022/01/01
.LINK
    https://github.com/nox309/myPosh
#>

#---------------------------------------------------------[Config]-----------------------------------------------------------------
$WID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$Prp = New-Object System.Security.Principal.WindowsPrincipal($WID)
$Adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$IsAdmin = $Prp.IsInRole($Adm)
$PSuserPath = $PROFILE.AllUsersAllHosts
$FontFolder = ".\Meslo"
$FontItem = Get-Item -Path $FontFolder
$FontList = Get-ChildItem -Path "$FontItem\*" -Include ('*.fon','*.otf','*.ttc','*.ttf')

#---------------------------------------------------------[Functions]--------------------------------------------------------------


function get-MoD {
    ##Build the MoD/banner
    #Referenz https://artii.herokuapp.com/
    $Font = @(
        "whimsy",
        "rounded",
        "nancyj"
    )
    $MoD_Font = $Font | Get-Random -Count 1 #get one Random Front
    $URL = 'https://artii.herokuapp.com/make?text=Install+myPhosh&font='+$MoD_Font #sets the URL for the banner together
    
    #Runtime optimization, only if Api is reachable the banner is displayed
    if (Test-Connection github.com -Count 1 -TimeoutSeconds 2) {
        invoke-restmethod $URL -TimeoutSec 5
    }
}

function install-noRequest {
    if(-not(Test-Path C:\ProgramData\chocolatey)){
        Write-Host -ForegroundColor red "Seems Chocolatey is not installed, installing now"
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }else{
        Write-Host -ForegroundColor Green "Chocolatey is already installed"
    }

    if(-not(Test-Path C:\Programme\WindowsApps\Microsoft.WindowsTerminal_1.11.3471.0_x64__8wekyb3d8bbwe\WindowsTerminal.exe)){
        Write-Host -ForegroundColor red "Seems Windows Terminal is not installed, installing now"
        choco install microsoft-windows-terminal -y 
    }else{
        Write-Host -ForegroundColor Green "Windows Terminal is already installed"
    }

    if(-not(Test-Path C:\Program Files\Git)){
        Write-Host -ForegroundColor red "Seems Git for Windows is not installed, installing now"
        choco install git -y
    }else{
        Write-Host -ForegroundColor Green "Git for Windows is already installed"
    }
}

function install-Request {

    if(-not(Test-Path C:\ProgramData\chocolatey)){
        Write-Host -ForegroundColor red "Seems Chocolatey is not installed, installing now"
        $choco = Read-Host -Prompt "The package manager Chocolatey is not installed, but it is needed. Should it be installed now? YES/NO"
        if ("yes" -eq $choco) {
            Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
            }
        else {
            Write-Host -ForegroundColor Red "The installation of the Package Manager was rejected. Installation is stopped."
            break
        }
    }
    else{
        Write-Host -ForegroundColor Green "Chocolatey is already installed"
    }

    $wterm = Read-Host -Prompt "The windows Terminial is not installed However, it is recommended. Should it be installed now? YES/NO"
    if ("yes" -eq $wterm) {
        Write-Host -ForegroundColor Green "Install Windows Terminal paket"
        choco install microsoft-windows-terminal -y 
        }
    else {
        Write-Host -ForegroundColor Red "The installation of the Windows Terminal was rejected. It must be reckoned by there with restrictions!"
    }

    $wterm = Read-Host -Prompt "Git is not installed However, it is recommended. Should it be installed now? YES/NO"
    if ("yes" -eq $wterm) {
        Write-Host -ForegroundColor Green "Install git for windows paket"
        choco install git -y 
        }
    else {
        Write-Host -ForegroundColor Red "The installation of Git was rejected. It must be reckoned by there with restrictions!"
    }

}
function install-Fronts {
    foreach ($Font in $FontList) {
            Write-Host 'Installing font -' $Font.BaseName
            Copy-Item $Font "C:\Windows\Fonts"
            New-ItemProperty -Name $Font.BaseName -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts" -PropertyType string -Value $Font.name         
    }
    
}
function Set-gitConfig {
    $gitconfig = Read-Host "Should the global Git Config be created now?"
    if ("yes" -eq $gitconfig) {
        $gituser = Read-Host "Please enter your name:"
        git config --global user.name $gituser
        $gitmail = Read-Host "Please enter your email Adress:"
        git config --global user.email $gitmail

        }
    else {
        Write-Host "Git Configuration was skipped"
    }
}


#---------------------------------------------------------[Logic]-------------------------------------------------------------------
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine

#Checking the permissions
if( !$IsAdmin ){
    Write-Host -ForegroundColor Red "The script does not have enough rights to install / update the myPosh environment. Please start with admin rights!"
    break
    }

#Testing Powershell version, currently works with PS 7
if (-not($(Get-Host).Version.Major -eq 7)) {
    Write-Host -ForegroundColor Red "Incorrect Powershell version. Please start with Powershell 7!"
    Break
    }

#Test Internet Connection
if (!Test-Connection github.com -Count 5 -TimeoutSeconds 2) {
        Write-Host -ForegroundColor Red "Please make sure you have an internet connection to Github.com and chocolatey.org and restart the installation!"
        Break
    }

get-MoD
Write-Host 
Write-Host "The installation of myPosh requires that packages are downloaded from external sources.
If this happens you have to confirm the execution.
Packages that are installed from the official Powershell Libery are installed WITHOUT approval.
However, you also have the option to allow all external sources. Which are they can be found here https://github.com/nox309/myPosh/doc/extSources.md"
$accept_install = Read-Host -Prompt "Should all required packages be installed without a request? YES/NO"
if ("yes" -eq $accept_install -or "no" -eq $accept_install) {
    write-host -ForegroundColor Green "Answer accepted, the answer was $accept_install. Script is continued"
    }
    else {
        $accept_install = Read-Host -Prompt "Should all required packages be installed without a request? Type YES/NO"
        if ("yes" -eq $accept_install  -or "no" -eq $accept_install )  {
            write-host -ForegroundColor Green "Answer accepted, the answer was $accept_install. Script is continued"
        }else
        {
            Write-Host -ForegroundColor Red "Incorrect answer, script is terminated!"
            break
        }
    }

#Clear-Host

if ("yes" -eq $accept_install) {
        install-noRequest
    }
    else {
        Write-Host -ForegroundColor Red "The installation of required packages via external sources was not approved. The installation is therefore aborted here now. 
        The profile can be installed manually and with some restrictions, please read the documentation on Github."
    }

# install requirements
install-Fronts
Register-PSRepository -Default
Install-Module -Name Terminal-Icons -Scope AllUsers -AllowClobber -Force
Install-Module oh-my-posh -Scope AllUsers -AllowClobber -Force
Install-Module posh-git -Scope AllUsers -AllowClobber -Force
Install-Module Get-ChildItemColor -Scope AllUsers -AllowClobber -Force

Copy-Item -Path .\profile.ps1 -Destination $PSuserPath -Force
Set-gitConfig
#Clear-Host
Write-Host "The installation of myPosh is completed, myPosh can now be used in any Powershell version 7. The optimal result is achieved with the Windows Terminal."
