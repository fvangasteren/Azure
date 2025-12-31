

# Initialize variables
$azureAdJoined = $false
$upn = "Unknown or not a domain user"

# Try to get the UPN
try {
    $upn = cmd /c "whoami /upn" 2>$null
} catch {
    Write-Host "Warning: Unable to retrieve UPN. User might not be domain joined."
}

# Run dsregcmd and capture the output
$dsregOutput = dsregcmd.exe /status
$lines = $dsregOutput -split "`r`n"

# Parse AzureAdJoined status
foreach ($line in $lines) {
    if ($line -match "^\s*AzureAdJoined\s*:\s*(\w+)\s*$") {
        $azureAdJoined = $matches[1] -eq "YES"
        break
    }
}

# Output results
Write-Host "Logged-in UPN: $upn"
Write-Host "Azure AD Joined: $azureAdJoined"

# Conditional logic
if ($azureAdJoined) {
    Write-Host "Device is Azure AD Joined. Proceeding with Azure-specific tasks..."
} else {
    Write-Host "Device is NOT Azure AD Joined. Skipping Azure-specific tasks..."
}
