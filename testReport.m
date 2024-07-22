classdef testReport < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        UIAxes                        matlab.ui.control.UIAxes
        UIAxes2                       matlab.ui.control.UIAxes
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
        System                        Whisper
        currentSound                  Sound
        currentSoundInternalRepresentation
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
            stem(app.UIAxes, real(app.currentSound.internalRepresentation));
    
            spect = app.currentSound.getHumanVoicedSoundBinnedRepresentation();
            stem(app.UIAxes2, real(spect));
        end

        function PlayInternalRepresentation(app, event)
            spectFreqDomain = app.currentSoundInternalRepresentation;
            phase = 2*pi*(rand(app.currentSound.numSamples/2,size(spectFreqDomain,2))-0.5); % assign random phase to freq spec
            s = (10.^(spectFreqDomain./10)).*exp(1i*phase); % convert dB to amplitudes
            ss = [ones(1,size(spectFreqDomain,2)); s; conj(flipud(s))];
            stim = ifft(ss); % transform from freq to time domain
            stim = (stim ./ rms(stim)); % Set dB of stimuli
            PlaySound(stim, app.currentSound.samplingRate, 6, app.System.test.callibratedBaseline);
        end

        function listOut = ListConversion(app, listIn)
            listOut = {};
            for ii = 1:length(listIn)
                listOut{end + 1} = char(string(listIn{ii}.name));
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
            app.bInternalRepresentationPanel.Position = [201 18 747 602];

            % Create Internal Representation frequency chart
            app.UIAxes = uiaxes(app.bInternalRepresentationPanel);
            title(app.UIAxes, 'Internal Representation')
            xlabel(app.UIAxes, 'Frequency')
            ylabel(app.UIAxes, 'Amplitude')
            app.UIAxes.Position = [8 120 380 300];

            % Create Real Sound frequency chart
            app.UIAxes2 = uiaxes(app.bInternalRepresentationPanel);
            title(app.UIAxes2, 'Presented Sound')
            xlabel(app.UIAxes2, 'Frequency')
            ylabel(app.UIAxes2, 'Amplitude')
            app.UIAxes2.Position = [400 120 380 300];

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

            app.toggleLabel();
        end
    end
end