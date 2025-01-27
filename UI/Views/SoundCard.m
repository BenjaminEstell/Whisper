classdef SoundCard < matlab.apps.AppBase
    % Sound Card
    % Constructs the UI for the sound cards for the test
    properties
        UIFigure                    matlab.ui.Figure
        SoundCardSoundCountLabel    matlab.ui.control.Label
        SoundCardSoundLabel         matlab.ui.control.Label
        ContinueButton              matlab.ui.control.Button
        Label_2                     matlab.ui.control.Label
        Label                       matlab.ui.control.Label
        System                      Whisper
    end
    
    methods
        % SoundCard Constructor
        function obj = SoundCard(UIFigure, WhisperIn)
            obj.System = WhisperIn;
            obj.UIFigure = UIFigure;
            obj.createComponents();
        end

        % Creates a Trial object to begin trials for the sound
        % Called when the user clicks the "Continue" button
        function beginTrials(app, ~)
            % Create the trial
            app.System.test.createTrial();
        end

        % Updates the Sound Card with the next sound and deletes the
        % previous Trial's UI
        % Called when the last trial of a sound is completed, and another
        % Sound needs to be completed
        function nextSound(app)
            app.SoundCardSoundLabel.Text = '/' + app.System.test.getCurrentSound().name + '/';
            app.SoundCardSoundCountLabel.Text = 'Sound ' + string(app.System.test.getCurrentSoundNumber()) + ' of ' + string(app.System.test.getNumSounds());
            set(app.UIFigure, 'KeyPressFcn', @app.processSoundCardKeyPress);
        end

        % Handles the keyboard shortcut to begin trials
        % Args
            % KeyData       the value of the key that was pressed
        % Returns: Nothing
        function processSoundCardKeyPress(app, ~, KeyData)
            if KeyData.Key == "return"
                app.beginTrials();
            end
        end
        
        % Builds the SoundCard UI
        function createComponents(app)
            % Allows the UIFigure to respond to keyboard inputs
            set(app.UIFigure, 'KeyPressFcn', @app.processSoundCardKeyPress);

            % Create SoundCardSoundLabel
            app.SoundCardSoundLabel = uilabel(app.UIFigure);
            app.SoundCardSoundLabel.HorizontalAlignment = 'center';
            app.SoundCardSoundLabel.FontSize = 48;
            app.SoundCardSoundLabel.FontWeight = 'bold';
            app.SoundCardSoundLabel.Position = [416 169 193 63];
            app.SoundCardSoundLabel.Text = '/' + app.System.test.getCurrentSound().name + '/';

            % Create SoundCardSoundCountLabel
            app.SoundCardSoundCountLabel = uilabel(app.UIFigure);
            app.SoundCardSoundCountLabel.HorizontalAlignment = 'center';
            app.SoundCardSoundCountLabel.FontSize = 14;
            app.SoundCardSoundCountLabel.Position = [440 620 115 22];
            app.SoundCardSoundCountLabel.Text = 'Sound ' + string(app.System.test.getCurrentSoundNumber()) + ' of ' + string(app.System.test.getNumSounds());

            % Create ContinueButton
            app.ContinueButton = uibutton(app.UIFigure, 'push');
            app.ContinueButton.ButtonPushedFcn = createCallbackFcn(app, @beginTrials, true);
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

