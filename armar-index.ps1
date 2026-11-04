# Genera index.html uniendo los modulos de /modulos en el orden de $modulos.
# El resultado se abre con doble clic (no necesita servidor).
# Ejecutar desde la raiz del proyecto cada vez que cambies un modulo:
#   powershell -ExecutionPolicy Bypass -File .\armar-index.ps1

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

# Orden de las secciones en la pagina (agrega, quita o reordena aqui)
$modulos = @(
  '01-menu',
  '02-hero',
  '03-miga-de-pan',
  '04-tipos-aliado',
  '05-vincularte',
  '06-beneficios',
  '07-resultados',
  '08-faq',
  '09-entidades',
  '10-contacto',
  '11-footer'
)

$utf8 = New-Object System.Text.UTF8Encoding($false)
$sb = New-Object System.Text.StringBuilder

[void]$sb.AppendLine('<!DOCTYPE html>')
[void]$sb.AppendLine('<html lang="es">')
[void]$sb.AppendLine('<head>')
[void]$sb.AppendLine('  <meta charset="UTF-8" />')
[void]$sb.AppendLine('  <meta name="viewport" content="width=device-width, initial-scale=1.0" />')
[void]$sb.AppendLine('  <title>Aliados CCO | Credibanco</title>')
[void]$sb.AppendLine('  <style>body { margin: 0; background: #fff; } html { scroll-behavior: smooth; }</style>')
[void]$sb.AppendLine('</head>')
[void]$sb.AppendLine('<body>')
[void]$sb.AppendLine('<!-- ARCHIVO GENERADO por armar-index.ps1. No editar aqui: edita los archivos de /modulos y vuelve a ejecutar el script. -->')

foreach ($m in $modulos) {
  $ruta = Join-Path $PSScriptRoot ($m + ".html")
  if (-not (Test-Path $ruta)) { throw "No existe el modulo: $ruta" }
  $contenido = [System.IO.File]::ReadAllText($ruta, $utf8)
  [void]$sb.AppendLine('')
  [void]$sb.AppendLine("<!-- ======== $m.html ======== -->")
  [void]$sb.AppendLine($contenido.TrimEnd())
}

[void]$sb.AppendLine('</body>')
[void]$sb.AppendLine('</html>')

[System.IO.File]::WriteAllText((Join-Path $PSScriptRoot 'index.html'), $sb.ToString(), $utf8)
Write-Host ("index.html generado con {0} modulos." -f $modulos.Count)
