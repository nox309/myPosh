<# 
.NAME
    <Write-Log>
.SYNOPSIS
    <Bereitstellen einer Logfunktion in Powershell>
.DESCRIPTION
    <Stellt eine Logfunktion bereit welches ein Log unter C:\tmp\Powershell\ ablegt, diese Funktion kann aus anderen Skripten her aufgerufen werden.
    als Status Level können 'Information','Warning','Error' und 'Debug' genutzt werden.
    Wird der Parameter "-console $true" mit übergeben wird die Entsprechende Nachricht auch auf der Console mit ausgeben und entspreched des Status Levels Eingefärbt>
.OUTPUTS
    <C:\tmp\Powershell\PS_log.txt>
.FUNCTIONALITY
    <Nimmt informationen in einem Script entgegen und Speicher diese mit Zeit stemple in einer Log Datei>
.EXAMPLE
    Write-Log -Message "Test Nachricht" -Severity Error -console $true>

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
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [parameter(Mandatory=$false)]
        [bool]$console, 

        [Parameter()]
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