Import-Module AWSPowerShell.NetCore

$main = Invoke-RestMethod -Uri https://www.reddit.com/r/aws/.json  
$comments = Invoke-RestMethod -Uri "$($main.data.children[0].data.url)/.json"
$firstComment = $comments.data.children[1].data.body 
Write-Host $firstComment
$lang = Find-COMPDominantLanguage -Text $firstComment 
$lang | Format-Table
Find-COMPKeyPhrase -Text $firstComment -LanguageCode $lang.LanguageCode | Format-Table
Find-COMPEntity -Text $firstComment -LanguageCode $lang.LanguageCode | Format-Table
Find-COMPSentiment -Text $firstComment -LanguageCode $lang.LanguageCode | Format-Table

$syntax = Find-COMPSyntax -Text $firstComment -LanguageCode $lang.LanguageCode
$syntax | ForEach-Object { Write-Host "$($_.Text) - $($_.PartOfSpeech.Tag) - $($_.PartOfSpeech.Score)" }

Write-Host "-----------"
Write-Host "NOUNS Only:"
$syntax | Where-Object { $_.PartOfSpeech.Tag -eq "PROPN" } | ForEach-Object { Write-Host $_.Text }