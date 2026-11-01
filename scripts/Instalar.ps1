$ErrorActionPreference = 'Stop'
$installDir = Join-Path $env:LOCALAPPDATA 'DuolingoStreakBot'
$files = @('Duolingo_Streak_Bot.exe', 'setup_schedule.ps1')
foreach ($name in $files) {
    if (-not (Test-Path -LiteralPath (Join-Path $PSScriptRoot $name) -PathType Leaf)) {
        throw "Falta $name. Extrae primero todos los archivos del ZIP."
    }
}
New-Item -ItemType Directory -Path $installDir -Force | Out-Null
$backupDir = Join-Path $installDir ('backup-' + (Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
foreach ($name in $files) {
    $sourcePath = Join-Path $PSScriptRoot $name
    $destinationPath = Join-Path $installDir $name
    if ([IO.Path]::GetFullPath($sourcePath) -eq [IO.Path]::GetFullPath($destinationPath)) { continue }
    if (Test-Path -LiteralPath $destinationPath) {
        New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
        Copy-Item -LiteralPath $destinationPath -Destination (Join-Path $backupDir $name)
    }
    Copy-Item -LiteralPath $sourcePath -Destination $destinationPath -Force
}
Write-Host "Instalado en $installDir"
Write-Host 'Abre Duolingo_Streak_Bot.exe desde esa carpeta. La tarea diaria se activa solo si la configuras.'
