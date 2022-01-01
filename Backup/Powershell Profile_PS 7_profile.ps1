## STUTE Standardprofil f�r Powershell

##################################################
############## Grund Einstellungen ###############
##################################################


# Function to test if the current host is being run as an administrator. If so, set console background to red.
$WID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$Prp = New-Object System.Security.Principal.WindowsPrincipal($WID)
$Adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$IsAdmin = $Prp.IsInRole($Adm)
$Version = '0.7.3'

#Import aller Module
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox

If (-Not (Test-Path Variable:PSise)) {  # Only run this in the console and not in the ISE
    Import-Module Get-ChildItemColor
    
    Set-Alias l Get-ChildItem -option AllScope
    Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
}
Set-Alias ip ipconfig 

Clear-Host

if( $IsAdmin ){
    Write-Host 
    Write-Host -ForegroundColor Red "Sie haben eine Powershell mit Administrativen Rechten gestartet!!"
    Write-Host 
    }


Write-Host "Dies ist ein System der STUTE Logistics (AG & Co.) KG."
Write-Host 
Write-Host "#######################################################################################"
Write-Host "#######################################################################################"
Write-Host "######                                                                           ######"
Write-Host "######    #####   ######   ##   ##  ######   #######           ######   ######   ######"
Write-Host "######   ##   ##    ##     ##   ##    ##     ##                  ##       ##     ######"
Write-Host "######   ##         ##     ##   ##    ##     ##                  ##       ##     ######"
Write-Host "######    #####     ##     ##   ##    ##     #####               ##       ##     ######"
Write-Host "######        ##    ##     ##   ##    ##     ##                  ##       ##     ######"
Write-Host "######   ##   ##    ##     ##   ##    ##     ##                  ##       ##     ######"
Write-Host "######    #####     ##      #####     ##     #######           ######     ##     ######"
Write-Host "######                                                                           ######"
Write-Host "#######################################################################################"
Write-Host "#######################################################################################"
Write-Host 
Write-Host
Write-Host -Foregroundcolor Green 'Systemname:' "$env:computername" 
Write-Host -Foregroundcolor Green "Login User:" "$env:username"
Write-Host -Foregroundcolor Green "Datum: " (Get-Date)
Set-Location c:\


##################################################
#################### functions ###################
##################################################

function Get-LAPS-info {
    param (    
        [Parameter(Position=1)]
        $Computer,
    [Parameter(Position=2)]
        $ADM
           )
    Get-ADComputer -LDAPFilter "(Name=$computer)" -Credential $ADM -Properties Name,ms-Mcs-AdmPwd,IPv4Address,OperatingSystem | format-table Name,ms-Mcs-AdmPwd,IPv4Address,OperatingSystem -AutoSize
 
}

function Get-Computerinfo {
    param (    
        [Parameter(Position=1)]
        $Computer,
    [Parameter(Position=2)]
        $ADM
           )
    Get-ADComputer -LDAPFilter "(Name=$computer)" -Credential $ADM -Properties Name,Description,IPv4Address,OperatingSystem,whenChanged,lastLogon | format-table Name,Description,IPv4Address,OperatingSystem,whenChanged,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}} -AutoSize
}
   


