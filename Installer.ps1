<# one command install: (Invoke-webrequest -URI "https://raw.githubusercontent.com/Okazakee/Fedora-WSL-Installer/main/Installer.ps1").Content | Out-File -FilePath $env:temp\script.ps1; iex $env:temp\script.ps1 #>
<# TODO: save variables in a file to be reused in icon setting function #>
Clear-Host
function Show-Menu
{
    Write-Host ""
    Write-Host "     ______         __                " -ForegroundColor Cyan -NoNewline; Write-Host "   _       _______ __       _            __        ____"
    Write-Host "    / ____/__  ____/ /___  _________ _" -ForegroundColor Cyan -NoNewline; Write-Host "  | |     / / ___// /      (_)___  _____/ /_____ _/ / /__  _____"
    Write-Host "   / /_  / _ \/ __  / __ \/ ___/ __ '/" -ForegroundColor Cyan -NoNewline; Write-Host "  | | /| / /\__ \/ /      / / __ \/ ___/ __/ __ '/ / / _ \/ ___/"
    Write-Host "  / __/ /  __/ /_/ / /_/ / /  / /_/ / " -ForegroundColor Cyan -NoNewline; Write-Host "  | |/ |/ /___/ / /___   / / / / (__  ) /_/ /_/ / / /  __/ /    "
    Write-Host " /_/    \___/\__,_/\____/_/   \__,_/  " -ForegroundColor Cyan -NoNewline; Write-Host "  |__/|__//____/_____/  /_/_/ /_/____/\__/\__,_/_/_/\___/_/     "
    Write-Host ""
    Write-Host ""
    Write-Host "                        This script lets you install Fedora as a WSL using Docker!"
    Write-Host ""
    Write-Host "                            Remember to open Docker Desktop before installing!" -ForegroundColor Red
    Write-Host ""
    Write-Host "                        For more info visit: https://github.com/Okazakee/Fedora-WSL-Installer"
    Write-Host ""
    Write-Host "1) Install Fedora WSL."
    Write-Host "2) Set the new WSL Windows Terminal profile icon to Fedora logo."
    Write-Host "q) Quit."
    Write-Host ""
}

function Bye-Message {
    Clear-Host
    Write-Host "============================================================"
    Write-Host "           Thank you for using my tool! -Okazakee"
    Write-Host "============================================================"
    sleep 2
    Clear-Host
    return
}

function Clear-Tmp {
    $FileName = "$env:temp\script.ps1"
    if (Test-Path $FileName) {
    Remove-Item $FileName
    Bye-Message
} else {
    Bye-Message
}
}

function Install-Wsl {

    $WSLname = Read-Host "Choose a name for the WSL (no uppercase)"
    $InstallPath = Read-Host "Choose a path to where will be WSL installed"
    $UnixUser = Read-Host "Choose the WSL username"

    Write-Host "============================================================"
    Write-Host "                     Initializing WSL..."
    Write-Host "============================================================"

    Write-Host "Downloading Dockerfile..."
    $dockerURL = 'https://raw.githubusercontent.com/Okazakee/Fedora-WSL-Installer/main/Dockerfile'
    $dockerfiletmp = (Invoke-webrequest -URI $dockerURL).Content | Out-File -FilePath $InstallPath\Dockerfile
    Write-Host "Building docker container..."
    $ContainerName = "docker_to_wsl_$WSLname"
    docker build -f $InstallPath\Dockerfile -t $ContainerName --build-arg UNIX_USER=$UnixUser --no-cache --progress plain .

    try {
        docker run -it --name "$ContainerName" "$ContainerName"
        $TarFile = Join-Path $InstallPath "wsl_distro.tar"
        docker export -o "$TarFile" "$ContainerName"
    }
    finally {
        docker rm "$ContainerName"
        docker rmi "$ContainerName"
    }

    wsl --import "$WSLname" "$InstallPath" "$TarFile"

    Write-Host "============================================================"
    Write-Host "                   Removing junk files..."
    Write-Host "============================================================"

    rm $InstallPath\wsl_distro.tar
    rm $InstallPath\Dockerfile

    Write-Host "Done! Fedora WSL correctly installed."
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Red
    Write-Host "REMEMBER TO RESTART WINDOWS TERMINAL BEFORE SETTING THE ICON" -ForegroundColor Red
    Write-Host "============================================================" -ForegroundColor Red

    return
}

function Set-Icon {

    $Wslname = Read-Host "How did you call the WSL?"
    $InstallPath = Read-Host "Where did you installed the WSL?"

    Write-Host "============================================================"
    Write-Host "                    Setting Fedora icon..."
    Write-Host "============================================================"

    $icoURL = 'https://raw.githubusercontent.com/Okazakee/Fedora-WSL-Installer/main/fedora.ico'
    Invoke-WebRequest -Uri $icoURL -OutFile $InstallPath\fedora.ico

    $settings = Get-Content $env:localappdata'\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json' -raw | ConvertFrom-Json
    $settings.profiles.list | % {if($_.name -eq "$WSLname"){Add-Member -InputObject $_ -MemberType NoteProperty -Name "icon" -Value "$InstallPath\fedora.ico" -Force}}
    $settings | ConvertTo-Json -depth 32| set-content $env:localappdata'\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'

    Write-Host "Done!"
    sleep 1
    Clear-Tmp
}

Show-Menu
 switch (Read-Host "Please make a selection")
 {
    '1' {
        Install-Wsl
    } '2' {
        Set-Icon
    } 'q' {
        Clear-Tmp
        return
    } default {
        Write-Host "Please choose one of the given inputs!"
    }
 }