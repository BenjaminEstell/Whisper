% GenerateInternalRepresentation

% Generates the internal representation of the sound using reverse
% correlation with compressive sensing

function [internalRepresentation, internalRepresentationTimeDomain] = GenerateInternalRepresentation(sound)
    internalRepresentation = (1/sound.numFreqs)*sound.stimulusMatrix'*sound.responseVector;
    internalRepresentationTimeDomain = ifft(internalRepresentation);
    % mirror sound and stretch
    folds = floor(sound.numSamples / sound.numFreqs);
    summation = zeros(floor(length(internalRepresentationTimeDomain)/folds));
    for fold = 1:folds
        currentFold = internalRepresentationTimeDomain(floor((length(internalRepresentationTimeDomain)*(fold-1)/folds)) + 1:floor(length(internalRepresentationTimeDomain)*fold/folds));
        summation = summation + currentFold;
    end
    stim4 = imresize(summation', [1 length(internalRepresentationTimeDomain)], 'nearest');
    stim5 = flipud(stim4');
    stim5(1:sound.signalStart) = 0.0001;
    stim5(sound.signalStop:end) = 0.0001;
    internalRepresentationTimeDomain = stim5;
end