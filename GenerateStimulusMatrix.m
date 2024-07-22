% Generate Stimulus Matrix

% Generates the compressive sensing stimulus matrix (numTrials x numBins)
% that is used to generate the computer-generated stimuli presented to
% patients

function stimulusMatrix = GenerateStimulusMatrix(sound)
    %stimulusMatrix = zeros(numTrials, numBins);
    % Generate the initial random noise
    %X = 10*(rand(numTrials, numBins)-0.5);

    spect = -100 * ones(sound.numTrials, sound.numSamples);
    %binned_repr = -100*ones(app.currentSoundObj.numBins, 1);
    binnum = getFreqBins(sound.samplingRate, sound.numSamples, sound.numBins, 0, sound.numSamples);
    for jj = 1:sound.numTrials
        spect(jj, :) = sound.humanVoicedSoundFrequencyDomain;
        % for ii = 1:sound.numBins
        %     if ii == sound.F1Bin
        %         this_amplitude_value = sound.F1Amp;
        %     elseif ii == sound.F2Bin
        %         this_amplitude_value = sound.F2Amp;
        %     elseif ii == sound.F3Bin
        %         this_amplitude_value = sound.F3Amp;
        %     else
        %         %this_amplitude_value = rand()*0.5;
        %         this_amplitude_value = sound.humanVoicedSoundFrequencyDomain(ii);
        %     end
        %     %binned_repr(ii) = this_amplitude_value;
        %     spect(jj, binnum==ii) = this_amplitude_value;
        % end
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