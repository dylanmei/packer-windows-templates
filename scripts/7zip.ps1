$Host.UI.RawUI.WindowTitle = "Setup 7zip"

#$url = "http://downloads.sourceforge.net/sevenzip/7z920-x64.msi"
$url = "http://tcpdiag.dl.sourceforge.net/project/sevenzip/7-Zip/9.20/7z920-x64.msi"

if (Test-Path "${env:ProgramFiles}\7-zip\7z.exe") {
  Write-Host "Already installed."
  exit 0
}

Write-Host "Downloading 7zip..."
(New-Object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\7zip.msi")

Write-Host "Installing 7zip..."
$p = Start-Process -Wait -PassThru -FilePath msiexec -ArgumentList "/i C:\Windows\Temp\7zip.msi /qb /l*v C:\Windows\Temp\7zip.log"

if ($p.ExitCode -ne 0) {
  throw "7-zip install failed. Log: C:\Windows\Temp\7zip.log"
}

Write-Host "Done."
Start-Sleep 2
