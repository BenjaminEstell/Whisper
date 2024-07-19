% GenerateInternalRepresentation

% Generates the internal representation of the sound using reverse
% correlation with compressive sensing

function internalRepresentation = GenerateInternalRepresentation(sound)
    sparsity = 64;
    internalRepresentation = zeros(sound.numBins, 1);

    % Find s_hat, the sparse internal representation of the sound
    % Create a candidate vector a (numBins, 1)
    a = (1/double(sound.numTrials))*(sound.stimulusMatrix'*sound.responseVector);
    val = sort(abs(a),'descend');
    gamma = val(sparsity+1);
    
    % soft threshold the basis coefficients 
    if norm(a,inf) <= gamma
        s_hat = zeros(sound.numBins,1);
    else
        s_hat = (1/norm(P(a,gamma),2))*P(a,gamma);
    end

    % Decompress s_hat, to find the real internal representation of the sound
    for ii = 1:sound.numBins
        ek = zeros(sound.numBins, 1);
        ek(ii) = 1;
        psi = idct(ek);
        internalRepresentation = internalRepresentation + psi(:)*s_hat(ii);
    end
end