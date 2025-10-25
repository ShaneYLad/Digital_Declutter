# =======================
# Digital Declutter Script
# Author: Shane Green (Shanzo)
# Description: Clears temp files, browser cache, history, and recent files.
# Note: Run PowerShell as Administrator and close all browsers.
# =======================

Clear-Host

# --- Colors ---
$Cyan = "Cyan"
$Gray = "Gray"
$Green = "Green"
$Yellow = "Yellow"
$Red = "Red"

# --- Header ---
Write-Host "===============================================" -ForegroundColor $Cyan
Write-Host "            [CLEANUP] DIGITAL DECLUTTER SCRIPT" -ForegroundColor $Cyan
Write-Host "===============================================" -ForegroundColor $Cyan
Write-Host ""
Write-Host "Author: Shane Green (Shanzo)" -ForegroundColor $Yellow
Write-Host "Description: Cleans browser cache, history, temp files, and recent files." -ForegroundColor $Gray
Write-Host ""
Write-Host "[WARNING] Run as Admin and close all browsers before starting." -ForegroundColor $Red
Write-Host ""

# --- Confirmation ---
$response = Read-Host "Do you want to start the cleanup? (Y/N)"
if ($response -notmatch "^[Yy]$") {
    Write-Host ""
    Write-Host "[CANCELLED] Cleanup cancelled by user." -ForegroundColor $Red
    Write-Host "===============================================" -ForegroundColor $Cyan
    exit
}

# --- Check running browsers ---
$runningBrowsers = Get-Process -Name chrome, brave, msedge, firefox -ErrorAction SilentlyContinue
if ($runningBrowsers) {
    Write-Host ""
    Write-Host "[ERROR] Please close all browsers (Chrome, Brave, Edge, Firefox) before cleanup." -ForegroundColor $Red
    exit
}

Write-Host ""
Write-Host "[STARTING] Cleanup starting... please wait." -ForegroundColor $Green
Write-Host "-----------------------------------------------" -ForegroundColor $Gray
Start-Sleep -Seconds 1

# --- Step 1: Clear Temp Files ---
Write-Host "[1/5] Clearing system temp files..." -ForegroundColor $Cyan
Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 800

# --- Step 2: Clear Browser Cache ---
Write-Host "[2/5] Clearing browser cache..." -ForegroundColor $Cyan
$browserCaches = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Cache",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache"
)
foreach ($cache in $browserCaches) {
    if (Test-Path $cache) {
        Remove-Item -Path "$cache\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "   ✔ Cleared cache: $cache" -ForegroundColor $Green
    }
}

# Firefox cache
$firefoxProfiles = Get-ChildItem "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory -ErrorAction SilentlyContinue
foreach ($profile in $firefoxProfiles) {
    $cachePath = Join-Path $profile.FullName "cache2"
    if (Test-Path $cachePath) {
        Remove-Item -Path "$cachePath\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "   ✔ Cleared cache: $cachePath" -ForegroundColor $Green
    }
}
Start-Sleep -Milliseconds 800

# --- Step 3: Clear Browser History ---
Write-Host "[3/5] Clearing browser history..." -ForegroundColor $Cyan
$historyFiles = @(
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\History",
    "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\History",
    "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\History"
)
foreach ($file in $historyFiles) {
    if (Test-Path $file) {
        Remove-Item $file -Force -ErrorAction SilentlyContinue
        Write-Host "   ✔ Deleted history: $file" -ForegroundColor $Green
    }
}

# Firefox history
foreach ($profile in $firefoxProfiles) {
    $historyPath = Join-Path $profile.FullName "places.sqlite"
    if (Test-Path $historyPath) {
        Remove-Item $historyPath -Force -ErrorAction SilentlyContinue
        Write-Host "   ✔ Deleted Firefox history: $historyPath" -ForegroundColor $Green
    }
}
Start-Sleep -Milliseconds 800

# --- Step 4: Empty Recycle Bin ---
Write-Host "[4/5] Emptying Recycle Bin..." -ForegroundColor $Cyan
$shell = New-Object -ComObject Shell.Application
$recycleBin = $shell.Namespace(0xA)
foreach ($item in $recycleBin.Items()) {
    Remove-Item $item.Path -Recurse -Force -ErrorAction SilentlyContinue
}
Start-Sleep -Milliseconds 800

# --- Step 5: Clear Recent Files ---
Write-Host "[5/5] Clearing recent files..." -ForegroundColor $Cyan
Remove-Item -Path "$env:APPDATA\Microsoft\Windows\Recent\*" -Force -ErrorAction SilentlyContinue
Start-Sleep -Milliseconds 800

# --- Finish ---
Write-Host ""
Write-Host "[DONE] Cleanup complete! System is now clutter-free." -ForegroundColor $Green
Write-Host "===============================================" -ForegroundColor $Cyan
Write-Host "   System feels lighter and cleaner now :)" -ForegroundColor $Yellow
Write-Host "===============================================" -ForegroundColor $Cyan
