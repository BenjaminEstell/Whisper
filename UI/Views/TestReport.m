classdef TestReport < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        UIAxes                        matlab.ui.control.UIAxes
        TestCompletePanel             matlab.ui.container.Panel
        TestCompletionHomeButton      matlab.ui.control.Button
        ViewTestReportButton          matlab.ui.control.Button
        CongratulationsYouvereachedtheendofthetestLabel  matlab.ui.control.Label
        TestReportPanel               matlab.ui.container.Panel
        TestReportHomeButton          matlab.ui.control.Button
        bInternalRepresentationPanel  matlab.ui.container.Panel
        PlaySoundButton               matlab.ui.control.Button
        SoundListBox                  matlab.ui.control.ListBox
        SoundListBoxLabel             matlab.ui.control.Label
        showInternalRepresentationButton matlab.ui.control.CheckBox
        showHumanVoicedSoundButton    matlab.ui.control.CheckBox
        System                        Whisper
        currentSound                  Sound
        showIR                        
        showHVS
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: HomeButton
        function ReturnHome(app, event)
            % Destroy all UI elements except UIFigure
            while ~isempty(app.UIFigure.Children)
                app.UIFigure.Children(1).delete();
            end

            % Construct Home view
            app.System.createComponents(app.System.UIFigure);
        end

        % Button pushed function: ViewTestReportButton
        function ViewTestReport(app, event)
            % Clear contents of the UI
            for ii = 1:length(app.UIFigure.Children)
                app.UIFigure.Children(ii).Visible = false;
            end

            % Build test report UI
            app.createTestReportComponents(app.UIFigure);
        end

        % Value changed function: SoundListBox
        function toggleLabel(app, event)
            value = app.SoundListBox.Value;
            % get the current Sound object from the name
            for ii = 1:length(app.System.test.sounds)
                sd = app.System.test.sounds{ii};
                if strcmp(sd.name, value)
                    app.currentSound = sd;
                    break;
                end
            end
            app.bInternalRepresentationPanel.Title = value + " Internal Representation";

            % Update graphs
            app.UpdatePlot();
        end

        function PlayInternalRepresentation(app, event)
            % Play sound
            PlaySound(real(app.currentSound.internalRepresentationTimeDomain), app.currentSound.samplingRate, 6, app.System.test.callibratedBaseline);
        end

        function listOut = ListConversion(app, listIn)
            listOut = {};
            for ii = 1:length(listIn)
                listOut{end + 1} = char(string(listIn{ii}.name));
            end
        end

        function ToggleInternalRepresentation(app, event)
            app.showIR = ~app.showIR;
            app.UpdatePlot();
        end

        function ToggleHumanVoicedSound(app, event)
            app.showHVS = ~app.showHVS;
            app.UpdatePlot();
        end

        % Updates the plot
        function UpdatePlot(app)
            x = 1:app.currentSound.numFreqs;
            OGSound = imresize(app.currentSound.humanVoicedSoundFrequencyDomain, [app.currentSound.numFreqs 1], "nearest");
            internalRepresentation = imresize(app.currentSound.internalRepresentation, [app.currentSound.numFreqs 1], "nearest");
            % Scale internal representation to match the OG sound
            match = rms(OGSound(1:app.currentSound.numFreqs)) / rms(internalRepresentation);
            if app.showIR && app.showHVS
                area(app.UIAxes, x, (abs(internalRepresentation).*match), FaceColor='b', EdgeColor='b', FaceAlpha=0.3, EdgeAlpha=0.3);
                hold(app.UIAxes, "on");
                area(app.UIAxes, x, abs(OGSound(1:app.currentSound.numFreqs)), FaceColor='r', EdgeColor='r', FaceAlpha=0.3, EdgeAlpha=0.3);
                legend(app.UIAxes, 'Internal Representation', 'Human-Voiced Sound');
                hold(app.UIAxes, "off");
            elseif app.showIR && ~app.showHVS
                area(app.UIAxes, x, (abs(internalRepresentation).*match), FaceColor='b', EdgeColor='b', FaceAlpha=0.3, EdgeAlpha=0.3);
                legend(app.UIAxes, 'Internal Representation');
            elseif app.showHVS && ~ app.showIR
                area(app.UIAxes, x, abs(OGSound(1:app.currentSound.numFreqs)), FaceColor='r', EdgeColor='r', FaceAlpha=0.3, EdgeAlpha=0.3);
                legend(app.UIAxes, 'Human-Voiced Sound');
            else
                cla(app.UIAxes);
            end
        end
    end

    % Component initialization
    methods (Access = public)

        % Create UIFigure and components
        function createTestCompleteCardComponents(app, UIFigure, WhisperIn)
            app.UIFigure = UIFigure;
            app.System = WhisperIn;

            % Create TestCompletePanel
            app.TestCompletePanel = uipanel(app.UIFigure);
            app.TestCompletePanel.Title = string(app.System.test.mode) + ' Test Complete';
            app.TestCompletePanel.FontSize = 14;
            app.TestCompletePanel.Position = [16 16 970 670];

            % Create CongratulationsYouvereachedtheendofthetestLabel
            app.CongratulationsYouvereachedtheendofthetestLabel = uilabel(app.TestCompletePanel);
            app.CongratulationsYouvereachedtheendofthetestLabel.HorizontalAlignment = 'center';
            app.CongratulationsYouvereachedtheendofthetestLabel.WordWrap = 'on';
            app.CongratulationsYouvereachedtheendofthetestLabel.FontSize = 36;
            app.CongratulationsYouvereachedtheendofthetestLabel.FontWeight = 'bold';
            app.CongratulationsYouvereachedtheendofthetestLabel.Position = [51 374 868 133];
            app.CongratulationsYouvereachedtheendofthetestLabel.Text = {'Congratulations! '; 'You''ve reached the end of the test.'};

            % Create ViewTestReportButton
            app.ViewTestReportButton = uibutton(app.TestCompletePanel, 'push');
            app.ViewTestReportButton.ButtonPushedFcn = createCallbackFcn(app, @ViewTestReport, true);
            app.ViewTestReportButton.FontSize = 18;
            app.ViewTestReportButton.Position = [360 202 250 55];
            app.ViewTestReportButton.Text = 'View Test Report';

            % Create TestCompletionHomeButton
            app.TestCompletionHomeButton = uibutton(app.TestCompletePanel, 'push');
            app.TestCompletionHomeButton.ButtonPushedFcn = createCallbackFcn(app, @ReturnHome, true);
            app.TestCompletionHomeButton.FontSize = 18;
            app.TestCompletionHomeButton.Position = [360 93 250 55];
            app.TestCompletionHomeButton.Text = 'Home';

        end

        % Create UIFigure and components
        function createTestReportComponents(app, UIFigure)
            app.UIFigure = UIFigure;
            app.currentSound = app.System.test.sounds{1};
            app.showIR = true;
            app.showHVS = true;


            % Create TestReportPanel
            app.TestReportPanel = uipanel(app.UIFigure);
            app.TestReportPanel.Title = 'Test Report - Patient ' + string(app.System.test.patient.ID);
            app.TestReportPanel.FontSize = 14;
            app.TestReportPanel.Position = [16 16 970 670];

            % Create SoundListBoxLabel
            app.SoundListBoxLabel = uilabel(app.TestReportPanel);
            app.SoundListBoxLabel.HorizontalAlignment = 'right';
            app.SoundListBoxLabel.FontSize = 14;
            app.SoundListBoxLabel.Position = [52 598 65 22];
            app.SoundListBoxLabel.Text = string(app.System.test.mode);

            % Create SoundListBox
            app.SoundListBox = uilistbox(app.TestReportPanel);
            app.SoundListBox.Items = app.ListConversion(app.System.test.sounds);
            app.SoundListBox.ValueChangedFcn = createCallbackFcn(app, @toggleLabel, true);
            app.SoundListBox.FontSize = 14;
            app.SoundListBox.Position = [16 137 101 462];
            app.SoundListBox.Value = app.SoundListBox.Items(1);

            % Create bInternalRepresentationPanel
            app.bInternalRepresentationPanel = uipanel(app.TestReportPanel);
            app.bInternalRepresentationPanel.Title = string(app.currentSound.name) + ' Internal Representation';
            app.bInternalRepresentationPanel.FontSize = 14;
            app.bInternalRepresentationPanel.Position = [190 18 770 602];

            % Create frequency chart
            app.UIAxes = uiaxes(app.bInternalRepresentationPanel);
            title(app.UIAxes, 'Internal Representation')
            xlabel(app.UIAxes, 'Frequency (Hz)')
            ylabel(app.UIAxes, 'Amplitude')
            app.UIAxes.Position = [8 60 750 510];

            % Create PlaySoundButton
            app.PlaySoundButton = uibutton(app.bInternalRepresentationPanel, 'push');
            app.PlaySoundButton.ButtonPushedFcn = createCallbackFcn(app, @PlayInternalRepresentation, true);
            app.PlaySoundButton.FontSize = 14;
            app.PlaySoundButton.Position = [259 10 250 45];
            app.PlaySoundButton.Text = 'Play Sound';

            % Create TestReportHomeButton
            app.TestReportHomeButton = uibutton(app.TestReportPanel, 'push');
            app.TestReportHomeButton.ButtonPushedFcn = createCallbackFcn(app, @ReturnHome, true);
            app.TestReportHomeButton.FontSize = 18;
            app.TestReportHomeButton.Position = [16 28 150 45];
            app.TestReportHomeButton.Text = 'Home';
            
            % Create showInternalRepresentationButton
            app.showInternalRepresentationButton = uicheckbox(app.bInternalRepresentationPanel);
            app.showInternalRepresentationButton.ValueChangedFcn = createCallbackFcn(app, @ToggleInternalRepresentation, true);
            app.showInternalRepresentationButton.Text = 'show Internal Representation';
            app.showInternalRepresentationButton.FontSize = 14;
            app.showInternalRepresentationButton.Position = [40 40 200 22];
            app.showInternalRepresentationButton.Value = true;

            % Create showHumanVoicedSoundButton
            app.showHumanVoicedSoundButton = uicheckbox(app.bInternalRepresentationPanel);
            app.showHumanVoicedSoundButton.ValueChangedFcn = createCallbackFcn(app, @ToggleHumanVoicedSound, true);
            app.showHumanVoicedSoundButton.Text = 'show Human Voiced Sound';
            app.showHumanVoicedSoundButton.FontSize = 14;
            app.showHumanVoicedSoundButton.Position = [40 10 200 22];
            app.showHumanVoicedSoundButton.Value = true;

            app.toggleLabel();
        end
    end
end