## create intunewin file
## make directory Intune in c:\papercut hive
## Make directory c:\Papercut-Hive
$DateString = (Get-Date).ToString('dd-MMM-yyyy') # Get the Current Date Formatted
$FolderPath = "c:\Papercut-Hive\$DateString"
$FolderPath1 = "c:\Papercut-Hive\$DateString\Intune"

# Check Folder Exists
If (Test-Path -Path $FolderPath) {
    #$Folder = Get-Item -Path $FolderPath
    #Write-Host "Folder already exists." -f Yellow
} Else {
    #Create a New Folder  
    $Folder = New-Item -ItemType Directory -Path $FolderPath
    $Folder = New-Item -ItemType Directory -Path $FolderPath1  
}

# Define paths
$inputFolder = $FolderPath1
$outputFolder = $FolderPath1
$setupFile = "PaperCut_Hive_Client_Install_v2.ps1"
$prepToolPath = "c:\Papercut-Hive\$DateString\Intune\IntuneWinAppUtil.exe"

# Log file
$logFile = "$outputFolder\packaging_log.txt"

# Ensure output folder exists
if (-not (Test-Path $outputFolder)) {
    New-Item -Path $outputFolder -ItemType Directory | Out-Null
}

# Validate input folder and setup file
if (-not (Test-Path "$inputFolder\$setupFile")) {
    Write-Host "ERROR: Setup file not found at $inputFolder\$setupFile"
    Add-Content -Path $logFile -Value "[$(Get-Date)] ERROR: Setup file not found."
    exit 1
}

# Run the packaging tool
try {
    Start-Process -FilePath $prepToolPath -ArgumentList @(
        "-c `"$inputFolder`"",
        "-s `"$setupFile`"",
        "-o `"$outputFolder`""
    ) -NoNewWindow -Wait

    Write-Host "Packaging completed successfully."
    Add-Content -Path $logFile -Value "[$(Get-Date)] Packaging completed successfully."
} catch {
    Write-Host "ERROR: Packaging failed. $_"
    Add-Content -Path $logFile -Value "[$(Get-Date)] ERROR: Packaging failed. $_"
    exit 1
}

# Verify output
$intunewinFile = Get-ChildItem -Path $outputFolder -Filter "*.intunewin" | Select-Object -First 1
if ($intunewinFile) {
    Write-Host "Output file: $($intunewinFile.FullName)"
    Add-Content -Path $logFile -Value "[$(Get-Date)] Output file: $($intunewinFile.FullName)"
} else {
    Write-Host "ERROR: No .intunewin file found in output folder."
    Add-Content -Path $logFile -Value "[$(Get-Date)] ERROR: No .intunewin file found."
}
