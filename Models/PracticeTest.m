% Practice Test class
% Extends the Test class
% Used for 5 practice trials with a CNC word before beginning the actual
% test

classdef PracticeTest < Test & matlab.apps.AppBase

    properties 
        RecognitionPanel            matlab.ui.container.Panel
        TestTrialCountLabel         matlab.ui.control.Label
        TestSoundCountLabel         matlab.ui.control.Label
        SoundLabel                  matlab.ui.control.Label
        DifferentLabel              matlab.ui.control.Label
        SameLabel                   matlab.ui.control.Label
        HearSoundsButton            matlab.ui.control.Button
        JButton                     matlab.ui.control.StateButton
        FButton                     matlab.ui.control.StateButton               
    end

    methods (Access = public)
        % Class constructor
        function obj = PracticeTest(WhisperIn, UIFigure)
            % Construct superclass, test
            numTrials = 5;
            numSounds = 1;
            obj@Test(WhisperIn, UIFigure, numTrials, numSounds, TestType.cnc);
            % Initialize properties to default values
            randomNum = randperm(499, obj.numSounds);
            testSound = Sound(string(randomNum), TestType.cnc, obj.numTrials);
            obj.sounds{end+1} = testSound;
            obj.currentSound = obj.sounds{1};
            obj.currentSound = obj.currentSound.generateStimulusMatrix();

            obj.createTestComponents();
        end

        % Plays the sounds for the trial. Passes the call to the Test
        % superclass
        % Returns: Nothing
        function playSounds(app, ~)
            playSounds@Test(app, app.currentTrialNumber);
        end

        % Navigates to the next trial
        % Called when the user makes a selection
        % Returns: Nothing
        function nextTrial(app, ~)
            % If we have finished the last trial, move on to the test
            if app.currentTrialNumber == app.numTrials
                app.System.runTest();
            else
                % otherwise, move on to the next trial
                app.currentTrialNumber = app.currentTrialNumber + 1;
                app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrialNumber) + ' of ' + string(app.numTrials);
                app.FButton.Value = false;
                app.JButton.Value = false;
                
                % Play sounds
                pause(0.1);
                app.playSounds(app.currentTrialNumber);
            end
        end
    end

    methods (Access = private)

        % Processes keyboard input
        % Args
            % KeyData       The key that was pressed
        % Returns: Nothing
        function processKeyPress(app, ~, KeyData)
            if KeyData.Key == 'j'
                app.JButton.Value = true;
                app.nextTrial();
            elseif KeyData.Key == 'f'
                app.FButton.Value = true;
                app.nextTrial();
            elseif KeyData.Key == 'space'
                app.playSounds();
            end
        end

        function createTestComponents(app)
            set(app.UIFigure, 'KeyPressFcn', @app.processKeyPress);

            % Create RecognitionPanel
            app.RecognitionPanel = uipanel(app.UIFigure);
            app.RecognitionPanel.Title = 'Syllable Recognition';
            app.RecognitionPanel.FontSize = 14;
            app.RecognitionPanel.Position = [16 16 970 670];

            % Create FButton
            app.FButton = uibutton(app.RecognitionPanel, 'state');
            app.FButton.ValueChangedFcn = createCallbackFcn(app, @nextTrial, true);
            app.FButton.Text = 'F';
            app.FButton.FontSize = 48;
            app.FButton.Position = [300 316 90 97];

            % Create JButton
            app.JButton = uibutton(app.RecognitionPanel, 'state');
            app.JButton.ValueChangedFcn = createCallbackFcn(app, @nextTrial, true);
            app.JButton.Text = 'J';
            app.JButton.FontSize = 48;
            app.JButton.Position = [593 317 90 97];

            % Create HearSoundsButton
            app.HearSoundsButton = uibutton(app.RecognitionPanel, 'push');
            app.HearSoundsButton.ButtonPushedFcn = createCallbackFcn(app, @playSounds, true);
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
            app.SoundLabel.Text = '/' + app.currentSound.name + '/';

            % Create TestSoundCountLabel
            app.TestSoundCountLabel = uilabel(app.RecognitionPanel);
            app.TestSoundCountLabel.FontSize = 14;
            app.TestSoundCountLabel.Position = [425 647 115 22];
            app.TestSoundCountLabel.Text = 'Practice Sound';

            % Create TestTrialCountLabel
            app.TestTrialCountLabel = uilabel(app.RecognitionPanel);
            app.TestTrialCountLabel.FontSize = 14;
            app.TestTrialCountLabel.Position = [865 648 94 22];
            app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrialNumber) + ' of ' + string(app.numTrials);
        end

    end
end