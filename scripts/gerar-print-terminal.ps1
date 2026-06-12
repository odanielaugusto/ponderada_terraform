param(
  [Parameter(Mandatory = $true)]
  [string] $InputPath,

  [Parameter(Mandatory = $true)]
  [string] $OutputPath,

  [string] $Title = "Evidencia de terminal"
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

$fullInputPath = Resolve-Path -LiteralPath $InputPath
$lines = Get-Content -LiteralPath $fullInputPath

if ($lines.Count -eq 0) {
  $lines = @("(sem saida)")
}

$font = New-Object System.Drawing.Font("Consolas", 12)
$titleFont = New-Object System.Drawing.Font("Arial", 16, [System.Drawing.FontStyle]::Bold)
$padding = 28
$lineHeight = 22
$maxChars = ($lines | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum
$width = [Math]::Min([Math]::Max(900, 56 + ($maxChars * 8)), 1800)
$height = [Math]::Max(260, 94 + ($lines.Count * $lineHeight))

$bitmap = New-Object System.Drawing.Bitmap($width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

$background = [System.Drawing.Color]::FromArgb(13, 17, 23)
$header = [System.Drawing.Color]::FromArgb(22, 27, 34)
$text = [System.Drawing.Color]::FromArgb(230, 237, 243)
$muted = [System.Drawing.Color]::FromArgb(139, 148, 158)
$green = [System.Drawing.Color]::FromArgb(63, 185, 80)

$graphics.Clear($background)
$graphics.FillRectangle((New-Object System.Drawing.SolidBrush($header)), 0, 0, $width, 56)
$graphics.FillEllipse((New-Object System.Drawing.SolidBrush($green)), 24, 22, 12, 12)
$graphics.DrawString($Title, $titleFont, (New-Object System.Drawing.SolidBrush($text)), 48, 17)
$graphics.DrawString((Split-Path -Leaf $InputPath), $font, (New-Object System.Drawing.SolidBrush($muted)), $padding, 68)

$y = 96
foreach ($line in $lines) {
  $graphics.DrawString($line, $font, (New-Object System.Drawing.SolidBrush($text)), $padding, $y)
  $y += $lineHeight
}

$outputDir = Split-Path -Parent $OutputPath
if ($outputDir) {
  New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

$bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
$graphics.Dispose()
$bitmap.Dispose()
