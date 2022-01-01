##################################################
#################### Settings ####################
##################################################

# Function to test if the current host is being run as an administrator.
$WID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$Prp = New-Object System.Security.Principal.WindowsPrincipal($WID)
$Adm = [System.Security.Principal.WindowsBuiltInRole]::Administrator
$IsAdmin = $Prp.IsInRole($Adm)

#IP Query
$ip = Get-WmiObject win32_NetworkadapterConfiguration -Filter "IPEnabled=True" | Where-Object{ $_.DefaultIPGateway -ne $null } | Select-Object IPAddress

#Uptime of the system query and output formatting
Function Get-Uptime
{
	$os = Get-WmiObject win32_operatingsystem
	$uptime = (Get-Date) - ($os.ConvertToDateTime($os.lastbootuptime))
	$Display = "Uptime: " + $Uptime.Days + " days, " + $Uptime.Hours + " hours, " + $Uptime.Minutes + " minutes"
	Write-Output $Display
}

#Import of all modules
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox

If (-Not (Test-Path Variable:PSise)) {  # Only run this in the console and not in the ISE
    Import-Module Get-ChildItemColor
    
    Set-Alias l Get-ChildItem -option AllScope
    Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
}

Clear-Host
if ($IsAdmin)
{
	Write-Host
	Write-Host -Foregroundcolor Red "Powershell was started as administrator"
	Write-Host
}
Write-Host -Foregroundcolor Green "#######################################################################################"
Write-Host -Foregroundcolor Green "##                                                                                   ##"
Write-Host -Foregroundcolor Green "##      Systemname: "$env:computername"                                              ##"
Write-Host -Foregroundcolor Green "##      Login User: "$env:username"                                                  ##"
Write-Host -Foregroundcolor Green "##      Date:" (Get-Date)"                                                          ##"
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
