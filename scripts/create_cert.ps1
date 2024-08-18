param (
    [string]$Domain,
    [string]$Password
)

# Convert password to SecureString
$SecurePassword = ConvertTo-SecureString -String $Password -Force -AsPlainText

$cert = New-SelfSignedCertificate `
    -CertStoreLocation Cert:\CurrentUser\My `
    -DnsName $Domain `
    -FriendlyName "My Self-Signed Certificate" `


# Verify the certificate store path
$certStorePath = "Cert:\CurrentUser\My\$($cert.Thumbprint)"
if (-not (Test-Path $certStorePath)) {
    Write-Host "Certificate path does not exist: $certStorePath"
    exit 1
}

# Define the path where the certificate will be saved
$certPath = "mycert.pfx"

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
