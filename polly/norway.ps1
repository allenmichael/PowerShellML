Import-Module AWSPowerShell.NetCore

$path = './polly/polly.mp3'
$text = "Trond sa, gode grunner til at AWS kan brukes til mye og innblikk i et vell av nyheter"
$speech = Get-POLSpeech -VoiceId Liv -Text $text -OutputFormat mp3
if (Test-Path $path) {
    Remove-Item $path
}
$fs = [System.IO.FileStream]::new($path, [System.IO.FileMode]::CreateNew)
$speech.AudioStream.CopyTo($fs)
$fs.Close()
afplay $path