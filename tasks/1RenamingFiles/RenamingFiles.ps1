# --- adjust path as necessary ---
$LabsDir = 'C:\Bash'
Set-Location $LabsDir

Get-ChildItem -Filter '*_Lab*' | ForEach-Object {
    $NewName = $_.Name -replace '.*?_Lab', 'Lab'   # non-greedy “.*?” up to first “_Lab”
    if ($_.Name -ne $NewName) {
        Rename-Item -LiteralPath $_.FullName -NewName $NewName
        Write-Host "✅ $($_.Name) → $NewName"
    }
}


