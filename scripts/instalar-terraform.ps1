param(
  [string] $Version = "1.15.6"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$toolDir = Join-Path $repoRoot ".tools\terraform\$Version"
$terraformExe = Join-Path $toolDir "terraform.exe"

if (Test-Path -LiteralPath $terraformExe) {
  & $terraformExe -version
  exit $LASTEXITCODE
}

New-Item -ItemType Directory -Force -Path $toolDir | Out-Null

$zipPath = Join-Path $toolDir "terraform_${Version}_windows_amd64.zip"
$downloadUrl = "https://releases.hashicorp.com/terraform/$Version/terraform_${Version}_windows_amd64.zip"

Write-Host "Baixando Terraform $Version..."
Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

Write-Host "Extraindo binario..."
Expand-Archive -LiteralPath $zipPath -DestinationPath $toolDir -Force
Remove-Item -LiteralPath $zipPath -Force

& $terraformExe -version
