# Organize-Media-by-Meta-Data.ps1

# find the powershell exectable installed by homebrew:
# for some reason homebrew didn't add the sym link from /opt/homebrew/bin/pwsh to the actuall install location
# each time homebrew updates powershell, vscode exe path setting will need to be updated.
# Leave the vscode powershell exe empty, and put the path as an additional exe
# whereis pwsh
# /opt/homebrew/Cellar/powershell/7.5.0/libexec/pwsh


#Export-ModuleMember -Function Get-FileMetadata

#$ChildItems = get-childitem -Path "~/Downloads"

$StartFolder = '~/Downloads'

Clear-Host
$ImagePath = "~/Downloads/IMG_0533.jpg"

[string]$imageProperties = exiftool -j $ImagePath
$ImagePropertiesJson = ConvertFrom-Json $imageProperties

#$ImagePropertiesJson.GetType()
#Write-Host `$ImagePropertiesJson.ImageHeight $ImagePropertiesJson.ImageHeight
#$imageProperties | Format-List

<#
$imagePropertiesJson.CreateDate
$imagePropertiesJson.CameraModelName
$imagePropertiesJson.FileTypeExtension
$imagePropertiesJson.Make
$imagePropertiesJson.HostComputer
#>

$year = $imagePropertiesJson.CreateDate.Substring(0,4)
#Write-Host `$year $year
$month = $imagePropertiesJson.CreateDate.Substring(5,2)
#Write-Host `$month $month
$day = $imagePropertiesJson.CreateDate.Substring(8,2)
#Write-Host `$day $day

$hour = $imagePropertiesJson.CreateDate.Substring(11,2)
#Write-Host `$hour $hour
$min = $imagePropertiesJson.CreateDate.Substring(14,2)
#Write-Host `$min $min
$sec = $imagePropertiesJson.CreateDate.Substring(17,2)
#Write-Host `$sec $sec

$MonthFolder = $year + '-' + $month + '-' + $day

Write-Host `$MonthFolder $MonthFolder

$NewFileName = $year + '-' + $month + '-' + $day + '_' + $hour + '-' + $min + '-' + $sec
$NewFileName = $NewFileName + '_' + $($imagePropertiesJson.Make).Replace(' ','-')
$NewFileName = $NewFileName + '_' + $($imagePropertiesJson.HostComputer).Replace(' ','-')
$NewFileName = $NewFileName + '.' + $imagePropertiesJson.FileTypeExtension
Write-Host `$NewFileName: $NewFileName
$DestinationFile = $DestinationFolderPath + '/' + $NewFileName

$YearFolderPath = $StartFolder + '/' + $year
# Create the year folder
if ( !$(Test-Path $YearFolderPath) ) {
    Write-Host "Create the parent folder:" $YearFolderPath
    New-Item -ItemType Directory -Path $YearFolderPath
}

# Create the Day Folder
$DestinationFolderPath = $YearFolderPath + '/' + $MonthFolder
if ( !$(Test-Path $DestinationFolderPath) ) {
    Write-Host "Create the day folder:" $DestinationFolderPath 
    New-Item -ItemType Directory -Path $DestinationFolderPath 
}

Write-Host "Copy the file to:" $DestinationFile
Copy-Item -Path $ImagePath -Destination $DestinationFile