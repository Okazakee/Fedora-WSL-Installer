<# TODO: save variables in a file to be reused in icon setting function #>
Clear-Host
function Show-Menu {
    Write-Host ""
    Write-Host "     ______         __                " -ForegroundColor Cyan -NoNewline; Write-Host "   _       _______ __       _            __        ____"
    Write-Host "    / ____/__  ____/ /___  _________ _" -ForegroundColor Cyan -NoNewline; Write-Host "  | |     / / ___// /      (_)___  _____/ /_____ _/ / /__  _____"
    Write-Host "   / /_  / _ \/ __  / __ \/ ___/ __ '/" -ForegroundColor Cyan -NoNewline; Write-Host "  | | /| / /\__ \/ /      / / __ \/ ___/ __/ __ '/ / / _ \/ ___/"
    Write-Host "  / __/ /  __/ /_/ / /_/ / /  / /_/ / " -ForegroundColor Cyan -NoNewline; Write-Host "  | |/ |/ /___/ / /___   / / / / (__  ) /_/ /_/ / / /  __/ /    "
    Write-Host " /_/    \___/\__,_/\____/_/   \__,_/  " -ForegroundColor Cyan -NoNewline; Write-Host "  |__/|__//____/_____/  /_/_/ /_/____/\__/\__,_/_/_/\___/_/     v1.1"
    Write-Host ""
    Write-Host ""
    Write-Host "                       This script lets you install Fedora as a WSL using Docker!"
    Write-Host ""
    Write-Host "                           Remember to open Docker Desktop before installing!" -ForegroundColor Red
    Write-Host ""
    Write-Host "                  For more info visit: https://github.com/Okazakee/Fedora-WSL-Installer"
    Write-Host ""
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

function Install-Wsl {

    $WSLname = Read-Host "Choose a name for the WSL (no uppercase)"
    $InstallPath = Read-Host "Choose a path to where will be WSL installed"
    $UnixUser = Read-Host "Choose the WSL username"

    Clear-Host
    Write-Host "============================================================"
    Write-Host "                     Initializing WSL..."
    Write-Host "============================================================"

    Clear-Host
    Write-Host "============================================================"
    Write-Host "                  Downloading Dockerfile..."
    Write-Host "============================================================"

    $dockerURL = 'https://raw.githubusercontent.com/Okazakee/Fedora-WSL-Installer/main/Dockerfile'
    $dockerfiletmp = (Invoke-webrequest -URI $dockerURL).Content | Out-File -FilePath $InstallPath\Dockerfile

    Clear-Host
    Write-Host "============================================================"
    Write-Host "                Building docker container..."
    Write-Host "============================================================"

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

    Clear-Host
    Write-Host "============================================================"
    Write-Host "                   Removing junk files..."
    Write-Host "============================================================"

    rm $InstallPath\wsl_distro.tar
    rm $InstallPath\Dockerfile

    Clear-Host
    Write-Host "============================================================" -ForegroundColor Red
    Write-Host "            Done! Fedora WSL correctly installed."
    Write-Host ""
    Write-Host "REMEMBER TO RESTART WINDOWS TERMINAL BEFORE SETTING THE ICON" -ForegroundColor Red
    Write-Host "============================================================" -ForegroundColor Red

    sleep 5
    Clear-Host
}

function Set-Icon {

    $Wslname = Read-Host "How did you call the WSL?"
    $InstallPath = Read-Host "Where did you installed the WSL?"

    <# TODO: TESTING stored variables BLOCK #>
    $FileName = "$env:temp\vars"
    if (Test-Path $FileName) {
    Write-Host "FILE EXISTS"
    Remove-Item $FileName
    sleep 2
    } else {
        Write-Host "FILE DOES NOT EXIST"
        $Wslname, $InstallPath | Out-File -FilePath $env:temp\vars
        sleep 2
    }
    <# TODO: TESTING stored variables BLOCK #>

    Clear-Host
    Write-Host "============================================================"
    Write-Host "                    Setting Fedora icon..."
    Write-Host "============================================================"

    $icoURL = 'https://raw.githubusercontent.com/Okazakee/Fedora-WSL-Installer/main/fedora.ico'
    Invoke-WebRequest -Uri $icoURL -OutFile $InstallPath\fedora.ico

    $settings = Get-Content $env:localappdata'\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json' -raw | ConvertFrom-Json
    $settings.profiles.list | % {if($_.name -eq "$WSLname"){Add-Member -InputObject $_ -MemberType NoteProperty -Name "icon" -Value "$InstallPath\fedora.ico" -Force}}
    $settings | ConvertTo-Json -depth 32| set-content $env:localappdata'\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json'

    Clear-Host
    Write-Host "============================================================"
    Write-Host "                          Done!"
    Write-Host "============================================================"

    sleep 2
    Clear-Host
}

function Choices{
    switch (Read-Host "Please make a selection")
    {
        '1' {
            Install-Wsl
            Show-Menu
            Choices
        } '2' {
            Set-Icon
            Show-Menu
            Choices
        } 'q' {
            Bye-Message
        } default {
            Write-Host "Please choose one of the given inputs!" -ForegroundColor Red
            sleep 2
            Clear-Host
            Show-Menu
            Choices
        }
    }

Show-Menu
Choices
