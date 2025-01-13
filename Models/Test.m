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
    end

    % Callbacks that handle component events
    methods (Access = public)

        % Moves the Test on to the next Sound
        function NextSound(app, UIFigure, Whisper)
            % Delete test components
            while ~isempty(app.RecognitionPanel.Children)
                app.RecognitionPanel.Children(1).delete();
            end
            app.RecognitionPanel.delete();

            view = SoundCard(app.UIFigure);
            app.currentSoundNumber = app.currentSoundNumber + 1;
            app.currentSound = app.sounds{app.currentSoundNumber};
            app.SoundCardSoundCountLabel.Text = 'Sound ' + string(app.currentSoundNumber) + ' of ' + string(app.numSounds);
            app.SoundCardSoundLabel.Visible = true;
            app.SoundCardSoundLabel.Text = '/' + app.currentSound.name + '/';
            set(app.UIFigure, 'KeyPressFcn', @app.processSoundCardKeyPress);


            app.currentSound = app.sounds{app.currentSoundNumber};
            app.currentTrialNumber = 1;
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
        function nextTrial(app, event)
            % If we have finished the last trial, move on to the next sound
            if app.currentTrialNumber == app.numTrials
                % generate the internal representation for this sound
                [app.currentSound.internalRepresentation, app.currentSound.internalRepresentationTimeDomain] = GenerateInternalRepresentation(app.currentSound);
                % save the Sound object back into the Sounds array
                app.sounds{app.currentSoundNumber} = app.currentSound;
                % if we have finished the last sound, end the test
                if app.currentSoundNumber == app.numSounds
                    app.TestReport();
                else
                    % Otherwise, move on to the next Sound
                    app.NextSound();
                end
            else
                % otherwise, move on to the next trial
                app.currentTrialNumber = app.currentTrialNumber + 1;
                app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrialNumber) + ' of ' + string(app.numTrials);
                app.FButton.Value = false;
                app.JButton.Value = false;
                
                % Play sounds
                pause(0.2);
                app.PlaySounds();
            end
        end


        function TestReport(app)
            % Clear contents of the UI
            for ii = 1:length(app.UIFigure.Children)
                app.UIFigure.Children(ii).Visible = false;
            end

            % end the test
            app.endTimestamp = datetime();
            app.duration = app.endTimestamp - app.startTimestamp;
            % save the test data in the Test object
            app.System.test = app;

            % Build test completion UI
            testReportView = testReport();
            testReportView.createTestCompleteCardComponents(app.UIFigure, app.System);
            % generate the dataset
            GenerateDataset(app);
        end

        % Plays the human voiced and computer generated sounds
        function PlaySounds(app, event)
            % Play human voiced sound
            sound(app.currentSound.humanVoicedSoundTimeDomain, app.currentSound.samplingRate);
            % Pause 1.5 seconds
            pause(1.5);

            % Play computer generated sound
            % Get representation in frequency domain and plot stimuli in
            % frequency domain
            stimFrequencyDomain = imresize(app.currentSound.stimulusMatrix(app.currentTrialNumber, :)', [app.currentSound.numFreqs 1], "nearest");
            % figure(1);
            % plot(abs(stimFrequencyDomain));
            % title('Computer-Generated Stimulus');
            % xlabel('Frequency (Hz)');
            % ylabel('Amplitude');

            % Convert stimulus into the time domain and plot
            stim = ifft(app.currentSound.stimulusMatrix(app.currentTrialNumber, :));
            % mirror sound and stretch
            folds = floor(app.currentSound.numSamples / app.currentSound.numFreqs);
            summation = zeros(1, floor(length(stim)/folds));
            for fold = 1:folds
                currentFold = stim(floor(length(stim)*(fold-1)/folds) + 1:floor(length(stim)*fold/folds));
                summation = summation + currentFold;
            end
            stim4 = imresize(summation, [1 length(stim)], 'nearest');
            % set values before and after the real signal to 0.001
            stim4(1:app.currentSound.signalStart) = 0.0001;
            stim4(app.currentSound.signalStop:end) = 0.0001;

            % Play sound
            sound(real(stim4), app.currentSound.samplingRate);
            
            % Plot human voiced sound in frequency domain
            % figure(3);
            % spect = imresize(abs(app.currentSoundObj.humanVoicedSoundFrequencyDomain), [app.currentSoundObj.numFreqs 1], "nearest");
            % plot(spect(1:app.currentSoundObj.numFreqs));
            % title('Human-Voiced Sound');
            % xlabel('Frequency (Hz)');
            % ylabel('Amplitude');

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
        end

        % Called when the user clicks "Begin Test"
        function runTest(app, UIFigure, WhisperIn)
            app.System = WhisperIn;
            % Create Sound Card
            soundCard = SoundCard(UIFigure);
        end

        function createTrial(app, UIFigure)
            t  = Trial(app.currentSound.name, app.currentSoundNumber, app.numSounds, app.numTrials, app.System);

        end
        
    end
end