set LOVE_DIR=E:\Users\wojte_000\Desktop\love-0.10.0-win64\
set ZIP_DIR="C:\Program Files\7-Zip"

del main.love

%ZIP_DIR%\7z.exe a -tzip main.love assets main.lua
%LOVE_DIR%\love.exe main.love
