> **⚠️ Archived.** Two reasons this is no longer maintained:
>
> 1. When I built it, I didn't know the [Fedora Remix for WSL](https://github.com/WhitewaterFoundry/Fedora-Remix-for-WSL) existed — if you're looking for Fedora on WSL, just use that instead (also available on the Microsoft Store).
> 2. I stopped using Windows entirely in 2024, so I can no longer test or support this project.
>
> Kept here for reference only.

<h3 align="center"><img src=".github/assets/logo.png"></h3>

---
Hello everyone! I am proud to announce my new utility!

I often use WSL to do stuff since I can't install Linux directly for reasons, and I noticed that there is no easy way to get Fedora, only Ubuntu or Debian etc... So after days of searching and finding nothing, I decided to create my own solution, at least I avoid going crazy and maybe others need it too.
### Usage

- Run `iex ((New-Object System.Net.WebClient).DownloadString('https://www.okazakee.dev/wsl-installer'))` in your powershell.
- Choose an option from menu.

<img src=".github/assets/wt.png" alt="img" align="right" width="650px">

### Requirements

- Powershell 7.
- Docker Desktop.

### Features

- Installs Fedora WSL.
- Change the WT profile icon.

### Working on:

- Automatically set start menu shortcut for WSL.
- Automatically check if Docker is running.
- Store vars in tmp file, check if it exists before asking user.
