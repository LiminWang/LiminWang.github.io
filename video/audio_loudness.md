
[Google developer](https://developers.google.com/actions/tools/audio-loudness)

# Audio Loudness

LUFS (Loudness Units relative to Full Scale) is a standard that enables volume normalization across many genres and production styles. LUFS is a complicated algorithm based on perceived loudness of human hearing at a comfortable listening volume and lets audio producers avoid jumps in amplitude that would require users to constantly adjust volume. LUFS is also known as LKFS (Loudness, K-weighted, relative to Full Scale)

Note: Volume is distinct from loudness. Volume is measured in decibels and is a physical measurement of peak air pressure change in a given acoustic situation. Loudness is a relative value used to compare digital programs based on the maximum loudness of a digital waveform (0.0 LUFS). This is why all LUFS are negative. Peak level is not a good measure of loudness and should not be used to compare audio material to the Google Assistant TTS output.
When playing back audio files using SSML, the average loudness should be -16 LUFS (Loudness Units Full Scale), which is the average loudness of the Google Assistant TTS output. This level gives a good balance between overall volume control on the Google Home and ample headroom for material with variable dynamic range when compared to the Google Assistant.

We recommend two options to measure and adjust audio loudness:

Use a Digital Audio Workstation (DAW) and LUFS meter.
Use FFmpeg, a command line utility.
Using a DAW and LUFS meter

The following steps describe how to ensure your audio meets the -16 LUFS recommendation:

Create all audio at consistently loud and balanced (equalized) levels for the entire duration of the audio, so that there are no spikes or dips in loudness.
Setup a digital audio workstation (DAW) and LUFS meter to measure audio loudness compared to the Google TTS Loudness Reference.
Measure and adjust the loudness of your audio so that it has an integrated average loudness of about -16 LUFS.
Ear check your audio by comparing its loudness to the Google TTS Loudness Reference.
Setup a DAW and LUFS meter

There are many DAWs and LUFS meters available as freeware and commercial products. If you already have a preferred DAW and LUFS meter, you can use that. Otherwise, we recommend Audacity for Windows and Linux or Reaper for Mac for DAWs and TBProAudio dpMeter II for an LUFS meter. The following sections assume you are using these tools.

Get the files

Download and install a DAW:
For Windows or Linux: Audacity
For Mac: Reaper
Download and install dpMeter II for your OS. This tool works with both Audacity and Reaper as a VST (Virtual Studio Technology) plugin.
Download the Google TTS Loudness Reference audio file. The TTS audio reads: "The integrated loudness of this sentence is about -16 LUFS". This file serves as the test audio for the meter as well as an ear check reference.
Configure dpMeter II for Audacity (Windows/Linux)

Open the Google TTS Loudness Reference audio file in Audacity.
Open the dpMeter II plugin by clicking on the Effect tab and choosing Add/Remove Plug-ins.
Find dpMeter2 in the list, click Enable, then OK. The dpMeter II plugin now appears in the Effect drop-down menu.
Click dpMeter2 from the Effect drop-down menu to open the plugin. dpMeter II defaults to RMS mode (orange color scheme). Change the mode to EBU r128 (blue color scheme) to measure LUFS.


Configure dpMeter II for Reaper (Mac)

Open the Google TTS Loudness Reference audio by clicking Insert > Media file.....
Open the dpMeter II plugin by clicking on the green FX button (number 1 in the figure) on the left pane of the audio layer. An FX window appears.


Click dpMeter2 in the list. dpMeter II defaults to RMS mode (orange color scheme). Change the mode to EBU r128 (blue color scheme) to measure LUFS.
Measuring and adjusting loudness

Different meters in different DAWs give slightly different readings. Audacity tends to measure the Google TTS Loudness Reference a little louder than other DAWs, at -15.1 LUFS, while Reaper gives a reading of -16.0 LUFS. As long as your DAW measures the loudness of the Google TTS Loudness Reference within +/-2 LUFS of -16, it should work fine for setting the loudness of your audio.

The basic steps for measuring and adjusting loudness are:

Use dpMeter II to measure the loudness of the Google TTS Loudness Reference to establish a baseline LUFS reading. If your DAW is measuring higher or lower than -16 LUFS for the Google TTS Loudness Reference, then simply match your audio to the baseline of your DAW. For example, in Audacity, dpMeter II measures an integrated loudness of -15.1 LUFS, so the new target loudness for your program should be -15.1 LUFS.
After establishing a baseline, adjust your audio to match the baseline reading.
Measuring the Google TTS Loudness Reference

Click the green play button in dpMeter II or press play (spacebar) in your DAW (number 4 below) to measure the loudness of the file.


The following list describes major features you might use in dpMeter II:

Mode: Set to EBU (instead of RMS) to measure loudness in LUFS
Gain Control: Be sure this is set to 0.0 until you are ready to change the loudness of your program.
Integrated Loudness: This is a measure of the average loudness of all of the audio that the plug-in has analyzed since the reset button (5) has been clicked. Click the reset button (5) before each loudness measurement to be sure you're measuring only the loudness of the current selection.
Play: This begins the loudness analysis of the audio file. (This button does not appear in all DAWs. Clicking the main play button (space bar) in your DAW should have the same effect.)
Reset: Click this button between each loudness measurement.
Apply: When you are ready to change the loudness of your program material to match the Google TTS Loudness Reference, this button applies the loudness change set by the Gain Control (2).
Matching loudness to the Google TTS Loudness Reference

Now that you have measured the Google TTS Loudness Reference loudness, you can measure and adjust your audio's loudness:

Open your audio file and click choose dpMeter2 from the Effect Menu.
Click the Play button and let the integrated loudness value settle to an average value for your audio file.
If the integrated loudness is different from the Google TTS Loudness Reference, adjust the gain of your audio to match the reference. For example, if your audio measures at an integrated loudness of -12, it's too loud, so decrease the gain by setting Gain Control to -4db and clicking Apply to bring it to the target range of the Google TTS Loudness Reference (-16 LUFS). You may need to measure and adjust the gain to get to the target loudness, since gain only approximates LUFS.
Note: You may also notice that your program audio is noticeably brighter or duller than the Google TTS Loudness Reference. In this case, you may want to adjust the balance using an EQ (equalizer) plugin.
Using ffmpeg

FFmpeg is a media framework with a command line tool for media conversion. The tool includes a filter called loudnorm for loudness normalization. You can use loudnorm to output a version of your audio file at the appropriate -16 LUFS loudness using dual-pass mode.

Download and install FFmpeg.
Navigate to the installation directory and run FFmpeg with the loudnorm filter on your input file.


```
./ffmpeg -i /path/to/input.wav -af loudnorm=I=-16:TP=-1.5:LRA=11:print_format=summary -f null -
This instructs FFmpeg to measure the audio values of your media file without creating an output file. You will get a series of values presented as follows:

Input Integrated:    -27.2 LUFS
Input True Peak:     -14.4 dBTP
Input LRA:             0.1 LU
Input Threshold:     -37.7 LUFS

Output Integrated:   -15.5 LUFS
Output True Peak:     -2.7 dBTP
Output LRA:            0.0 LU
Output Threshold:    -26.2 LUFS
```

Normalization Type:   Dynamic
Target Offset:        -0.5 LU
The sample values above indicate important information about the incoming media. For instance, the Input Integrated value shown indicates audio that is too loud. The Output Integrated value is much closer to -16.0. Both the Input True Peak and Input LRA, or loudness range, values are higher than our provided ceilings and will be reduced in the normalized version. Finally, the Target Offset represents the offset gain used in the output.
Run a second pass of the loudnorm filter, supplying the values from step 1 as "measured" values in the loudnorm options.

```
./ffmpeg -i /path/to/input.wav -af loudnorm=I=-16:TP=-1.5:LRA=11:measured_I=-27.2:measured_TP=-14.4:measured_LRA=0.1:measured_thresh=-37.7:offset=-0.7:linear=true:print_format=summary output.wav
```

A file, output.wav, is created that contains a loudness normalized version of your input file.
