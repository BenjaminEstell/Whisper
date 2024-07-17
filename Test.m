classdef Test < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        PhonemeRecognitionPanel     matlab.ui.container.Panel
        TestTrialCountLabel            matlab.ui.control.Label
        TestSoundCountLabel             matlab.ui.control.Label
        NextTrialButton             matlab.ui.control.Button
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
        numBins                     int32
        numSounds                   int32
        currentTrial                int32
        currentSound                int32
        currentSoundObj             Sound
        sounds          
        mode                        TestType
        patientID                   string
        testID                      int32
        startTimestamp              
        endTimestamp                
        duration                    
        patient                     Patient
        callibratedBaseline         double
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: FButton
        function ToggleF(app, event)
            value = app.FButton.Value;
            if value
                app.JButton.Value = ~value;
                app.NextTrialButton.Enable = true;
            else
                app.NextTrialButton.Enable = false;
            end
        end

        % Value changed function: JButton
        function ToggleJ(app, event)
            value = app.JButton.Value;
            if value
                app.FButton.Value = ~value;
                app.NextTrialButton.Enable = true;
            else
                app.NextTrialButton.Enable = false;
            end
        end

        % Button pushed function: NextTrialButton
        % Navigates to the next trial
        function NextTrial(app, event)
            % If we have finished the last trial, move on to the next sound
            if app.currentTrial == app.numTrials
                % if we have finished the last sound, end the test
                if app.currentSound == app.numSounds
                    app.TestReport();
                else
                    app.NextSoundCard();
                end
            else
                % otherwise, move on to the next trial
                app.currentTrial = app.currentTrial + 1;
                app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrial) + ' of ' + string(app.numTrials);
                app.FButton.Value = false;
                app.JButton.Value = false;
                app.NextTrialButton.Enable = false;
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

            % Build test completion UI
            testReportView = testReport();
            testReportView.createTestCompleteCardComponents(app.UIFigure, app.System);
        end

        function NextSoundCard(app)
            % Delete test components
            while ~isempty(app.PhonemeRecognitionPanel.Children)
                app.PhonemeRecognitionPanel.Children(1).delete();
            end
            app.PhonemeRecognitionPanel.delete();

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
        end

        % Plays the human voiced and computer generated sounds
        function PlaySounds(app, event)
            % Play human voiced sound
            PlaySound(app.currentSoundObj.humanVoicedSoundTimeDomain, app.currentSoundObj.samplingRate, 50, app.callibratedBaseline);
            % Pause 1.5 seconds
            pause(1.5);
            % Play computer generated sound
            PlaySoundFromRandom(app.currentSoundObj.numSamples, app.currentSoundObj.samplingRate, 65, app.callibratedBaseline);
        end
    end

    % Component initialization
    methods (Access = public)

        % Class constructor
        function obj = Test()
            % Initialize properties to default values
            obj.numTrials = 100;
            obj.numSounds = 0;
            obj.mode = TestType.phoneme;
            obj.sounds = [];
            obj.patientID = '';
            obj.testID = randi([0, 2^32], 1, 1);
            obj.numBins = 256;
            obj.startTimestamp = datetime();
            obj.patient = Patient("0");
            obj.callibratedBaseline = 50;
        end

        % Create UIFigure and components
        function createTestComponents(app, UIFigure)
            app.UIFigure = UIFigure;
            % Create PhonemeRecognitionPanel
            app.PhonemeRecognitionPanel = uipanel(app.UIFigure);
            app.PhonemeRecognitionPanel.Title = 'Phoneme Recognition';
            app.PhonemeRecognitionPanel.FontSize = 14;
            app.PhonemeRecognitionPanel.Position = [16 16 970 670];

            % Create FButton
            app.FButton = uibutton(app.PhonemeRecognitionPanel, 'state');
            app.FButton.ValueChangedFcn = createCallbackFcn(app, @ToggleF, true);
            app.FButton.Text = 'F';
            app.FButton.FontSize = 36;
            app.FButton.Position = [300 316 90 97];

            % Create JButton
            app.JButton = uibutton(app.PhonemeRecognitionPanel, 'state');
            app.JButton.ValueChangedFcn = createCallbackFcn(app, @ToggleJ, true);
            app.JButton.Text = 'J';
            app.JButton.FontSize = 48;
            app.JButton.Position = [593 317 90 97];

            % Create HearSoundsButton
            app.HearSoundsButton = uibutton(app.PhonemeRecognitionPanel, 'push');
            app.HearSoundsButton.ButtonPushedFcn = createCallbackFcn(app, @PlaySounds, true);
            app.HearSoundsButton.FontSize = 18;
            app.HearSoundsButton.Position = [260 149 450 50];
            app.HearSoundsButton.Text = 'Hear Sounds';

            % Create SameLabel
            app.SameLabel = uilabel(app.PhonemeRecognitionPanel);
            app.SameLabel.HorizontalAlignment = 'center';
            app.SameLabel.WordWrap = 'on';
            app.SameLabel.FontSize = 14;
            app.SameLabel.Position = [280 279 130 41];
            app.SameLabel.Text = 'Same';

            % Create DifferentLabel
            app.DifferentLabel = uilabel(app.PhonemeRecognitionPanel);
            app.DifferentLabel.HorizontalAlignment = 'center';
            app.DifferentLabel.WordWrap = 'on';
            app.DifferentLabel.FontSize = 14;
            app.DifferentLabel.Position = [573 280 130 41];
            app.DifferentLabel.Text = 'Different';

            % Create SoundLabel
            app.SoundLabel = uilabel(app.PhonemeRecognitionPanel);
            app.SoundLabel.HorizontalAlignment = 'center';
            app.SoundLabel.FontSize = 48;
            app.SoundLabel.FontWeight = 'bold';
            app.SoundLabel.Position = [388 472 193 63];
            app.SoundLabel.Text = '/' + app.currentSoundObj.name + '/';

            % Create NextTrialButton
            app.NextTrialButton = uibutton(app.PhonemeRecognitionPanel, 'push');
            app.NextTrialButton.ButtonPushedFcn = createCallbackFcn(app, @NextTrial, true);
            app.NextTrialButton.FontSize = 14;
            app.NextTrialButton.Enable = 'off';
            app.NextTrialButton.Position = [698 23 250 45];
            app.NextTrialButton.Text = 'Next Trial';

            % Create TestSoundCountLabel
            app.TestSoundCountLabel = uilabel(app.PhonemeRecognitionPanel);
            app.TestSoundCountLabel.FontSize = 14;
            app.TestSoundCountLabel.Position = [430 647 110 22];
            app.TestSoundCountLabel.Text = 'Sound ' + string(app.currentSound) + ' of ' + string(app.numSounds);

            % Create TestTrialCountLabel
            app.TestTrialCountLabel = uilabel(app.PhonemeRecognitionPanel);
            app.TestTrialCountLabel.FontSize = 14;
            app.TestTrialCountLabel.Position = [878 648 86 22];
            app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrial) + ' of ' + string(app.numTrials);
        end

        function createSoundCardComponents(app, UIFigure, WhisperIn)
            app.UIFigure = UIFigure;
            app.System = WhisperIn;
            app.currentSound = 1;
            app.currentSoundObj = app.sounds{app.currentSound};
            app.currentTrial = 1;

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
            app.SoundCardSoundCountLabel.Position = [448 620 105 22];
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
            app.Label_2.Text = 'Your task is to determine if the two sounds are almost identical, or not. If they sound almost identical, click the button on the left. If they do not sound almost identical, click the button on the right. When you''re ready to move on, click "next trial." You can also use keyboard shortcuts to make your selection.';
        end
    end
end