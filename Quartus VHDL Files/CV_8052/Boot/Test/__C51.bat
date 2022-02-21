@echo off
::This file was created automatically by CrossIDE to compile with C51.
C:
cd "\Source\CV_8052\Boot\Test\"
"C:\Source\call51\bin\c51.exe" --use-stdout  "C:\Source\CV_8052\Boot\Test\shared_memory_test.c"
if not exist hex2mif.exe goto done
if exist shared_memory_test.ihx hex2mif shared_memory_test.ihx
if exist shared_memory_test.hex hex2mif shared_memory_test.hex
:done
echo done
echo Crosside_Action Set_Hex_File C:\Source\CV_8052\Boot\Test\shared_memory_test.hex
