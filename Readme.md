
# myPosh

myPosh is primarily to improve the look and usability of Powershell.
In addition, various functions are added to facilitate various tasks.


## Prerequisites:

Windows Powershell 7 must already be installed on the system.</br>
This can be downloaded here:</br>

[Powershell 7.x](https://docs.microsoft.com/de-de/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2#installing-the-msi-package)</br>
</br>

Or via chocolatey:
```
choco install powershell-core
```


## Installation
For installation, please download and unzip the current version. [HERE](https://github.com/nox309/myPosh/releases)

Then start the Powershell 7 as admin and navigate to the unzipped directory.

Then start the installation file:

```powershell
  .\install.ps1
```
If the Windows Terminal is already installed, you have 2 options for configuration:
- If you are already using your own config and do not want to overwrite it, you must set the required font in the settings. You can do this either as default or only for PowerShell.
Please select the font MesloLGM NF under Display.
- Alternatively you can use the template that comes with myPosh, this will be overide any existing settings: </br>
  ```powershell
  Copy-Item -Path $env:ProgramData\myPosh\config\wt_settings.json $env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Force
  ```

## Features

- Windows Terminal Configuration
- Customization of Powershell layout
- Functions:
  - Start-asAdmin
  - Start-PSasAdmin


## Screenshots

![myPoshLayout](./doc/img/ProfilLayout.PNG)
![myPoshGIT](./doc/img/Git.PNG)

## Acknowledgements

 - [FAQ](https://github.com/nox309/myPosh/tree/master/doc/FAQ.md)
 - [External Sources](https://github.com/nox309/myPosh/blob/master/doc/extSources.md)
