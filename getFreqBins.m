function binnum = getFreqBins(samplingRate, numSamples, numBins, minFreq, maxFreq)
        % ### get_freq_bins
        % 
        % Generates a vector indicating
        % which frequencies belong to the same bin,
        % following a tonotopic map of audible frequency perception.
        % 
        % **OUTPUTS:**
        % 
        %   - binnum: `n x 1` numerical vector
        %       that contains the mapping from frequency to bin number
        %       e.g., `[1, 1, 2, 2, 2, 3, 3, 3, 3, ...]`
        % 
        %   - nfft: `1x1` numerical scalar,
        %       the number of points of the full FFT
        %
        %   - frequency_vector: `n x 1` numerical vector.
        %       the frequencies that `binnum` maps to bin numbers
        % 


        % Define Frequency Bin Indices 1 through self.n_bins
        bintops = round(mels2hz(linspace(hz2mels(minFreq), hz2mels(maxFreq), numBins+1)));
        bin_starts = bintops(1:end-1);
        bin_stops = bintops(2:end); 
        binnum = zeros(numSamples/2, 1);
        frequency_vector = linspace(0, samplingRate/2, numSamples/2)';

        for itor = 1:numBins
            binnum(frequency_vector <= bin_stops(itor) & frequency_vector >= bin_starts(itor)) = itor;
        end


    end % function