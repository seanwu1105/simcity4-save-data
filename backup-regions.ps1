$ErrorActionPreference = "Stop"

Write-Host "Backing up SimCity 4 regions"

Set-Location $PSScriptRoot

Invoke-Expression "git fetch --all"
Invoke-Expression "git reset --hard origin/master"

$destinationFolder = ".\Regions"

if (Test-Path $destinationFolder) {
    Remove-Item $destinationFolder -Recurse
}

$sourceFolder = [Environment]::GetFolderPath("MyDocuments") + "\SimCity 4\Regions"

Copy-Item $sourceFolder -Destination $PSScriptRoot -Recurse

$status = Invoke-Expression "git status --porcelain"

if ($status) {
    Invoke-Expression "git add ."

    $datetime = Get-Date
    Invoke-Expression "git commit -m `"chore: $($datetime.ToString("yyyy-mm-dd_hh-mm-ss"))`""
    Invoke-Expression "git push origin master"
}
else {
    Write-Host "No changes detected"
}