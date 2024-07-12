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
%   "volume" + "callibratedBaseline"
%
%   Returns: 0 on success. 1 on error

function error = PlaySoundFromFile(filename, volume, callibratedBaseline)
    arguments
        filename char = []
        volume (1,1) {mustBePositive, mustBeReal} = 50
        callibratedBaseline (1,1) {mustBeReal} = 0
    end

    % define variables
    error = 0;
    % load from file
    [y, Fs] = audioread(filename);
    % monkey with the volume
    % play the sound
    sound(y, Fs);

end
