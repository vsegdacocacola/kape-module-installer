$urls = @(
	'https://www.tzworks.net/prototypes/builds/2020.01.16.win64.zip',
	'https://www.nirsoft.net/utils/browsinghistoryview-x64.zip',
	'https://github.com/obsidianforensics/hindsight/releases/download/v2.4.0/hindsight.exe',
	'https://www.nirsoft.net/utils/fulleventlogview-x64.zip',
	'https://download.microsoft.com/download/f/f/1/ff1819f9-f702-48a5-bbc7-c9656bc74de8/LogParser.msi',
#	'https://github.com/gentilkiwi/mimikatz/releases/download/2.2.0-20200308/mimikatz_trunk.zip',
	'https://download.sysinternals.com/files/SysinternalsSuite.zip',
	'https://github.com/Velocidex/c-aff4/releases/download/3.2/winpmem_3.2.exe',
	'https://download.sysinternals.com/files/Autoruns.zip',
	'https://raw.githubusercontent.com/forensenellanebbia/powershell-scripts/master/Get-DoSvcExternalIP.ps1',
	'https://gist.githubusercontent.com/jaredcatkinson/23905d34537ce4b5b1818c3e6405c1d2/raw/104f630cc1dda91d4cb81cf32ef0d67ccd3e0735/Get-InjectedThread.ps1',
	'https://raw.githubusercontent.com/IllusiveNetworks-Labs/Get-NetworkConnection/master/Get-NetworkConnection.ps1',
	'https://download.sysinternals.com/files/Handle.zip',
	'https://github.com/jfarley248/iTunes_Backup_Reader/releases/download/v3.1/iTunes_Backup_Reader_v3.1.exe',
	'https://github.com/Beercow/SEPparser/archive/v1.2.zip',
	'https://www.rlvision.com/files/Snap2HTML.zip', 
	'https://github.com/MarkBaggett/srum-dump/raw/python3/srum_dump_csv.exe',
	'https://sqlite.org/2019/sqlite-tools-win32-x86-3270200.zip',
	'https://github.com/thumbcacheviewer/thumbcacheviewer/releases/download/v1.0.1.7/thumbcache_viewer_cmd.zip',
	'https://www.cert.at/media/files/downloads/software/densityscout/files/densityscout_build_45_windows.zip',
	'https://www.sno.phy.queensu.ca/~phil/exiftool/exiftool-11.43.zip', 
	'https://github.com/esecrpm/WMI_Forensics/raw/master/CCM_RUA_Finder.exe',
	'https://github.com/keydet89/RegRipper2.8/archive/master.zip' 
	'https://github.com/keydet89/Tools/archive/master.zip',
	'https://raw.githubusercontent.com/thimbleweed/All-In-USB/master/utilities/DumpIt/DumpIt.exe'
)

$modulesFolder = 'Modules\bin'

$oldProgressPreference = $global:progressPreference
$global:progressPreference = 'silentlyContinue'  

foreach ($url in $urls) {

	$filename = $url -replace '.*\/([^\/]+)$','$1'  

	Write-Host "Downloading $url to $filename"

	Invoke-WebRequest -Uri $url -OutFile "$modulesFolder\$filename"
	if($filename -match '\.zip$') {
		Write-Host "Expanding zip archive $filename"
		Expand-Archive -LiteralPath "$modulesFolder\$filename" -DestinationPath "$modulesFolder\tmp" -Force
		if ($url -match 'RegRipper') {
			mv "$modulesFolder\tmp\RegRipper2.8-master" "$modulesFolder\regripper" -Force
		} elseif ($url -match 'keydet89/Tools') {
			mv "$modulesFolder\tmp\Tools-master\exe" "$modulesFolder\tln_tools" -Force
		} elseif ($url -match 'Snap2HTML') {
			mv "$modulesFolder\tmp\Snap2HTML" $modulesFolder -Force
		} elseif ($url -match 'SEPparser') {
			mv "$modulesFolder\tmp\SEPparser-1.2\bin\*" $modulesFolder -Force
		} elseif ($url -match 'sqlite-tools') {
			mv "$modulesFolder\tmp\sqlite-tools-win32-x86-3270200\*" $modulesFolder -Force
		} elseif ($url -match 'densityscout') {
			mv "$modulesFolder\tmp\win64\*" $modulesFolder -Force
		} elseif ($url -match 'exiftool') {
			mv "$modulesFolder\tmp\exiftool(-k).exe" "$modulesFolder\exiftool.exe" -Force
		} elseif ($url -match 'iTunes_Backup_Reader') {
			mv "$modulesFolder\tmp\iTunes_Backup_Reader_v3.1.exe" "$modulesFolder\iTunes_Backup_Reader.exe" -Force
		} elseif ($url -match 'tzworks') {
			mv "$modulesFolder\tmp\2020.01.16.win64\bin\*" $modulesFolder -Force
		} else {
			mv "$modulesFolder\tmp\*" $modulesFolder -Force
		}
		rmdir "$modulesFolder\tmp" -Force -Recurse
		rm $modulesFolder\$filename
	} elseif ($filename -match '\.msi$') {
		msiexec /i $filename
	}
}

$progressPreference = $oldProgressPreference