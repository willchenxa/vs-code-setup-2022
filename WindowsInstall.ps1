IF (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
 Write-Host "This script must be run using an administrator account. Follow the instructions in the comments at the top of this script to re-run it"
 exit
}

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

$name = [Environment]::UserName | Out-String
$name = $name.Trim()
$dest = -join("C:\Users\", $name, "\Downloads")

$log_path = -join($dest, "\Developer_Windows_DotNet_log.txt")
"___________________________________________________________" | Out-File -filepath $log_path -Append
Get-Date | Out-File -filepath $log_path -Append

$choco_failures = @()
$choco_successes = @()
$choco_installed = @()
$failures = @()
$sucesses = @()

function Record-Result {
 param (
   [int]$exit_code, [string]$package
 )

 if($exit_code -e 0)
 {
  $script:choco_failures += $package
 }
 else {
  $script:choco_successes += $package
 }
}

function Install-Choco
{
 choco install -y --no-progress chocolatey
 refreshenv | Out-Null
}

function Choco-Installs
{
  #Oh My Posh
  choco install -y --no-progress oh-my-posh
  Record-Result $LASTEXITCODE "Oh My Posh"
  refreshenv | Out-Null

  #Nerd font
  choco install -y --no-progress cascadia-code-nerd-font
  Record-Result $LASTEXITCODE "Nerd Font"
  refreshenv | Out-Null

  #Google Chrome
  choco install -y --no-progress googlechrome
  Record-Result $LASTEXITCODE "Google Chrome"
  refreshenv | Out-Null

  #Microsoft Teams
  choco install -y --no-progress microsoft-teams
  Record-Result $LASTEXITCODE "Microsoft Teams"
  refreshenv | Out-Null

  #Git
  choco install -y --no-progress git.install
  Record-Result $LASTEXITCODE "Git"
  refreshenv | Out-Null

  #Postman
  choco install -y --no-progress postman
  Record-Result $LASTEXITCODE "Postman"
  refreshenv | Out-Null

   #Kubernetes cli
  choco install -y --no-progress kubernetes-cli
  Record-Result $LASTEXITCODE "Kubernetes Cli"
  refreshenv | Out-Null

  #Docker Desktop
  choco install -y --no-progress docker-desktop
  Record-Result $LASTEXITCODE "Docker Desktop"
  refreshenv | Out-Null

  #Fiddler
  choco install -y --no-progress fiddler
  Record-Result $LASTEXITCODE "Fiddler"
  refreshenv | Out-Null

  #dotnet sdk 6
  choco install -y --no-progress dotnet-6.0-sdk
  Record-Result $LASTEXITCODE ".Net SDK 6"
  refreshenv | Out-Null

  #dotnet sdk
  choco install -y --no-progress dotnet-sdk
  Record-Result $LASTEXITCODE ".Net SDK"
  refreshenv | Out-Null

  #VS Code
  choco install -y --no-progress vscode
  Record-Result $LASTEXITCODE "VS Code"
  refreshenv | Out-Null

  #JetBrain Ultimate
  choco install -y --no-progress jetbrains-rider --params "/PerMachine"
  Record-Result $LASTEXITCODE "JetBrain Rider"
  refreshenv | Out-Null

  #Visual Studio Professional 2022
  choco install -y --no-progress visualstudio2022professional
  Record-Result $LASTEXITCODE "Visual Studio 2022 Professional"
  refreshenv | Out-Null

  #WinMerge
  choco install -y --no-progress winmerge
  Record-Result $LASTEXITCODE "WinMerge"
  refreshenv | Out-Null
}

function Output-Results
{
 Write-Host "`nChocolatey Installation results:" -foregroundcolor "Megenta"
 "`r`nAdditional installation results" | Out-File -filepath $log_path -Append

 if($choco_successes.Count -ne 0)
 {
   Write-Host "`nSuccessful Installation results:" -foregroundcolor "green"
   "`r`nAdditional installation results" | Out-File -filepath $log_path -Append
   $choco_successes | Tee-Object -filepath $log_path -Append
 }

 if($choco_failures.Count -ne 0)
 {
   Write-Host "`nSuccessful Installation results:" -foregroundcolor "red"
   "`r`nAdditional installation results" | Out-File -filepath $log_path -Append
   $choco_failures | Tee-Object -filepath $log_path -Append
 }
}

Install-Choco | Tee-Object -filepath $log_path -Append
Choco-Installs | Tee-Object -filepath $log_path -Append
Output-Results
