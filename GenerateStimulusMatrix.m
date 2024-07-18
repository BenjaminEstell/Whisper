% Generate Stimulus Matrix

% Generates the compressive sensing stimulus matrix (numTrials x numBins)
% that is used to generate the computer-generated stimuli presented to
% patients

function stimulusMatrix = GenerateStimulusMatrix(numTrials, numBins)
    stimulusMatrix = zeros(numTrials, numBins);
    % Generate the initial random noise
    X = 10*(rand(numTrials, numBins)-0.5);

    
    for ii = 1:numBins
        % Create initial basis vectors, ek
        ek = zeros(numBins, 1);
        % Put 1's on the diagonal to create basis vectors
        ek(ii) = 1;
        % Take the inverse cosine transform of ek, resulting in a sparse
        % basis vecctor
        psi = idct(ek);
        % Multiply each sparse basis vector by X, and insert as a column of 
        % stimulusMatrix
        stimulusMatrix(:, ii) = X*psi(:);
    end 

    % Generates both the binned representation and frequency
    % representations
    %spect = -100 * ones(app.currentSoundObj.numSamples / 2, 1);
    %binned_repr = 0*ones(app.currentSoundObj.numBins, 1);
    %for ii = 1:app.currentSoundObj.numBins
    %    this_amplitude_value = -100 * rand();
    %    binned_repr(ii) = this_amplitude_value;
    %    spect(binnum==ii) = this_amplitude_value;
    %end
end