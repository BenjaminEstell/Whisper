# Whisper

# Project Overview
The goal of this project is to determine if the reverse correlation method is a more effective method of uncovering
the integration of sounds in bimodal patients, which are hearing patients with a cochlear implant in one ear, and
a hearing aid in the opposite ear.
To determine this, Whisper uses reverse correlation with compressive sensing to compute an approximation of the 
integrated sound for several different types of inputs, including consonant-vowel sounds, H-vowel-D sounds, and CNC words.
Whisper allows researchers to administer a test to bimodal patients in which the patients are first presented with
a human voice speaking the sound in question, followed by computer-generated random noise. Participants indicate
whether the computer-generated noise sounds very similar to the human voiced sound. After performing many trials with
the same human voiced sound, but different computer-generated random sounds, Whisper can approximate the bimodal
integration for that sound.
After the test is complete, Whisper allows researchers to download the data from the test, and analyze the spectal contents
of the patient's bimodal integration.

# References
Portions of this project were influenced by Lammert et al's work on tinnitus reconstruction.
The getFreqBins function was borrowed from Lammert et al's work.
The Segmented Smooth function was borrowed from Thomas O'Harver as indicated in the comments in that file.