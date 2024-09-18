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
        Label_2                     matlab.ui.control.Label
        Label                       matlab.ui.control.Label
        ContinueButton              matlab.ui.control.Button
        SoundCardSoundCountLabel    matlab.ui.control.Label
        SoundCardSoundLabel         matlab.ui.control.Label
        System                      Whisper
        numTrials                   int32
        numSounds                   int32
        currentTrial                int32
        currentSound                int32
        currentSoundObj             Sound
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

        % Navigates to the next trial
        function NextTrial(app, event)
            % save the patient's response in the response vector
            if app.FButton.Value
                % Patient selected "similar"
                app.currentSoundObj.responseVector(app.currentTrial) = 1;
            elseif app.JButton.Value
                % Patient selected "not similar"
                app.currentSoundObj.responseVector(app.currentTrial) = -1;
            end
            % If we have finished the last trial, move on to the next sound
            if app.currentTrial == app.numTrials
                % generate the internal representation for this sound
                [app.currentSoundObj.internalRepresentation, app.currentSoundObj.internalRepresentationTimeDomain] = GenerateInternalRepresentation(app.currentSoundObj);
                % save the Sound object back into the Sounds array
                app.sounds{app.currentSound} = app.currentSoundObj;
                % if we have finished the last sound, end the test
                if app.currentSound == app.numSounds
                    app.TestReport();
                else
                    % Otherwise, move on to the next Sound
                    app.NextSoundCard();
                end
            else
                % otherwise, move on to the next trial
                app.currentTrial = app.currentTrial + 1;
                app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrial) + ' of ' + string(app.numTrials);
                app.FButton.Value = false;
                app.JButton.Value = false;
                
                % Play sounds
                pause(0.2);
                app.PlaySounds();
            end

        end

        % Keyboard shortcuts
        function processKeyPress(app, event, KeyData)
            if KeyData.Key == 'j'
                app.JButton.Value = true;
                app.NextTrial();
            elseif KeyData.Key == 'f'
                app.FButton.Value = true;
                app.NextTrial();
            elseif KeyData.Key == 'space'
                app.PlaySounds();
            end
        end

        function processSoundCardKeyPress(app, event, KeyData)
            if KeyData.Key == 'return'
                app.nextSound();
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

        function NextSoundCard(app)
            % Delete test components
            while ~isempty(app.RecognitionPanel.Children)
                app.RecognitionPanel.Children(1).delete();
            end
            app.RecognitionPanel.delete();

            % unhide sound card components
            app.Label_2.Visible = true;
            app.Label.Visible = true;
            app.ContinueButton.Visible = true;
            app.SoundCardSoundCountLabel.Visible = true;
            app.currentSound = app.currentSound + 1;
            app.currentSoundObj = app.sounds{app.currentSound};
            app.SoundCardSoundCountLabel.Text = 'Sound ' + string(app.currentSound) + ' of ' + string(app.numSounds);
            app.SoundCardSoundLabel.Visible = true;
            app.SoundCardSoundLabel.Text = '/' + app.currentSoundObj.name + '/';
            set(app.UIFigure, 'KeyPressFcn', @app.processSoundCardKeyPress);

            % generate the stimulus matrix for the next sound
            app.currentSoundObj.stimulusMatrix = GenerateStimulusMatrix(app.currentSoundObj);
        end


         % Button pushed function: ContinueButton
        function nextSound(app, event)
            % Hide sound card components
            for ii = 1:length(app.UIFigure.Children)
                app.UIFigure.Children(ii).Visible = false;
            end
            % create test components
            app.createTestComponents(app.UIFigure);
            app.currentTrial = 1;
            app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrial) + ' of ' + string(app.numTrials);

            % Play sounds
            pause(0.4);
            app.PlaySounds();
        end

        % Plays the human voiced and computer generated sounds
        function PlaySounds(app, event)
            % Play human voiced sound
            sound(app.currentSoundObj.humanVoicedSoundTimeDomain, app.currentSoundObj.samplingRate);
            % Pause 1.5 seconds
            pause(1.5);

            % Play computer generated sound
            % Get representation in frequency domain and plot stimuli in
            % frequency domain
            stimFrequencyDomain = imresize(app.currentSoundObj.stimulusMatrix(app.currentTrial, :)', [app.currentSoundObj.numFreqs 1], "nearest");
            % figure(1);
            % plot(abs(stimFrequencyDomain));
            % title('Computer-Generated Stimulus');
            % xlabel('Frequency (Hz)');
            % ylabel('Amplitude');

            % Convert stimulus into the time domain and plot
            stim = ifft(app.currentSoundObj.stimulusMatrix(app.currentTrial, :));
            % mirror sound and stretch
            folds = floor(app.currentSoundObj.numSamples / app.currentSoundObj.numFreqs);
            summation = zeros(1, floor(length(stim)/folds));
            for fold = 1:folds
                currentFold = stim(floor(length(stim)*(fold-1)/folds) + 1:floor(length(stim)*fold/folds));
                summation = summation + currentFold;
            end
            stim4 = imresize(summation, [1 length(stim)], 'nearest');
            % set values before and after the real signal to 0.001
            stim4(1:app.currentSoundObj.signalStart) = 0.0001;
            stim4(app.currentSoundObj.signalStop:end) = 0.0001;

            % Play sound
            sound(real(stim4), app.currentSoundObj.samplingRate);
            
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
        end

        % Create UIFigure and components
        function createTestComponents(app, UIFigure)
            app.UIFigure = UIFigure;
            set(app.UIFigure, 'KeyPressFcn', @app.processKeyPress);

            % Create RecognitionPanel
            app.RecognitionPanel = uipanel(app.UIFigure);
            app.RecognitionPanel.Title = 'Syllable Recognition';
            app.RecognitionPanel.FontSize = 14;
            app.RecognitionPanel.Position = [16 16 970 670];

            % Create FButton
            app.FButton = uibutton(app.RecognitionPanel, 'state');
            app.FButton.ValueChangedFcn = createCallbackFcn(app, @NextTrial, true);
            app.FButton.Text = 'F';
            app.FButton.FontSize = 48;
            app.FButton.Position = [300 316 90 97];

            % Create JButton
            app.JButton = uibutton(app.RecognitionPanel, 'state');
            app.JButton.ValueChangedFcn = createCallbackFcn(app, @NextTrial, true);
            app.JButton.Text = 'J';
            app.JButton.FontSize = 48;
            app.JButton.Position = [593 317 90 97];

            % Create HearSoundsButton
            app.HearSoundsButton = uibutton(app.RecognitionPanel, 'push');
            app.HearSoundsButton.ButtonPushedFcn = createCallbackFcn(app, @PlaySounds, true);
            app.HearSoundsButton.FontSize = 18;
            app.HearSoundsButton.Position = [260 149 450 50];
            app.HearSoundsButton.Text = 'Hear Sounds';

            % Create SameLabel
            app.SameLabel = uilabel(app.RecognitionPanel);
            app.SameLabel.HorizontalAlignment = 'center';
            app.SameLabel.WordWrap = 'on';
            app.SameLabel.FontSize = 18;
            app.SameLabel.Position = [280 279 130 41];
            app.SameLabel.Text = 'Similar';

            % Create DifferentLabel
            app.DifferentLabel = uilabel(app.RecognitionPanel);
            app.DifferentLabel.HorizontalAlignment = 'center';
            app.DifferentLabel.WordWrap = 'on';
            app.DifferentLabel.FontSize = 18;
            app.DifferentLabel.Position = [573 280 130 41];
            app.DifferentLabel.Text = 'Different';

            % Create SoundLabel
            app.SoundLabel = uilabel(app.RecognitionPanel);
            app.SoundLabel.HorizontalAlignment = 'center';
            app.SoundLabel.FontSize = 48;
            app.SoundLabel.FontWeight = 'bold';
            app.SoundLabel.Position = [388 472 193 63];
            app.SoundLabel.Text = '/' + app.currentSoundObj.name + '/';

            % Create TestSoundCountLabel
            app.TestSoundCountLabel = uilabel(app.RecognitionPanel);
            app.TestSoundCountLabel.FontSize = 14;
            app.TestSoundCountLabel.Position = [425 647 115 22];
            app.TestSoundCountLabel.Text = 'Sound ' + string(app.currentSound) + ' of ' + string(app.numSounds);

            % Create TestTrialCountLabel
            app.TestTrialCountLabel = uilabel(app.RecognitionPanel);
            app.TestTrialCountLabel.FontSize = 14;
            app.TestTrialCountLabel.Position = [865 648 94 22];
            app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrial) + ' of ' + string(app.numTrials);
        end

        function createSoundCardComponents(app, UIFigure, WhisperIn)
            app.UIFigure = UIFigure;
            app.System = WhisperIn;
            app.currentSound = 1;
            app.currentSoundObj = app.sounds{app.currentSound};
            app.currentTrial = 1;
            app.currentSoundObj.stimulusMatrix = GenerateStimulusMatrix(app.currentSoundObj);

            % Create SoundCardSoundLabel
            app.SoundCardSoundLabel = uilabel(app.UIFigure);
            app.SoundCardSoundLabel.HorizontalAlignment = 'center';
            app.SoundCardSoundLabel.FontSize = 48;
            app.SoundCardSoundLabel.FontWeight = 'bold';
            app.SoundCardSoundLabel.Position = [416 169 193 63];
            app.SoundCardSoundLabel.Text = '/' + app.currentSoundObj.name + '/';

            % Create SoundCardSoundCountLabel
            app.SoundCardSoundCountLabel = uilabel(app.UIFigure);
            app.SoundCardSoundCountLabel.HorizontalAlignment = 'center';
            app.SoundCardSoundCountLabel.FontSize = 14;
            app.SoundCardSoundCountLabel.Position = [440 620 115 22];
            app.SoundCardSoundCountLabel.Text = 'Sound ' + string(app.currentSound) + ' of ' + string(app.numSounds);

            % Create ContinueButton
            app.ContinueButton = uibutton(app.UIFigure, 'push');
            app.ContinueButton.ButtonPushedFcn = createCallbackFcn(app, @nextSound, true);
            app.ContinueButton.FontSize = 14;
            app.ContinueButton.Position = [723 33 250 45];
            app.ContinueButton.Text = 'Continue';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'center';
            app.Label.WordWrap = 'on';
            app.Label.FontSize = 18;
            app.Label.Position = [101 449 811 118];
            app.Label.Text = 'Instructions: On the next screen, you will be presented with two sounds. The first is a human voice speaking the sound written below. The second is a computer generated sound.';

            % Create Label_2
            app.Label_2 = uilabel(app.UIFigure);
            app.Label_2.HorizontalAlignment = 'center';
            app.Label_2.WordWrap = 'on';
            app.Label_2.FontSize = 18;
            app.Label_2.Position = [101 360 811 133];
            app.Label_2.Text = 'Your task is to determine if the two sounds are almost similar, or not. If they sound similar, click the button on the left. If they do not sound similar, click the button on the right. You can also use keyboard shortcuts to make your selection.';
        end
    end
end