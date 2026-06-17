$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$port = 8123
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Start()
Write-Host "Serving $root on http://localhost:$port/"
$mime = @{ '.html'='text/html'; '.js'='application/javascript'; '.css'='text/css'; '.png'='image/png'; '.fbx'='application/octet-stream'; '.json'='application/json' }
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $rel = [System.Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath.TrimStart('/'))
  if ($rel -eq '') { $rel = 'index.html' }
  $path = Join-Path $root $rel
  if (Test-Path $path -PathType Leaf) {
    $bytes = [System.IO.File]::ReadAllBytes($path)
    $ext = [System.IO.Path]::GetExtension($path).ToLower()
    if ($mime.ContainsKey($ext)) { $ctx.Response.ContentType = $mime[$ext] }
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  } else {
    $ctx.Response.StatusCode = 404
  }
  $ctx.Response.Close()
}
