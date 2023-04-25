$ErrorActionPreference = "Stop"

$sourceFolder = "..\simcity4-backup"
$files = Get-ChildItem $sourceFolder

foreach ($file in $files) {
    Write-Host "Migrating $($file.BaseName)"

    MigrateRegions
}

function MigrateRegions() {
    $destinationFolder = ".\Regions"

    if (Test-Path $destinationFolder) {
        Remove-Item $destinationFolder -Recurse
    }

    New-Item $destinationFolder -ItemType Directory

    $copied = Copy-Item $file.FullName -Destination $destinationFolder -PassThru

    Expand-Archive $copied.FullName -DestinationPath $destinationFolder

    Remove-Item $copied.FullName

    $status = Invoke-Expression "git status --porcelain"

    if ($status) {
        Invoke-Expression "git add ."
        Invoke-Expression "git commit -m `"chore: $($file.BaseName)`""
    }
    else {
        Write-Host "No changes detected for $($file.BaseName)"
    }
}
