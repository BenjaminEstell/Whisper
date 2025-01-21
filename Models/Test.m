classdef Test < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        RecognitionPanel     matlab.ui.container.Panel
        TestTrialCountLabel            matlab.ui.control.Label
        TestSoundCountLabel             matlab.ui.control.Label
        SoundLabel                     matlab.ui.control.Label
        DifferentLabel              matlab.ui.control.Label
        SameLabel                   matlab.ui.control.Label
        HearSoundsButton            matlab.ui.control.Button
        JButton                     matlab.ui.control.StateButton
        FButton                     matlab.ui.control.StateButton
        
        
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
    end

    % Callbacks that handle component events
    methods (Access = public)

        % Moves the Test on to the next Sound
        function NextSound(app)
            % Update current sound values
            app.currentSoundNumber = app.currentSoundNumber + 1;
            app.currentSound = app.sounds{app.currentSoundNumber};
            app.currentTrialNumber = 1;

            % update the sound card's components and deletes the previous
            % trial UI
            app.soundCard.nextSound();
        end

        function saveUserResponse(app, similar, different)
            % save the patient's response in the response vector
            if similar
                % Patient selected "similar"
                app.currentSound.responseVector(app.currentTrialNumber) = 1;
            elseif different
                % Patient selected "not similar"
                app.currentSound.responseVector(app.currentTrialNumber) = -1;
            end
        end

        % Updates the test and trial models
        function val = nextTrial(app, FVal, JVal)
            % Save the user response
            app.saveUserResponse(FVal, JVal);
            % If we have finished the last trial, move on to the next sound
            if app.currentTrialNumber == app.numTrials
                % generate the internal representation for this sound
                [app.currentSound.internalRepresentation, app.currentSound.internalRepresentationTimeDomain] = GenerateInternalRepresentation(app.currentSound);
                % save the Sound object back into the Sounds array
                app.sounds{app.currentSoundNumber} = app.currentSound;
                % if we have finished the last sound, end the test
                if app.currentSoundNumber == app.numSounds
                    app.testReport();
                else
                    % Otherwise, move on to the next Sound
                    app.NextSound();
                end
                val = false;
            else
                % otherwise, continue to the next trial  
                app.currentTrialNumber = app.currentTrialNumber + 1;
                val = true;
            end
        end


        function testReport(app)
            % Clear contents of the UI
            %for ii = 1:length(app.UIFigure.Children)
            %    app.UIFigure.Children(ii).Visible = false;
            %end
            app.soundCard.delete();

            % end the test
            app.endTimestamp = datetime();
            app.duration = app.endTimestamp - app.startTimestamp;
            % save the test data in the Test object. This is probably not
            % necessary
            % app.System.test = app;

            % Build test completion UI
            testReportView = TestReport();
            testReportView.createTestCompleteCardComponents(app.UIFigure, app.System);
            % generate the dataset
            GenerateDataset(app);
        end

        % Plays the human voiced and computer generated sounds
        function PlaySounds(app, currentTrialNumber)
            % Play human voiced sound
            sound(app.currentSound.humanVoicedSoundTimeDomain, app.currentSound.samplingRate);
            % Pause 1.5 seconds
            pause(1.5);

            % Play computer generated sound sound
            sound(app.currentSound.getStimulusTimeDomain(currentTrialNumber), app.currentSound.samplingRate);
        end
    end

    % Component initialization
    methods (Access = public)

        % Class constructor
        function obj = Test()
            % Initialize properties to default values
            obj.numTrials = 100;
            obj.numSounds = 0;
            obj.mode = TestType.syllable;
            obj.sounds = [];
            obj.testID = randi([0, 2^32], 1, 1);
            obj.startTimestamp = datetime();
            obj.patient = Patient("0");
            obj.currentSoundNumber = 1;
            obj.currentTrialNumber = 1;
        end

        % Called when the user clicks "Begin Test"
        function runTest(app, UIFigure, WhisperIn)
            app.UIFigure = UIFigure;
            app.System = WhisperIn;
            % Create Sound Card, which will be reused for each sound in the
            % test
            app.System.test.currentSound = app.System.test.sounds{1};
            app.soundCard = SoundCard(app.UIFigure, app.System);
        end
        
    end
end