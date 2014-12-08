@echo off
cd CSSocket/bin
for /l %%x in (1, 1, 100) do Main-Debug.exe
pause