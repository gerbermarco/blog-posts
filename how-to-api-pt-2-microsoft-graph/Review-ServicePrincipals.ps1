# Variables
$tenantName = "Your tenant name or id"
$daysBack = "-30"
$teamsWebhookUri = "Your Teams webhook URL"
$graphApiVersion = "v1.0"
$graphApiEndpoint = "https://graph.microsoft.com/$($graphApiVersion)"

# Login to Azure
az login --tenant $tenantName

# Obtain access token from the authenticated Azure CLI session and define request headers
$graphAccessToken = (az account get-access-token --resource=https://graph.microsoft.com | ConvertFrom-Json).accessToken
$requestHeaders = @{
    "Authorization" = "Bearer $($graphAccessToken)"
}

# Function to create the payload and invoke the webhook itself
function Send-Webhook {
    param (
        [string]$createdDateTime,
        [string]$displayName,
        [string]$objectId
    )
    
    # JSON payload representing the Teams Adaptive Card content
    $payloadJson = @"
{
    "@type": "MessageCard",
    "@context": "http://schema.org/extensions",
    "themeColor": "0076D7",
    "summary": "Review - New service principal found",
    "sections": [{
        "activityTitle": "REVIEW - New service principal found: $($displayName)",
        "activitySubtitle": "Tenant: $($tenantName)",
        "facts": [{
            "name": "Service principal name",
            "value": "$($displayName)"
        }, {
            "name": "Service principal object id",
            "value": "$($objectId)"
        }, {
            "name": "Creation datetime",
            "value": "$($createdDateTime)"
        }],
        "markdown": true
    }],
    "potentialAction": [{
        "@type": "OpenUri",
        "name": "Open in Azure Portal",
        "targets": [{
            "os": "default",
            "uri": "https://portal.azure.com/#view/Microsoft_AAD_IAM/ManagedAppMenuBlade/~/Overview/objectId/$($sp.id)/appId/$($sp.appId)/preferredSingleSignOnMode~/null"
        }]
    }]
}
"@

    # Create Teams Adaptive Card using a post request
    Invoke-RestMethod -Method Post -ContentType 'Application/Json' -Body $payloadJson -Uri $teamsWebhookUri
}

# Get service principals with a creation date older than 30 days
$utcDateTime = (Get-Date).AddDays($daysBack) | Get-Date -Format yyyy-MM-ddTHH:mm:ssZ 
$servicePrincipals = (Invoke-RestMethod -Method Get -Headers $requestHeaders -Uri "$($graphApiEndpoint)/servicePrincipals?`$filter=createdDateTime ge $utcDateTime").value

# Invoke Teams webhooks with custom data
foreach ($sp in $servicePrincipals) {
    Send-Webhook -displayName $sp.displayName -objectId $sp.id -createdDateTime $sp.createdDateTime
}