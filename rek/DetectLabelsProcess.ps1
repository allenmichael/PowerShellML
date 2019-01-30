New-AWSPowerShellLambda -Template DetectLabels 
New-AWSPowerShellLambdaPackage -ScriptPath ./DetectLabels.ps1 -OutputPackage DetectLabels.zip
Write-S3Object -BucketName ng.amsxbg -File ./DetectLabels.zip 
New-CFNStack -StackName DetectLabelsPS -Capabilities @("CAPABILITY_IAM","CAPABILITY_AUTO_EXPAND") -TemplateBody $(Get-Content ./serverless.template.json | Out-String)
Wait-CFNStack -StackName DetectLabelPS
Get-CFNStack -StackName DetectLabelsPS | Select-Object -ExpandProperty Outputs | Select-Object -Property @{Name='BucketName'; Expression={$_.OutputValue}} | Write-S3Object -File /Users/amsg/Documents/laser.jpg
Get-CFNStack -StackName DetectLabelsPS | Select-Object -ExpandProperty Outputs | Select-Object -Property @{Name='BucketName'; Expression={$_.OutputValue}} | Get-S3ObjectTagSet -Key laser.jpg
Remove-CFNStack -StackName DetectLabelsPS 