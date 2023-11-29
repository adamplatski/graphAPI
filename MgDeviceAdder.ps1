$groups = Invoke-MgGraphRequest -Uri 'https://graph.microsoft.com/v1.0/groups?$top=500'
$wtf = $groups.value
$groupID = "0000000-0000-0000-0000-000000000"
#Get-MgGroup -GroupId $groupID
$userObjectId = "0000000-0000-0000-0000-000000000"
$uri = "https://graph.microsoft.com/v1.0/groups/$groupID/members/$ref"
$body = @{
    "@odata.id" = "https://graph.microsoft.com/v1.0/devices/$userObjectId"
} 

$groupMember = Invoke-MgGraphRequest -Uri $uri -Method POST -Body $body
$groupMember

#-------------------------------------------------------------------------------------------------------------

$client_id = "0000000-0000-0000-0000-000000000"
$tenantId = "0000000-0000-0000-0000-000000000"
$client_secret = "0000000-0000-0000-0000-000000000"
$group_id = "0000000-0000-0000-0000-000000000"
$device_id = "0000000-0000-0000-0000-000000000"

$tokenEndpoint = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
$scope = "https://graph.microsoft.com/.default"

$body = @{
    client_id     = $client_id  
    client_secret = $client_secret
    scope         = $scope
    grant_type    = "client_credentials"
}

$response = Invoke-RestMethod -Method Post -Uri $tokenEndpoint -Body $body
$accessToken = $response.access_token
$uri = "https://graph.microsoft.com/v1.0/groups/$group_id/members/$ref"
$body = @{
    "@odata.id" = "https://graph.microsoft.com/v1.0/devices/$device_id"
} 

$response = Invoke-RestMethod -Uri $uri -Headers @{Authorization = "Bearer $accessToken"} -Method POST -Body ($body | ConvertTo-Json) -ContentType "application/json"
$response