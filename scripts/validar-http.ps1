$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$terraform = Join-Path $repoRoot "bin\tf.ps1"

$url = & $terraform output -raw web_url
$response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 15

"status=$($response.StatusCode) url=$url"
($response.Content -split "`n" | Select-Object -First 10)
