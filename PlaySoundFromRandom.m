%   PlaySoundFromRandom
%
%   Arguments:
%       - numSamples: a 1x1 scalar representing the total number of audio
%       samples to be generated. This should match the number of audio
%       samples in the sound tone this random sound is matched with.
%       - volume: a 1x1 scalar representing the app-level volume
%       - callibratedBaseline: a 1x1 scalar representing the callibrated
%       system volume
%   
%
%   Requires: Volume is an integer greater than 0. Volume respresents the 
%   raw audio level, while callibratedBaseline represents the user's
%   baseline audio level.
%
%   Modifies: None
%
%   Effects: Plays random white noise at volume + callibratedBaseline
%
%   Returns: timeDomainSound: an mx1 vector of sound data in the time
%   domain. frequencyDomainSoundBins: a numBins x 1 vector of sound data in
%   the frequency domain

function [timeDomainSound, frequencyDomainSoundBins] = PlaySoundFromRandom(numSamples, samplingRate, volume, callibratedBaseline)
    arguments
        numSamples (1,1) {mustBePositive, mustBeReal} = 44100
        samplingRate (1,1) {mustBePositive, mustBeReal} = 44100
        volume (1,1) {mustBePositive, mustBeReal} = 50
        callibratedBaseline (1,1) {mustBeReal} = 0
    end

    % define variables
    numBins = 256;
    
    % Quantize in frequency domain
    frequencyDomainSoundBins = ones(numBins, 1);
    % For each frequency bin, generate a random amplitude
    for ii = 1:numBins
        frequencyDomainSoundBins(ii) = randn();
    end
    % Transform to time domain
    timeDomainSound = real(ifft(frequencyDomainSoundBins, numSamples));
    timeDomainSound = timeDomainSound.* 6;
    %figure(1)
    %t = 1:numBins;
    %plot(t, frequencyDomainSoundBins)
    %ti = 1:numSamples;
    %figure(2)
    %plot(ti, timeDomainSound)
    
    % play sound to user
    PlaySound(timeDomainSound, samplingRate, volume, callibratedBaseline);

end
