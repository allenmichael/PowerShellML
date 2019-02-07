Import-Module AWSPowerShell.NetCore

$bucket = Get-CFNStack -StackName DetectLabelsPS | Select-Object -ExpandProperty Outputs | Select-Object -Property @{Name = 'BucketName'; Expression = {$_.OutputValue}}
$bucket | Get-S3Object | Remove-S3Object -Force
Remove-CFNStack -StackName DetectLabelsPS 