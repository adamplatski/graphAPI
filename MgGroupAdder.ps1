$RequiredScopes = @("GroupMember.ReadWrite.All", "Device.Read.All")
Connect-MgGraph -Scopes $RequiredScopes

$csvFilePath = "C:\Users\adam.plater\Downloads\GroupImportMembersTemplate.csv"
$appToUpdate = "AppRemedy-Bitwarden 2023.3.2.0"
$mailNickName = "AppRemedy-Bitwarden 2023.3.2.0"
#New-MgGroup -DisplayName $appToUpdate -MailEnabled:$False -MailNickname $mailNickName -SecurityEnabled
$group = Get-MgGroup -All | Where-Object {$_.displayName -like $appToUpdate}
$groupID = $group.Id

$devices1 = Get-MgDevice -All | Select-Object Id,DeviceID,displayName #Get-MgDeviceManagementManagedDevice -All | Select-Object "UserPrincipalName", "DeviceName"
$devices2 = Import-Csv -Path $csvFilePath | Select-Object -ExpandProperty DeviceId | Select-Object -Skip 2 -First 147 | ForEach-Object {
    [PSCustomObject]@{
        DeviceId = $_
    }
}
$devices3 = $devices1 | Where-Object { $devices2 -contains $_.DeviceId } | Select-Object DeviceName, UserPrincipalName, objectId
$userlist = $devices3 | Where-Object { $_.UserPrincipalName -like "*@hut8.io" }
$userlistUPN = $userlist.UserPrincipalName 
$refinedlist = $userlistUPN | Select-Object -Unique


$userIds = foreach ($userz in $refinedlist){
    Get-MgUser -UserId $userz
}

foreach ($id in $devices1.id) {
    #$userId.Id
    New-MgGroupMember -GroupId $groupID -DirectoryObjectId $id
}

$devices2 = Import-Csv -Path $csvFilePath |  Select-Object -ExpandProperty DeviceId | Select-Object -Skip 2 -First 147 | ForEach-Object {
    [PSCustomObject]@{
        DeviceId = $_.DeviceId
    }
}

