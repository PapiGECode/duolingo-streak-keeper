# Verificación de la publicación 2.2.0

Fecha: 1 de noviembre de 2026.

- Ejecutable idéntico, byte a byte, a la copia conservada 2.2-speech anterior al modo en segundo plano.
- Diagnóstico del ejecutable: salida 0, versión 2.2-speech, pausa 20 ms, speech_skip=true, captura 3840 × 2160.
- Pruebas del motor recuperado de este mismo ejecutable: detección de voz original, borde distinto, texto mayor, menor y azul; SALTAR conserva su detección.
- Regresión sobre tres capturas locales: inicio, continuar y Sonidos; coincidencia de botones y coordenadas con el motor original. Recuperación de botones verdes y amarillos comprobada.
- En esta máquina, las medianas de detección de esas tres capturas fueron 151,0 / 43,7 / 153,9 ms, frente a 905,8 / 875,2 / 874,4 ms del motor original. Son medidas locales de detección, no tiempos de lección ni garantías para otros equipos.
- El paquete no incluye la extensión, el conector, configuraciones de sesión, registros ni capturas personales.

La validación de esta publicación no repite una lección real en una cuenta nueva. La versión se había utilizado previamente en la cuenta del autor; otros cursos, idiomas, resoluciones y cambios de Duolingo pueden necesitar ajustes.

## SHA-256

Ejecutable publicado:

```text
06cbd8c570f7b4c2e6b43cbfbf1d15b302227971fd196947fccc9349a8bd5fa3
```

Comprueba una descarga con PowerShell:

```powershell
Get-FileHash .\Duolingo_Streak_Bot.exe -Algorithm SHA256
```

Los hashes del ejecutable y del ZIP están también en `SHA256SUMS.txt`, en la misma publicación de GitHub Releases, y en `release-manifest.json`.
