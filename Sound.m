classdef Sound
    %Sound 
    %   The Sound class represents a sound whose internal representation
    %   will be discovered by presenting the user with a number of trials.

    properties
        name                                string
        humanVoicedSoundTimeDomain        
        humanVoicedSoundFrequencyDomain
        samplingRate                        
        numSamples                          int32
        stimulusMatrix
        responseVector
        type                                TestType
    end

    methods
        % Class Constructor
        function obj = Sound(nameIn, typeIn)
            obj.name = nameIn;
            obj.type = typeIn;
            obj = obj.getAudio();
        end

         % Loads the audio for the Sound from a file
         function obj = getAudio(obj)
            % Load the human voiced sound from file
            if obj.type == TestType.phoneme
                filename = "phoneme_sounds/" + obj.name + ".wav";
            else
                filename = "cnc_sounds/" + obj.name + ".wav";
            end

            [obj.humanVoicedSoundTimeDomain, obj.samplingRate] = audioread(filename);
            obj.humanVoicedSoundFrequencyDomain = real(ifft(obj.humanVoicedSoundTimeDomain));
            obj.numSamples = size(obj.humanVoicedSoundTimeDomain, 1);
        end
    end
end