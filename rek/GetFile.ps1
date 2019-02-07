Import-Module AWSPowerShell.NetCore

$bucket = Get-CFNStack -StackName DetectLabelsPS | Select-Object -ExpandProperty Outputs | Select-Object -Property @{Name = 'BucketName'; Expression = {$_.OutputValue}}
$file = Read-Host -Prompt "Enter a file name"
$results = $bucket | Get-S3ObjectTagSet -Key $file
Write-Output $results