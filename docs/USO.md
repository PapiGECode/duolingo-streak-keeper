# Uso en Windows

## Requisitos

- Windows de 64 bits. Verificado en Windows 11.
- Cuenta propia de Duolingo, ya iniciada en el navegador o la aplicación.
- Interfaz en español y sección Sonidos disponible en el curso.
- Duolingo visible y maximizado en el monitor principal. Zoom del navegador al 100 %.
- Equipo encendido, sesión desbloqueada y ratón libre durante la ejecución.

## Abrir sin instalar

Extrae el ZIP y abre `Duolingo_Streak_Bot.exe`. El programa guarda sus plantillas y registros en `%LOCALAPPDATA%\DuolingoStreakBot`. No requiere introducir la contraseña de Duolingo en el bot.

El archivo no tiene firma digital de un editor comercial. Comprueba que procede de este repositorio y, si lo deseas, compara su SHA-256 con `SHA256SUMS.txt`. No hace falta desactivar el antivirus ni ejecutar la aplicación como administrador.

## Instalar en una ubicación fija (opcional)

Para que los controles de programación diaria encuentren el ejecutable y su script:

1. Extrae el ZIP.
2. Abre PowerShell dentro de la carpeta extraída.
3. Ejecuta `powershell -NoProfile -ExecutionPolicy Bypass -File .\Instalar.ps1`.

El script copia únicamente el ejecutable y `setup_schedule.ps1` a `%LOCALAPPDATA%\DuolingoStreakBot`. No instala tareas, no abre Duolingo y no cambia la configuración global de PowerShell. Si ya hay una instalación, conserva una copia de los archivos que sustituye. Usa después el ejecutable de esa ubicación.

## Programación diaria

Después de la instalación opcional, utiliza los controles de programación de la aplicación y elige la hora. También puedes hacerlo en PowerShell:

```powershell
& "$env:LOCALAPPDATA\DuolingoStreakBot\setup_schedule.ps1" -Action install -Time '00:00'
& "$env:LOCALAPPDATA\DuolingoStreakBot\setup_schedule.ps1" -Action status
```

Se crea la tarea `DuolingoDailyStreakFarmer` para el usuario actual, sin elevación. Usa el mismo nombre que las versiones anteriores: al instalarla se actualiza esa tarea. No hay automatización en GitHub ni ejecución con el ordenador apagado. Mantén la sesión de Windows desbloqueada y Duolingo autenticado; la ejecución programada también utiliza la pantalla y el ratón.

Para quitar la tarea:

```powershell
& "$env:LOCALAPPDATA\DuolingoStreakBot\setup_schedule.ps1" -Action remove
```

## Si no detecta un botón

Pulsa **F8**. Comprueba el monitor principal, la ventana maximizada, el idioma y el zoom. Usa **F7** para comprobar la detección sin clics. La aplicación permite calibrar los botones con un recorte; las plantillas se guardan en `templates` dentro de su carpeta de datos.

Si una actualización de Duolingo cambia el recorrido o los botones, puede ser necesario recalibrar. Si tu cuenta no tiene Sonidos, este flujo no es compatible.

## Archivos locales

La carpeta de datos puede contener `registro_rachas.log`, `diagnostico.json`, `ultima_prueba.png`, plantillas y otros fotogramas de diagnóstico. Las capturas pueden mostrar tu cuenta: revisa los archivos antes de adjuntarlos a una incidencia pública.

`Duolingo_Streak_Bot.exe --diagnose` genera un diagnóstico local sin hacer clics. `--daily` inicia una lección y utiliza el ratón; **F8** permite detenerla.

Para retirar la aplicación, cierra el bot, elimina primero la tarea si la instalaste y borra la carpeta de la aplicación cuando ya no necesites las plantillas o registros.
