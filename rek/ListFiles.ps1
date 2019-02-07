Import-Module AWSPowerShell.NetCore

$bucket = Get-CFNStack -StackName DetectLabelsPS | Select-Object -ExpandProperty Outputs | Select-Object -Property @{Name = 'BucketName'; Expression = {$_.OutputValue}}
$files = $bucket | Get-S3Object 

foreach ($file in $files) {
    Write-Output $file.Key
}