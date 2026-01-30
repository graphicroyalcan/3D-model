@echo off
setlocal enabledelayedexpansion
title 3D Model Generator - Fixed Auto-Upload

echo ==================================================
echo      3D html by Designdee (Final Fix)
echo ==================================================
set /p "newModel=Enter New Model FileName (e.g., saba.glb): "

if "%newModel%"=="" (
    echo [Error] No filename entered.
    pause
    exit
)

:: 1. แยกชื่อไฟล์เพื่อตั้งชื่อ .html
for %%f in ("%newModel%") do set "fileName=%%~nf"
set "outputFile=%fileName%.html"

echo [1/3] Generating %outputFile%...

:: 2. สร้างไฟล์ HTML (จัดรูปแบบสวยงามเหมือนฝั่งซ้าย)
(
echo ^<!DOCTYPE html^>
echo ^<html lang="en"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>Designdee 3D Preview^</title^>
echo     ^<script type="module" src="https://ajax.googleapis.com/ajax/libs/model-viewer/3.3.0/model-viewer.min.js"^>^</script^>
echo     ^<style^>
echo         body, html {
echo             margin: 0; padding: 0; width: 100%%; height: 100%%;
echo             overflow: hidden; background-color: #ffffff;
echo         }
echo         .logo-container {
echo             position: absolute; top: 20px; left: 20px;
echo             z-index: 1000; pointer-events: none;
echo         }
echo         .logo-container img {
echo             width: 150px; height: auto;
echo             filter: drop-shadow(0px 2px 4px rgba(0,0,0,0.2^)^);
echo         }
echo         model-viewer {
echo             width: 100%%; height: 100vh;
echo             --poster-color: transparent;
echo         }
echo         #ar-button {
echo             background-color: #ffffff; border-radius: 30px;
echo             border: 1px solid #dadce0; bottom: 30px; left: 50%%;
echo             position: absolute; transform: translateX(-50%%^);
echo             padding: 14px 28px; font-family: sans-serif;
echo             font-size: 16px; font-weight: bold; color: #1a73e8;
echo             box-shadow: 0 4px 10px rgba(0,0,0,0.15^); cursor: pointer; z-index: 1000;
echo         }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="logo-container"^>
echo         ^<img src="RCIlogo.png" alt="Company Logo"^>
echo     ^</div^>
echo     ^<model-viewer
echo         src="%newModel%"
echo         ar ar-modes="webxr scene-viewer quick-look"
echo         camera-controls tone-mapping="neutral"
echo         shadow-intensity="1" auto-rotate touch-action="pan-y"
echo         alt="3D Model Preview"^>
echo         ^<button slot="ar-button" id="ar-button"^>📦 View in AR^</button^>
echo     ^</model-viewer^>
echo ^</body^>
echo ^</html^>
) > "%outputFile%"

:: 3. แปลงเป็น UTF8 และคัดลอกลิงก์ (แก้ปัญหาภาษาต่างดาว)
echo [2/3] Copying link to Clipboard...
powershell -Command "$content = Get-Content '%outputFile%'; [System.IO.File]::WriteAllLines('%outputFile%', $content, [System.Text.Encoding]::UTF8); $link = 'https://graphicroyalcan.github.io/3D-model/' + '%outputFile%'.Replace(' ', '%%20'); $link | clip; Write-Host 'Link Copied: ' $link"

:: 4. เริ่มต้นการอัปโหลดขึ้น GitHub (Git Push) พร้อมตรวจสอบสิทธิ์
echo [3/3] Uploading to GitHub...
if exist ".git" (
    git add .
    git commit -m "Auto-upload: %outputFile%"
    git push origin main
    if !ERRORLEVEL! EQU 0 (
        echo.
        echo [Success] File created, Link copied, and Uploaded!
    ) else (
        echo.
        echo [Error] Push failed. Please check your internet or GitHub login status.
    )
) else (
    echo.
    echo [Critical Error] .git folder not found!
    echo Please move this .bat file into your local GitHub Repository folder.
)

echo ==================================================
pause