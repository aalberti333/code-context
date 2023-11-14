Add-Type -AssemblyName System.IO.Compression.FileSystem

$currentDirectory = "C:\path\to\zip" # Replace with your current directory path
$zipFile = "$currentDirectory\file.zip" # Replace with your zip file name
$destinationPath = "C:\extract\destination" # Replace with your destination path

$tempPath = [System.IO.Path]::GetTempFileName()
Remove-Item $tempPath # Remove the temporary file
New-Item -ItemType Directory -Path $tempPath | Out-Null # Create a temporary directory

Start-Job -ScriptBlock {
    try {
        # Extract to temporary directory
        [System.IO.Compression.ZipFile]::ExtractToDirectory($using:zipFile, $using:tempPath)

        # Replace the contents of the destination path with the temp directory contents
        Remove-Item -Path "$using:destinationPath\*" -Recurse -Force -ErrorAction SilentlyContinue
        Move-Item -Path "$using:tempPath\*" -Destination $using:destinationPath

    } catch {
        Write-Error "An error occurred: $_"
    } finally {
        # Cleanup: Delete the temporary directory
        Remove-Item -Path $using:tempPath -Recurse -Force
    }
}

# Optionally, wait for the job to finish and output any result
# Get-Job | Wait-Job | Receive-Job
