@echo off
setlocal enabledelayedexpansion
title 3D Model Automate (Single File)

echo ==================================================
echo      3D Model Auto Generator ^& GitHub Push
echo ==================================================
set /p "newModel=Enter New Model FileName (e.g., saba.glb): "

if "%newModel%"=="" (
    echo [Error] No filename entered.
    pause
    exit
)

:: แยกชื่อไฟล์ออกมาเพื่อใช้เป็นชื่อไฟล์ HTML
for %%f in ("%newModel%") do set "fileName=%%~nf"
set "outputFile=%fileName%.html"

echo Generating %outputFile%...

:: สร้างไฟล์ HTML โดยใช้โค้ดภาษาอังกฤษที่คุณต้องการ
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$model = '%newModel%';" ^
    "$html = '<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><title>3D Preview</title><script type=\"module\" src=\"https://ajax.googleapis.com/ajax/libs/model-viewer/3.3.0/model-viewer.min.js\"></script><style>body, html { margin: 0; padding: 0; width: 100%%; height: 100%%; overflow: hidden; background-color: #ffffff; } .logo-container { position: absolute; top: 20px; left: 20px; z-index: 1000; pointer-events: none; } .logo-container img { width: 150px; height: auto; filter: drop-shadow(0px 2px 4px rgba(0,0,0,0.2)); } model-viewer { width: 100%%; height: 100vh; --poster-color: transparent; } #ar-button { background-color: #ffffff; border-radius: 30px; border: 1px solid #dadce0; bottom: 30px; left: 50%%; position: absolute; transform: translateX(-50%%); padding: 14px 28px; font-family: sans-serif; font-size: 16px; font-weight: bold; color: #1a73e8; box-shadow: 0 4px 10px rgba(0,0,0,0.15); cursor: pointer; z-index: 1000; }</style></head><body><div class=\"logo-container\"><img src=\"LOGO.png\" alt=\"Logo\"></div><model-viewer src=\"' + $model + '\" ar ar-modes=\"webxr scene-viewer quick-look\" camera-controls tone-mapping=\"neutral\" shadow-intensity=\"1\" auto-rotate touch-action=\"pan-y\"><button slot=\"ar-button\" id=\"ar-button\">📦 View in AR</button></model-viewer></body></html>';" ^
    "$html | Out-File -FilePath '%outputFile%' -Encoding UTF8 -Force"

echo [Success] Created %outputFile%

:: ส่วนของ GitHub Automate
echo.
echo --------------------------------------------------
echo      Pushing to GitHub...
echo --------------------------------------------------
git add .
git commit -m "Auto-added %outputFile% for model %newModel%"
git push origin main

echo.
echo ==================================================
echo      ALL DONE! Your model is now online.
echo ==================================================
pause