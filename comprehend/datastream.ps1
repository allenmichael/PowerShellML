Import-Module AWSPowerShell.NetCore

$name = "RedditStream"
$shard = "shardId-000000000000"

function GetRecord {
    param(
        [string]$ShardId,
        [string]$ShardName
    )

    $it = Get-KINShardIterator -StreamName $name -ShardIteratorType TRIM_HORIZON -ShardId $shard -Region eu-west-2
    $data = Get-KINRecord -ShardIterator $it -Region eu-west-2
    $data | Format-List
    $in = $data | Select-Object -ExpandProperty Records | Select-Object -ExpandProperty Data
    $reader = New-Object System.IO.StreamReader($in); 
    $in.Position = 0;
    $payload = $reader.ReadToEnd()
}

Write-Output $payload 