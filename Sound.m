classdef Sound
    %Sound 
    %   The Sound class represents a sound whose internal representation
    %   will be discovered by presenting the user with a number of trials.

    properties
        name                                string
        humanVoicedSoundTimeDomain        
        humanVoicedSoundFrequencyDomain
        samplingRate                        
        numSamples                          
        numBins 
        numTrials
        stimulusMatrix                      
        responseVector
        type                                TestType
        internalRepresentation
        F1Bin
        F2Bin
        F3Bin
        F1Amp
        F2Amp
        F3Amp
    end

    methods
        % Class Constructor
        function obj = Sound(nameIn, typeIn, numTrialsIn)
            obj.name = nameIn;
            obj.type = typeIn;
            obj = obj.getAudio();
            obj.numTrials = numTrialsIn;
            obj.responseVector = zeros(obj.numTrials);
            obj.internalRepresentation = zeros(obj.numBins, 1);
            obj = obj.getFormants();
        end

         % Loads the audio for the Sound from a file
         function obj = getAudio(obj)
            % Load the human voiced sound from file
            if obj.type == TestType.syllable
                filename = "syllable_sounds/" + obj.name + ".wav";
            else
                filename = "cnc_sounds/" + obj.name + ".wav";
            end

            [obj.humanVoicedSoundTimeDomain, obj.samplingRate] = audioread(filename);
            obj.humanVoicedSoundFrequencyDomain = fft(obj.humanVoicedSoundTimeDomain);
            % Normalize in the frequency domain
            %obj.humanVoicedSoundFrequencyDomain = obj.humanVoicedSoundFrequencyDomain ./ rms(obj.humanVoicedSoundFrequencyDomain);
            obj.numSamples = size(obj.humanVoicedSoundTimeDomain, 1);
            if rem(obj.numSamples, 2) == 1
                obj.numSamples = obj.numSamples - 1;
            end
            obj.humanVoicedSoundFrequencyDomain = obj.humanVoicedSoundFrequencyDomain(1:obj.numSamples);
            obj.numBins = obj.numSamples/2;
         end

         % determines the amplitudes and frequencies of the first 2
         % formants of the Sound
         function obj = getFormants(obj)
             F1Bin = 0;
             F2Bin = 0;
             F3Bin = 0;
             F1Amp = 0;
             F2Amp = 0;
             F3Amp = 0;
             % Walk through each frequency bin
             for freqBin = 1:obj.numBins
                 if obj.humanVoicedSoundFrequencyDomain(freqBin) > F1Amp
                     F1Amp = obj.humanVoicedSoundFrequencyDomain(freqBin);
                     F1Bin = freqBin;
                 elseif obj.humanVoicedSoundFrequencyDomain(freqBin) > F2Amp
                     F2Amp = obj.humanVoicedSoundFrequencyDomain(freqBin);
                     F2Bin = freqBin;
                 elseif obj.humanVoicedSoundFrequencyDomain(freqBin) > F3Amp
                     F3Amp = obj.humanVoicedSoundFrequencyDomain(freqBin);
                     F3Bin = freqBin;
                 end
             end
             obj.F1Bin = F1Bin;
             obj.F2Bin = F2Bin;
             obj.F3Bin = F3Bin;
             obj.F1Amp = F1Amp;
             obj.F2Amp = F2Amp;
             obj.F3Amp = F3Amp;
         end

         % Converts a numSamples length frequency domain sound vector into
         % a numBins quantized representation
         function spect = getHumanVoicedSoundBinnedRepresentation(obj)
             binnum = getFreqBins(obj.samplingRate, obj.numSamples, obj.numBins, 0, obj.samplingRate);
             spect = -100 * ones(1, obj.numSamples);
             % Fill bins
             for ii = 1:obj.numBins
                 % Fills each frequency in bin ii with the amplitude of the
                 % lowest frequency in that bin
                 spect(binnum==ii) = obj.humanVoicedSoundFrequencyDomain(ii);
             end
         end
    end
end