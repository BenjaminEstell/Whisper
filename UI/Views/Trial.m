classdef Trial < matlab.apps.AppBase
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
        function obj = Trial(currentSoundName, currentSoundNumber, numSounds, numTrials, system, UIFigure)
            obj.currentSoundName = currentSoundName;
            obj.currentSoundNumber = currentSoundNumber;
            obj.currentTrial = 1;
            obj.numSounds = numSounds;
            obj.numTrials = numTrials;
            obj.System = system;
            obj.UIFigure = UIFigure;
            % Generate Stimulus
            system.test.currentSound.stimulusMatrix = GenerateStimulusMatrix(system.test.currentSound);
            obj.createTestComponents();
            pause(0.4);
            obj.System.test.PlaySounds(obj.currentTrial);
        end

        % Keyboard shortcuts
        function processKeyPress(app, ~, KeyData)
            if KeyData.Key == 'j'
                app.JButton.Value = true;
                app.NextTrial();
            elseif KeyData.Key == 'f'
                app.FButton.Value = true;
                app.NextTrial();
            elseif KeyData.Key == 'space'
                app.System.test.PlaySounds(app.currentTrial);
            end
        end

        function NextTrial(app, ~)
            % Updates the model
            if app.System.test.nextTrial(app.FButton.Value, app.JButton.Value)
                % Updates the UI from the updated model
                app.currentTrial = app.currentTrial + 1;
                app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrial) + ' of ' + string(app.numTrials);
                app.FButton.Value = false;
                app.JButton.Value = false;
                
                % Play sounds
                pause(0.2);
                app.System.test.PlaySounds(app.currentTrial);
            end
        end

        function playSounds(app, ~)
            app.System.test.PlaySounds(app.currentTrial);
        end


        % Create UIFigure and components
        function createTestComponents(app)
            set(app.UIFigure, 'KeyPressFcn', @app.processKeyPress);

            % Create RecognitionPanel
            app.RecognitionPanel = uipanel(app.UIFigure);
            app.RecognitionPanel.Title = 'Syllable Recognition';
            app.RecognitionPanel.FontSize = 14;
            app.RecognitionPanel.Position = [16 16 970 670];

            % Create FButton
            app.FButton = uibutton(app.RecognitionPanel, 'state');
            app.FButton.ValueChangedFcn = createCallbackFcn(app, @NextTrial, false);
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
            app.SoundLabel.Text = '/' + app.currentSoundName + '/';

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

