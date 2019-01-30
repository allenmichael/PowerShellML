Import-Module AWSPowerShell.NetCore
function Speak {
    param (
        [string]$Path,
        [string]$Text,
        [string]$Voice
    )
    $speech = Get-POLSpeech -Text $Text -VoiceId $Voice -OutputFormat mp3
    if (Test-Path $Path) {
        Remove-Item $Path
    }
    $fs = [System.IO.FileStream]::new($Path, [System.IO.FileMode]::CreateNew)
    $speech.AudioStream.CopyTo($fs)
    $fs.Close()
    afplay $Path
}

$path = './translate/greeting-en.mp3'
$text = Read-Host -Prompt "Speak: "
Speak -Path $path -Text $text -Voice "Amy"

$convertedPath = './translate/greeting-fr.mp3'
$convert = ConvertTo-TRNTargetLanguage -Text $text -SourceLanguageCode 'en' -TargetLanguageCode 'fr'
Speak -Path $convertedPath -Text $convert -Voice "Celine"