function Start-PSs {
   param (    
    [Parameter(Position=1)]
    $Computer,
[Parameter(Position=2)]
    $ADM
       )
    Enter-PSSession $computer -Credential $Adm
 }

 function Get-Profil {
    Write-Host -Foregroundcolor Green "Profil Version" $Version
    Write-Host -Foregroundcolor Green "Liste der Profile Pfade"
    Write-Host -Foregroundcolor Green "Mit 'Update-Profil' kann das Powershell Profil geupdatet werden"
    $Profile | Select-Object *
 }

 function Update-Profil {
    if( $IsAdmin ){
        $deployVer = Get-Content "\\hb-HQ-FS-002\deploy\Powershell\Profile\version.txt"
        $user = $PROFILE.AllUsersAllHosts
        if ($deployVer -gt $Version) {
            write-host -ForegroundColor Yellow "Es ist ein Update des Powershell Profiles vorhanden"
            write-host -ForegroundColor Yellow "Das Profil wird geupdatet"
    
            try
            {
                Copy-Item "\\hb-HQ-FS-002\deploy\Powershell\Profile\profile.ps1" -Destination $user -ErrorAction 'Stop'
                Start-Sleep -s 15
                write-host -ForegroundColor Green "Update Erfolgreich"
                write-host -ForegroundColor Green "Änderungen werden nach einem Neustart der Powershellsitzung übernommen"
            }
            catch
            {
                Write-Host "Update Fehlgeschlagen"
            }
        }
        else {
            write-host -ForegroundColor Green "Profile auf dem aktuellstem Stand"
        }
        }
    else {
            write-host -ForegroundColor Red "Fehler, nicht ausreichende Rechte. Bitte das Updates mit Administrativen rechten noch einmal starten"
        }
    
 }
    
 function Get-Profile-hilfe {
    Write-Host -Foregroundcolor White "Dies ist ein Zentrales Profile für Powershell in der Version 7."
    Write-Host -Foregroundcolor White "Dies Profil Steuert div. abläufe im hintegrund und stellt zusätzliche administrative Funktionen bereit."
    Write-Host 
    Write-Host -Foregroundcolor White "Folgende Befehle sind bereits implemetiert:"
    Write-Host -Foregroundcolor Green "########################################################################################################"
    Write-Host -Foregroundcolor White "LAPS Infos Hole via get-LAPS-info Computername ADM_user"
    Write-Host
    Write-Host -Foregroundcolor Yellow "Beispiel:"
    Write-Host -Foregroundcolor White "C:\PS>Get-LAPS-info STUTE-LP-1055 ADM_Inselmann"
    Write-Host
    Write-Host -Foregroundcolor White "PowerShell credential request"
    Write-Host -Foregroundcolor White "Enter your credentials."
    Write-Host -Foregroundcolor White "Password for user adm_inselmann: ***********"
    Write-Host
    Write-Host -Foregroundcolor White "Name          ms-Mcs-AdmPwd IPv4Address  OperatingSystem"
    Write-Host -Foregroundcolor White "____          _____________ ___________  _______________"
    Write-Host -Foregroundcolor White "STUTE-LP-1055 xxxxxxxx      192.168.56.1 Windows 10 Pro"
    Write-Host
    Write-Host -Foregroundcolor Green "########################################################################################################"
    Write-Host -Foregroundcolor White "Die Bekannten Befehle l, ls und ip aus der Unix Welt funktioniern hier auch."
    Write-Host 
    Write-Host -Foregroundcolor Green "########################################################################################################"
    Write-Host -Foregroundcolor White "Aktuelle Infos eines PCs aus dem AD ziehen mit get-Computerinfo Computername ADM_user"
    Write-Host -Foregroundcolor Yellow "Beispiel:"
    Write-Host -Foregroundcolor White "❯ Get-Computerinfo STUTE-LP-1055 ADM_Inselmann"

    Write-Host -Foregroundcolor White "PowerShell credential request"
    Write-Host -Foregroundcolor White "Enter your credentials."
    Write-Host -Foregroundcolor White "Password for user ADM_Inselmann: ***********"
    Write-Host
    Write-Host -Foregroundcolor White "Name          Description       IPv4Address  OperatingSystem"
    Write-Host -Foregroundcolor White "____          ___________       ___________  _______________"
    Write-Host -Foregroundcolor White "STUTE-LP-1055 Inselmann, Torben 192.168.56.1 Windows 10 Pro"
    Write-Host -Foregroundcolor Green "########################################################################################################"
    Write-Host -Foregroundcolor White "Via PSsession auf einen Entfernten PC zugreifen kann "
    Write-Host -Foregroundcolor White "mit Start-PSs 'Computername' 'ADM User'  "
    Write-Host
    Write-Host -Foregroundcolor Yellow "Beispiel:"
    Write-Host -Foregroundcolor White "❯ Start-PSs stute-lp-1130 adm_Inselmann"

    Write-Host -Foregroundcolor White "PowerShell credential request"
    Write-Host -Foregroundcolor White "Enter your credentials."
    Write-Host -Foregroundcolor White "Password for user adm_Inselmann: ***********"
    Write-Host 
    Write-Host -Foregroundcolor White "[stute-lp-1130]: PS C:\"
    Write-Host -Foregroundcolor Green "########################################################################################################"
    Write-Host -Foregroundcolor White "Mit 'Get-Profil' lässt sich die Info zum Profile anzeigen."
    Write-Host -Foregroundcolor Green "########################################################################################################"

 }