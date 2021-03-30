##################################################
############## Grund Einstellungen ###############
##################################################

# Function to test if the current host is being run as an administrator. If so, set console background to red.
$WID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$Prp = New-Object System.Security.Principal.WindowsPrincipal($WID)
$Adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$IsAdmin = $Prp.IsInRole($Adm)

#IP Abfrage
$ip = Get-WmiObject win32_NetworkadapterConfiguration -Filter "IPEnabled=True" | Where-Object{ $_.DefaultIPGateway -ne $null } | Select-Object IPAddress

#Uptime des System abrfragen und Ausgabe Formatiren
Function Get-Uptime
{
	$os = Get-WmiObject win32_operatingsystem
	$uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
	$Display = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes"
	Write-Output $Display
}


Set-Alias ls Get-ChildItem-Color -option AllScope -Force
Set-Alias dir Get-ChildItem-Color -option AllScope -Force

Clear-Host
if ($IsAdmin)
{
	Write-Host
	Write-Host -Foregroundcolor Red "Sie haben eine Powershell mit Administrativen Rechten gestartet!!"
	Write-Host
}
Write-Host -Foregroundcolor Green "#######################################################################################"
Write-Host -Foregroundcolor Green "##                                                                                   ##"
Write-Host -Foregroundcolor Green "##      Systemname: "$env:computername"                                              ##"
Write-Host -Foregroundcolor Green "##      Login User: "$env:username"                                                  ##"
Write-Host -Foregroundcolor Green "##      Datum:" (Get-Date)"                                                          ##"
Write-Host -Foregroundcolor Green "##      System IP Adresse:" $ip.IPAddress"                                           ##"
Write-Host -Foregroundcolor Green "##      System "Get-Uptime"                                                          ##"
Write-Host -Foregroundcolor Green "##                                                                                   ##"
Write-Host -Foregroundcolor Green "#######################################################################################"
Write-Host
Set-Location c:\

##################################################
#################### functions ###################
##################################################

function prompt
{
	$host.ui.RawUI.WindowTitle = $(get-location)
	"[PS] [$env:username] $(get-location)>"
	if ($IsAdmin)
	{
		"[PS] [$env:username] $(get-location)>"
		$host.ui.RawUI.WindowTitle = "Administrator:" + " " + $(get-location)
	}
}
