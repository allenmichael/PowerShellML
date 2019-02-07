Import-Module AWSPowerShell.NetCore

$fileOrHost = Read-Host "Read from terminal[1] or file[2] (1 or 2)?"
if ("1", "2" -notcontains $fileOrHost ) {
    $fileOrHost = "1"
}

$text = ""
if ($fileOrHost -eq "1") {
    $text = Read-Host "Enter text to be redacted."
}

$lang = Find-COMPDominantLanguage -Text $text 
$syntax = Find-COMPSyntax -Text $text -LanguageCode $lang.LanguageCode
$words = $syntax | 
    Where-Object { 
    $_.PartOfSpeech.Tag -eq "PROPN" -or 
    $_.PartOfSpeech.Tag -eq "NOUN" 
}  
# -or $_.PartOfSpeech.Tag -eq "PRON" 
foreach ($word in $words) {
    $chars = ($word.EndOffset - $word.BeginOffset)
    $text = $text.Remove($word.BeginOffset, $chars)
    $filler = "x" * $chars
    $text = $text.Insert($word.BeginOffset, $filler)
}

Write-Host $text


