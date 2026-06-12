param(
  [Parameter(Mandatory = $true)]
  [string] $Nome,

  [Parameter(Mandatory = $true)]
  [string] $Comando,

  [string] $Titulo = "Evidencia de terminal"
)

$ErrorActionPreference = "Continue"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$evidenceDir = Join-Path $repoRoot "docs\evidencias"
New-Item -ItemType Directory -Force -Path $evidenceDir | Out-Null

$txtPath = Join-Path $evidenceDir "$Nome.txt"
$pngPath = Join-Path $evidenceDir "$Nome.png"

$env:NO_COLOR = "1"

"PS> $Comando" | Out-File -LiteralPath $txtPath -Encoding utf8
"Executado em: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')" | Out-File -LiteralPath $txtPath -Encoding utf8 -Append
"" | Out-File -LiteralPath $txtPath -Encoding utf8 -Append

Invoke-Expression $Comando 2>&1 | Tee-Object -FilePath $txtPath -Append
$exitCode = $LASTEXITCODE

& (Join-Path $repoRoot "scripts\gerar-print-terminal.ps1") -InputPath $txtPath -OutputPath $pngPath -Title $Titulo

exit $exitCode
