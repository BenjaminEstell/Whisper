classdef Sound < handle
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
        freqDivisor                         int32
        numTrials                           int16
        stimulusMatrix    
        responseVector
        type                                TestType
        internalRepresentation
        internalRepresentationTimeDomain
        formantFrequencies
        signalStart
        signalStop
    end

    methods (Access = public)

        % Class Constructor
        % Args
            % nameIn        string      The name of the sound
            % typeIn        TestType    The type of test the sound is used in
            % numTrialsIn   int         The number of trials for the sound
        % Returns: The constructed Sound
        function obj = Sound(nameIn, typeIn, numTrialsIn)
            obj.name = nameIn;
            obj.type = typeIn;
            obj.getAudio();
            obj.numTrials = numTrialsIn;
            obj.responseVector = zeros(obj.numTrials, 1);
            obj.internalRepresentation = zeros(obj.numFreqs, 1);
            resizedFrequencyDomain = imresize(fft(obj.humanVoicedSoundTimeDomain), [obj.freqDivisor*obj.numSamples 1], "nearest");
            obj.humanVoicedSoundFrequencyDomain = resizedFrequencyDomain(1:obj.numSamples);
            % Gets the first 3 formants of the original sound for later use
            obj.getFormants(3);
        end

         % Sets the name of the sound
         % Args
            % nameIn        string      the name of the sound
         function setName(obj, nameIn)
             obj.name = nameIn;
         end

         % Computes the time-domain representation of the
         % computer-generated stimulus so it can be played to the user
         % Called whenever the user plays the sounds
         % Args
            % currentTrial      int     the trials number of the stimulus
         function stimulusTimeDomain = getStimulusTimeDomain(obj, currentTrial)
            % Get representation in frequency domain and plot stimuli in
            % frequency domain
            stimFrequencyDomain = imresize(obj.stimulusMatrix(currentTrial, :)', [obj.numFreqs 1], "nearest");
            figure(1);
            plot(abs(stimFrequencyDomain));
            title('Computer-Generated Stimulus');
            xlabel('Frequency (Hz)');
            ylabel('Amplitude');

            % Convert stimulus into the time domain and play
            stim = ifft(obj.stimulusMatrix(currentTrial, :));
            % mirror sound and stretch
            folds = floor(cast(obj.numSamples, "double") / cast(obj.numFreqs, "double"));
            summation = zeros(1, floor(length(stim)/folds));
            for fold = 1:folds
                currentFold = stim(floor(length(stim)*(fold-1)/folds) + 1:floor(length(stim)*fold/folds));
                summation = summation + currentFold;
            end
            stim4 = imresize(summation, [1 length(stim)], 'nearest');
            % set values before and after the real signal to 0.001
            stim4(1:obj.signalStart) = 0.0001;
            stim4(obj.signalStop:end) = 0.0001;

            % Get the real value
            stimulusTimeDomain = real(stim4);
            
            % Plot human voiced sound in frequency domain
            figure(2);
            spect = imresize(abs(obj.humanVoicedSoundFrequencyDomain), [obj.numFreqs 1], "nearest");
            plot(spect(1:obj.numFreqs));
            title('Human-Voiced Sound');
            xlabel('Frequency (Hz)');
            ylabel('Amplitude');
         end

         % Generates the stimulus matrix for the sound
         % Called by the trial constructor, when the trial is created
         % Returns: the sound object
         function generateStimulusMatrix(obj)   
            obj.stimulusMatrix = -100 * ones(obj.numTrials, obj.numSamples);
            binnum = GetFreqBins(obj.numSamples, obj.numFreqs, 0, obj.numSamples);
            binWidth = 12;
            for jj = 1:obj.numTrials
                obj.stimulusMatrix(jj, :) = obj.humanVoicedSoundFrequencyDomain;
        
                for ii = 1:length(obj.formantFrequencies)
                    randBin = floor(rand() * min(obj.numFreqs-(binWidth*2 + 1), 3500))+binWidth+1;
                    % swap the amplitude of the formant frequency, plus the binWidth frequencies on either side with a random
                    % collection of frequency binWidth*2 + 1 frequencies
                    randBinFreqs = randBin-binWidth:randBin+binWidth;
                    peakFreqs= obj.formantFrequencies(ii)-binWidth:obj.formantFrequencies(ii)+binWidth;
                    for kk = 1:binWidth*2 + 1
                        temp = obj.stimulusMatrix(jj, binnum==randBinFreqs(kk));
                        obj.stimulusMatrix(jj, binnum==randBinFreqs(kk)) = obj.stimulusMatrix(jj, binnum==peakFreqs(kk));
                        obj.stimulusMatrix(jj, binnum==peakFreqs(kk)) = temp;
                    end
                end
            end
         end

         % Generates the internal representation of the sound from the user
         % responses and stimulus matrix
         % Called at the conclusion of all trials for the sound
         % Returns: The sound obj
         function generateInternalRepresentation(obj)
            obj.internalRepresentation = (1/obj.numFreqs)*obj.stimulusMatrix'*obj.responseVector;
            obj.internalRepresentationTimeDomain = ifft(obj.internalRepresentation);
            % mirror sound and stretch
            folds = floor(cast(obj.numSamples, "double") ./ cast(obj.numFreqs, "double"));
            summation = zeros(floor(length(obj.internalRepresentationTimeDomain)/folds));
            for fold = 1:folds
                currentFold = obj.internalRepresentationTimeDomain(floor((length(obj.internalRepresentationTimeDomain)*(fold-1)/folds)) + 1:floor(length(obj.internalRepresentationTimeDomain)*fold/folds));
                summation = summation + currentFold;
            end
            stim4 = imresize(summation', [1 length(obj.internalRepresentationTimeDomain)], 'nearest');
            stim5 = flipud(stim4');
            stim5 = stim5 .* (rms(obj.humanVoicedSoundTimeDomain) / rms(stim5));
            stim5(1:obj.signalStart) = 0.0001;
            stim5(obj.signalStop:end) = 0.0001;
            obj.internalRepresentationTimeDomain = stim5;
        end
    end

    methods (Access = private)

         % Loads the audio for the Sound from a file
         % Called by the Sound constructor
         % Returns: The sound object
         function getAudio(obj)
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
            obj.freqDivisor = 4.0;
            obj.numFreqs = floor(cast(obj.numSamples, "double")./cast(obj.freqDivisor, "double"));
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

         % Determines the frequencies of the first n formants of the Sound
         % Called by the Sound constructor
         % Returns: The Sound object
         function getFormants(obj, n)
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

    end
end