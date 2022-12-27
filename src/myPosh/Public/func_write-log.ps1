<# 
.NAME
    <Write-Log>
.SYNOPSIS
    <Providing a log function in Powershell>
.DESCRIPTION
    <Provides a log function which stores a log under C:_tmp\Powershell\, this function can be called from other scripts.
    as status level 'Information', 'Warning', 'Error' and 'Debug' can be used.
    If the parameter "-console $true" is passed the corresponding message will also be printed on the console and colored according to the status level.>
.OUTPUTS
    <C:\tmp\Powershell\PS_log.txt>
.FUNCTIONALITY
    <Takes information in a script and stores it with time stemple in a log file>
.EXAMPLE
    Write-Log -Message "Test Nachricht" -Severity Error -console $true>
.NOTES
    Author: nox309
    Email: support@inselmann.it
    Git: https://github.com/nox309
    DateCreated: 2022/12/23
    #>
$logpath = "C:\tmp\Powershell"

if(Test-Path  $logpath) 
	{ 
	Write-Host "Log Pfad gefunden"
	}  
else
	{
	  mkdir $logpath
	  Write-Host "Log Pfad erstellt"
	}
function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [parameter(Mandatory=$false)]
        [bool]$console, 

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Information','Warning','Error','Debug')]
        [string]$Severity = 'Information'
    )

    $time = (get-date -Format yyyyMMdd-HH:mm:ss)

    if (!(Test-Path $logpath\PS_log.txt)) {
        "Timestamp | Severity | Message" | Out-File -FilePath $logpath\PS_log.txt -Append  -Encoding utf8
        "$Time | Information | Log started" | Out-File -FilePath $logpath\PS_log.txt -Append  -Encoding utf8
    }

    if ($console) {
        if ($Severity -eq "Information") {
            $color = "Gray"
        }

        if ($Severity -eq "Warning") {
            $color = "Yellow"
        }

        if ($Severity -eq "Error") {
            $color = "Red"
        }

        if ($Severity -eq "Debug") {
            $color = "Green"
        }

        Write-Host -ForegroundColor $color "$Time | $Severity | $Message"
    }

    "$Time | $Severity | $Message" | Out-File -FilePath $logpath\PS_log.txt -Append  -Encoding utf8

}