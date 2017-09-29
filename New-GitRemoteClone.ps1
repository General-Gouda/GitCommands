function New-GitRemoteClone
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory=$true)]
		$RepositoryUrl,

		[parameter(Mandatory=$true)]
		$Destination,

		[parameter(Mandatory=$false)]
		[switch]$NewDirectory,

		[parameter(Mandatory=$false)]
		[string]$DesiredBranch
	)
	
	if (Test-Path $Destination)
	{
		if ((git ls-remote $RepositoryUrl) -notmatch 'fatal')
		{
			if ($NewDirectory)
			{
				Push-Location $Destination
				git clone $RepositoryUrl
			}
			else
			{
				Push-Location $Destination
				git clone $RepositoryUrl $Destination
			}

			if ([string]::IsNullOrEmpty($DesiredBranch) -eq $false)
			{
				git checkout $DesiredBranch
			}
		}
		else
		{
			Write-Error "Remote repository not found!"
		}
	}
	else
	{
		Write-Error "Folder location $Destination not found!"
	}
}
