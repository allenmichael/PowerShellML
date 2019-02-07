Import-Module AWSPowerShell.NetCore
Import-Module AWSLambdaPSCore

# New-AWSPowerShellLambda -Template DetectLabels 
New-AWSPowerShellLambdaPackage -ScriptPath ./rek/DetectLabels.ps1 -OutputPackage ./rek/DetectLabels.zip
Write-S3Object -BucketName amsxbg-ps1-eu -File ./rek/DetectLabels.zip 
try {
    New-CFNStack -StackName DetectLabelsPS -Capabilities @("CAPABILITY_IAM", "CAPABILITY_AUTO_EXPAND") -TemplateBody $(Get-Content ./rek/serverless.template.json | Out-String)
}
catch {
    $cfnError = $_ | Out-String
    if ($cfnError -and $cfnError.Contains("already exists")) {
        Write-Output "Updating stack..."
        Update-CFNStack -StackName DetectLabelsPS -Capabilities @("CAPABILITY_IAM", "CAPABILITY_AUTO_EXPAND") -TemplateBody $(Get-Content ./rek/serverless.template.json | Out-String)
    }
    else {
        throw $error
    }
}
Wait-CFNStack -StackName DetectLabelsPS
$bucket = Get-CFNStack -StackName DetectLabelsPS | Select-Object -ExpandProperty Outputs | Select-Object -Property @{Name = 'BucketName'; Expression = {$_.OutputValue}}
$bucket | Write-S3Object -File /Users/amsg/Documents/laser.jpg
$results = $bucket | Get-S3ObjectTagSet -Key laser.jpg

Write-Output $results