  Write-Host "Initializing and formatting raw disks"

  $disks = Get-Disk | where partitionstyle -eq 'raw'

  ## start at F: because D: is reserved in Azure and sometimes E: shows up as a CD drive in Azure
  $letters = New-Object System.Collections.ArrayList
  $letters.AddRange( ('F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z') )

  Function AvailableVolumes() {
      $currentDrives = get-volume
      ForEach ($v in $currentDrives) {
          if ($letters -contains $v.DriveLetter.ToString()) {
              Write-Host "Drive letter $($v.DriveLetter) is taken, moving to next letter"
              $letters.Remove($v.DriveLetter.ToString())
          }
      }
  }

  ForEach ($d in $disks) {
      AvailableVolumes
      $driveLetter = $letters[0]
      Write-Host "Creating volume $($driveLetter)"
      $d | Initialize-Disk -PartitionStyle GPT -PassThru | New-Partition -DriveLetter $driveLetter  -UseMaximumSize
      # Prevent error ' Cannot perform the requested operation while the drive is read only'
      Start-Sleep 1
      Format-Volume  -FileSystem NTFS -NewFileSystemLabel "datadisk" -DriveLetter $driveLetter -Confirm:$false
  }
