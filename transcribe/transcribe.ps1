Import-Module AWSPowerShell.NetCore

$podcastPath = "./transcribe/podcast.mp3"
$croppedPodcastPath = "./transcribe/cropped_podcast.mp3"
$resultsPath = "./transcribe/results.json"

foreach ($path in @($podcastPath, $croppedPodcastPath, $resultsPath)) {
    if (Test-Path $path) {
        Remove-Item $path
    }
}

# https://d3gih7jbfe3jlq.cloudfront.net/aws-podcast.rss
$podcasts = Invoke-RestMethod https://d3gih7jbfe3jlq.cloudfront.net/aws-podcast.rss | select -ExpandProperty enclosure | select -ExpandProperty url
Invoke-WebRequest -Uri $podcasts[0] -OutFile $podcastPath
ffmpeg -t 30 -i $podcastPath -acodec copy $croppedPodcastPath
Write-S3Object -BucketName livecoding -File $croppedPodcastPath

$bucket = 'livecoding'
$prefix = 'https://s3-us-west-2.amazonaws.com'
$s3uri = "$prefix/$bucket/cropped_podcast.mp3"
$jobName = "podcast-$(-join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_}))"

Write-Host "Creating job: $jobName"
Start-TRSTranscriptionJob -Media_MediaFileUri $s3uri -TranscriptionJobName $jobName -MediaFormat mp3 -LanguageCode en-US
$results = Get-TRSTranscriptionJob -TranscriptionJobName $jobName
 
while ($results.TranscriptionJobStatus -eq 'IN_PROGRESS') {
    Start-Sleep -Seconds 5
    $results = Get-TRSTranscriptionJob -TranscriptionJobName $jobName
}

if ($results.TranscriptionJobStatus -eq 'COMPLETED') {
    $transcripturi = $results.Transcript.TranscriptFileUri 
    Invoke-Webrequest -Uri $transcripturi -OutFile $resultsfile
}

if ($results.TranscriptionJobStatus -eq 'COMPLETED') {
    $transcripturi = $results.Transcript.TranscriptFileUri 
    Invoke-Webrequest -Uri $transcripturi -OutFile $resultsPath
}