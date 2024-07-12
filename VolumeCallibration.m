function callibratedBaseline = VolumeCallibration()
%   VOLUMECALLIBRATION 
%   
%   
outputArg1 = inputArg1;
outputArg2 = inputArg2;
end



% Let's talk about the general process for a second. The idea here is we
% want to normalize the perceived loudness between users by finding the
% volume level which, to the user, is barely audible. This level will
% server as the user's 0% baseline. From our perspective, this will be some
% audio level, which we will save. Then, when we play sounds to each user,
% we will add our desired audio level to the user's 0% baseline to produce
% the actual volume level that the sound generator uses to drive the audio
% signal.
