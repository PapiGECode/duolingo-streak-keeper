param([string]$Action='status', [string]$Time='00:00')
$ErrorActionPreference = 'Stop'
$taskName = 'DuolingoDailyStreakFarmer'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$exePath = Join-Path $scriptDir 'Duolingo_Streak_Bot.exe'
if ($Action -eq 'status') {
    $task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
    if ($task -and $task.State -ne 'Disabled') {
        $info = Get-ScheduledTaskInfo -TaskName $taskName
        Write-Host 'STATUS: ACTIVE'
        Write-Host ('Hora programada: ' + ([datetime]$task.Triggers[0].StartBoundary).ToString('HH:mm'))
        Write-Host ('Proxima ejecucion: ' + $info.NextRunTime)
    } else { Write-Host 'STATUS: NOT_INSTALLED' }
} elseif ($Action -eq 'remove') {
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
} elseif ($Action -eq 'run') {
    Start-ScheduledTask -TaskName $taskName
} elseif ($Action -in @('install','update-time')) {
    if ($Time -notmatch '^([01]?[0-9]|2[0-3]):[0-5][0-9]$') { throw 'Hora no valida' }
    if (-not (Test-Path -LiteralPath $exePath)) { throw 'No se encuentra el ejecutable instalado' }
    $taskAction = New-ScheduledTaskAction -Execute $exePath -Argument '--daily' -WorkingDirectory $scriptDir
    $trigger = New-ScheduledTaskTrigger -Daily -At $Time
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -WakeToRun -StartWhenAvailable -ExecutionTimeLimit (New-TimeSpan -Minutes 10)
    $principal = New-ScheduledTaskPrincipal -UserId ([System.Security.Principal.WindowsIdentity]::GetCurrent().Name) -LogonType Interactive -RunLevel Limited
    Register-ScheduledTask -TaskName $taskName -Action $taskAction -Trigger $trigger -Settings $settings -Principal $principal -Description 'Duolingo diario mediante sesion interactiva' -Force | Out-Null
    Write-Host ('OK: Programado a las '+$Time)
}
