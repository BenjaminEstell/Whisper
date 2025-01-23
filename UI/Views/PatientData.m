classdef PatientData < matlab.apps.AppBase
    % Patient Data
    % Constructs the UI to collect patient data before beginning the test

    properties (Access = public)
        UIFigure                            matlab.ui.Figure
        PatientDataPanel                    matlab.ui.container.Panel
        RightEarEditField                   matlab.ui.control.NumericEditField
        RightEarEditField_2Label            matlab.ui.control.Label
        BeginTestButton                     matlab.ui.control.Button
        LeftEarEditField                    matlab.ui.control.NumericEditField
        LeftEarEditFieldLabel               matlab.ui.control.Label
        Panel                               matlab.ui.container.Panel
        SexDropDown                         matlab.ui.control.DropDown
        SexDropDownLabel                    matlab.ui.control.Label
        DateofBirthDatePicker               matlab.ui.control.DatePicker
        DateofBirthDatePickerLabel          matlab.ui.control.Label
        PatientIDEditField                  matlab.ui.control.EditField
        PatientIDEditFieldLabel             matlab.ui.control.Label
        RightEarHearingDeviceDropDown       matlab.ui.control.DropDown
        RightEarHearingDeviceDropDownLabel  matlab.ui.control.Label
        LeftEarHearingDeviceDropDown        matlab.ui.control.DropDown
        LeftEarHearingDeviceDropDownLabel   matlab.ui.control.Label
        System                              Whisper
    end

    methods (Access = public)

        % PatientData constructor
        function obj = PatientData(UIFigure, WhisperIn)
            obj.UIFigure = UIFigure;
            obj.System = WhisperIn;
            obj.createComponents();
        end

    end

    methods (Access = private)

        function configurePatientData(app)
            app.System.test.createPatient(app.PatientIDEditField.Value, app.DateofBirthDatePicker.Value, app.SexDropDown.Value);
            app.System.test.setPatientHearing(app.LeftEarHearingDeviceDropDown.Value, app.LeftEarEditField.Value, app.RightEarHearingDeviceDropDown.Value, app.RightEarEditField.Value);
        end

        % Value changed function: LeftEarHearingDeviceDropDown
        function leftEarSelection(app, ~)
            value = app.LeftEarHearingDeviceDropDown.Value;
            if strcmp(value, "None")
                app.LeftEarEditField.Enable = false;
            else
                app.LeftEarEditField.Enable = true;
            end
        end

        % Value changed function: RightEarHearingDeviceDropDown
        function rightEarSelection(app, ~)
            value = app.RightEarHearingDeviceDropDown.Value;
            if strcmp(value, "None")
                app.RightEarEditField.Enable = false;
            else
                app.RightEarEditField.Enable = true;
            end
        end

        % Saves patient data, and begins the test
        % Called when the user selects "Begin Test"
        function beginTest(app, ~)
            % Save selections
            app.configurePatientData();
            app.System.toTest();
        end

        % Create UIFigure and components
        function createComponents(app)

            % Create PatientDataPanel
            app.PatientDataPanel = uipanel(app.UIFigure);
            app.PatientDataPanel.Title = 'Patient Data';
            app.PatientDataPanel.Position = [16 16 970 670];

            % Create LeftEarHearingDeviceDropDownLabel
            app.LeftEarHearingDeviceDropDownLabel = uilabel(app.PatientDataPanel);
            app.LeftEarHearingDeviceDropDownLabel.HorizontalAlignment = 'right';
            app.LeftEarHearingDeviceDropDownLabel.FontSize = 14;
            app.LeftEarHearingDeviceDropDownLabel.Position = [140 291 154 22];
            app.LeftEarHearingDeviceDropDownLabel.Text = 'Left Ear Hearing Device';

            % Create LeftEarHearingDeviceDropDown
            app.LeftEarHearingDeviceDropDown = uidropdown(app.PatientDataPanel);
            app.LeftEarHearingDeviceDropDown.Items = {'None', 'Hearing Aid', 'Cochlear Implant'};
            app.LeftEarHearingDeviceDropDown.ValueChangedFcn = createCallbackFcn(app, @leftEarSelection, true);
            app.LeftEarHearingDeviceDropDown.FontSize = 14;
            app.LeftEarHearingDeviceDropDown.Position = [301 285 175 35];
            app.LeftEarHearingDeviceDropDown.Value = 'None';

            % Create RightEarHearingDeviceDropDownLabel
            app.RightEarHearingDeviceDropDownLabel = uilabel(app.PatientDataPanel);
            app.RightEarHearingDeviceDropDownLabel.HorizontalAlignment = 'right';
            app.RightEarHearingDeviceDropDownLabel.FontSize = 14;
            app.RightEarHearingDeviceDropDownLabel.Position = [512 291 163 22];
            app.RightEarHearingDeviceDropDownLabel.Text = 'Right Ear Hearing Device';

            % Create RightEarHearingDeviceDropDown
            app.RightEarHearingDeviceDropDown = uidropdown(app.PatientDataPanel);
            app.RightEarHearingDeviceDropDown.Items = {'None', 'Hearing Aid', 'Cochlear Implant'};
            app.RightEarHearingDeviceDropDown.ValueChangedFcn = createCallbackFcn(app, @rightEarSelection, true);
            app.RightEarHearingDeviceDropDown.FontSize = 14;
            app.RightEarHearingDeviceDropDown.Position = [690 285 175 35];
            app.RightEarHearingDeviceDropDown.Value = 'None';

            % Create Panel
            app.Panel = uipanel(app.PatientDataPanel);
            app.Panel.Position = [23 423 925 206];

            % Create PatientIDEditFieldLabel
            app.PatientIDEditFieldLabel = uilabel(app.Panel);
            app.PatientIDEditFieldLabel.HorizontalAlignment = 'right';
            app.PatientIDEditFieldLabel.FontSize = 14;
            app.PatientIDEditFieldLabel.Position = [32 161 66 22];
            app.PatientIDEditFieldLabel.Text = 'Patient ID';

            % Create PatientIDEditField
            app.PatientIDEditField = uieditfield(app.Panel, 'text');
            app.PatientIDEditField.FontSize = 14;
            app.PatientIDEditField.Position = [113 154 150 35];

            % Create DateofBirthDatePickerLabel
            app.DateofBirthDatePickerLabel = uilabel(app.Panel);
            app.DateofBirthDatePickerLabel.HorizontalAlignment = 'right';
            app.DateofBirthDatePickerLabel.FontSize = 14;
            app.DateofBirthDatePickerLabel.Position = [15 97 83 22];
            app.DateofBirthDatePickerLabel.Text = 'Date of Birth';

            % Create DateofBirthDatePicker
            app.DateofBirthDatePicker = uidatepicker(app.Panel);
            app.DateofBirthDatePicker.FontSize = 14;
            app.DateofBirthDatePicker.Position = [113 90 150 35];

            % Create SexDropDownLabel
            app.SexDropDownLabel = uilabel(app.Panel);
            app.SexDropDownLabel.HorizontalAlignment = 'right';
            app.SexDropDownLabel.FontSize = 14;
            app.SexDropDownLabel.Position = [69 34 29 22];
            app.SexDropDownLabel.Text = 'Sex';

            % Create SexDropDown
            app.SexDropDown = uidropdown(app.Panel);
            app.SexDropDown.Items = {'Male', 'Female'};
            app.SexDropDown.FontSize = 14;
            app.SexDropDown.Position = [113 27 150 35];
            app.SexDropDown.Value = 'Male';

            % Create LeftEarEditFieldLabel
            app.LeftEarEditFieldLabel = uilabel(app.PatientDataPanel);
            app.LeftEarEditFieldLabel.HorizontalAlignment = 'right';
            app.LeftEarEditFieldLabel.WordWrap = 'on';
            app.LeftEarEditFieldLabel.Position = [154 205 132 35];
            app.LeftEarEditFieldLabel.Text = 'Years since left ear hearing device insertion';
            app.LeftEarEditFieldLabel.FontSize = 14;

            % Create LeftEarEditField
            app.LeftEarEditField = uieditfield(app.PatientDataPanel, 'numeric');
            app.LeftEarEditField.Limits = [0 100];
            app.LeftEarEditField.ValueDisplayFormat = '%.0f';
            app.LeftEarEditField.Enable = 'off';
            app.LeftEarEditField.Position = [301 203 175 35];
            app.LeftEarEditField.FontSize = 14;

            % Create BeginTestButton
            app.BeginTestButton = uibutton(app.PatientDataPanel, 'push');
            app.BeginTestButton.ButtonPushedFcn = createCallbackFcn(app, @beginTest, true);
            app.BeginTestButton.FontSize = 14;
            app.BeginTestButton.FontWeight = 'bold';
            app.BeginTestButton.FontColor = [0.851 0.3255 0.098];
            app.BeginTestButton.Position = [698 23 250 45];
            app.BeginTestButton.Text = 'Begin Test';

            % Create RightEarEditField_2Label
            app.RightEarEditField_2Label = uilabel(app.PatientDataPanel);
            app.RightEarEditField_2Label.HorizontalAlignment = 'right';
            app.RightEarEditField_2Label.WordWrap = 'on';
            app.RightEarEditField_2Label.Position = [543 205 132 35];
            app.RightEarEditField_2Label.Text = 'Years since right ear hearing device insertion';
            app.RightEarEditField_2Label.FontSize = 14;

            % Create RightEarEditField
            app.RightEarEditField = uieditfield(app.PatientDataPanel, 'numeric');
            app.RightEarEditField.Limits = [0 100];
            app.RightEarEditField.ValueDisplayFormat = '%.0f';
            app.RightEarEditField.Enable = 'off';
            app.RightEarEditField.Position = [690 203 175 35];
            app.RightEarEditField.FontSize = 14;
        end
    end
end