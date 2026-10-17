@echo off
setlocal
cd /d "%~dp0"

set CM_BASE=https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.16
set PDF_BASE=https://cdnjs.cloudflare.com/ajax/libs/pdf.js/6.1.200

echo == VanoLeaf: downloading libraries (one-time) ==

if not exist "vendor\codemirror\mode\stex" mkdir "vendor\codemirror\mode\stex"
if not exist "vendor\codemirror\addon\hint" mkdir "vendor\codemirror\addon\hint"
if not exist "vendor\codemirror\addon\edit" mkdir "vendor\codemirror\addon\edit"
if not exist "vendor\codemirror\addon\comment" mkdir "vendor\codemirror\addon\comment"
if not exist "vendor\codemirror\addon\fold" mkdir "vendor\codemirror\addon\fold"
if not exist "vendor\codemirror\addon\selection" mkdir "vendor\codemirror\addon\selection"
if not exist "vendor\codemirror\theme" mkdir "vendor\codemirror\theme"
if not exist "vendor\pdfjs" mkdir "vendor\pdfjs"

where curl >nul 2>nul
if errorlevel 1 (
    echo curl.exe not found. It ships with Windows 10 ^(1803+^)/11 by default.
    echo If it's missing on your system, download the files listed below manually
    echo into the matching vendor\ subfolders instead.
    pause
    exit /b 1
)

echo   - vendor\codemirror\codemirror.min.js
curl -fsSL "%CM_BASE%/codemirror.min.js" -o "vendor\codemirror\codemirror.min.js"
echo   - vendor\codemirror\codemirror.min.css
curl -fsSL "%CM_BASE%/codemirror.min.css" -o "vendor\codemirror\codemirror.min.css"
echo   - vendor\codemirror\mode\stex\stex.min.js
curl -fsSL "%CM_BASE%/mode/stex/stex.min.js" -o "vendor\codemirror\mode\stex\stex.min.js"
echo   - vendor\codemirror\addon\hint\show-hint.min.js
curl -fsSL "%CM_BASE%/addon/hint/show-hint.min.js" -o "vendor\codemirror\addon\hint\show-hint.min.js"
echo   - vendor\codemirror\addon\hint\show-hint.min.css
curl -fsSL "%CM_BASE%/addon/hint/show-hint.min.css" -o "vendor\codemirror\addon\hint\show-hint.min.css"
echo   - CodeMirror editor addons
curl -fsSL "%CM_BASE%/addon/edit/closebrackets.min.js" -o "vendor\codemirror\addon\edit\closebrackets.min.js"
curl -fsSL "%CM_BASE%/addon/edit/matchbrackets.min.js" -o "vendor\codemirror\addon\edit\matchbrackets.min.js"
curl -fsSL "%CM_BASE%/addon/comment/comment.min.js" -o "vendor\codemirror\addon\comment\comment.min.js"
curl -fsSL "%CM_BASE%/addon/fold/foldcode.min.js" -o "vendor\codemirror\addon\fold\foldcode.min.js"
curl -fsSL "%CM_BASE%/addon/fold/foldgutter.min.js" -o "vendor\codemirror\addon\fold\foldgutter.min.js"
curl -fsSL "%CM_BASE%/addon/fold/brace-fold.min.js" -o "vendor\codemirror\addon\fold\brace-fold.min.js"
curl -fsSL "%CM_BASE%/addon/fold/foldgutter.min.css" -o "vendor\codemirror\addon\fold\foldgutter.min.css"
curl -fsSL "%CM_BASE%/addon/selection/active-line.min.js" -o "vendor\codemirror\addon\selection\active-line.min.js"
echo   - vendor\codemirror\theme\material-darker.min.css
curl -fsSL "%CM_BASE%/theme/material-darker.min.css" -o "vendor\codemirror\theme\material-darker.min.css"
echo   - vendor\pdfjs\pdf.min.mjs
curl -fsSL "%PDF_BASE%/pdf.min.mjs" -o "vendor\pdfjs\pdf.min.mjs"
echo   - vendor\pdfjs\pdf.worker.min.mjs
curl -fsSL "%PDF_BASE%/pdf.worker.min.mjs" -o "vendor\pdfjs\pdf.worker.min.mjs"

echo.
echo Done. VanoLeaf can now run without an internet connection.
