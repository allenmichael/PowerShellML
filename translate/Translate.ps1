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

$path = './translate/aml-fr.mp3'
$quote = "Le temps n'a rien changé. Amélie continue à se réfugier dans la solitude. Elle prend plaisir à se poser des questions idiotes sur le monde ou sur cette ville qui s'étend là sous ses yeux."
Speak -Path $path -Text $quote -Voice "Mathieu"

$convertedPath = './translate/aml-en.mp3'
$convert = ConvertTo-TRNTargetLanguage -Text $quote -SourceLanguageCode 'fr' -TargetLanguageCode 'en'
Speak -Path $convertedPath -Text $convert -Voice "Brian"
