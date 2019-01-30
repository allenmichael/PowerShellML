Import-Module AWSPowerShell.NetCore

$path = './polly/polly.mp3'
$text = Read-Host -Prompt "Enter text to be spoken"
$speech = Get-POLSpeech -VoiceId Justin -Text $text -OutputFormat mp3
if (Test-Path $path) {
    Remove-Item $path
}
$fs = [System.IO.FileStream]::new($path, [System.IO.FileMode]::CreateNew)
$speech.AudioStream.CopyTo($fs)
$fs.Close()
afplay $path