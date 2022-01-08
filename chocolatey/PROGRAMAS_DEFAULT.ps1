Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco install powershell -y
choco install GoogleChrome -y
choco install firefox -y
choco install opera
choco install 7zip -y
choco install JavaRuntime -y
choco install dotnet4.7.2 -y
choco install silverlight -y
choco install adobereader -y
choco install microsoft-teams -y
choco install anydesk -y
choco install teamviewer --version 13.2.26558 -y
choco install vlc -y -y
choco install paint.net -y
choco install notepadplusplus.install -y