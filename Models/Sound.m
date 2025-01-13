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
        numFreqs 
        freqDivisor
        numTrials
        stimulusMatrix    
        responseVector
        type                                TestType
        internalRepresentation
        internalRepresentationTimeDomain
        formantFrequencies
        signalStart
        signalStop
    end

    methods
        % Class Constructor
        function obj = Sound(nameIn, typeIn, numTrialsIn)
            obj.name = nameIn;
            obj.type = typeIn;
            obj = obj.getAudio();
            obj.numTrials = numTrialsIn;
            obj.responseVector = zeros(obj.numTrials, 1);
            obj.internalRepresentation = zeros(obj.numFreqs, 1);
            resizedFrequencyDomain = imresize(fft(obj.humanVoicedSoundTimeDomain), [obj.freqDivisor*obj.numSamples 1], "nearest");
            obj.humanVoicedSoundFrequencyDomain = resizedFrequencyDomain(1:obj.numSamples);
            obj = obj.getFormants(3);
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
            obj.numSamples = size(obj.humanVoicedSoundTimeDomain, 1);
            
            % Generate vars to compress sound by reducing the number of
            % frequencies in play
            obj.freqDivisor = 4;
            obj.numFreqs = floor(obj.numSamples/obj.freqDivisor);
            % numSamples must be a multiple of the number of frequencies
            obj.numSamples = obj.numFreqs * obj.freqDivisor;
            % Truncate sound to numSamples
            obj.humanVoicedSoundTimeDomain = obj.humanVoicedSoundTimeDomain(1:obj.numSamples);

            % Identify signal start and stop
            rollingAverage = movmean(abs(obj.humanVoicedSoundTimeDomain), 1000);
            point = 1;
            while rollingAverage(point) < 0.003 && point < length(obj.humanVoicedSoundTimeDomain) - 4
                point = point + 4;
            end
            start = point;
            
            while rollingAverage(point) > 0.001 && point < length(obj.humanVoicedSoundTimeDomain) - 4
                point = point + 4;
            end
            stop = point;
            obj.signalStart = start;
            obj.signalStop = stop;
         end

         % determines the frequencies of the first n formants of the Sound
         function obj = getFormants(obj, n)
             % Convert to freq domain and smooth
             soundFreqDomain = abs(fft(obj.humanVoicedSoundTimeDomain));
             firstPass = SegmentedSmooth(soundFreqDomain, 20, 2);
             secondPass = SegmentedSmooth(firstPass, 10, 2);
             % perform peak detection and sort
             [~, sortedLocations] = findpeaks(secondPass(1:obj.numFreqs), 1:obj.numFreqs,'SortStr', 'descend', 'MinPeakProminence',1);
             
             % figure(1);
             % plot(soundFreqDomain(1:obj.numFreqs));
             % figure(2);
             % plot(secondPass(1:obj.numFreqs));
             % sortedLocations
             % save formant frequencies in obj.formatFrequencies
             obj.formantFrequencies = sortedLocations(1:n);
         end

         % Sets the name of the sound
         function obj = setName(obj, nameIn)
             obj.name = nameIn;
         end
    end
end