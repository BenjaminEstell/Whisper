%   PlaySoundFromFile 
%
%   Arguments:
%       - filename: character vector representing the path to the audio file
%       - volume: a 1x1 scalar representing the app-level volume
%       - callibratedBaseline: a 1x1 scalar representing the callibrated
%       system volume
%   
%
%   Requires: filename names a valid audio file. Volume is an integer
%   greater than 0. Volume respresents the raw audio level, while
%   callibratedBaseline represents the user's baseline audio level.
%
%   Modifies: None
%
%   Effects: Plays the audio file specified in "filename" at
%   "volume" - "callibratedBaseline"
%
%   Returns: error: 0 on success. 1 on error. Also returns the number of
%   audio samples,

function [error, numSamples] = PlaySoundFromFile(filename, volume, callibratedBaseline)
    arguments
        filename char = []
        volume (1,1) {mustBePositive, mustBeReal} = 50
        callibratedBaseline (1,1) {mustBeReal} = 0
    end

    % define variables
    error = 0;
    % load sound samples from file
    [soundDataSamples, Fs] = audioread(filename);
    numSamples = size(soundDataSamples, 1);
    % convert to bin representation
    
    % play sound to user
    PlaySound(soundDataSamples, Fs, volume, callibratedBaseline);

end
