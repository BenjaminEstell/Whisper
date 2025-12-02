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

        LeftEarLabel                   matlab.ui.control.Label
        RightEarLabel                  matlab.ui.control.Label
        HearingThresholdLevelsLabel    matlab.ui.control.Label

        HzEditField_16                 matlab.ui.control.NumericEditField
        HzLabel_12                     matlab.ui.control.Label
        HzEditField_15                 matlab.ui.control.NumericEditField
        HzLabel_11                     matlab.ui.control.Label
        HzEditField_13                 matlab.ui.control.NumericEditField
        HzEditFieldLabel_4             matlab.ui.control.Label
        HzEditField_12                 matlab.ui.control.NumericEditField
        HzLabel_9                      matlab.ui.control.Label
        HzEditField_11                 matlab.ui.control.NumericEditField
        HzLabel_8                      matlab.ui.control.Label
        HzEditField_10                 matlab.ui.control.NumericEditField
        HzLabel_7                      matlab.ui.control.Label
        HzEditField_8                  matlab.ui.control.NumericEditField
        HzLabel_6                      matlab.ui.control.Label
        HzEditField_7                  matlab.ui.control.NumericEditField
        HzLabel_5                      matlab.ui.control.Label
        HzEditField_5                  matlab.ui.control.NumericEditField
        HzEditFieldLabel_2             matlab.ui.control.Label
        HzEditField_4                  matlab.ui.control.NumericEditField
        HzLabel_3                      matlab.ui.control.Label
        HzEditField_3                  matlab.ui.control.NumericEditField
        HzLabel_2                      matlab.ui.control.Label
        HzEditField_2                  matlab.ui.control.NumericEditField
        HzLabel                        matlab.ui.control.Label

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
            app.System.test.setPatientHearingThresholds('left', app.HzEditField_2.Value, app.HzEditField_3.Value, app.HzEditField_4.Value, app.HzEditField_5.Value, app.HzEditField_7.Value, app.HzEditField_8.Value);
            app.System.test.setPatientHearingThresholds('right', app.HzEditField_10.Value, app.HzEditField_11.Value, app.HzEditField_12.Value, app.HzEditField_13.Value, app.HzEditField_15.Value, app.HzEditField_16.Value);
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
            app.LeftEarHearingDeviceDropDownLabel.Position = [130 355 154 22];
            app.LeftEarHearingDeviceDropDownLabel.Text = 'Left Ear Hearing Device';

            % Create LeftEarHearingDeviceDropDown
            app.LeftEarHearingDeviceDropDown = uidropdown(app.PatientDataPanel);
            app.LeftEarHearingDeviceDropDown.Items = {'None', 'Hearing Aid', 'Cochlear Implant'};
            app.LeftEarHearingDeviceDropDown.ValueChangedFcn = createCallbackFcn(app, @leftEarSelection, true);
            app.LeftEarHearingDeviceDropDown.FontSize = 14;
            app.LeftEarHearingDeviceDropDown.Position = [290 350 175 35];
            app.LeftEarHearingDeviceDropDown.Value = 'None';

            % Create RightEarHearingDeviceDropDownLabel
            app.RightEarHearingDeviceDropDownLabel = uilabel(app.PatientDataPanel);
            app.RightEarHearingDeviceDropDownLabel.HorizontalAlignment = 'right';
            app.RightEarHearingDeviceDropDownLabel.FontSize = 14;
            app.RightEarHearingDeviceDropDownLabel.Position = [502 355 163 22];
            app.RightEarHearingDeviceDropDownLabel.Text = 'Right Ear Hearing Device';

            % Create RightEarHearingDeviceDropDown
            app.RightEarHearingDeviceDropDown = uidropdown(app.PatientDataPanel);
            app.RightEarHearingDeviceDropDown.Items = {'None', 'Hearing Aid', 'Cochlear Implant'};
            app.RightEarHearingDeviceDropDown.ValueChangedFcn = createCallbackFcn(app, @rightEarSelection, true);
            app.RightEarHearingDeviceDropDown.FontSize = 14;
            app.RightEarHearingDeviceDropDown.Position = [680 350 175 35];
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
            app.LeftEarEditFieldLabel.Position = [140 293 132 35];
            app.LeftEarEditFieldLabel.Text = 'Years since left ear hearing device insertion';
            app.LeftEarEditFieldLabel.FontSize = 14;

            % Create LeftEarEditField
            app.LeftEarEditField = uieditfield(app.PatientDataPanel, 'numeric');
            app.LeftEarEditField.Limits = [0 100];
            app.LeftEarEditField.ValueDisplayFormat = '%.0f';
            app.LeftEarEditField.Enable = 'off';
            app.LeftEarEditField.Position = [290 290 175 35];
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
            app.RightEarEditField_2Label.Position = [533 293 132 35];
            app.RightEarEditField_2Label.Text = 'Years since right ear hearing device insertion';
            app.RightEarEditField_2Label.FontSize = 14;

            % Create RightEarEditField
            app.RightEarEditField = uieditfield(app.PatientDataPanel, 'numeric');
            app.RightEarEditField.Limits = [0 100];
            app.RightEarEditField.ValueDisplayFormat = '%.0f';
            app.RightEarEditField.Enable = 'off';
            app.RightEarEditField.Position = [680 290 175 35];
            app.RightEarEditField.FontSize = 14;

            

            % Create LeftEarLabel
            app.LeftEarLabel = uilabel(app.PatientDataPanel);
            app.LeftEarLabel.FontSize = 24;
            app.LeftEarLabel.Position = [199 211 89 31];
            app.LeftEarLabel.Text = 'Left Ear';

            % Create HearingThresholdLevelsLabel
            app.HearingThresholdLevelsLabel = uilabel(app.PatientDataPanel);
            app.HearingThresholdLevelsLabel.HorizontalAlignment = 'center';
            app.HearingThresholdLevelsLabel.FontSize = 24;
            app.HearingThresholdLevelsLabel.FontWeight = 'bold';
            app.HearingThresholdLevelsLabel.Position = [259 211 453 61];
            app.HearingThresholdLevelsLabel.Text = 'Hearing Threshold Levels (dB)';

           % Create HzLabel
            app.HzLabel = uilabel(app.PatientDataPanel);
            app.HzLabel.HorizontalAlignment = 'right';
            app.HzLabel.FontSize = 18;
            app.HzLabel.Position = [49 145 62 23];
            app.HzLabel.Text = '250 Hz';

            % Create HzEditField_2
            app.HzEditField_2 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_2.HorizontalAlignment = 'center';
            app.HzEditField_2.FontSize = 18;
            app.HzEditField_2.Position = [126 145 100 24];

            % Create HzLabel_2
            app.HzLabel_2 = uilabel(app.PatientDataPanel);
            app.HzLabel_2.HorizontalAlignment = 'right';
            app.HzLabel_2.FontSize = 18;
            app.HzLabel_2.Position = [49 115 62 23];
            app.HzLabel_2.Text = '500 Hz';

            % Create HzEditField_3
            app.HzEditField_3 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_3.HorizontalAlignment = 'center';
            app.HzEditField_3.FontSize = 18;
            app.HzEditField_3.Position = [126 115 100 24];

            % Create HzLabel_3
            app.HzLabel_3 = uilabel(app.PatientDataPanel);
            app.HzLabel_3.HorizontalAlignment = 'right';
            app.HzLabel_3.FontSize = 18;
            app.HzLabel_3.Position = [39 85 72 23];
            app.HzLabel_3.Text = '1000 Hz';

            % Create HzEditField_4
            app.HzEditField_4 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_4.HorizontalAlignment = 'center';
            app.HzEditField_4.FontSize = 18;
            app.HzEditField_4.Position = [126 85 100 24];

            % Create HzEditFieldLabel_2
            app.HzEditFieldLabel_2 = uilabel(app.PatientDataPanel);
            app.HzEditFieldLabel_2.HorizontalAlignment = 'right';
            app.HzEditFieldLabel_2.FontSize = 18;
            app.HzEditFieldLabel_2.Position = [274 145 72 23];
            app.HzEditFieldLabel_2.Text = '2000 Hz';

            % Create HzEditField_5
            app.HzEditField_5 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_5.HorizontalAlignment = 'center';
            app.HzEditField_5.FontSize = 18;
            app.HzEditField_5.Position = [361 145 100 24];

            % Create HzLabel_5
            app.HzLabel_5 = uilabel(app.PatientDataPanel);
            app.HzLabel_5.HorizontalAlignment = 'right';
            app.HzLabel_5.FontSize = 18;
            app.HzLabel_5.Position = [269 117 77 23];
            app.HzLabel_5.Text = ' 4000 Hz';

            % Create HzEditField_7
            app.HzEditField_7 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_7.HorizontalAlignment = 'center';
            app.HzEditField_7.FontSize = 18;
            app.HzEditField_7.Position = [361 117 100 24];

            % Create HzLabel_6
            app.HzLabel_6 = uilabel(app.PatientDataPanel);
            app.HzLabel_6.HorizontalAlignment = 'right';
            app.HzLabel_6.FontSize = 18;
            app.HzLabel_6.Position = [274 87 72 23];
            app.HzLabel_6.Text = '8000 Hz';

            % Create HzEditField_8
            app.HzEditField_8 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_8.HorizontalAlignment = 'center';
            app.HzEditField_8.FontSize = 18;
            app.HzEditField_8.Position = [361 87 100 24];

            % Create HzLabel_7
            app.HzLabel_7 = uilabel(app.PatientDataPanel);
            app.HzLabel_7.HorizontalAlignment = 'right';
            app.HzLabel_7.FontSize = 18;
            app.HzLabel_7.Position = [517 145 62 23];
            app.HzLabel_7.Text = '250 Hz';

            % Create HzEditField_10
            app.HzEditField_10 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_10.HorizontalAlignment = 'center';
            app.HzEditField_10.FontSize = 18;
            app.HzEditField_10.Position = [594 145 100 24];

            % Create HzLabel_8
            app.HzLabel_8 = uilabel(app.PatientDataPanel);
            app.HzLabel_8.HorizontalAlignment = 'right';
            app.HzLabel_8.FontSize = 18;
            app.HzLabel_8.Position = [517 115 62 23];
            app.HzLabel_8.Text = '500 Hz';

            % Create HzEditField_11
            app.HzEditField_11 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_11.HorizontalAlignment = 'center';
            app.HzEditField_11.FontSize = 18;
            app.HzEditField_11.Position = [594 115 100 24];

            % Create HzLabel_9
            app.HzLabel_9 = uilabel(app.PatientDataPanel);
            app.HzLabel_9.HorizontalAlignment = 'right';
            app.HzLabel_9.FontSize = 18;
            app.HzLabel_9.Position = [507 85 72 23];
            app.HzLabel_9.Text = '1000 Hz';

            % Create HzEditField_12
            app.HzEditField_12 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_12.HorizontalAlignment = 'center';
            app.HzEditField_12.FontSize = 18;
            app.HzEditField_12.Position = [594 85 100 24];

            % Create HzEditFieldLabel_4
            app.HzEditFieldLabel_4 = uilabel(app.PatientDataPanel);
            app.HzEditFieldLabel_4.HorizontalAlignment = 'right';
            app.HzEditFieldLabel_4.FontSize = 18;
            app.HzEditFieldLabel_4.Position = [742 145 72 23];
            app.HzEditFieldLabel_4.Text = '2000 Hz';

            % Create HzEditField_13
            app.HzEditField_13 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_13.HorizontalAlignment = 'center';
            app.HzEditField_13.FontSize = 18;
            app.HzEditField_13.Position = [829 145 100 24];

            % Create HzLabel_11
            app.HzLabel_11 = uilabel(app.PatientDataPanel);
            app.HzLabel_11.HorizontalAlignment = 'right';
            app.HzLabel_11.FontSize = 18;
            app.HzLabel_11.Position = [737 117 77 23];
            app.HzLabel_11.Text = ' 4000 Hz';

            % Create HzEditField_15
            app.HzEditField_15 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_15.HorizontalAlignment = 'center';
            app.HzEditField_15.FontSize = 18;
            app.HzEditField_15.Position = [829 117 100 24];

            % Create HzLabel_12
            app.HzLabel_12 = uilabel(app.PatientDataPanel);
            app.HzLabel_12.HorizontalAlignment = 'right';
            app.HzLabel_12.FontSize = 18;
            app.HzLabel_12.Position = [742 87 72 23];
            app.HzLabel_12.Text = '8000 Hz';

            % Create HzEditField_16
            app.HzEditField_16 = uieditfield(app.PatientDataPanel, 'numeric');
            app.HzEditField_16.HorizontalAlignment = 'center';
            app.HzEditField_16.FontSize = 18;
            app.HzEditField_16.Position = [829 87 100 24];

            % Create RightEarLabel
            app.RightEarLabel = uilabel(app.PatientDataPanel);
            app.RightEarLabel.FontSize = 24;
            app.RightEarLabel.Position = [680 211 105 31];
            app.RightEarLabel.Text = 'Right Ear';
        end
    end
end