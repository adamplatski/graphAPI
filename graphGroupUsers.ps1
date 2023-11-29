Connect-MicrosofTeams
Connect-MgGraph
$finance = "0000000-0000-0000-0000-000000000"
$PEOC = "0000000-0000-0000-0000-000000000"
$NOC = "0000000-0000-0000-0000-000000000"
$groupId = $NOC

$members = Get-MgGroupMember -GroupId $groupId

$userArray = @()

foreach ($member in $members)
{
    if ($member['@odata.type'] -eq "#microsoft.graph.user")
    {
        $user = Get-MgUser -UserId $member.Id
	Write-Host "User ID: " $member.Id "User Name: " $user.DisplayName

        $userObj = New-Object PSObject -Property @{
            UserID = $member.Id
            UserName = $user.DisplayName
        }
        $userArray += $userObj
    }
}

# Print the userArray to check the output
$userArray | Format-Table -AutoSize