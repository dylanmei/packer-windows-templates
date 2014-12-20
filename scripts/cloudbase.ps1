$Host.UI.RawUI.WindowTitle = "Downloading Cloudbase-Init..."

$url = "http://www.cloudbase.it/downloads/CloudbaseInitSetup_Beta_x64.msi"
(new-object System.Net.WebClient).DownloadFile($url, "C:\Windows\Temp\cloudbase-init.msi")

$Host.UI.RawUI.WindowTitle = "Installing Cloudbase-Init..."

$serialPortName = @(Get-WmiObject Win32_SerialPort)[0].DeviceId

$p = Start-Process -Wait -PassThru -FilePath msiexec -ArgumentList "/i C:\Windows\Temp\cloudbase-init.msi /qn /l*v C:\Windows\Temp\cloudbase-init.log LOGGINGSERIALPORTNAME=$serialPortName USERNAME=Administrator NETWORKADAPTERNAME=""Intel(R) PRO/1000 MT Network Connection"""
if ($p.ExitCode -ne 0) {
    throw "Installing Cloudbase-Init failed. Log: C:\Windows\Temp\cloudbase-init.log"
}

$Host.UI.RawUI.WindowTitle = "Running Cloudbase-Init SetSetupComplete..."
& "${env:ProgramFiles(x86)}\Cloudbase Solutions\Cloudbase-Init\bin\SetSetupComplete.cmd"

$Host.UI.RawUI.WindowTitle = "Running Sysprep..."
$unattendedXmlPath = "${env:ProgramFiles(x86)}\Cloudbase Solutions\Cloudbase-Init\conf\Unattend.xml"
& "${env:SystemRoot}\System32\Sysprep\Sysprep.exe" `/generalize `/oobe `/shutdown `/unattend:"$unattendedXmlPath"

