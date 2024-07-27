% Generate Stimulus Matrix

% Generates the compressive sensing stimulus matrix (numTrials x numBins)
% that is used to generate the computer-generated stimuli presented to
% patients

function stimulusMatrix = GenerateStimulusMatrix(sound)
    spect = -100 * ones(sound.numTrials, sound.numSamples);
    binnum = getFreqBins(sound.samplingRate, sound.numSamples, sound.numBins, 0, sound.numSamples);
    % Keep the first 4 formants, but reset everything else
    formantBins = sound.formantFrequencies;
    for jj = 1:sound.numTrials
        spect(jj, :) = sound.humanVoicedSoundFrequencyDomain;

        for ii = 1:length(formantBins)
            % swap the amplitude of the formant bin with a random bin
            % Something ain't right here
            randBin = floor(rand() * sound.numBins);
            temp = spect(jj, binnum==randBin);
            spect(jj, binnum==randBin) = spect(jj, formantBins(ii));
            spect(jj, binnum==formantBins(ii)) = temp;
        end
    end
    stimulusMatrix = spect;

    % Compressive sensing
    % for ii = 1:numBins
    %     % Create initial basis vectors, ek
    %     ek = zeros(numBins, 1);
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