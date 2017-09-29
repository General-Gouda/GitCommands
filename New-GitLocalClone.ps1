function New-GitLocalClone
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory=$true)]
		$RepoToCloneLocation,

		[parameter(Mandatory=$true)]
		$Destination,

		[parameter(Mandatory=$false)]
		[switch]$NewDirectory,

		[parameter(Mandatory=$false)]
		[string]$DesiredBranch
	)
	
	if (Test-Path $Destination)
	{
		if (Test-Path $RepoToCloneLocation)
		{
			Push-Location $RepoToCloneLocation

			if ((git status) -notmatch "fatal")
			{
				if ($NewDirectory)
				{
					Push-Location $Destination
					git clone $RepoToCloneLocation
				}
				else
				{
					Push-Location $Destination
					git clone $RepoToCloneLocation $Destination
				}

				if ([string]::IsNullOrEmpty($DesiredBranch) -eq $false)
				{
					git checkout $DesiredBranch
				}
			}
			else
			{
				$continue = 0

				do
				{
					$query = Read-Host "Git repo not found at $RepoToCloneLocation`nInitialize new git repo here? [Y/N]"

					if ($query.ToUpper() -eq "Y")
					{
						New-GitInit
						Push-Location $Destination
						git clone $RepoToCloneLocation

						if ([string]::IsNullOrEmpty($DesiredBranch) -eq $false)
						{
							git checkout $DesiredBranch
						}
						$continue = 1
					}
					elseif ($query.ToUpper() -eq "N")
					{
						Write-Warning "No new git repo created. Stopping script."
						$continue = 1
					}
					else
					{
						Write-Output "Invalid input."
					}
				} while ($continue -eq 0)

			}
		}
		else
		{
			Write-Error "Folder location $RepoToCloneLocation not found!"
		}
	}
	else
	{
		Write-Error "Folder location $Destination not found!"
	}
}
