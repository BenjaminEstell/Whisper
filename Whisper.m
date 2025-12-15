classdef Whisper < matlab.apps.AppBase & handle

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure            matlab.ui.Figure
        VersionLabel        matlab.ui.control.Label
        Image               matlab.ui.control.Image
        BeginNewTestButton  matlab.ui.control.Button
        test                Test
        practiceTest        logical
        testOptionSelection TestOptionSelection
        patientData         PatientData
        practiceTestView    
        testReportView      TestReport
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: BeginNewTestButton
        % Creates and configures the Test
        function createTest(app, ~)
            if exist(app.test)
                % Delete Test obj
                app.test.delete();
            end
            % Create a Test object
            app.test = Test(app, app.UIFigure, 0, 0, TestType.syllable);
            % Configure the Test
            toTestOptions(app);
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

        function setPracticeTest(app, practiceTest)
            app.practiceTest = practiceTest;
        end

        % Clears the UI and loads the Test Option Selection View
        % Called when the user clicks "Begin New Test"
        function toTestOptions(app)
            % clear the current ui
            while ~isempty(app.UIFigure.Children)
                app.UIFigure.Children(1).delete();
            end

            % Build Test Options View
            app.testOptionSelection = TestOptionSelection(app.UIFigure, app);
        end

        function toPatientData(app)
            % Clear contents of the UI
            app.testOptionSelection.delete();
            app.patientData = PatientData(app.UIFigure, app);
        end

        function toTest(app)
            % clear the current ui
            while ~isempty(app.UIFigure.Children)
                app.UIFigure.Children(1).delete();
            end
            app.patientData.delete();
            % Build test UI
            if (app.practiceTest)
                app.practiceTestView = PracticeTest(app, app.UIFigure);
                app.practiceTestView.playSounds(1);
            else
                app.test.runTest();
            end
        end

        function runTest(app)
            % clear the current ui
            while ~isempty(app.UIFigure.Children)
                app.UIFigure.Children(1).delete();
            end
            % Delete practice test
            app.practiceTestView.delete();
            app.test.runTest();
        end

        function toTestReport(app)
            % Generate test report UI
            app.testReportView = TestReport(app.UIFigure, app);
            % generate the dataset from the test
            app.test.generateDataset();
        end

        % Returns to the home screen
        function returnHome(app)
            % Delete the test report view
            app.testReportView.delete();

            % clear the current ui
            while ~isempty(app.UIFigure.Children)
                app.UIFigure.Children(1).delete();
            end

            % Construct Home view
            app.createComponents(app.UIFigure);
        end
    
        % Creates the Whisper Landing Page View
        function createComponents(app, UIFigure)
            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));
            app.UIFigure = UIFigure;

            % Create BeginNewTestButton
            app.BeginNewTestButton = uibutton(app.UIFigure, 'push');
            app.BeginNewTestButton.ButtonPushedFcn = createCallbackFcn(app, @createTest, true);
            app.BeginNewTestButton.FontSize = 18;
            app.BeginNewTestButton.Position = [376 199 250 45];
            app.BeginNewTestButton.Text = 'Begin New Test';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [191 243 619 312];
            app.Image.ImageSource = fullfile(pathToMLAPP, '/UI/Images/Whisper Logo Gray.png');

            % Create VersionLabel
            app.VersionLabel = uilabel(app.UIFigure);
            app.VersionLabel.FontSize = 14;
            app.VersionLabel.Position = [477 67 47 25];
            app.VersionLabel.Text = 'v 1.2';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end

        % Code that executes before app deletion
        function delete(app)
            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end