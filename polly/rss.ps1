Import-Module AWSPowerShell.NetCore

$path = "./polly/rss.mp3"
$txtPath = "./polly/rss.txt"

function Get-NextBlog() {
    $continue = Read-Host "Read a blog description? (y/n)"
    while ("y", "n" -notcontains $continue ) {
        $continue = Read-Host "Read a blog description? (y/n)"
    }
    return $continue
}
$doc = Invoke-RestMethod http://feeds.feedburner.com/AmazonWebServicesBlog?fmt=xml 
if (Test-Path $txtPath) {
    Remove-Item $txtPath
}
$doc | Out-File $txtPath
$blogsDescribed = 0
$continue = Get-NextBlog
while ($continue -ne 'n') {
    $text = $doc[$blogsDescribed].description
    $speech = Get-POLSpeech -VoiceId Nicole -Text $text -OutputFormat mp3
    if (Test-Path $path) {
        Remove-Item $path
    }
    $fs = [System.IO.FileStream]::new($path, [System.IO.FileMode]::CreateNew)
    $speech.AudioStream.CopyTo($fs)
    $fs.Close()
    afplay $path
    $blogsDescribed += 1
    if ($doc.Length -le $blogsDescribed) {
        break;
    }
    else {
        $continue = Get-NextBlog
    }
}
Write-Host "Thanks for listening!"