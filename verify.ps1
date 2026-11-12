$ErrorActionPreference = 'Stop'
$chrome = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$url = "http://localhost:8137/"
$out = Join-Path $env:TEMP "cb-verify"
New-Item -ItemType Directory -Force -Path $out | Out-Null

$widths = @(
  @{ w = 1280; h = 3200; name = "desktop" },
  @{ w = 768;  h = 4200; name = "tablet" },
  @{ w = 390;  h = 7000; name = "mobile" }
)

foreach ($cfg in $widths) {
  $png = Join-Path $out ("cb-" + $cfg.name + "-" + $cfg.w + ".png")
  $args = @(
    "--headless=new",
    "--disable-gpu",
    "--hide-scrollbars",
    "--force-device-scale-factor=1",
    ("--window-size=" + $cfg.w + "," + $cfg.h),
    ("--screenshot=" + $png),
    $url
  )
  & $chrome @args 2>$null | Out-Null
  Start-Sleep -Milliseconds 500
  if (Test-Path $png) {
    $len = (Get-Item $png).Length
    Write-Output ("OK " + $cfg.name + " (" + $cfg.w + "px) -> " + $png + " [" + $len + " bytes]")
  } else {
    Write-Output ("FAIL " + $cfg.name + " (" + $cfg.w + "px) no screenshot")
  }
}
Write-Output ("OUTDIR " + $out)
