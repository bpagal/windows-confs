$folderPath = "$env:USERPROFILE\Documents\AutoHotkey scripts"

if (!(Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Path $folderPath
    Write-Host "Created folder: $folderPath" -ForegroundColor Green
} else {
    Write-Host "Folder already exists: $folderPath" -ForegroundColor Yellow
}

# Copy all .ahk files from current directory to the folder
$ahkFiles = Get-ChildItem -Path . -Filter *.ahk

if ($ahkFiles.Count -gt 0) {
    Copy-Item -Path *.ahk -Destination $folderPath -Force
    Write-Host "Copied $($ahkFiles.Count) .ahk file(s) to $folderPath" -ForegroundColor Green
} else {
    Write-Host "No .ahk files found in current directory" -ForegroundColor Yellow
}

timeout /t 5