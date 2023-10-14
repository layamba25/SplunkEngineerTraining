# Download the Splunk Enterprise installer
$installerUrl = "https://download.splunk.com/products/splunk/releases/8.2.2/windows/splunk-8.2.2-87344edfcdb4-x64-release.msi"
$installerPath = "$env:TEMP\splunk.msi"
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# Install Splunk Enterprise
$arguments = "/i `"$installerPath`" /quiet /l*v `"$env:TEMP\splunk_install.log`" /acceptlicense SPLUNK_START_ARGS=--accept-license SPLUNK_USERNAME=admin SPLUNK_PASSWORD=P@22W0Rd"
Start-Process -FilePath msiexec.exe -ArgumentList $arguments -Wait

# Start the Splunk Enterprise service
Start-Service -Name Splunkd

# Check if Splunkd service is running
$status = Get-Service -Name Splunkd | Select-Object -ExpandProperty Status

# Display the status of the Splunkd service
if ($status -eq "Running") {
    Write-Host "Splunk is running"
} else {
    Write-Host "Splunk is not running"
}
