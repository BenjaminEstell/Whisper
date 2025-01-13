classdef Whisper < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        versionLabel        matlab.ui.control.Label
        Image               matlab.ui.control.Image
        BeginNewTestButton  matlab.ui.control.Button
        test
        practiceTest
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BeginNewTestButton
        % Creates and configures the Test
        function CreateTest(app, ~)
            % Create a Test object
            testObj = Test();
            app.test = testObj;
            % Configure the Test
            NavToTestOptions(app);
        end

        % Clears the UI and loads the Test Option Selection View
        function NavToTestOptions(app)
            % Clear contents of the UI
            for ii = 1:length(app.UIFigure.Children)
                app.UIFigure.Children(ii).Visible = false;
            end

            % Build Test Options View
            testOptionSelectionPage = TestOptionSelection();
            testOptionSelectionPage.createComponents(app.UIFigure, app);
        end

        % Creates the Whisper Landing Page View
        function createComponents(app, UIFigure)
            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));
            app.UIFigure = UIFigure;

            % Create BeginNewTestButton
            app.BeginNewTestButton = uibutton(app.UIFigure, 'push');
            app.BeginNewTestButton.ButtonPushedFcn = createCallbackFcn(app, @CreateTest, true);
            app.BeginNewTestButton.FontSize = 18;
            app.BeginNewTestButton.Position = [376 199 250 45];
            app.BeginNewTestButton.Text = 'Begin New Test';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [191 243 619 312];
            app.Image.ImageSource = fullfile(pathToMLAPP, '/UI/Images/Whisper Logo Gray.png');

            % Create versionLabel
            app.versionLabel = uilabel(app.UIFigure);
            app.versionLabel.FontSize = 14;
            app.versionLabel.Position = [477 67 47 25];
            app.versionLabel.Text = 'v 1.0';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
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