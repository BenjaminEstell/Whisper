%   PlaySound
%
%   Arguments:
%       - soundDataSamples: an n x 1 vector of sound data
%       - samplingRate: a 1x1 scalar representing the audio sampling rate
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
%   Effects: Plays the sound data samples at the specified volume
%
%   Returns: Nothing

function PlaySound(soundDataSamples, samplingRate, volume, callibratedBaseline)
    arguments
        soundDataSamples (:,1)
        samplingRate (1,1) {mustBePositive, mustBeReal} = 44100
        volume (1,1) {mustBePositive, mustBeReal} = 50
        callibratedBaseline (1,1) {mustBeReal} = 0
    end

    
    % Apply Volume Callibration
    gain = callibratedBaseline * 10^(volume/20);

    scaledSoundData = (gain / 100) *(soundDataSamples);

    % play the sound
    sound(scaledSoundData, samplingRate);

end
