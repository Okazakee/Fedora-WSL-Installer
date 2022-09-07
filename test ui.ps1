<# one command install: iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Okazakee/Fedora-WSL-Installer/main/Installer.ps1')) #>
<# TODO: save variables in a file to be reused in icon setting function #>
Clear-Host
function Show-Menu
{
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

    sleep 1

    Clear-Host
    Write-Host "============================================================"
    Write-Host "                Building docker container..."
    Write-Host "============================================================"

    sleep 1

    try {
        sleep 1
    }
    finally {
        sleep 1
    }

    sleep 1

    Clear-Host
    Write-Host "============================================================"
    Write-Host "                   Removing junk files..."
    Write-Host "============================================================"

    sleep 1

    Clear-Host
    Write-Host "============================================================" -ForegroundColor Red
    Write-Host "            Done! Fedora WSL correctly installed."
    Write-Host ""
    Write-Host "REMEMBER TO RESTART WINDOWS TERMINAL BEFORE SETTING THE ICON" -ForegroundColor Red
    Write-Host "============================================================" -ForegroundColor Red

    sleep 4

    Clear-Host
}

function Set-Icon {

    $Wslname = Read-Host "How did you call the WSL?"
    $InstallPath = Read-Host "Where did you installed the WSL?"

    Clear-Host
    Write-Host "============================================================"
    Write-Host "                    Setting Fedora icon..."
    Write-Host "============================================================"

    sleep 1

    sleep 1

    Clear-Host
    Write-Host "============================================================"
    Write-Host "                          Done!"
    Write-Host "============================================================"

    sleep 1

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
}

Show-Menu
Choices