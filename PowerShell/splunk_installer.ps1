# # Download the Splunk Enterprise installer
# $installerUrl = "https://download.splunk.com/products/splunk/releases/8.2.2/windows/splunk-8.2.2-87344edfcdb4-x64-release.msi"
# $installerPath = "$env:TEMP\splunk.msi"
# Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

# # Install Splunk Enterprise
# $arguments = "/i `"$installerPath`" /quiet /l*v `"$env:TEMP\splunk_install.log`" /acceptlicense SPLUNK_START_ARGS=--accept-license SPLUNK_USERNAME=admin SPLUNK_PASSWORD=P@22W0Rd"
# Start-Process -FilePath msiexec.exe -ArgumentList $arguments -Wait

# # Start the Splunk Enterprise service
# Start-Service -Name Splunkd

# Define URL
$url = "https://download.splunk.com/products/splunk/releases/8.2.2/windows/splunk-8.2.2-87344edfcdb4-x64-release.msi"

# Determine destination path in the Temp directory
$destinationPath = Join-Path $env:TEMP "splunk-8.2.2-87344edfcdb4-x64-release.msi"

# Download the MSI file
Invoke-WebRequest -Uri $url -OutFile $destinationPath

# Determine installation directory based on system architecture
if ([Environment]::Is64BitOperatingSystem) {
    $installDir = "C:\Program Files\Splunk"
} else {
    $installDir = "C:\Program Files (x86)\Splunk"
}

# Define installation parameters
$params = @{
    LAUNCHSPLUNK = "0"         # Don't launch Splunk after installation
    AGREETOLICENSE = "Yes"     # Agree to the license terms
    INSTALLDIR = $installDir   # Installation directory determined above
}

# Convert the parameters to a string format suitable for msiexec
$paramString = ($params.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join ' '

# Execute the silent installation
Start-Process -Wait -FilePath "msiexec.exe" -ArgumentList "/i `"$destinationPath`" $paramString /quiet"

# Check if Splunk was installed successfully
if (Test-Path "$installDir\bin\splunk.exe") {
    Write-Host "Splunk Enterprise installed successfully!"
} else {
    Write-Host "There was an issue installing Splunk Enterprise."
}


# Check if Splunkd service is running
$status = Get-Service -Name Splunkd | Select-Object -ExpandProperty Status

# Display the status of the Splunkd service
if ($status -eq "Running") {
    Write-Host "Splunk is running"
} else {
    Write-Host "Splunk is not running"
}
