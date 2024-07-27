classdef Sound
    %Sound 
    %   The Sound class represents a sound whose internal representation
    %   will be discovered by presenting the user with a number of trials.

    properties
        name                                string
        humanVoicedSoundTimeDomain        
        humanVoicedSoundFrequencyDomain
        humanVoicedSoundBinnedRepresentation
        samplingRate                        
        numSamples                          
        numBins 
        binWidth
        numTrials
        stimulusMatrix                      
        responseVector
        type                                TestType
        internalRepresentation
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
            obj.internalRepresentation = zeros(obj.numBins, 1);
            obj.humanVoicedSoundBinnedRepresentation = obj.getHumanVoicedSoundBinnedRepresentation();
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
            obj.humanVoicedSoundFrequencyDomain = fft(obj.humanVoicedSoundTimeDomain);
            obj.numSamples = size(obj.humanVoicedSoundTimeDomain, 1);
            
            % Split sound into bins
            obj.binWidth = 8;
            obj.numBins = floor(obj.numSamples/obj.binWidth);
            % numSamples must be a multiple of the number of bins, so each
            % bin is the same size
            obj.numSamples = obj.numBins * obj.binWidth;
            % Truncate sounds to numSamples
            obj.humanVoicedSoundFrequencyDomain = obj.humanVoicedSoundFrequencyDomain(1:obj.numSamples);
            obj.humanVoicedSoundTimeDomain = obj.humanVoicedSoundTimeDomain(1:obj.numSamples);

            % Identify signal start and stop
            rollingAverage = movmean(abs(obj.humanVoicedSoundTimeDomain), 1000);
            point = 1;
            while rollingAverage(point) < 0.003 && point < length(obj.humanVoicedSoundTimeDomain)
                point = point + 1;
            end
            start = point;
            
            while rollingAverage(point) > 0.001 && point < length(obj.humanVoicedSoundTimeDomain)
                point = point + 1;
            end
            stop = point;

            obj.signalStart = start;
            obj.signalStop = stop;

         end

         % determines the frequencies of the first n formants of the Sound
         function obj = getFormants(obj, n)
             % perform peak detection
             if length(obj.humanVoicedSoundBinnedRepresentation) >= 10000
                topFreq = 10000;
             else
                topFreq = length(obj.humanVoicedSoundBinnedRepresentation);
             end
             [peaks, locations] = findpeaks(abs(obj.humanVoicedSoundBinnedRepresentation(1:topFreq)), 1:topFreq,'MinPeakProminence',2,'Annotate','extents');
             % sort peaks
             [sortedPeaks, I] = sort(peaks, 'descend');
             % copy peaks of n highest amplitude into a new array
             sortedLocations = locations(I);
             % save formant frequencies in obj.formatFrequencies
             obj.formantFrequencies = sortedLocations(1:n);
         end

         % Converts a numSamples length frequency domain sound vector into
         % a numBins quantized representation
         function spect = getHumanVoicedSoundBinnedRepresentation(obj)
             binnum = getFreqBins(obj.samplingRate, obj.numSamples, obj.numBins, 0, obj.numSamples);
             spect = -100 * ones(1, obj.numSamples);
             % Fill bins
             for ii = 1:obj.numBins
                 % This scheme compresses by creating bins for the signal
                 % and filling the bin with the sum of its component
                 % frequencies. However, it still retains numSamples
                 % data points by setting all frequency values in the bin
                 % to the bin value. To actually compress the signal, we
                 % would want to save only the bin values, and the expand
                 % it later. The scheme suffers from loss of important
                 % data, since the amplitude fluctuates greatly within each
                 % bin
                 % binSum = 0;
                 % for freq = 1:obj.binWidth
                 %     binSum = binSum + obj.humanVoicedSoundFrequencyDomain((ii-1)*obj.binWidth + freq);
                 % end
                 % % Fills each frequency in bin ii
                 % spect(binnum==ii) = binSum;

                 % This scheme compresses by only keeping the first numBin
                 % frequencies and stretching them by a factor of binSize,
                 % so that we retain numSamples data points. It effectively
                 % stretches
                 spect(binnum==ii) = obj.humanVoicedSoundFrequencyDomain(ii);
             end
         end
    end
end