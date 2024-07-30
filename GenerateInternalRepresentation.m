% GenerateInternalRepresentation

% Generates the internal representation of the sound using reverse
% correlation with compressive sensing

function internalRepresentation = GenerateInternalRepresentation(sound)
    internalRepresentation = (1/sound.numFreqs)*sound.stimulusMatrix'*sound.responseVector;
end