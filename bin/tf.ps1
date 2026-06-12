param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]] $TerraformArgs
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$version = (Get-Content -LiteralPath (Join-Path $repoRoot ".terraform-version") -TotalCount 1).Trim()
$terraformExe = Join-Path $repoRoot ".tools\terraform\$version\terraform.exe"

if (-not (Test-Path -LiteralPath $terraformExe)) {
  & (Join-Path $repoRoot "scripts\instalar-terraform.ps1") -Version $version
}

& $terraformExe @TerraformArgs
exit $LASTEXITCODE
