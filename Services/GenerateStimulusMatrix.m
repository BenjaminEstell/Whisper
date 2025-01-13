% Generate Stimulus Matrix

% Generates the compressive sensing stimulus matrix (numTrials x numFreqs)
% that is used to generate the computer-generated stimuli presented to
% patients

function stimulusMatrix = GenerateStimulusMatrix(sound)   
    stimulusMatrix = -100 * ones(sound.numTrials, sound.numSamples);
    binnum = getFreqBins(sound.samplingRate, sound.numSamples, sound.numFreqs, 0, sound.numSamples);
    formantFreqs = sound.formantFrequencies;
    binWidth = 12;
    for jj = 1:sound.numTrials
        stimulusMatrix(jj, :) = sound.humanVoicedSoundFrequencyDomain;

        for ii = 1:length(formantFreqs)
            randBin = floor(rand() * min(sound.numFreqs-(binWidth*2 + 1), 3500))+binWidth+1;
            % swap the amplitude of the formant frequency, plus the binWidth frequencies on either side with a random
            % collection of frequency binWidth*2 + 1 frequencies
            randBinFreqs = randBin-binWidth:randBin+binWidth;
            peakFreqs= formantFreqs(ii)-binWidth:formantFreqs(ii)+binWidth;
            for kk = 1:binWidth*2 + 1
                temp = stimulusMatrix(jj, binnum==randBinFreqs(kk));
                stimulusMatrix(jj, binnum==randBinFreqs(kk)) = stimulusMatrix(jj, binnum==peakFreqs(kk));
                stimulusMatrix(jj, binnum==peakFreqs(kk)) = temp;
            end
        end
    end

    % Compressive sensing
    % for ii = 1:numFreqs
    %     % Create initial basis vectors, ek
    %     ek = zeros(numFreqs, 1);
    %     % Put 1's on the diagonal to create basis vectors
    %     ek(ii) = 1;
    %     % Take the inverse cosine transform of ek, resulting in a sparse
    %     % basis vecctor
    %     psi = idct(ek);
    %     % Multiply each sparse basis vector by X, and insert as a column of
    %     % stimulusMatrix
    %     stimulusMatrix(:, ii) = X*psi(:);
    % end
end