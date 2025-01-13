classdef Trial
    %TRIAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        UIFigure            matlab.ui.Figure
        RecognitionPanel     matlab.ui.container.Panel
        JButton                     matlab.ui.control.StateButton
        FButton                     matlab.ui.control.StateButton
        SoundLabel                     matlab.ui.control.Label
        DifferentLabel              matlab.ui.control.Label
        SameLabel                   matlab.ui.control.Label
        HearSoundsButton            matlab.ui.control.Button
        TestTrialCountLabel            matlab.ui.control.Label
        TestSoundCountLabel             matlab.ui.control.Label
        currentSoundName
        currentSoundNumber
        numSounds
        currentTrial
        numTrials
        System                  Whisper
    end
    
    methods

        % Trial Constructor
        function obj = Trial(currentSoundName, currentSoundNumber, numSounds, numTrials, system)
            obj.currentSoundName = currentSoundName;
            obj.currentSoundNumber = currentSoundNumber;
            obj.currentTrial = 1;
            obj.numSounds = numSounds;
            obj.numTrials = numTrials;
            obj.System = system;

            pause(0.4);
            app.System.test.PlaySounds();
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
                app.System.test.PlaySounds();
            end
        end

        function processSoundCardKeyPress(app, event, KeyData)
            if KeyData.Key == 'return'
                app.nextSound();
            end
        end

        function nextTrial(app, ~)
            % Plays the next sounds
            app.System.test.PlaySounds();
            % Saves stuff
            app.System.test.saveUserResponse(app.FButton.Value, app.JButton.Value);
            % Updates the model
            app.System.test.nextTrial();
            % Updates the UI

            
        end

        function playSounds(app, ~)
            app.System.test.PlaySounds();
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
            app.SoundLabel.Text = '/' + app.currentSoundName.name + '/';

            % Create TestSoundCountLabel
            app.TestSoundCountLabel = uilabel(app.RecognitionPanel);
            app.TestSoundCountLabel.FontSize = 14;
            app.TestSoundCountLabel.Position = [425 647 115 22];
            app.TestSoundCountLabel.Text = 'Sound ' + string(app.currentSoundNumber) + ' of ' + string(app.numSounds);

            % Create TestTrialCountLabel
            app.TestTrialCountLabel = uilabel(app.RecognitionPanel);
            app.TestTrialCountLabel.FontSize = 14;
            app.TestTrialCountLabel.Position = [865 648 94 22];
            app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrial) + ' of ' + string(app.numTrials);
        end
    end
end

