Import-Module AWSPowerShell.NetCore

$path = './polly/polly.mp3'
$text = "
<speak>
  <amazon:auto-breaths>
    <amazon:effect vocal-tract-length=`"+15%`">
      <prosody pitch=`"+20%`">
        Well, the Earth Mark <break time=`"200ms`" /> <emphasis level=`"strong`">Two</emphasis>, in fact, 
      </prosody>
    </amazon:effect> said Slartibartfast cheerfully. 
    <amazon:effect vocal-tract-length=`"+15%`">
      <prosody pitch=`"+20%`">
        We're making a copy from our original blueprints.
      </prosody>
    </amazon:effect>
    <break time=`"500ms`" /> There was a pause. <break time=`"800ms`" />
    <prosody pitch=`"high`">
    Are you trying to tell me,
    </prosody>
    said Arthur, <break time=`"500ms`" /> slowly and with control, 
    <prosody pitch=`"high`">
      that you originally <break time=`"300ms`" /><emphasis level=`"strong`">made</emphasis> the Earth? 
    </prosody>
    <amazon:effect vocal-tract-length=`"+15%`">
      <prosody pitch=`"+20%`">
        Oh yes, 
      </prosody>
    </amazon:effect>
    said Slartibartfast. 
    <amazon:effect vocal-tract-length=`"+15%`">
      <prosody pitch=`"+20%`">
        Did you ever go to a place <break time=`"500ms`" /> I think it was called 
        <prosody volume=`"loud`"> Norway? </prosody>
      </prosody>
    </amazon:effect>
    <prosody pitch=`"high`">No,</prosody>
    said Arthur. 
    <prosody pitch=`"high`">No, I didn’t.</prosody>
    <amazon:effect vocal-tract-length=`"+15%`">
      <prosody pitch=`"+20%`">
      <emphasis level=`"strong`">Pity,</emphasis> 
      </prosody>
    </amazon:effect>
    said Slartibartfast, 
    <amazon:effect vocal-tract-length=`"+15%`">
      <prosody pitch=`"+20%`">
        that was one of mine. 
        Won an award, you know. <break time=`"500ms`" /> 
        <emphasis level=`"strong`">
          Lovely
        </emphasis> crinkly edges. 
        I was most upset to hear of its destruction.
        </prosody>
      </amazon:effect>
  </amazon:auto-breaths>
</speak>”
$speech = Get-POLSpeech -VoiceId Brian -Text $text -OutputFormat mp3 -TextType ssml
if (Test-Path $path) {
    Remove-Item $path
}
$fs = [System.IO.FileStream]::new($path, [System.IO.FileMode]::CreateNew)
$speech.AudioStream.CopyTo($fs)
$fs.Close()
afplay $path