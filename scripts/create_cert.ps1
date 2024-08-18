param (
    [string]$Domain,
    [string]$Password
)

# Convert password to SecureString
$SecurePassword = ConvertTo-SecureString -String $Password -Force -AsPlainText

# Generate the self-signed certificate

$cert = New-SelfSignedCertificate -Type Custom -Subject "alt self signed" -KeyUsage DigitalSignature -FriendlyName "ALT self signed" -CertStoreLocation "Cert:\CurrentUser\My" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")
# Check if certificate was created successfully
if ($null -eq $cert) {
    Write-Host "Certificate creation failed."
    exit 1
}

# Verify the certificate store path
$certStorePath = "Cert:\LocalMachine\My\$($cert.Thumbprint)"
if (-not (Test-Path $certStorePath)) {
    Write-Host "Certificate path does not exist: $certStorePath"
    exit 1
}

# Define the path where the certificate will be saved
$certPath = "$env:USERPROFILE\Desktop\mycert.pfx"

# Export the certificate to a PFX file
try {
    Export-PfxCertificate `
        -Cert $certStorePath `
        -FilePath $certPath `
        -Password $SecurePassword
    Write-Host "Certificate generated and saved to $certPath"
} catch {
    Write-Host "Failed to export certificate: $_"
}
