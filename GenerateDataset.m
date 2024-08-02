% Generate Dataset

% Generates a dataset containing
% Creates a folder called '[PatientID]-[StartTimestamp]'
% Inside the folder, we have a txt file with the patient data
%   - Patient Data
        % PatientID
        % DoB
        % Sex
        % Left ear hearing
        % Right ear hearing
% We also have a txt file with the test data
%   - Test Data
        % Start time
        % End time
        % Duration
        % Number of trials
% Create a folder called Sounds
% Each sound is its own folder within the Sounds folder
%   - For each sound
        % Save the original sound as .wav
        % save the stimulus matrix as txt
        % save the response vector as txt
        % save the internal representation as txt
        % Remember chart labels
            % x axis
            % y axis
            % title
        % Chart of the original sound as png
        % Chart of the internal representation as png
        % Chart of the response vector as png




function GenerateDataset(test)
    % Create dataset folder
    folderName = string(test.patient.ID) + "-" + strrep(string(test.startTimestamp), ':', '.');
    truncatedPath = split(test.SavePath, ':');
    savePath = truncatedPath(2);
    [status, msg, msgID] = mkdir(savePath, folderName);
    if ~status
        % Folder could not be created
        msg
        msgID
    else
        folderPath = fullfile(savePath, folderName);
        
        % use saveas to save the charts as png
    
        % Save Patient Data
        patientTablePath = fullfile(folderPath, "PatientData.txt");
        ID = test.patient.ID;
        DoB = test.patient.DOB;
        Sex = test.patient.sex;
        LeftEarHearingDevice = test.patient.leftEarDevice;
        TimeWithLeftEarHearingDevice = test.patient.leftEarDeviceYears;
        RightEarHearingDevice = test.patient.rightEarDevice;
        TimeWithRightEarHearingDevice = test.patient.rightEarDeviceYears;
        PatientTable = table(ID, DoB, Sex, LeftEarHearingDevice, TimeWithLeftEarHearingDevice, RightEarHearingDevice, TimeWithRightEarHearingDevice);
        writetable(PatientTable, patientTablePath)

        % Save Test Data
        testTablePath = fullfile(folderPath, "TestData.txt");
        StartTime = test.startTimestamp;
        EndTime = test.endTimestamp;
        Duration = test.duration;
        NumberOfTrials = test.numTrials;
        TestTable = table(StartTime, EndTime, Duration, NumberOfTrials);
        writetable(TestTable, testTablePath);

        % Save Sounds
        mkdir(folderPath, "Sounds");
        for soundIdx = 1:test.numSounds
            sound = test.sounds{soundIdx};
            % Create directory for this Sound's data
            mkdir(fullfile(folderPath, "Sounds"), sound.name);
            soundPath = fullfile(fullfile(folderPath, "Sounds"), sound.name);
            % Save HVS as .wav
            audiowrite(fullfile(soundPath, "HVS.wav"), sound.humanVoicedSoundTimeDomain, sound.samplingRate);
            % Save IR as .wav
            audiowrite(fullfile(soundPath, "InternalRepresentation.wav"), real(sound.internalRepresentationTimeDomain), sound.samplingRate);
            % Save stimulusMatrix as txt
            writematrix(sound.stimulusMatrix, fullfile(soundPath, "StimulusMatrix.txt"));
            % Save responseVector as txt    
            writematrix(sound.responseVector, fullfile(soundPath, "ResponseVector.txt"));
            % Save internal representation as txt
            writematrix(sound.internalRepresentation, fullfile(soundPath, "InternalRepresentation.txt"));
            
            % Save HVS as png
            x = 1:sound.numFreqs;
            OGSound = imresize(sound.humanVoicedSoundFrequencyDomain, [sound.numFreqs 1], "nearest");
            internalRepresentation = imresize(sound.internalRepresentation, [sound.numFreqs 1], "nearest");
            match = rms(OGSound(1:sound.numFreqs)) / rms(internalRepresentation);
            fig1 = figure('Visible','off');
            HVSChart = axes(fig1);
            area(HVSChart, x, abs(OGSound(1:sound.numFreqs)), FaceColor='r', EdgeColor='r', FaceAlpha=0.3, EdgeAlpha=0.3);
            legend(HVSChart, 'Human-Voiced Sound');
            xlabel(HVSChart, "Frequency (Hz)");
            ylabel(HVSChart, "Amplitude");
            title(HVSChart, "Human Voiced Sound Frequency Components");
            saveas(HVSChart, fullfile(soundPath, "HVS.png"), 'png');
            % Save IR as png
            fig2 = figure('Visible','off');
            IRChart = axes(fig2);
            area(IRChart, x, (abs(internalRepresentation).*match), FaceColor='b', EdgeColor='b', FaceAlpha=0.3, EdgeAlpha=0.3);
            legend(IRChart, 'Internal Representation');
            xlabel(IRChart, "Frequency (Hz)");
            ylabel(IRChart, "Amplitude");
            title(IRChart, "Internal Representation Frequency Components");
            saveas(IRChart, fullfile(soundPath, "InternalRepresentation.png"), 'png');            

            % Save combined chart as png
            fig3 = figure('Visible','off');
            CombinedChart = axes(fig3);
            area(CombinedChart, x, (abs(internalRepresentation).*match), FaceColor='b', EdgeColor='b', FaceAlpha=0.3, EdgeAlpha=0.3);
            hold(CombinedChart, "on");
            area(CombinedChart, x, abs(OGSound(1:sound.numFreqs)), FaceColor='r', EdgeColor='r', FaceAlpha=0.3, EdgeAlpha=0.3);
            legend(CombinedChart, 'Internal Representation', 'Human-Voiced Sound');
            hold(CombinedChart, "off");
            xlabel(CombinedChart, "Frequency (Hz)");
            ylabel(CombinedChart, "Amplitude");
            title(CombinedChart, "Human Voiced Sound and Internal Representation Frequency Components");
            saveas(CombinedChart, fullfile(soundPath, "CombinedChart.png"), 'png');

            % save responseVector as png
            fig4 = figure('Visible','off');
            responseVectorChart = axes(fig4);
            scatter(responseVectorChart, 1:sound.numTrials, sound.responseVector);xlabel(sound.CombinedChart, "Frequency (Hz)");
            xlabel(responseVectorChart, "Trial Number");
            ylabel(responseVectorChart, "Patient Response (1=similar, -1=not similar)");
            title(responseVectorChart, "Patient Responses");
            saveas(responseVectorChart, fullfile(soundPath, "ResponseVector.png"), 'png');
            % Write back sound obj
            test.sounds{soundIdx} = sound;
        end
    end
end