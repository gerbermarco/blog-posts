# Login to Azure using the system-assigned Managed Identity
Connect-AzAccount -Identity | Out-null

# Retrieve an access token
$token = (Get-AzAccessToken).Token

# Decode the access token from Base64
$tokenPayload = $token.Split(".")[1].Replace('-', '+').Replace('_', '/')
$accessToken = ([System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($tokenPayload)) | ConvertFrom-Json)

Write-Output "Your Managed Identity object id is: $($accessToken.sub)"
