@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:: Usage: pack_lib_assets.cmd [OUTPUT_FILE]
set "OUT=all_sources.md"
if not "%~1"=="" set "OUT=%~1"

:: start clean
break > "%OUT%"
for %%A in ("%OUT%") do set "OUTABS=%%~fA"
set "ROOT=%CD%"

call :pack "lib" "%OUT%"
call :pack "assets" "%OUT%"

echo Wrote: %OUT%
exit /b 0

:pack
set "DIR=%~1"
set "OUTFILE=%~2"
if not exist "%DIR%" exit /b 0

:: list .dart, .md, .arb recursively, name-sorted
for /f "usebackq delims=" %%F in (`
  dir /b /s /a:-d "%DIR%\*.dart" "%DIR%\*.md" "%DIR%\*.arb" ^| sort
`) do (
  set "FULL=%%~fF"
  if /i "!FULL!"=="%OUTABS%" (
    rem skip the output file if it lives under lib/assets
  ) else (
    set "REL=!FULL:%ROOT%\=!"
    set "REL=!REL:\=/!"

    >>"%OUTFILE%" echo ---
    >>"%OUTFILE%" echo # !REL!
    >>"%OUTFILE%" echo.

    type "%%~fF" >> "%OUTFILE%"
    >>"%OUTFILE%" echo.
  )
)
exit /b 0
