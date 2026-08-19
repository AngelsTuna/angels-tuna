
$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$port = 8080

function Get-MimeType([string]$path) {
    switch ([IO.Path]::GetExtension($path).ToLowerInvariant()) {
        ".html" { "text/html; charset=utf-8" }
        ".htm"  { "text/html; charset=utf-8" }
        ".css"  { "text/css; charset=utf-8" }
        ".js"   { "application/javascript; charset=utf-8" }
        ".json" { "application/json; charset=utf-8" }
        ".png"  { "image/png" }
        ".jpg"  { "image/jpeg" }
        ".jpeg" { "image/jpeg" }
        ".gif"  { "image/gif" }
        ".svg"  { "image/svg+xml" }
        ".ico"  { "image/x-icon" }
        ".mp4"  { "video/mp4" }
        ".webm" { "video/webm" }
        ".woff" { "font/woff" }
        ".woff2"{ "font/woff2" }
        default { "application/octet-stream" }
    }
}

function Send-Response($stream, [int]$statusCode, [string]$statusText, [byte[]]$body, [string]$contentType) {
    $header = "HTTP/1.1 $statusCode $statusText`r`n" +
              "Content-Type: $contentType`r`n" +
              "Content-Length: $($body.Length)`r`n" +
              "Cache-Control: no-cache`r`n" +
              "Connection: close`r`n`r`n"
    $headerBytes = [Text.Encoding]::ASCII.GetBytes($header)
    $stream.Write($headerBytes, 0, $headerBytes.Length)
    if ($body.Length -gt 0) {
        $stream.Write($body, 0, $body.Length)
    }
    $stream.Flush()
}

try {
    $listener = [System.Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, $port)
    $listener.Start()
} catch {
    Write-Host ""
    Write-Host "ERRORE: impossibile avviare il server sulla porta $port." -ForegroundColor Red
    Write-Host $_.Exception.Message
    Write-Host ""
    Write-Host "Chiudi eventuali altre finestre ANGEL'S TUNA e riprova."
    Read-Host "Premi INVIO per chiudere"
    exit 1
}

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host " ANGEL'S TUNA v24 - SERVER LOCALE WINDOWS" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Server attivo su: http://localhost:$port" -ForegroundColor Green
Write-Host "Cartella: $root"
Write-Host ""
Write-Host "LASCIA APERTA QUESTA FINESTRA mentre usi l'app." -ForegroundColor Yellow
Write-Host "Per chiudere il server premi CTRL+C."
Write-Host ""

Start-Sleep -Milliseconds 700
Start-Process "http://localhost:$port"

while ($true) {
    $client = $listener.AcceptTcpClient()
    try {
        $stream = $client.GetStream()
        $reader = New-Object IO.StreamReader($stream, [Text.Encoding]::ASCII, $false, 4096, $true)
        $requestLine = $reader.ReadLine()
        if ([string]::IsNullOrWhiteSpace($requestLine)) {
            $client.Close()
            continue
        }

        # Consume request headers
        do {
            $line = $reader.ReadLine()
        } while ($line -ne $null -and $line -ne "")

        $parts = $requestLine.Split(" ")
        if ($parts.Length -lt 2) {
            $body = [Text.Encoding]::UTF8.GetBytes("Bad Request")
            Send-Response $stream 400 "Bad Request" $body "text/plain; charset=utf-8"
            $client.Close()
            continue
        }

        $urlPath = [Uri]::UnescapeDataString(($parts[1].Split("?")[0]))
        if ($urlPath -eq "/" -or [string]::IsNullOrWhiteSpace($urlPath)) {
            $urlPath = "/index.html"
        }

        $relativePath = $urlPath.TrimStart("/").Replace("/", "\")
        $requestedPath = [IO.Path]::GetFullPath((Join-Path $root $relativePath))
        $rootFull = [IO.Path]::GetFullPath($root)

        # Prevent path traversal
        if (-not $requestedPath.StartsWith($rootFull, [StringComparison]::OrdinalIgnoreCase)) {
            $body = [Text.Encoding]::UTF8.GetBytes("Forbidden")
            Send-Response $stream 403 "Forbidden" $body "text/plain; charset=utf-8"
            $client.Close()
            continue
        }

        if (Test-Path $requestedPath -PathType Leaf) {
            $bytes = [IO.File]::ReadAllBytes($requestedPath)
            $mime = Get-MimeType $requestedPath
            Send-Response $stream 200 "OK" $bytes $mime
            Write-Host ("200  " + $urlPath) -ForegroundColor DarkGray
        } else {
            # SPA fallback to index.html for unknown routes
            $indexPath = Join-Path $root "index.html"
            if (Test-Path $indexPath) {
                $bytes = [IO.File]::ReadAllBytes($indexPath)
                Send-Response $stream 200 "OK" $bytes "text/html; charset=utf-8"
                Write-Host ("200  " + $urlPath + " -> index.html") -ForegroundColor DarkGray
            } else {
                $body = [Text.Encoding]::UTF8.GetBytes("Not Found")
                Send-Response $stream 404 "Not Found" $body "text/plain; charset=utf-8"
            }
        }
    } catch {
        Write-Host ("Errore richiesta: " + $_.Exception.Message) -ForegroundColor Red
    } finally {
        try { $client.Close() } catch {}
    }
}
