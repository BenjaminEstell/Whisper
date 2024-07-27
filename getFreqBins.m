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
        %bintops = round(mels2hz(linspace(hz2mels(minFreq), hz2mels(maxFreq), numBins+1)));
        bintops = linspace(minFreq, maxFreq, numBins+1);
        bin_starts = bintops(1:end-1);
        bin_stops = bintops(2:end); 
        binnum = zeros(numSamples, 1);
        frequency_vector = linspace(0, numSamples, numSamples)';
        for itor = 1:numBins
            % Assign all binnum values whose indices match with the indices
            % of frequency vector whose values fall within the range
            % bin_starts(itor) - bin_stops(itor)

            % should be assigning all frequencies their proper binnum
            % we determine which frequencies to assign to this binnum by
            % checking if the INDEX falls within the proper range

            % The indices are run through the frequency vector function, so
            % this comparison converts indexes to frequency_vector values
            binnum(frequency_vector <= bin_stops(itor) & frequency_vector >= bin_starts(itor)) = itor;
        end

    end % function