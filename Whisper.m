classdef Whisper < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        versionLabel        matlab.ui.control.Label
        Image               matlab.ui.control.Image
        BeginNewTestButton  matlab.ui.control.Button
        test
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BeginNewTestButton
        function SelectTestType(app, event)
            % Create a Test object
            testObj = Test();
            app.test = testObj;
            % Navigate to test option selection
            NavToTestOptions(app);
        end
    end

    % Component initialization
    methods (Access = public)

        % Create UIFigure and components
        function createComponents(app, UIFigure)
            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));
            app.UIFigure = UIFigure;

            % Create BeginNewTestButton
            app.BeginNewTestButton = uibutton(app.UIFigure, 'push');
            app.BeginNewTestButton.ButtonPushedFcn = createCallbackFcn(app, @SelectTestType, true);
            app.BeginNewTestButton.FontSize = 18;
            app.BeginNewTestButton.Position = [376 199 250 45];
            app.BeginNewTestButton.Text = 'Begin New Test';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [191 243 619 312];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'Whisper Logo Gray.png');

            % Create versionLabel
            app.versionLabel = uilabel(app.UIFigure);
            app.versionLabel.FontSize = 14;
            app.versionLabel.Position = [477 67 47 25];
            app.versionLabel.Text = 'v 0.2.0';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end

        function NavToTestOptions(app)
            % Clear contents of the UI
            for ii = 1:length(app.UIFigure.Children)
                app.UIFigure.Children(ii).Visible = false;
            end

            % Build test options UI
            testOptionSelectionPage = testOptionSelection();
            testOptionSelectionPage.createComponents(app.UIFigure, app);
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Whisper()

            % Create UIFigure and components
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [450 150 1000 700];
            app.UIFigure.Name = 'MATLAB App';
            createComponents(app, app.UIFigure);

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end