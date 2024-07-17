classdef volumeCallibration < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        VolumeCallibrationPanel  matlab.ui.container.Panel
        Image2                   matlab.ui.control.Image
        Image                    matlab.ui.control.Image
        BeginTestButton          matlab.ui.control.Button
        PlayToneButton           matlab.ui.control.Button
        DragthevolumeslideruntiltheaudiotoneisjustbarelynoticeableLabel  matlab.ui.control.Label
        VolumeSlider             matlab.ui.control.Slider
        System                   Whisper
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: PlayToneButton
        function toggleTone(app, event)
            PlaySingleTone(app.System.test.callibratedBaseline);
        end

        % Button pushed function: BeginTestButton
        function BeginTest(app, event)
            % Clear contents of the UI
            for ii = 1:length(app.UIFigure.Children)
                app.UIFigure.Children(ii).Visible = false;
            end
            % Construct Test UI
            bimodalIntegrationTestView = app.System.test;
            bimodalIntegrationTestView.createSoundCardComponents(app.UIFigure, app.System);
        end

        % Update the gain
        function updateGain(app, event)
            app.System.test.callibratedBaseline = app.VolumeSlider.Value;
        end
    end

    % Component initialization
    methods (Access = public)

        % Create UIFigure and components
        function createComponents(app, UIFigure, WhisperIn)
            app.UIFigure = UIFigure;
            app.System = WhisperIn;

            % Create VolumeCallibrationPanel
            app.VolumeCallibrationPanel = uipanel(app.UIFigure);
            app.VolumeCallibrationPanel.Title = 'Volume Callibration';
            app.VolumeCallibrationPanel.FontSize = 14;
            app.VolumeCallibrationPanel.Position = [16 16 970 670];

            % Create VolumeSlider
            app.VolumeSlider = uislider(app.VolumeCallibrationPanel);
            app.VolumeSlider.MajorTicks = [];
            app.VolumeSlider.MinorTicks = [];
            app.VolumeSlider.FontSize = 14;
            app.VolumeSlider.Position = [235 277 500 3];
            app.VolumeSlider.Value = 50;
            app.VolumeSlider.ValueChangedFcn = createCallbackFcn(app, @updateGain, true);

            % Create DragthevolumeslideruntiltheaudiotoneisjustbarelynoticeableLabel
            app.DragthevolumeslideruntiltheaudiotoneisjustbarelynoticeableLabel = uilabel(app.VolumeCallibrationPanel);
            app.DragthevolumeslideruntiltheaudiotoneisjustbarelynoticeableLabel.HorizontalAlignment = 'center';
            app.DragthevolumeslideruntiltheaudiotoneisjustbarelynoticeableLabel.WordWrap = 'on';
            app.DragthevolumeslideruntiltheaudiotoneisjustbarelynoticeableLabel.FontSize = 24;
            app.DragthevolumeslideruntiltheaudiotoneisjustbarelynoticeableLabel.Position = [78 358 814 59];
            app.DragthevolumeslideruntiltheaudiotoneisjustbarelynoticeableLabel.Text = 'Drag the volume slider until the audio tone is just barely noticeable. Then, click ''Begin Test''.';

            % Create PlayToneButton
            app.PlayToneButton = uibutton(app.VolumeCallibrationPanel, 'push');
            app.PlayToneButton.ButtonPushedFcn = createCallbackFcn(app, @toggleTone, true);
            app.PlayToneButton.Text = 'Play Tone';
            app.PlayToneButton.FontSize = 14;
            app.PlayToneButton.Position = [360 162 250 45];

            % Create BeginTestButton
            app.BeginTestButton = uibutton(app.VolumeCallibrationPanel, 'push');
            app.BeginTestButton.ButtonPushedFcn = createCallbackFcn(app, @BeginTest, true);
            app.BeginTestButton.FontSize = 14;
            app.BeginTestButton.FontWeight = 'bold';
            app.BeginTestButton.FontColor = [0.851 0.3255 0.098];
            app.BeginTestButton.Position = [698 23 250 45];
            app.BeginTestButton.Text = 'Begin Test';

            % Create Image
            app.Image = uiimage(app.VolumeCallibrationPanel);
            app.Image.Position = [162 258 60 40];
            app.Image.ImageSource = 'volume-low.svg';

            % Create Image2
            app.Image2 = uiimage(app.VolumeCallibrationPanel);
            app.Image2.Position = [765 258 50 40];
            app.Image2.ImageSource = 'volume-high.svg';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end
end