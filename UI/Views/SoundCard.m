classdef SoundCard < matlab.apps.AppBase
    
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

        function obj = SoundCard(UIFigure)
            obj.createComponents(UIFigure);
        end

        % Button pushed function: ContinueButton
        % User has clicked "Begin
        function BeginTrials(app, ~)
            % Create the trial
            t  = Trial(app.currentSound.name, app.currentSoundNumber, app.numSounds, app.numTrials, app.System);
            t.createTestComponents(app.UIFigure);
        end
        
        function createComponents(app, UIFigure)
            app.UIFigure = UIFigure;

            % Create SoundCardSoundLabel
            app.SoundCardSoundLabel = uilabel(app.UIFigure);
            app.SoundCardSoundLabel.HorizontalAlignment = 'center';
            app.SoundCardSoundLabel.FontSize = 48;
            app.SoundCardSoundLabel.FontWeight = 'bold';
            app.SoundCardSoundLabel.Position = [416 169 193 63];
            app.SoundCardSoundLabel.Text = '/' + app.System.test.currentSoundObj.name + '/';

            % Create SoundCardSoundCountLabel
            app.SoundCardSoundCountLabel = uilabel(app.UIFigure);
            app.SoundCardSoundCountLabel.HorizontalAlignment = 'center';
            app.SoundCardSoundCountLabel.FontSize = 14;
            app.SoundCardSoundCountLabel.Position = [440 620 115 22];
            app.SoundCardSoundCountLabel.Text = 'Sound ' + string(app.System.test.currentSound) + ' of ' + string(app.System.test.numSounds);

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

