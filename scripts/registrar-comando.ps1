param(
  [Parameter(Mandatory = $true)]
  [string] $Nome,

  [Parameter(Mandatory = $true)]
  [string] $Comando,

  [string] $Titulo = "Evidencia de terminal"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$evidenceDir = Join-Path $repoRoot "docs\evidencias"
New-Item -ItemType Directory -Force -Path $evidenceDir | Out-Null

$txtPath = Join-Path $evidenceDir "$Nome.txt"
$pngPath = Join-Path $evidenceDir "$Nome.png"

$env:NO_COLOR = "1"

"PS> $Comando" | Out-File -LiteralPath $txtPath -Encoding utf8
"Executado em: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')" | Out-File -LiteralPath $txtPath -Encoding utf8 -Append
"" | Out-File -LiteralPath $txtPath -Encoding utf8 -Append

function Append-Text {
  param([string] $Text)

  if ([string]::IsNullOrWhiteSpace($Text)) {
    return
  }

  $cleanText = $Text.TrimEnd()
  Write-Output $cleanText
  $cleanText | Out-File -LiteralPath $txtPath -Encoding utf8 -Append
}

function Read-RedirectedText {
  param([string] $Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    return ""
  }

  $bytes = [System.IO.File]::ReadAllBytes($Path)

  if ($bytes.Length -eq 0) {
    return ""
  }

  $nullBytes = ($bytes | Where-Object { $_ -eq 0 }).Count
  if ($nullBytes -gt ($bytes.Length / 4)) {
    return [System.Text.Encoding]::Unicode.GetString($bytes)
  }

  return [System.Text.Encoding]::UTF8.GetString($bytes)
}

$stdoutPath = Join-Path ([System.IO.Path]::GetTempPath()) "$Nome.stdout.txt"
$stderrPath = Join-Path ([System.IO.Path]::GetTempPath()) "$Nome.stderr.txt"
Remove-Item -LiteralPath $stdoutPath, $stderrPath -Force -ErrorAction SilentlyContinue

$wrappedCommand = "& { $Comando; if (`$null -ne `$global:LASTEXITCODE) { exit `$global:LASTEXITCODE } }"

$process = Start-Process `
  -FilePath "powershell" `
  -ArgumentList @("-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $wrappedCommand) `
  -WorkingDirectory $repoRoot `
  -RedirectStandardOutput $stdoutPath `
  -RedirectStandardError $stderrPath `
  -NoNewWindow `
  -PassThru

$completed = $process.WaitForExit(120000)

if (-not $completed) {
  Stop-Process -Id $process.Id -Force -ErrorAction SilentlyContinue
  Append-Text -Text "ERRO: comando excedeu o tempo limite de 120 segundos."
  $exitCode = 124
}
else {
  $stdout = Read-RedirectedText -Path $stdoutPath
  $stderr = Read-RedirectedText -Path $stderrPath

  Append-Text -Text $stdout
  Append-Text -Text $stderr

  $exitCode = $process.ExitCode
}

& (Join-Path $repoRoot "scripts\gerar-print-terminal.ps1") -InputPath $txtPath -OutputPath $pngPath -Title $Titulo

exit $exitCode
