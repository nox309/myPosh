<#
.NAME
    get-update
.SYNOPSIS
    Update function for the myPosh environment.
.DESCRIPTION
    Update function for the myPosh environment. with this function the local version is synchronized with the Git version.
    If there is an update, it will be downloaded and installed.
.FUNCTIONALITY
    On execution, the version is aligned with GIT. If there is an update, this is loaded down and stored locally. After storing, all components are updated.
.NOTES
    Author: nox309
    Email: support@inselmann.it
    Git: https://github.com/nox309
    DateCreated: 2022/01/27
.LINK
    https://github.com/nox309/myPosh
#>
#Get current stabel Version
function get-myPoshVersion {   
    Start-BitsTransfer -Source "https://raw.githubusercontent.com/nox309/myPosh/master/src/version.txt" -Destination $env:TMP\version.txt
    $GlobalReleaseVersion = Get-Content -Path $env:TMP\version.txt
}

#Compare local version with current stabel version
function get-myPoshUpdate {
    if (!($GlobalReleaseVersion -eq $myPosh_Version)){
        Write-Host -ForegroundColor Red "Lokal myPosh Version is outdated. New version is $GlobalReleaseVersion"
        Write-Host -ForegroundColor Yellow "Please Update with 'start-myPoshUpdate"
        }
    else {
        Write-Host -ForegroundColor Green "No Update available!"
        }
}

#Update Function for external Moduls
function update-externalModuls {
    Update-Module -Name Terminal-Icons -Force -Scope AllUsers
    Update-Module -Name oh-my-posh -Force -Scope AllUsers
    Update-Module -Name posh-git -Force -Scope AllUsers
    Update-Module -Name Get-ChildItemColor -Force -Scope AllUsers
    choco update microsoft-windows-terminal -y
    choco update git -y
}

# Update Function for Stable Version of myPosh
function update-myPoshStable {
    $url = "https://github.com/nox309/myPosh/releases/download/$GlobalReleaseVersion/myPosh_v$GlobalReleaseVersion.zip"
    Invoke-RestMethod -Uri $url -OutFile $env:TMP\myPosh_v$GlobalReleaseVersion.zip
    Expand-Archive -Path "$env:TMP\myPosh_v$GlobalReleaseVersion.zip" -DestinationPath "$env:ProgramData\myPosh\" -Force
}

#Update Function for Beta Version 
function update-myPoshBeta {
    # TODO: query with indication that a beta version is being installed and whether you are sure.
    Invoke-RestMethod -Uri "https://codeload.github.com/nox309/myPosh/zip/refs/heads/master" -OutFile $env:TMP\myPosh_master.zip
    Expand-Archive -Path "$env:TMP\myPosh_master.zip" -DestinationPath "$env:TMP\myPosh_master\" -Force
    Copy-Item -Path $env:TMP\myPosh_master\myPosh-master\src\* $env:ProgramData\myPosh\ -Force -Recurse 
}


# Main Update Function ( Parameter are allow Build: Stabel|Beta or Update all|myPosh)
# Build Stabel update to the last Release of myPosh
# Build Beta Clone the Git Repo
#
# Update all means update all components (myPosh + necessary third party provider tools)
# Update myPosh means update only myPosh
function start-myPoshUpdate {
    param (
        [Parameter(Position=0)]
        [ValidateSet('Stable', 'Beta')]
        [string] $build = "Stable",
        [Parameter(Position=1)]
        [ValidateSet('all', 'myPosh')]
        [string] $update = "all"       
    )

    if( !$IsAdmin ){
        Write-Host -ForegroundColor Red "The function does not have enough rights to install / update the myPosh environment. Please start with admin rights!"
        break
        }

    if ($update -eq "all") {
        if ($build -eq "Stable"){
            update-myPoshStable
            update-externalModuls            
            }
        if ($build -eq "beta"){
            update-myPoshBeta
            update-externalModuls
            }
    }
    if ($update -eq "myPosh") {
        if ($build -eq "Stable"){
            update-myPoshStable            
            }
        if ($build -eq "beta"){
            update-myPoshBeta
            }
    }
    Remove-Item $env:TMP\myPosh* -Recurse
    write-host -ForegroundColor Green "The module was successfully updated, please restart Powershell or windows Terminal."

}