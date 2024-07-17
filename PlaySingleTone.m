% Generates a single tone for 

function PlaySingleTone(callibratedBaseline)
    samplingRate = 22050;
    duration = 0.7;
    tone_freq = 800;
    % generate single tone
    t = 0:1/samplingRate:duration;
    soundDataSamples = sin(2*pi*tone_freq.*t)';
    % play single tone at callibrated Baseline volume
    scaledSoundData = (callibratedBaseline / 800)*(soundDataSamples);
    sound(scaledSoundData, samplingRate);
end


