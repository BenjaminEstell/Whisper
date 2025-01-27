classdef Test < handle
    % Test
    % Class that represents the Test
    properties (GetAccess = ?PracticeTest)
        UIFigure                    matlab.ui.Figure
        System                      Whisper
        numTrials                   int32
        numSounds                   int32
        currentTrialNumber          int32
        currentTrial                Trial
        currentSoundNumber          int32
        currentSound                Sound
        sounds          
        mode                        TestType
        testID                      int32
        startTimestamp              
        endTimestamp                
        duration                    
        patient                     Patient
        savePath                    string
        soundCard                   SoundCard
        trial                       Trial
    end

    methods (Access = public)

        % Test constructor
        function obj = Test(WhisperIn, UIFigure, numTrials, numSounds, mode)
            % Initialize properties to default values
            obj.UIFigure = UIFigure;
            obj.System = WhisperIn;
            obj.numTrials = numTrials;
            obj.numSounds = numSounds;
            obj.mode = mode;
            obj.sounds = [];
            obj.testID = randi([0, 2^32], 1, 1);
            obj.startTimestamp = datetime();
            obj.patient = Patient("0", "0", "male");
            obj.currentSoundNumber = 1;
            obj.currentTrialNumber = 1;
        end

        % Creates the sound card of the initial sound in the test
        % Called when the user clicks "Begin Test"
        % Returns: Nothing
        function runTest(app)
            % Create Sound Card, which will be reused for each sound
            app.currentSound = app.sounds{1};
            app.soundCard = SoundCard(app.UIFigure, app.System);
        end

        % Creates a new sound and appends it to the tests sounds
        % Called when the test options are being configured
        % Returns: The updated test
        function createSound(app, name, type)
            newSound = Sound(name, type, app.numTrials);
            % store the new Sound in the Test
            app.sounds{end+1} = newSound;
        end

        function setSound(app, testSound)
            app.sounds{end+1} = testSound;
            app.currentSound = app.sounds{1};
        end

        function createPatient(app, ID, DOB, sex)
            app.patient = Patient(ID, DOB, sex);
        end

        function setPatientHearing(app, leftDevice, leftYears, rightDevice, rightYears)
            app.patient.setPatientHearing(leftDevice, leftYears, rightDevice, rightYears);
        end

        % ear takes the value "right" or "left to signify the ear
        % args a-h correspond to the hearing threshold (in dB) level for
        % 125Hz, 250 Hz, 500 Hz .... 8000Hz
        function setPatientHearingThresholds(app, ear, a, b, c, d, e, f, g, h)
            app.patient.setHearingThresholds(ear, a, b, c, d, e, f, g, h);
        end

        function setTestMode(app, type)
            app.mode = type;
        end

        function setNumTrials(app, numTrials)
            app.numTrials = numTrials;
        end

        function setSavePath(app, path)
            app.savePath = path;
        end

        function sound = getFirstSound(app)
            sound = app.sounds{1};
        end

        function sound = getCurrentSound(app)
            sound = app.sounds{app.currentSoundNumber};
        end

        function num = getCurrentSoundNumber(app)
            num = app.currentSoundNumber;
        end

        function num = getNumSounds(app)
            num = app.numSounds;
        end

        function mode = getTestMode(app)
            mode = app.mode;
        end

        function sounds = getSounds(app)
            sounds = app.sounds;
        end

        function patient = getPatient(app)
            patient = app.patient;
        end

        % Sets the number of sounds in the test
        % Called when the test is finished being configured
        function finishSoundSelection(app)
            app.numSounds = length(app.sounds);
        end

        % Generates numSounds random CNC words and adds them to sounds
        % Called when the user configures of test of CNC words
        % Args
            % numSounds     int     the number of sounds to generate
        % Returns: The Test
        function generateCNCSounds(app, numSounds)
            app.numSounds = numSounds;
            cncMap = MapCNCNames();
            % pick random numbers between 0 and 499 
            randomNumberSet = randperm(499, app.numSounds);
            % for each random number, construct a Sound object
            for ii = 1:size(randomNumberSet, 1)
                newSound = Sound(string(randomNumberSet(ii)), TestType.cnc, app.numTrials);
                newSound = newSound.setName(lookup(cncMap, newSound.name));
                % store the new Sound in the Test
                app.sounds{end+1} = newSound;
            end
        end

        % Updates the test and trial models
        % Called when the user makes a selection during each trial
        % Returns: val      logical     true if another trial should be
        % performed. False if there are no more trials for this sound.
        function val = nextTrial(app, FVal, JVal)
            % Save the user response
            app.saveUserResponse(FVal, JVal);
            % If we have finished the last trial, move on to the next sound
            if app.currentTrialNumber == app.numTrials
                % generate the internal representation for this sound
                app.currentSound.generateInternalRepresentation();
                % save the Sound object back into the Sounds array
                app.sounds{app.currentSoundNumber} = app.currentSound;
                val = false;
            else
                % otherwise, continue to the next trial  
                app.currentTrialNumber = app.currentTrialNumber + 1;
                val = true;
            end
        end

        function completeTrial(app)
            % if we have finished the last sound, end the test
            if app.currentSoundNumber == app.numSounds
                app.testReport();
                % delete the completed Trial
                app.deleteTrial();
            else
                % delete the completed Trial
                app.deleteTrial();
                % Otherwise, move on to the next Sound
                app.nextSound();
            end
        end

        % Plays the human voiced and computer generated sounds
        % Called when the trial begins or when users request that the
        % sounds be played again
        % Returns: Nothing
        function playSounds(app, currentTrialNumber)
            % Play human voiced sound
            sound(app.currentSound.humanVoicedSoundTimeDomain, app.currentSound.samplingRate);
            % Pause 1.5 seconds
            pause(1.5);

            % Play computer generated sound sound
            sound(app.currentSound.getStimulusTimeDomain(currentTrialNumber), app.currentSound.samplingRate);
        end

        % Creates a trial
        % Called when the user moves on to the trials from the Sound Card
        % Returns: Nothing
        function createTrial(app)
            app.trial = Trial(app.currentSound.name, app.currentSoundNumber, app.numSounds, app.numTrials, app.System, app.UIFigure);
        end

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
            % save the original sound as txt
            % Chart of the original sound as png
            % Chart of the internal representation as png
            % Chart of the response vector as png
            % Difference chart as png
  
        function generateDataset(app)
            % Create dataset folder
            folderName = string(app.patient.ID) + "-" + strrep(string(app.startTimestamp), ':', '.');
            truncatedPath = split(app.savePath, ':');
            path = truncatedPath(2);
            [status, msg, msgID] = mkdir(path, folderName);
            if ~status
                % Folder could not be created
                msg
                msgID
            else
                folderPath = fullfile(path, folderName);
                
                % Save Patient Data
                patientTablePath = fullfile(folderPath, "PatientData.txt");
                ID = app.patient.ID;
                DoB = app.patient.DOB;
                Sex = app.patient.sex;
                LeftEarHearingDevice = app.patient.leftEarDevice;
                TimeWithLeftEarHearingDevice = app.patient.leftEarDeviceYears;
                RightEarHearingDevice = app.patient.rightEarDevice;
                TimeWithRightEarHearingDevice = app.patient.rightEarDeviceYears;
                Left125Hz = app.patient.left125;
                Left250Hz = app.patient.left250;
                Left500Hz = app.patient.left500;
                Left1000Hz = app.patient.left1000;
                Left2000Hz = app.patient.left2000;
                Left3000Hz = app.patient.left3000;
                Left4000Hz = app.patient.left4000;
                Left8000Hz = app.patient.left8000;
                Right125Hz = app.patient.right125;
                Right250Hz = app.patient.right250;
                Right500Hz = app.patient.right500;
                Right1000Hz = app.patient.right1000;
                Right2000Hz = app.patient.right2000;
                Right3000Hz = app.patient.right3000;
                Right4000Hz = app.patient.right4000;
                Right8000Hz = app.patient.right8000;

                PatientTable = table(ID, DoB, Sex, LeftEarHearingDevice, TimeWithLeftEarHearingDevice, RightEarHearingDevice, TimeWithRightEarHearingDevice, ...
                    Left125Hz, Left250Hz, Left500Hz, Left1000Hz, Left2000Hz, Left3000Hz, Left4000Hz, Left8000Hz, ...
                    Right125Hz, Right250Hz, Right500Hz, Right1000Hz, Right2000Hz, Right3000Hz, Right4000Hz, Right8000Hz);
                writetable(PatientTable, patientTablePath)
            
                % Save Test Data
                testTablePath = fullfile(folderPath, "TestData.txt");
                StartTime = app.startTimestamp;
                EndTime = app.endTimestamp;
                Duration = app.duration;
                NumberOfTrials = app.numTrials;
                TestTable = table(StartTime, EndTime, Duration, NumberOfTrials);
                writetable(TestTable, testTablePath);
            
                % Save Sounds
                mkdir(folderPath, "Sounds");
                for soundIdx = 1:app.numSounds
                    sound = app.sounds{soundIdx};
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
                    % Save original sound as txt
                    writematrix(sound.humanVoicedSoundTimeDomain, fullfile(soundPath, "OriginalSound.txt"));
                    
                    % Save HVS as png
                    x = 1:sound.numFreqs;
                    OGSound = imresize(sound.humanVoicedSoundFrequencyDomain, [sound.numFreqs 1], "nearest");
                    internalRepresentation = imresize(sound.internalRepresentation, [sound.numFreqs 1], "nearest");
                    match = rms(OGSound(1:sound.numFreqs)) / rms(internalRepresentation);
                    fig1 = figure('Visible','off');
                    HVSChart = axes(fig1);
                    plot(HVSChart, x, SegmentedSmooth(abs(OGSound(1:sound.numFreqs)), 30, 3));
                    legend(HVSChart, 'Human-Voiced Sound');
                    xlabel(HVSChart, "Frequency (Hz)");
                    ylabel(HVSChart, "Amplitude");
                    title(HVSChart, "Human Voiced Sound Frequency Components");
                    saveas(HVSChart, fullfile(soundPath, "HVS.png"), 'png');

                    % Save IR as png
                    fig2 = figure('Visible','off');
                    IRChart = axes(fig2);
                    plot(IRChart, x, SegmentedSmooth(abs(internalRepresentation), 30, 3).*match);
                    legend(IRChart, 'Internal Representation');
                    xlabel(IRChart, "Frequency (Hz)");
                    ylabel(IRChart, "Amplitude");
                    title(IRChart, "Internal Representation Frequency Components");
                    saveas(IRChart, fullfile(soundPath, "InternalRepresentation.png"), 'png');            
            
                    % Save combined chart as png
                    fig3 = figure('Visible','off');
                    CombinedChart = axes(fig3);
                    area(CombinedChart, x, (SegmentedSmooth(abs(internalRepresentation), 30, 3).*match), FaceColor='b', EdgeColor='b', FaceAlpha=0.3, EdgeAlpha=0.3);
                    hold(CombinedChart, "on");
                    area(CombinedChart, x, SegmentedSmooth(abs(OGSound(1:sound.numFreqs)), 30, 3), FaceColor='r', EdgeColor='r', FaceAlpha=0.3, EdgeAlpha=0.3);
                    legend(CombinedChart, 'Internal Representation', 'Human-Voiced Sound');
                    hold(CombinedChart, "off");
                    xlabel(CombinedChart, "Frequency (Hz)");
                    ylabel(CombinedChart, "Amplitude");
                    title(CombinedChart, "Human Voiced Sound and Internal Representation Frequency Components");
                    saveas(CombinedChart, fullfile(soundPath, "AreaChart.png"), 'png');
            
                    % save responseVector as png
                    fig4 = figure('Visible','off');
                    responseVectorChart = axes(fig4);
                    scatter(responseVectorChart, 1:sound.numTrials, sound.responseVector);
                    xlabel(responseVectorChart, "Trial Number");
                    ylabel(responseVectorChart, "Patient Response (1=similar, -1=not similar)");
                    title(responseVectorChart, "Patient Responses");
                    saveas(responseVectorChart, fullfile(soundPath, "ResponseVector.png"), 'png');
                    
                    % save difference chart as png
                    fig5 = figure('Visible', 'off');
                    differenceChart = axes(fig5);
                    scaledInternalRepresentation = SegmentedSmooth(abs(internalRepresentation(1:sound.numFreqs)).*match, 30, 3);
                    scaledOriginalSound = SegmentedSmooth(abs(OGSound(1:sound.numFreqs)), 30, 3);
                    diff = scaledOriginalSound - scaledInternalRepresentation;

                    plot(differenceChart, x, diff, 'blue');
                    hold(differenceChart, "on");
                    horizontalLine = zeros(1, sound.numFreqs);
                    plot(differenceChart, x, horizontalLine, '--');
                    xlabel(differenceChart, "Frequency (Hz)");
                    ylabel(differenceChart, "Amplitude");
                    title(differenceChart, 'Difference between Internal Representation and Human-Voiced Sound');
                    saveas(differenceChart, fullfile(soundPath, "DifferenceChart.png"), 'png');
                end
            end
        end
    end

    % Private Methods
    methods (Access = private)
        % Moves the Test on to the next Sound
        % Called when the last trial for a sound has been completed
        function nextSound(app)
            % Update current sound values
            app.currentSoundNumber = app.currentSoundNumber + 1;
            app.currentSound = app.sounds{app.currentSoundNumber};
            app.currentTrialNumber = 1;

            % update the sound card's components
            app.soundCard.nextSound();
        end
    
        % Saves the patient's response in the response vector
        % Called when the user moves on to the next trial
        % Returns: Nothing
        function saveUserResponse(app, similar, different)
            if similar
                % Patient selected "similar"
                app.currentSound.responseVector(app.currentTrialNumber) = 1;
            elseif different
                % Patient selected "not similar"
                app.currentSound.responseVector(app.currentTrialNumber) = -1;
            end
        end

        % Generates the dataset and test report UI
        % Called when the last trial of the last sound is competed
        % Returns: Nothing
        function testReport(app)
            % Delete the Sound Card
            app.soundCard.delete();

            % end the test
            app.endTimestamp = datetime();
            app.duration = app.endTimestamp - app.startTimestamp;

            % Build test completion UI
            app.System.toTestReport();
        end

        % Deletes a trial
        % Called when all trials for a sound have been completed
        % Returns: Nothing
        function deleteTrial(app)
            app.trial.delete();
        end

    end
end