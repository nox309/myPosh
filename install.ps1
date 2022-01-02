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

$testchoco = powershell choco -v

#---------------------------------------------------------[Functions]--------------------------------------------------------------
function get-MoD {
    ##Build the MoD/banner
    #Referenz https://artii.herokuapp.com/
    $Font = @(
        "whimsy",
        "rounded",
        "nvscript",
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
    if(-not($testchoco)){
        Write-Host -ForegroundColor red "Seems Chocolatey is not installed, installing now"
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    else{
        Write-Host -ForegroundColor Green "Chocolatey Version $testchoco is already installed"
    }
    Write-Host -ForegroundColor Green "Install Windows Terminal paket"
    choco install microsoft-windows-terminal -y 
    
    Write-Host -ForegroundColor Green "Install git for windows paket"
    choco install git -y 
}

function install-Request {

    if(-not($testchoco)){
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
        Write-Host -ForegroundColor Green "Chocolatey Version $testchoco is already installed"
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

#---------------------------------------------------------[Logic]-------------------------------------------------------------------
#Checking the permissions
if( $IsAdmin ){
    Write-Host -ForegroundColor Red "The script does not have enough rights to install / update the myPosh environment. Please start with admin rights!"
    break
    }

#Testing Powershell version, currently works with PS 7
if (-not($(Get-Host).Version.Major -eq 7)) {
    Write-Host -ForegroundColor Red "Incorrect Powershell version. Please start with Powershell 7!"
    Break
    }

get-MoD
Write-Host 
Write-Host "The installation of myPosh requires that packages are downloaded from external sources.
If this happens you have to confirm the execution.
Packages that are installed from the official Powershell Libery are installed WITHOUT approval.
However, you also have the option to allow all external sources. Which are they can be found here https://github.com/nox309/myPosh/extSources.md"
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
            Write-Host -ForegroundColor Red "Incorrect answer, script is terminated"
            break
        }
    }

#Clear-Host

if ("yes" -eq $accept_install) {
        install-noRequest
    }
    else {
        install-Request
    }




# install requirements
Install-Module oh-my-posh -Scope AllUsers -AllowClobber -Force
Install-Module posh-git -Scope AllUsers -AllowClobber -Force
Install-Module Get-ChildItemColor -Scope AllUsers -AllowClobber -Force

