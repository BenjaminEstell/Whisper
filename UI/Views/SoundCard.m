classdef SoundCard < matlab.apps.AppBase
    
    properties
        UIFigure                    matlab.ui.Figure
        SoundCardSoundCountLabel    matlab.ui.control.Label
        SoundCardSoundLabel         matlab.ui.control.Label
        ContinueButton              matlab.ui.control.Button
        Label_2                     matlab.ui.control.Label
        Label                       matlab.ui.control.Label
        System                      Whisper
        t                           Trial
    end
    
    methods

        function obj = SoundCard(UIFigure, WhisperIn)
            obj.System = WhisperIn;
            obj.UIFigure = UIFigure;
            obj.createComponents();
        end

        % Button pushed function: ContinueButton
        % User has clicked "Begin
        function BeginTrials(app, ~)
            % Create the trial
            app.t  = Trial(app.System.test.currentSound.name, app.System.test.currentSoundNumber, app.System.test.numSounds, app.System.test.numTrials, app.System, app.UIFigure);
        end

        % Updates the Sound Card with the next sound and deletes the
        % previous Trial's UI
        function nextSound(app)
            app.SoundCardSoundLabel.Text = '/' + app.System.test.currentSound.name + '/';
            app.SoundCardSoundCountLabel.Text = 'Sound ' + string(app.System.test.currentSoundNumber) + ' of ' + string(app.System.test.numSounds);

            % Delete Trial
            while ~isempty(app.t.RecognitionPanel.Children)
                app.t.RecognitionPanel.Children(1).delete();
            end
            app.t.RecognitionPanel.delete();
            app.t.delete();

            
        end

        function processSoundCardKeyPress(app, KeyData)
            if KeyData.Key == 'return'
                app.nextSound();
            end
        end
        
        function createComponents(app)
            set(app.UIFigure, 'KeyPressFcn', @app.processSoundCardKeyPress);
            % Create SoundCardSoundLabel
            app.SoundCardSoundLabel = uilabel(app.UIFigure);
            app.SoundCardSoundLabel.HorizontalAlignment = 'center';
            app.SoundCardSoundLabel.FontSize = 48;
            app.SoundCardSoundLabel.FontWeight = 'bold';
            app.SoundCardSoundLabel.Position = [416 169 193 63];
            app.SoundCardSoundLabel.Text = '/' + app.System.test.currentSound.name + '/';

            % Create SoundCardSoundCountLabel
            app.SoundCardSoundCountLabel = uilabel(app.UIFigure);
            app.SoundCardSoundCountLabel.HorizontalAlignment = 'center';
            app.SoundCardSoundCountLabel.FontSize = 14;
            app.SoundCardSoundCountLabel.Position = [440 620 115 22];
            app.SoundCardSoundCountLabel.Text = 'Sound ' + string(app.System.test.currentSoundNumber) + ' of ' + string(app.System.test.numSounds);

            % Create ContinueButton
            app.ContinueButton = uibutton(app.UIFigure, 'push');
            app.ContinueButton.ButtonPushedFcn = createCallbackFcn(app, @BeginTrials, true);
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

