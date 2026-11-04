# Descarga los assets del diseño "seccion-alianzas" (Figma) a ./assets
# Las URLs de Figma son temporales (caducan ~7 días). Ejecutar desde la raíz del proyecto:
#   powershell -ExecutionPolicy Bypass -File .\descargar-assets.ps1

$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

$base = 'https://www.figma.com/api/mcp/asset/'
$assets = [ordered]@{
  # Menú
  'icono-hub-connect.png'        = '8987f94b-67fd-4cc8-988d-50425324feb8/154b5.png'
  'icono-centro-ayuda.png'       = '8987f94b-67fd-4cc8-988d-50425324feb8/29eaf.png'
  'icono-desarrolladores.png'    = '8987f94b-67fd-4cc8-988d-50425324feb8/5b56e.png'
  'logo-credibanco-menu.svg'     = '8987f94b-67fd-4cc8-988d-50425324feb8/f234e.svg'
  # Hero
  'hero-bg.png'                  = 'd39615a8-b66b-44a2-8b0d-826ece1deb65/78e76.png'
  # Selección de aliado
  'aliado-comercial.png'         = '5951f73c-2158-4acb-a0f5-9a0827eebaf4/f3172.png'
  'aliado-comercial-color.png'   = '5951f73c-2158-4acb-a0f5-9a0827eebaf4/5909c.png'
  'aliado-tecnologico.png'       = '5951f73c-2158-4acb-a0f5-9a0827eebaf4/2e962.png'
  'aliado-soluciones.png'        = '5951f73c-2158-4acb-a0f5-9a0827eebaf4/57a61.png'
  'aliado-tecnologico-color.png' = 'b02c5645-486a-4988-bbd7-560364162ceb/10880.png'
  'aliado-soluciones-color.png'  = 'e4df3102-a8c8-4d29-a6fa-daba9b466a85/0442e.png'
  'portafolio-tecnologico.png'   = '42c4d5a0-c6b1-4781-b0ec-32fbf543fd8c/6d046.png'
  'portafolio-soluciones.png'    = '8b62131f-9c24-4f39-b0bb-4833a0dd24e8/02d16.png'
  'hero-image.png'               = '5951f73c-2158-4acb-a0f5-9a0827eebaf4/8c089.png'
  'check.svg'                    = '5951f73c-2158-4acb-a0f5-9a0827eebaf4/fb7cc.svg'
  'list-bullets.svg'             = '5951f73c-2158-4acb-a0f5-9a0827eebaf4/1cf41.svg'
  'arrow-down.svg'               = '5951f73c-2158-4acb-a0f5-9a0827eebaf4/347d0.svg'
  # ¿Cómo puedes vincularte?
  'vincularte-1.png'             = 'a7fd2ada-ab98-4ea8-9eb2-b83f980cd06d/4b569.png'
  'vincularte-2.png'             = 'a7fd2ada-ab98-4ea8-9eb2-b83f980cd06d/1d515.png'
  # Beneficios
  'trending-up.svg'              = 'def1d6d6-0dd3-42e2-9120-61c36f314349/1f568.svg'
  'sdk.svg'                      = 'def1d6d6-0dd3-42e2-9120-61c36f314349/79df3.svg'
  'settings.svg'                 = 'def1d6d6-0dd3-42e2-9120-61c36f314349/dbf98.svg'
  'group.svg'                    = 'def1d6d6-0dd3-42e2-9120-61c36f314349/3ec9d.svg'
  # FAQ
  'faq.png'                      = 'b5db77b8-837b-4418-8b30-e5fbbe6a2127/940df.png'
  'chevron-down.svg'             = 'b5db77b8-837b-4418-8b30-e5fbbe6a2127/12b38.svg'
  # Logos de bancos (export completo del bloque)
  'logos-bancos.svg'             = '7b9cac48-fc0b-4280-a508-2837ed5d40ad.svg'
  # Formulario
  'radio.svg'                    = 'f874f729-2740-49f6-8bb8-bd59ea58449a/9c4c4.svg'
  'select-chevron.svg'           = 'f874f729-2740-49f6-8bb8-bd59ea58449a/2057b.svg'
  'arrow-right.svg'              = 'f874f729-2740-49f6-8bb8-bd59ea58449a/1fda5.svg'
  # Footer
  'google-play.png'              = '3f60b350-b21f-41f3-8f43-c9a849b3042f/b602e.png'
  'app-store.png'                = '3f60b350-b21f-41f3-8f43-c9a849b3042f/c17bb.png'
  'certificaciones.png'          = '3f60b350-b21f-41f3-8f43-c9a849b3042f/afe49.png'
  'vigilado.png'                 = '3f60b350-b21f-41f3-8f43-c9a849b3042f/0b469.png'
  'logo-credibanco.svg'          = '3f60b350-b21f-41f3-8f43-c9a849b3042f/cbd61.svg'
  'facebook.svg'                 = '3f60b350-b21f-41f3-8f43-c9a849b3042f/c5797.svg'
  'x.svg'                        = '3f60b350-b21f-41f3-8f43-c9a849b3042f/dc95b.svg'
  'youtube.svg'                  = '3f60b350-b21f-41f3-8f43-c9a849b3042f/d1fa3.svg'
  'instagram.svg'                = '3f60b350-b21f-41f3-8f43-c9a849b3042f/57c82.svg'
  'linkedin.svg'                 = '3f60b350-b21f-41f3-8f43-c9a849b3042f/7f8ef.svg'
}

$fallos = 0
foreach ($destino in $assets.Keys) {
  $url = $base + $assets[$destino]
  try {
    Invoke-WebRequest -Uri $url -OutFile $destino -UseBasicParsing
    $size = (Get-Item $destino).Length
    if ($size -eq 0) { throw 'archivo vacío' }
    Write-Host ("OK   {0} ({1} bytes)" -f $destino, $size)
  } catch {
    $fallos++
    Write-Host ("FAIL {0}: {1}" -f $destino, $_.Exception.Message) -ForegroundColor Red
  }
}
Write-Host ("`n{0} de {1} assets descargados." -f ($assets.Count - $fallos), $assets.Count)
