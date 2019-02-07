Import-Module AWSPowerShell.NetCore

$bucket = Get-CFNStack -StackName DetectLabelsPS | Select-Object -ExpandProperty Outputs | Select-Object -Property @{Name = 'BucketName'; Expression = {$_.OutputValue}}
$file = Read-Host -Prompt "Enter a file path to upload"
$bucket | Write-S3Object -File $file