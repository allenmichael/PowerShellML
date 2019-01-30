$results = Get-Content -Path './transcribe/results.json' | ConvertFrom-Json
$items = $results.results.items
Start-Process afplay -ArgumentList @('./transcribe/cropped_podcast.mp3') -NoNewWindow
$counter = 1
foreach ($item in $items) {
    if ($item.end_time -lt $counter) {
        if ($item.alternatives[0].content -eq '.') {
            write-host -NoNewline $item.alternatives[0].content
            Write-Host
        }
        else {
            write-host -NoNewline "$($item.alternatives[0].content) "
        }
    }
    else {
        $counter++
        Start-Sleep -Seconds 1
        if ($item.alternatives[0].content -eq '.') {
            write-host -NoNewline $item.alternatives[0].content
            Write-Host
        }
        else {
            write-host -NoNewline "$($item.alternatives[0].content) "
        }
    }
}