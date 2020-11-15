$tweaks = @(
	"RequireAdmin",
    "CreateRestorePoint"
    "InstallRishabhProgs"
    "InstallNotepadplusplus"
    "InstallJDK"
    "InstallJRE"
    
    

    function Show-Choco-Menu {
        param(
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string]$Title,
        
            [Parameter(Mandatory)]
            [ValidateNotNullOrEmpty()]
            [string]$ChocoInstall
        )
       
     do
     {
        Clear-Host
        Write-Host "================ $Title ================"
        Write-Host "Y: Press 'Y' to do this."
        Write-Host "2: Press 'N' to skip this."
        Write-Host "Q: Press 'Q' to stop the entire script."
        $selection = Read-Host "Please make a selection"
        switch ($selection)
        {
        'y' { choco install $ChocoInstall -y }
        'n' { Break }
        'q' { Exit  }
        }
     }
     until ($selection -match "y" -or $selection -match "n" -or $selection -match "q")
    }
    
    Function InstallRishabhProgs {
        Write-Output "Installing Chocolatey"
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        choco install chocolatey-core.extension -y /quiet
    }
    
    Function RequireAdmin {
        If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
            Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
            Exit
        }
    }
    
)

Function InstallNotepadplusplus {
	Show-Choco-Menu -Title "Do you want to install Notepad++?" -ChocoInstall "notepadplusplus"
}

Function InstallJDK {
	Show-Choco-Menu -Title "Do you want to install JDK?" -ChocoInstall "jdk8"
}

Function InstallJRE {
	Show-Choco-Menu -Title "Do you want to install JDK?" -ChocoInstall "jre8"
}

Function CreateRestorePoint {
    Write-Output "Creating Restore Point incase something bad happens"
    Enable-ComputerRestore -Drive "C:\"
    Checkpoint-Computer -Description "RestorePoint1" -RestorePointType "MODIFY_SETTINGS"
  }

# Call the desired tweak functions
$tweaks | ForEach { Invoke-Expression $_ }
