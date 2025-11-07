@echo off
setlocal EnableDelayedExpansion
:: --- edit this path if needed ---
set "labs_dir=C:\Bash"
cd /d "%labs_dir%" || (echo Cannot find "%labs_dir%" & exit /b 1)

for %%F in (*_Lab*) do (
    set "name=%%~nF"
    set "ext=%%~xF"
    :: strip everything up to and including '_Lab'
    set "new=!name:*_Lab=Lab!"
    ren "%%F" "!new!!ext!"
    echo ✅  %%F  →  !new!!ext!
)
endlocal