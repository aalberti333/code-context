Add-Type -AssemblyName System.IO.Compression.FileSystem

Function Extract-ZipFile {
    param (
        [string]$zipFilePath,
        [string]$extractPath
    )
    
    $zipArchive = [System.IO.Compression.ZipFile]::OpenRead($zipFilePath)
    foreach ($entry in $zipArchive.Entries) {
        $completePath = Join-Path -Path $extractPath -ChildPath $entry.FullName
        $directoryPath = [System.IO.Path]::GetDirectoryName($completePath)
        
        # Ensure the directory exists
        if (!(Test-Path $directoryPath)) {
            New-Item -ItemType Directory -Path $directoryPath | Out-Null
        }
        
        # Extract and overwrite file
        $fileDestinationPath = [System.IO.Path]::Combine($extractPath, $entry.FullName)
        $fileStream = [System.IO.File]::Open($fileDestinationPath, [System.IO.FileMode]::Create)
        try {
            $entryStream = $entry.Open()
            $entryStream.CopyTo($fileStream)
        }
        finally {
            $fileStream.Dispose()
            $entryStream.Dispose()
        }
    }
    $zipArchive.Dispose()
}

$currentDirectory = "C:\path\to\zip" # Replace with your current directory path
$destinationPath = "C:\extract\destination" # Replace with your destination path
$zipFile = "file.zip" # Replace with your zip file name

Start-Job -ScriptBlock {
    Extract-ZipFile -zipFilePath "$using:currentDirectory\$using:zipFile" -extractPath "$using:destinationPath"
}
