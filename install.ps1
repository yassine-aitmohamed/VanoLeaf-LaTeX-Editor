# VanoLeaf - Windows installer. Safe to run again. ASCII only on purpose.
$ErrorActionPreference = "Continue"
$ProgressPreference    = "SilentlyContinue"
$env:PYTHONUTF8        = "1"
$Dir = $PSScriptRoot
$Url = "http://127.0.0.1:5500"

function Ok($m)   { Write-Host "  [OK] $m" -ForegroundColor Green }
function Warn($m) { Write-Host "  [!]  $m" -ForegroundColor Yellow }
function Has($n)  { return [bool](Get-Command $n -ErrorAction SilentlyContinue) }
function Refresh-Path {
    $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
}
function Winget-Install($id) {
    if (-not (Has "winget")) { return $false }
    & winget install --id $id -e --silent --accept-package-agreements --accept-source-agreements | Out-Host
    Refresh-Path
    return ($LASTEXITCODE -eq 0)
}
function Find-Python {
    $c = @()
    foreach ($v in @("3.12","3.11","3.13","3.10")) { $c += ,@("py", @("-$v")) }
    $c += ,@("python", @())
    foreach ($p in (Get-ChildItem "$env:LOCALAPPDATA\Programs\Python\Python3*\python.exe" -ErrorAction SilentlyContinue)) { $c += ,@($p.FullName, @()) }
    foreach ($x in $c) {
        if (-not (Has $x[0]) -and -not (Test-Path $x[0])) { continue }
        try {
            $o = & $x[0] @($x[1]) -c "import sys;print('%d.%d' % sys.version_info[:2])" 2>$null
            if ($LASTEXITCODE -eq 0 -and "$o" -match '^3\.(\d+)$' -and [int]$Matches[1] -ge 9) { return @{ Exe=$x[0]; Args=$x[1] } }
        } catch {}
    }
    return $null
}

Write-Host "VanoLeaf - installation" -ForegroundColor White

Write-Host "1/4  Python" -ForegroundColor Cyan
$Py = Find-Python
if (-not $Py) { Winget-Install "Python.Python.3.12" | Out-Null; $Py = Find-Python }
if (-not $Py) { Warn "Python 3.9+ not found. Install it from python.org (tick 'Add python.exe to PATH'), then run INSTALL.bat again."; exit 1 }
Ok "Python found"

Write-Host "2/4  Libraries" -ForegroundColor Cyan
$vpy = Join-Path $Dir "venv\Scripts\python.exe"
if (-not (Test-Path $vpy)) { & $Py.Exe @($Py.Args) -m venv (Join-Path $Dir "venv") | Out-Null }
& $vpy -m pip install -q --upgrade pip | Out-Null
& $vpy -m pip install -q -r (Join-Path $Dir "requirements.txt")
if ($LASTEXITCODE -eq 0) { Ok "Flask installed" } else { Warn "pip failed (see messages above)"; exit 1 }

Write-Host "3/4  LaTeX (MiKTeX)" -ForegroundColor Cyan
$miktex = @("$env:LOCALAPPDATA\Programs\MiKTeX\miktex\bin\x64", "$env:ProgramFiles\MiKTeX\miktex\bin\x64")
function Find-Bin { if (Has "pdflatex") { return (Split-Path (Get-Command pdflatex).Source) }; foreach ($d in $miktex) { if (Test-Path "$d\pdflatex.exe") { return $d } }; return $null }
$bin = Find-Bin
if (-not $bin) { Winget-Install "MiKTeX.MiKTeX" | Out-Null; $bin = Find-Bin }
if ($bin) {
    try { & "$bin\initexmf.exe" --set-config-value "[MPM]AutoInstall=1" 2>&1 | Out-Null } catch {}
    Ok "LaTeX ready (missing packages install themselves on first compile)"
} else { Warn "MiKTeX not installed: install it from miktex.org, VanoLeaf cannot compile without it." }

Write-Host "4/4  Shortcut and launch" -ForegroundColor Cyan
try {
    $sh = New-Object -ComObject WScript.Shell
    $l = $sh.CreateShortcut((Join-Path ([Environment]::GetFolderPath("Desktop")) "VanoLeaf.lnk"))
    $l.TargetPath = Join-Path $Dir "START_VanoLeaf.bat"
    $l.WorkingDirectory = $Dir
    $l.Save()
    Ok "Desktop shortcut created"
} catch { Warn "Shortcut not created" }
Start-Process -FilePath (Join-Path $Dir "START_VanoLeaf.bat") -WorkingDirectory $Dir
Write-Host "Done. VanoLeaf opens at $Url" -ForegroundColor White
