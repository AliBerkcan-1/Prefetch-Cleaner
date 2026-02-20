@echo off
cls
echo [!] Ultra-Fast Cleaner Build System
echo -----------------------------------

:: 1. Adım: Assembly dosyasını işle
echo [+] Assembler calistiriliyor (NASM)...
nasm.exe -f win64 cleaner.asm -o cleaner.obj
if %errorlevel% neq 0 goto error

:: 2. Adım: Linker ile birleştir (GoLink en kolayıdır)
echo [+] Linker calistiriliyor (GoLink)...
GoLink.exe /entry main cleaner.obj kernel32.dll user32.dll
if %errorlevel% neq 0 goto error

echo -----------------------------------
echo [SUCCESS] cleaner.exe olusturuldu!
pause
exit

:error
echo [!] HATA: Bir seyler ters gitti kfskfs. Kodlari kontrol et.
pause