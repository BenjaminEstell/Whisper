classdef patientData < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        PatientDataPanel               matlab.ui.container.Panel
        YearssincerightearhearingdeviceinsertionEditField  matlab.ui.control.NumericEditField
        YearssincerightearhearingdeviceinsertionEditField_2Label  matlab.ui.control.Label
        NextVolumeCallibrationButton   matlab.ui.control.Button
        YearssinceleftearhearingdeviceinsertionEditField  matlab.ui.control.NumericEditField
        YearssinceleftearhearingdeviceinsertionEditFieldLabel  matlab.ui.control.Label
        Panel                          matlab.ui.container.Panel
        SexDropDown                    matlab.ui.control.DropDown
        SexDropDownLabel               matlab.ui.control.Label
        DateofBirthDatePicker          matlab.ui.control.DatePicker
        DateofBirthDatePickerLabel     matlab.ui.control.Label
        PatientIDEditField             matlab.ui.control.NumericEditField
        PatientIDEditFieldLabel        matlab.ui.control.Label
        RightEarHearingDeviceDropDown  matlab.ui.control.DropDown
        RightEarHearingDeviceDropDownLabel  matlab.ui.control.Label
        LeftEarHearingDeviceDropDown   matlab.ui.control.DropDown
        LeftEarHearingDeviceDropDownLabel  matlab.ui.control.Label
        System                          Whisper
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: LeftEarHearingDeviceDropDown
        function LeftEarSelection(app, event)
            value = app.LeftEarHearingDeviceDropDown.Value;
            if strcmp(value, "None")
                app.YearssinceleftearhearingdeviceinsertionEditField.Enable = false;
            else
                app.YearssinceleftearhearingdeviceinsertionEditField.Enable = true;
            end
        end

        % Value changed function: RightEarHearingDeviceDropDown
        function RightEarSelection(app, event)
            value = app.RightEarHearingDeviceDropDown.Value;
            if strcmp(value, "None")
                app.YearssincerightearhearingdeviceinsertionEditField.Enable = false;
            else
                app.YearssincerightearhearingdeviceinsertionEditField.Enable = true;
            end
        end

        % Button pushed function: NextVolumeCallibrationButton
        function VolumeCallibration(app, event)
            % Save selections
            app.System.test.patient.ID = app.PatientIDEditField.Value;
            app.System.test.patient.DOB = app.DateofBirthDatePicker.Value;
            app.System.test.patient.sex = app.SexDropDown.Value;
            app.System.test.patient.leftEarDevice = app.LeftEarHearingDeviceDropDown.Value;
            app.System.test.patient.leftEarDeviceYears = app.YearssinceleftearhearingdeviceinsertionEditField.Value;
            app.System.test.patient.rightEarDevice = app.RightEarHearingDeviceDropDown.Value;
            app.System.test.patient.rightEarDeviceYears = app.YearssincerightearhearingdeviceinsertionEditField.Value;

            % clear the current ui
            for ii = 1:length(app.UIFigure.Children)
                app.UIFigure.Children(ii).Visible = false;
            end
            % Build patient data UI
            volumeCallibrationView = volumeCallibration();
            volumeCallibrationView.createComponents(app.UIFigure, app.System);
        end
    end

    % Component initialization
    methods (Access = public)

        % Create UIFigure and components
        function createComponents(app, UIFigure, WhisperIn)
            app.UIFigure = UIFigure;
            app.System = WhisperIn;

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
            app.LeftEarHearingDeviceDropDown.ValueChangedFcn = createCallbackFcn(app, @LeftEarSelection, true);
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
            app.RightEarHearingDeviceDropDown.ValueChangedFcn = createCallbackFcn(app, @RightEarSelection, true);
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
            app.PatientIDEditField = uieditfield(app.Panel, 'numeric');
            app.PatientIDEditField.Limits = [0 Inf];
            app.PatientIDEditField.ValueDisplayFormat = '%.0f';
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

            % Create YearssinceleftearhearingdeviceinsertionEditFieldLabel
            app.YearssinceleftearhearingdeviceinsertionEditFieldLabel = uilabel(app.PatientDataPanel);
            app.YearssinceleftearhearingdeviceinsertionEditFieldLabel.HorizontalAlignment = 'right';
            app.YearssinceleftearhearingdeviceinsertionEditFieldLabel.WordWrap = 'on';
            app.YearssinceleftearhearingdeviceinsertionEditFieldLabel.Position = [154 205 132 30];
            app.YearssinceleftearhearingdeviceinsertionEditFieldLabel.Text = 'Years since left ear hearing device insertion';

            % Create YearssinceleftearhearingdeviceinsertionEditField
            app.YearssinceleftearhearingdeviceinsertionEditField = uieditfield(app.PatientDataPanel, 'numeric');
            app.YearssinceleftearhearingdeviceinsertionEditField.Limits = [0 100];
            app.YearssinceleftearhearingdeviceinsertionEditField.ValueDisplayFormat = '%.0f';
            app.YearssinceleftearhearingdeviceinsertionEditField.Enable = 'off';
            app.YearssinceleftearhearingdeviceinsertionEditField.Position = [301 203 175 35];

            % Create NextVolumeCallibrationButton
            app.NextVolumeCallibrationButton = uibutton(app.PatientDataPanel, 'push');
            app.NextVolumeCallibrationButton.ButtonPushedFcn = createCallbackFcn(app, @VolumeCallibration, true);
            app.NextVolumeCallibrationButton.FontSize = 18;
            app.NextVolumeCallibrationButton.Position = [698 23 250 45];
            app.NextVolumeCallibrationButton.Text = 'Next: Volume Callibration';

            % Create YearssincerightearhearingdeviceinsertionEditField_2Label
            app.YearssincerightearhearingdeviceinsertionEditField_2Label = uilabel(app.PatientDataPanel);
            app.YearssincerightearhearingdeviceinsertionEditField_2Label.HorizontalAlignment = 'right';
            app.YearssincerightearhearingdeviceinsertionEditField_2Label.WordWrap = 'on';
            app.YearssincerightearhearingdeviceinsertionEditField_2Label.Position = [543 205 132 30];
            app.YearssincerightearhearingdeviceinsertionEditField_2Label.Text = 'Years since right ear hearing device insertion';

            % Create YearssincerightearhearingdeviceinsertionEditField
            app.YearssincerightearhearingdeviceinsertionEditField = uieditfield(app.PatientDataPanel, 'numeric');
            app.YearssincerightearhearingdeviceinsertionEditField.Limits = [0 100];
            app.YearssincerightearhearingdeviceinsertionEditField.ValueDisplayFormat = '%.0f';
            app.YearssincerightearhearingdeviceinsertionEditField.Enable = 'off';
            app.YearssincerightearhearingdeviceinsertionEditField.Position = [690 203 175 35];
        end
    end
end