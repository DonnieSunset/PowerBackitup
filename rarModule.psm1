#v0.2

#call the command
# "-ep1" Exclude base directory from names
# "-m0" Set compression level (0-store...3-default...5-maximal)
# "-hp" Encrypt both file data and headers
# "-rr[N]" Add data recovery record
# "-v<size>[k,b]"  Create volumes with size=<size>*1000 [*1024, *1]
# "-rv[N]" Create recovery volumes

$rarExecLocation="C:\Program Files\WinRAR\rar.exe"

function ValidateFolderExists
{
	param(
		[string]$folder
	)

	if ((Test-Path $folder))
	{
		#Write-Host "Hello World"
	}
	else
	{
		Throw "Folder not found: <$folder>."
	}
}

function CleanFolderOfExistingArchives
{
	param(
		[string]$folder_in,
		[string]$prefix_in
	)

	ValidateFolderExists $folder_in
	
	Remove-Item "$folder_in\*$prefix_in*" -include *.rar,*.rev
}

function Secure2Plain($sec)
{
	return [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec))
}

function ReadPassword
{
	#read secure password
	$tmpPassword1 = Read-Host '   type in the password' -AsSecureString
	$tmpPassword2 = Read-Host 're-type in the password' -AsSecureString
	
	#transform to plain password
	$p1 = Secure2Plain($tmpPassword1)
	$p2 = Secure2Plain($tmpPassword2)
	
	#check if password is ok
	if ($p1 -ne $p2)
	{
		Write-Host "Passwords did not match. Exiting..."
		exit
	}

	return $p1
}

function RarSingleFolder
{
	param(
		#path where to store the result archives
		[string]$archiveDestinationFolder_in,
		#prefix for the archives, e.g. "sonstiges"
		[string]$archivePrefix_in,
		#the folder which shall be archived
		[string]$filesToAdd,
		#the maximum size of the volume, -1 or undef for unlimited volume
		[string]$volumeSize_in,
		#password of the archive
		[string]$password_in
	)

	#check directory existence
	ValidateFolderExists $archiveDestinationFolder_in
	ValidateFolderExists $filesToAdd

	#define the volume handling
	$volSizeParam = ""
	if ("", "-1" -NotContains $volumeSize_in) 
	{
		$volSizeParam = "-v$volumeSize_in"
	}
	
	#define archive destination location
	$destRarLocation = "$archiveDestinationFolder_in\$archivePrefix_in.rar"
	
	#delete existing archives
	CleanFolderOfExistingArchives $archiveDestinationFolder_in $archivePrefix_in
	
	#&$rarExecLocation a -ep1 -m0 "-hp$password_in" -rr $volSizeParam -rv $destRarLocation $filesToAdd 
	&$rarExecLocation a -ep1 -m0 "-hp$password_in" $destRarLocation $filesToAdd 
}

export-modulemember -function RarSingleFolder
export-modulemember -function ReadPassword
