classdef TestReport < matlab.apps.AppBase
    % Test Report
    % UI for the test report displayed at the conclusion of the test

    properties
        UIFigure                      matlab.ui.Figure
        UIAxes                        matlab.ui.control.UIAxes
        TestCompletePanel             matlab.ui.container.Panel
        TestCompletionHomeButton      matlab.ui.control.Button
        ViewTestReportButton          matlab.ui.control.Button
        EndOfTestLabel                matlab.ui.control.Label
        TestReportPanel               matlab.ui.container.Panel
        TestReportHomeButton          matlab.ui.control.Button
        InternalRepresentationPanel   matlab.ui.container.Panel
        PlaySoundButton               matlab.ui.control.Button
        SoundListBox                  matlab.ui.control.ListBox
        SoundListBoxLabel             matlab.ui.control.Label
        ShowInternalRepresentationButton matlab.ui.control.CheckBox
        ShowHumanVoicedSoundButton    matlab.ui.control.CheckBox
        System                        Whisper
        currentSound                  Sound
        showIR                        logical
        showHVS                       logical
    end

    methods

        % Test Report Constructor
        % Constructs a Test Report object and generates the test completetion
        % screen UI
        % Args
            % UIFigure      matlab.ui.Figure    a reference to the figure used to display the trial
            % system        Whisper a reference to the global system object
        % Returns: the constructed TestReport
        function obj = TestReport(UIFigure, system)
            obj.UIFigure = UIFigure;
            obj.System = system;
            obj.createTestCompleteCardComponents();
            obj.currentSound = obj.System.test.getFirstSound();
            obj.showIR = true;
            obj.showHVS = true;
        end

        % Returns to the Home Screen
        % Called when the user clicks the "Return Home" button
        % Returns: Nothing
        function ReturnHome(app, ~)
           app.System.returnHome();
        end

        % Displays the Test Report
        % Called when the user clicks the "View Test Report" button
        % Returns: Nothing
        function ViewTestReport(app, ~)
            % Clear contents of the test completion UI
            for ii = 1:length(app.UIFigure.Children)
                app.UIFigure.Children(ii).Visible = false;
            end

            % Build test report UI
            app.createTestReportComponents();
        end

        % Displays the test report of a new sound
        % Called when the user selects the test report of a new sound
        % Returns: Nothing
        function toggleLabel(app, ~)
            value = app.SoundListBox.Value;
            % get the current Sound object from the name
            sounds = app.System.test.getSounds();
            for ii = 1:length(sounds)
                sd = sounds{ii};
                if strcmp(sd.name, value)
                    app.currentSound = sd;
                    break;
                end
            end
            app.InternalRepresentationPanel.Title = value + " Internal Representation";

            % Update graphs
            app.updatePlot();
        end

        % Plays the reconstructed sound
        % Called when the user clicks the "Play Internal Representation" button
        % Returns: Nothing
        function PlayInternalRepresentation(app, ~)
            % Play sound
            sound(real(app.currentSound.internalRepresentationTimeDomain), app.currentSound.samplingRate);
        end

        % Updates the test report plots
        % Called when the user toggles what graphs are plotted
        % Returns: Nothing
        function ToggleInternalRepresentation(app, ~)
            app.showIR = ~app.showIR;
            app.updatePlot();
        end

        % Updates the test report plots
        % Called when the user toggles what graphs are plotted
        % Returns: Nothing
        function ToggleHumanVoicedSound(app, ~)
            app.showHVS = ~app.showHVS;
            app.updatePlot();
        end

        % Updates the test report axes
        % Called whenever an axes control is toggled
        function updatePlot(app)
            % Get the list of x values
            x = 1:app.currentSound.numFreqs;
            OGSound = imresize(app.currentSound.humanVoicedSoundFrequencyDomain, [app.currentSound.numFreqs 1], "nearest");
            internalRepresentation = imresize(app.currentSound.internalRepresentation, [app.currentSound.numFreqs 1], "nearest");
            % Scale internal representation to match the OG sound
            match = rms(OGSound(1:app.currentSound.numFreqs)) / rms(internalRepresentation);
            if app.showIR && app.showHVS
                % Display internal representation and human voiced sound
                area(app.UIAxes, x, (abs(internalRepresentation).*match), FaceColor='b', EdgeColor='b', FaceAlpha=0.3, EdgeAlpha=0.3);
                hold(app.UIAxes, "on");
                area(app.UIAxes, x, abs(OGSound(1:app.currentSound.numFreqs)), FaceColor='r', EdgeColor='r', FaceAlpha=0.3, EdgeAlpha=0.3);
                legend(app.UIAxes, 'Internal Representation', 'Human-Voiced Sound');
                hold(app.UIAxes, "off");
            elseif app.showIR && ~app.showHVS
                % Display only the internal representation
                area(app.UIAxes, x, (abs(internalRepresentation).*match), FaceColor='b', EdgeColor='b', FaceAlpha=0.3, EdgeAlpha=0.3);
                legend(app.UIAxes, 'Internal Representation');
            elseif app.showHVS && ~ app.showIR
                % Display only the human voiced sound
                area(app.UIAxes, x, abs(OGSound(1:app.currentSound.numFreqs)), FaceColor='r', EdgeColor='r', FaceAlpha=0.3, EdgeAlpha=0.3);
                legend(app.UIAxes, 'Human-Voiced Sound');
            else
                % Clear all plots from the axes
                cla(app.UIAxes);
            end
        end

        % Create UIFigure and components
        function createTestCompleteCardComponents(app)
            % Create TestCompletePanel
            app.TestCompletePanel = uipanel(app.UIFigure);
            app.TestCompletePanel.Title = string(app.System.test.getTestMode()) + ' Test Complete';
            app.TestCompletePanel.FontSize = 14;
            app.TestCompletePanel.Position = [16 16 970 670];

            % Create EndOfTestLabel
            app.EndOfTestLabel = uilabel(app.TestCompletePanel);
            app.EndOfTestLabel.HorizontalAlignment = 'center';
            app.EndOfTestLabel.WordWrap = 'on';
            app.EndOfTestLabel.FontSize = 36;
            app.EndOfTestLabel.FontWeight = 'bold';
            app.EndOfTestLabel.Position = [51 374 868 133];
            app.EndOfTestLabel.Text = {'Congratulations! '; 'You''ve reached the end of the test.'};

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
        function createTestReportComponents(app)
            % Create TestReportPanel
            app.TestReportPanel = uipanel(app.UIFigure);
            app.TestReportPanel.Title = 'Test Report - Patient ' + string(app.System.test.getPatient().ID);
            app.TestReportPanel.FontSize = 14;
            app.TestReportPanel.Position = [16 16 970 670];

            % Create SoundListBoxLabel
            app.SoundListBoxLabel = uilabel(app.TestReportPanel);
            app.SoundListBoxLabel.HorizontalAlignment = 'right';
            app.SoundListBoxLabel.FontSize = 14;
            app.SoundListBoxLabel.Position = [52 598 65 22];
            app.SoundListBoxLabel.Text = string(app.System.test.getTestMode());

            % Create SoundListBox
            app.SoundListBox = uilistbox(app.TestReportPanel);
            app.SoundListBox.Items = ListConversion(app.System.test.getSounds());
            app.SoundListBox.ValueChangedFcn = createCallbackFcn(app, @toggleLabel, true);
            app.SoundListBox.FontSize = 14;
            app.SoundListBox.Position = [16 137 101 462];
            app.SoundListBox.Value = app.SoundListBox.Items(1);

            % Create bInternalRepresentationPanel
            app.InternalRepresentationPanel = uipanel(app.TestReportPanel);
            app.InternalRepresentationPanel.Title = string(app.currentSound.name) + ' Internal Representation';
            app.InternalRepresentationPanel.FontSize = 14;
            app.InternalRepresentationPanel.Position = [190 18 770 602];

            % Create frequency chart
            app.UIAxes = uiaxes(app.InternalRepresentationPanel);
            title(app.UIAxes, 'Internal Representation')
            xlabel(app.UIAxes, 'Frequency (Hz)')
            ylabel(app.UIAxes, 'Amplitude')
            app.UIAxes.Position = [8 60 750 510];

            % Create PlaySoundButton
            app.PlaySoundButton = uibutton(app.InternalRepresentationPanel, 'push');
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
            
            % Create ShowInternalRepresentationButton
            app.ShowInternalRepresentationButton = uicheckbox(app.InternalRepresentationPanel);
            app.ShowInternalRepresentationButton.ValueChangedFcn = createCallbackFcn(app, @ToggleInternalRepresentation, true);
            app.ShowInternalRepresentationButton.Text = 'show Internal Representation';
            app.ShowInternalRepresentationButton.FontSize = 14;
            app.ShowInternalRepresentationButton.Position = [40 40 200 22];
            app.ShowInternalRepresentationButton.Value = true;

            % Create showHumanVoicedSoundButton
            app.ShowHumanVoicedSoundButton = uicheckbox(app.InternalRepresentationPanel);
            app.ShowHumanVoicedSoundButton.ValueChangedFcn = createCallbackFcn(app, @ToggleHumanVoicedSound, true);
            app.ShowHumanVoicedSoundButton.Text = 'show Human Voiced Sound';
            app.ShowHumanVoicedSoundButton.FontSize = 14;
            app.ShowHumanVoicedSoundButton.Position = [40 10 200 22];
            app.ShowHumanVoicedSoundButton.Value = true;

            % Displays the test report for the first sound
            app.toggleLabel();
        end
    end
end