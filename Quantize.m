%   Quantize
%
%   Arguments:
%       - soundDataSamples: an n x 1 vector of sound data
%   
%
%   Requires: 
%
%   Modifies: 
%
%   Effects: Quantizes the input audio signal by 
%
%   Returns: Nothing

function Quantize(soundDataSamples, samplingRate, volume, callibratedBaseline)
    arguments
        soundDataSamples (:,1)
        samplingRate (1,1) {mustBePositive, mustBeReal} = 44100
        volume (1,1) {mustBePositive, mustBeReal} = 50
        callibratedBaseline (1,1) {mustBeReal} = 0
    end

    
    % TODO: Apply Volume Callibration
    %gain = 10^((volume-callibratedBaseline)/20);
    %scaledSoundData = gain*(soundDataSamples ./ rms(soundDataSamples));

    % play the sound
    sound(soundDataSamples, samplingRate);
    %pause(4);
    %sound(scaledSoundData, samplingRate);

end
