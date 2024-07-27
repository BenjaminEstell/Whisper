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
        % End time
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
    folderName = test.patient.ID + '-' + string(test.startTimestamp);
    % Issue with this
    %fullfile(test.SavePath, folderName)
    %mkdir(fullfile(test.SavePath, folderName));

    % use writetable to write to txt file
    % use writematrix to save matrixes
    % use saveas to save the charts as png

    % Save Patient Data
    ID = test.patient.ID;
    DoB = test.patient.DOB;
    Sex = test.patient.sex;
    LeftEarHearingDevice = test.patient.leftEarDevice;
    TimeWithLeftEarHearingDevice = test.patient.leftEarDeviceYears;
    RightEarHearingDevice = test.patient.leftEarDevice;
    TimeWithRightEarHearingDevice = test.patient.leftEarDeviceYears;
    PatientTable = table(ID, DoB, Sex, LeftEarHearingDevice, RightEarHearingDevice);
    PatientTable
    
end