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
%   Returns: 0 on success. 1 on error

function error = PlaySoundFromRandom(numSamples, volume, callibratedBaseline)
    arguments
        numSamples (1,1) {mustBePositive, mustBeReal} = 44100
        volume (1,1) {mustBePositive, mustBeReal} = 50
        callibratedBaseline (1,1) {mustBeReal} = 0
    end

    % define variables
    error = 0;
    Fs = 44100;
    % generate random sound samples
    y = rand(numSamples,1);
    % quantize the sound samples
    % play sound to user
    PlaySound(y, Fs, volume, callibratedBaseline);

end
