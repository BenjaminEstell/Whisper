classdef testOptionSelection < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        TestOptionsPanel           matlab.ui.container.Panel
        SaveOptionsPanel           matlab.ui.container.Panel
        BrowseButton               matlab.ui.control.Button
        Label                      matlab.ui.control.Label
        willbeperformedforeachsoundLabel  matlab.ui.control.Label
        NextPatientDataButton      matlab.ui.control.Button
        SelectNumberofTrialsPanel  matlab.ui.container.Panel
        trialsEditField            matlab.ui.control.NumericEditField
        trialsEditFieldLabel       matlab.ui.control.Label
        SelectWordsPanel           matlab.ui.container.Panel
        ChoosehowmanywordsyouwouldliketoincludeinthetestLabel  matlab.ui.control.Label
        wordsEditField             matlab.ui.control.NumericEditField
        wordsEditFieldLabel        matlab.ui.control.Label
        SelectPhonemesPanel        matlab.ui.container.Panel
        allCheckBox                matlab.ui.control.CheckBox
        hooedCheckBox              matlab.ui.control.CheckBox
        hudCheckBox                matlab.ui.control.CheckBox
        hoedCheckBox               matlab.ui.control.CheckBox
        hadCheckBox                matlab.ui.control.CheckBox
        headCheckBox               matlab.ui.control.CheckBox
        zaCheckBox                 matlab.ui.control.CheckBox
        paCheckBox                 matlab.ui.control.CheckBox
        faCheckBox                 matlab.ui.control.CheckBox
        naCheckBox                 matlab.ui.control.CheckBox
        gaCheckBox                 matlab.ui.control.CheckBox
        hayedCheckBox              matlab.ui.control.CheckBox
        hidCheckBox                matlab.ui.control.CheckBox
        heardCheckBox              matlab.ui.control.CheckBox
        hodCheckBox                matlab.ui.control.CheckBox
        xtaCheckBox                matlab.ui.control.CheckBox
        xsaCheckBox                matlab.ui.control.CheckBox
        saCheckBox                 matlab.ui.control.CheckBox
        kaCheckBox                 matlab.ui.control.CheckBox
        hoodCheckBox               matlab.ui.control.CheckBox
        heedCheckBox               matlab.ui.control.CheckBox
        hawedCheckBox              matlab.ui.control.CheckBox
        xzaCheckBox                matlab.ui.control.CheckBox
        vaCheckBox                 matlab.ui.control.CheckBox
        xdaCheckBox                matlab.ui.control.CheckBox
        taCheckBox                 matlab.ui.control.CheckBox
        maCheckBox                 matlab.ui.control.CheckBox
        daCheckBox                 matlab.ui.control.CheckBox
        baCheckBox                 matlab.ui.control.CheckBox
        SelectTestTypeButtonGroup  matlab.ui.container.ButtonGroup
        WordRecognitionButton      matlab.ui.control.RadioButton
        PhonemeRecognitionButton   matlab.ui.control.RadioButton
        System                     Whisper
    end

    
    properties (Access = private)
        numCheckedPhonemes = 0;    % Gives the number of phoneme checkboxes that are checked
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Selection changed function: SelectTestTypeButtonGroup
        function TestTypeSelection(app, event)
            selectedButton = app.SelectTestTypeButtonGroup.SelectedObject;
            if selectedButton == app.PhonemeRecognitionButton
                app.SelectPhonemesPanel.Enable = true;
                app.SelectWordsPanel.Enable = false;
                if app.numCheckedPhonemes == 0
                    app.SelectNumberofTrialsPanel.Enable = false;
                    app.NextPatientDataButton.Enable = false;
                else
                    app.SelectNumberofTrialsPanel.Enable = true;
                    app.NextPatientDataButton.Enable = true;
                end
            end
            if selectedButton == app.WordRecognitionButton
                app.SelectPhonemesPanel.Enable = false;
                app.SelectWordsPanel.Enable = true;
                app.SelectNumberofTrialsPanel.Enable = true;
                app.NextPatientDataButton.Enable = true;
            end
        end

        % Value changed function: allCheckBox
        function ToggleAllPhonemes(app, event)
            value = app.allCheckBox.Value;
            % set value of all phoneme checkboxes to value
            app.hoedCheckBox.Value = value;
            app.hadCheckBox.Value = value;
            app.headCheckBox.Value = value;
            app.zaCheckBox.Value = value;
            app.paCheckBox.Value = value;
            app.faCheckBox.Value = value;
            app.naCheckBox.Value = value;
            app.gaCheckBox.Value = value;
            app.hayedCheckBox.Value = value;
            app.hidCheckBox.Value = value;
            app.heardCheckBox.Value = value;
            app.hodCheckBox.Value = value;
            app.xtaCheckBox.Value = value;
            app.xsaCheckBox.Value = value;
            app.saCheckBox.Value = value;
            app.kaCheckBox.Value = value;
            app.hoodCheckBox.Value = value;
            app.heedCheckBox.Value = value;
            app.hawedCheckBox.Value = value;
            app.hudCheckBox.Value = value;
            app.hooedCheckBox.Value = value;
            app.xzaCheckBox.Value = value;
            app.vaCheckBox.Value = value;
            app.xdaCheckBox.Value = value;
            app.taCheckBox.Value = value;
            app.maCheckBox.Value = value;
            app.daCheckBox.Value = value;
            app.baCheckBox.Value = value;

            % if a box is checked, enable number of trials section
            if app.SelectTestTypeButtonGroup.SelectedObject == app.PhonemeRecognitionButton
                if value
                    app.SelectNumberofTrialsPanel.Enable = true;
                    app.NextPatientDataButton.Enable = true;
                    app.numCheckedPhonemes = 26;
                else
                    app.SelectNumberofTrialsPanel.Enable = false;
                    app.NextPatientDataButton.Enable = false;
                    app.numCheckedPhonemes = 0;
                end
            end
        end

        % Value changed function: wordsEditField
        function WordSelection(app, event)
            if app.SelectTestTypeButtonGroup.SelectedObject == app.WordRecognitionButton
                app.SelectNumberofTrialsPanel.Enable = true;
                app.NextPatientDataButton.Enable = true;
            end
        end

        % Value changed function: baCheckBox, daCheckBox, faCheckBox, 
        % ...and 25 other components
        function ToggleOnePhoneme(app, event)
            value = event.Source.Value;
            if value
                app.numCheckedPhonemes = app.numCheckedPhonemes + 1;
            else
                app.numCheckedPhonemes = app.numCheckedPhonemes - 1;
            end
            if app.numCheckedPhonemes == 0
                app.SelectNumberofTrialsPanel.Enable = false;
                app.NextPatientDataButton.Enable = false;
            else
                app.SelectNumberofTrialsPanel.Enable = true;
                app.NextPatientDataButton.Enable = true;
            end
            if app.numCheckedPhonemes ~= 26
                app.allCheckBox.Value = false;
            elseif app.numCheckedPhonemes == 26
                app.allCheckBox.Value = true;
            end
        end

        % Value changed function: trialsEditField
        function NumberOfTrialsSelection(app, event)
            app.NextPatientDataButton.Enable = true;
            app.System.test.numTrials = app.trialsEditField.Value;
        end

        % Button pushed function: NextPatientDataButton
        function EnterPatientData(app, event)
            % record mode and sounds chosen
            if app.SelectTestTypeButtonGroup.SelectedObject == app.PhonemeRecognitionButton
                app.System.test.mode = TestType.phoneme;
                % collect all phonemes that will be used in the Test
                for ii = 1:length(app.SelectPhonemesPanel.Children)
                    if app.SelectPhonemesPanel.Children(ii).Value == true && ~strcmp(app.SelectPhonemesPanel.Children(ii).Text,"all")
                        % Gets the phoneme name from the element on the page
                        temp = split(app.SelectPhonemesPanel.Children(ii).Text, '/');
                        temp2 = split(temp(2), '/');
                        % construct a Sound object for the sound
                        newSound = Sound(string(temp2(1)), TestType.phoneme, app.System.test.numTrials);
                        % store the new Sound in the Test
                        app.System.test.sounds{end+1} = newSound;
                    end
                end
                app.System.test.numSounds = length(app.System.test.sounds);
            else
                app.System.test.mode = TestType.cnc;
                % choose numSounds random cnc sounds
                app.System.test.numSounds = app.wordsEditField.Value;
                % pick random numbers between 100 and 1049 
                randomNumberSet = randi([100 1049], 1, app.System.numSounds);
                % for each random number, construct a Sound object
                for ii = 1:size(randomNumberSet, 1)
                    newSound = Sound(string(randomNumberSet(ii)), TestType.cnc, app.System.test.numTrials);
                    % store the new Sound in the Test
                    app.System.test.sounds{end+1} = newSound;
                end
            end
            % clear the current ui
            for ii = 1:length(app.UIFigure.Children)
                app.UIFigure.Children(ii).Visible = false;
            end
            % Build patient data UI
            patientDataView = patientData();
            patientDataView.createComponents(app.UIFigure, app.System);
        end
    end

    % View creation
    methods (Access = public)
        % Create UIFigure and components
        function createComponents(app, UIFigure, WhisperIn)
            app.System = WhisperIn;
            app.UIFigure = UIFigure;

            % Create TestOptionsPanel
            app.TestOptionsPanel = uipanel(app.UIFigure);
            app.TestOptionsPanel.Title = 'Test Options';
            app.TestOptionsPanel.Position = [16 16 970 670];

            % Create SelectTestTypeButtonGroup
            app.SelectTestTypeButtonGroup = uibuttongroup(app.TestOptionsPanel);
            app.SelectTestTypeButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @TestTypeSelection, true);
            app.SelectTestTypeButtonGroup.Title = 'Select Test Type';
            app.SelectTestTypeButtonGroup.FontSize = 14;
            app.SelectTestTypeButtonGroup.Position = [26 541 194 89];

            % Create PhonemeRecognitionButton
            app.PhonemeRecognitionButton = uiradiobutton(app.SelectTestTypeButtonGroup);
            app.PhonemeRecognitionButton.Text = 'Phoneme Recognition';
            app.PhonemeRecognitionButton.FontSize = 14;
            app.PhonemeRecognitionButton.Position = [11 39 159 22];
            app.PhonemeRecognitionButton.Value = true;

            % Create WordRecognitionButton
            app.WordRecognitionButton = uiradiobutton(app.SelectTestTypeButtonGroup);
            app.WordRecognitionButton.Text = 'Word Recognition';
            app.WordRecognitionButton.FontSize = 14;
            app.WordRecognitionButton.Position = [10 9 133 22];

            % Create SelectPhonemesPanel
            app.SelectPhonemesPanel = uipanel(app.TestOptionsPanel);
            app.SelectPhonemesPanel.Title = 'Select Phonemes';
            app.SelectPhonemesPanel.FontSize = 14;
            app.SelectPhonemesPanel.Position = [246 237 444 393];

            % Create baCheckBox
            app.baCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.baCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.baCheckBox.Text = '/ba/';
            app.baCheckBox.FontSize = 14;
            app.baCheckBox.Position = [20 330 45 22];

            % Create daCheckBox
            app.daCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.daCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.daCheckBox.Text = '/da/';
            app.daCheckBox.FontSize = 14;
            app.daCheckBox.Position = [130 331 45 22];

            % Create maCheckBox
            app.maCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.maCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.maCheckBox.Text = '/ma/';
            app.maCheckBox.FontSize = 14;
            app.maCheckBox.Position = [130 282 49 22];

            % Create taCheckBox
            app.taCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.taCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.taCheckBox.Text = '/ta/';
            app.taCheckBox.FontSize = 14;
            app.taCheckBox.Position = [130 234 41 22];

            % Create xdaCheckBox
            app.xdaCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.xdaCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.xdaCheckBox.Text = '/xda/';
            app.xdaCheckBox.FontSize = 14;
            app.xdaCheckBox.Position = [350 235 52 22];

            % Create vaCheckBox
            app.vaCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.vaCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.vaCheckBox.Text = '/va/';
            app.vaCheckBox.FontSize = 14;
            app.vaCheckBox.Position = [240 235 44 22];

            % Create xzaCheckBox
            app.xzaCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.xzaCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.xzaCheckBox.Text = '/xza/';
            app.xzaCheckBox.FontSize = 14;
            app.xzaCheckBox.Position = [240 182 51 22];

            % Create hawedCheckBox
            app.hawedCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.hawedCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.hawedCheckBox.Text = '/hawed/';
            app.hawedCheckBox.FontSize = 14;
            app.hawedCheckBox.Position = [240 132 71 22];

            % Create heedCheckBox
            app.heedCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.heedCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.heedCheckBox.Text = '/heed/';
            app.heedCheckBox.FontSize = 14;
            app.heedCheckBox.Position = [350 82 61 22];

            % Create hoodCheckBox
            app.hoodCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.hoodCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.hoodCheckBox.Text = '/hood/';
            app.hoodCheckBox.FontSize = 14;
            app.hoodCheckBox.Position = [130 31 61 22];

            % Create kaCheckBox
            app.kaCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.kaCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.kaCheckBox.Text = '/ka/';
            app.kaCheckBox.FontSize = 14;
            app.kaCheckBox.Position = [21 280 44 22];

            % Create saCheckBox
            app.saCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.saCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.saCheckBox.Text = '/sa/';
            app.saCheckBox.FontSize = 14;
            app.saCheckBox.Position = [22 230 44 22];

            % Create xsaCheckBox
            app.xsaCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.xsaCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.xsaCheckBox.Text = '/xsa/';
            app.xsaCheckBox.FontSize = 14;
            app.xsaCheckBox.Position = [22 180 51 22];

            % Create xtaCheckBox
            app.xtaCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.xtaCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.xtaCheckBox.Text = '/xta/';
            app.xtaCheckBox.FontSize = 14;
            app.xtaCheckBox.Position = [130 181 48 22];

            % Create hodCheckBox
            app.hodCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.hodCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.hodCheckBox.Text = '/hod/';
            app.hodCheckBox.FontSize = 14;
            app.hodCheckBox.Position = [130 131 53 22];

            % Create heardCheckBox
            app.heardCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.heardCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.heardCheckBox.Text = '/heard/';
            app.heardCheckBox.FontSize = 14;
            app.heardCheckBox.Position = [130 81 65 22];

            % Create hidCheckBox
            app.hidCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.hidCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.hidCheckBox.Text = '/hid/';
            app.hidCheckBox.FontSize = 14;
            app.hidCheckBox.Position = [240 82 48 22];

            % Create hayedCheckBox
            app.hayedCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.hayedCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.hayedCheckBox.Text = '/hayed/';
            app.hayedCheckBox.FontSize = 14;
            app.hayedCheckBox.Position = [22 80 68 22];

            % Create gaCheckBox
            app.gaCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.gaCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.gaCheckBox.Text = '/ga/';
            app.gaCheckBox.FontSize = 14;
            app.gaCheckBox.Position = [350 331 45 22];

            % Create naCheckBox
            app.naCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.naCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.naCheckBox.Text = '/na/';
            app.naCheckBox.FontSize = 14;
            app.naCheckBox.Position = [240 283 45 22];

            % Create faCheckBox
            app.faCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.faCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.faCheckBox.Text = '/fa/';
            app.faCheckBox.FontSize = 14;
            app.faCheckBox.Position = [240 331 41 22];

            % Create paCheckBox
            app.paCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.paCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.paCheckBox.Text = '/pa/';
            app.paCheckBox.FontSize = 14;
            app.paCheckBox.Position = [350 284 45 22];

            % Create zaCheckBox
            app.zaCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.zaCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.zaCheckBox.Text = '/za/';
            app.zaCheckBox.FontSize = 14;
            app.zaCheckBox.Position = [350 183 44 22];

            % Create headCheckBox
            app.headCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.headCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.headCheckBox.Text = '/head/';
            app.headCheckBox.FontSize = 14;
            app.headCheckBox.Position = [350 133 61 22];

            % Create hadCheckBox
            app.hadCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.hadCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.hadCheckBox.Text = '/had/';
            app.hadCheckBox.FontSize = 14;
            app.hadCheckBox.Position = [22 130 53 22];

            % Create hoedCheckBox
            app.hoedCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.hoedCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.hoedCheckBox.Text = '/hoed/';
            app.hoedCheckBox.FontSize = 14;
            app.hoedCheckBox.Position = [22 30 61 22];

            % Create hudCheckBox
            app.hudCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.hudCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.hudCheckBox.Text = '/hud/';
            app.hudCheckBox.FontSize = 14;
            app.hudCheckBox.Position = [240 31 53 22];

            % Create hooedCheckBox
            app.hooedCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.hooedCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleOnePhoneme, true);
            app.hooedCheckBox.Text = '/hooed/';
            app.hooedCheckBox.FontSize = 14;
            app.hooedCheckBox.Position = [350 31 68 22];

            % Create allCheckBox
            app.allCheckBox = uicheckbox(app.SelectPhonemesPanel);
            app.allCheckBox.ValueChangedFcn = createCallbackFcn(app, @ToggleAllPhonemes, true);
            app.allCheckBox.Text = 'all';
            app.allCheckBox.FontSize = 14;
            app.allCheckBox.FontWeight = 'bold';
            app.allCheckBox.Position = [399 371 37 22];

            % Create SelectWordsPanel
            app.SelectWordsPanel = uipanel(app.TestOptionsPanel);
            app.SelectWordsPanel.Enable = 'off';
            app.SelectWordsPanel.Title = 'Select Words';
            app.SelectWordsPanel.FontSize = 14;
            app.SelectWordsPanel.Position = [246 86 444 124];

            % Create wordsEditFieldLabel
            app.wordsEditFieldLabel = uilabel(app.SelectWordsPanel);
            app.wordsEditFieldLabel.HorizontalAlignment = 'center';
            app.wordsEditFieldLabel.FontSize = 14;
            app.wordsEditFieldLabel.Position = [226 18 42 22];
            app.wordsEditFieldLabel.Text = 'words';

            % Create wordsEditField
            app.wordsEditField = uieditfield(app.SelectWordsPanel, 'numeric');
            app.wordsEditField.Limits = [5 100];
            app.wordsEditField.ValueDisplayFormat = '%.0f';
            app.wordsEditField.ValueChangedFcn = createCallbackFcn(app, @WordSelection, true);
            app.wordsEditField.FontSize = 14;
            app.wordsEditField.Position = [169 17 51 22];
            app.wordsEditField.Value = 5;

            % Create ChoosehowmanywordsyouwouldliketoincludeinthetestLabel
            app.ChoosehowmanywordsyouwouldliketoincludeinthetestLabel = uilabel(app.SelectWordsPanel);
            app.ChoosehowmanywordsyouwouldliketoincludeinthetestLabel.WordWrap = 'on';
            app.ChoosehowmanywordsyouwouldliketoincludeinthetestLabel.FontSize = 14;
            app.ChoosehowmanywordsyouwouldliketoincludeinthetestLabel.Position = [20 49 398 41];
            app.ChoosehowmanywordsyouwouldliketoincludeinthetestLabel.Text = 'Choose how many words you would like to include in the test';

            % Create SelectNumberofTrialsPanel
            app.SelectNumberofTrialsPanel = uipanel(app.TestOptionsPanel);
            app.SelectNumberofTrialsPanel.Enable = 'off';
            app.SelectNumberofTrialsPanel.Title = 'Select Number of Trials';
            app.SelectNumberofTrialsPanel.Position = [715 520 233 110];

            % Create trialsEditFieldLabel
            app.trialsEditFieldLabel = uilabel(app.SelectNumberofTrialsPanel);
            app.trialsEditFieldLabel.HorizontalAlignment = 'right';
            app.trialsEditFieldLabel.FontSize = 14;
            app.trialsEditFieldLabel.Position = [129 59 35 22];
            app.trialsEditFieldLabel.Text = 'trials';

            % Create trialsEditField
            app.trialsEditField = uieditfield(app.SelectNumberofTrialsPanel, 'numeric');
            app.trialsEditField.Limits = [1 5000];
            app.trialsEditField.ValueDisplayFormat = '%.0f';
            app.trialsEditField.ValueChangedFcn = createCallbackFcn(app, @NumberOfTrialsSelection, true);
            app.trialsEditField.FontSize = 14;
            app.trialsEditField.Position = [69 59 61 22];
            app.trialsEditField.Value = 100;

            % Create willbeperformedforeachsoundLabel
            app.willbeperformedforeachsoundLabel = uilabel(app.SelectNumberofTrialsPanel);
            app.willbeperformedforeachsoundLabel.HorizontalAlignment = 'center';
            app.willbeperformedforeachsoundLabel.WordWrap = 'on';
            app.willbeperformedforeachsoundLabel.FontSize = 14;
            app.willbeperformedforeachsoundLabel.Position = [49 1 135 59];
            app.willbeperformedforeachsoundLabel.Text = 'will be performed for each sound';

            % Create NextPatientDataButton
            app.NextPatientDataButton = uibutton(app.TestOptionsPanel, 'push');
            app.NextPatientDataButton.ButtonPushedFcn = createCallbackFcn(app, @EnterPatientData, true);
            app.NextPatientDataButton.FontSize = 18;
            app.NextPatientDataButton.Enable = 'off';
            app.NextPatientDataButton.Position = [742 23 206 45];
            app.NextPatientDataButton.Text = 'Next: Patient Data';

            % Create SaveOptionsPanel
            app.SaveOptionsPanel = uipanel(app.TestOptionsPanel);
            app.SaveOptionsPanel.Title = 'Save Options';
            app.SaveOptionsPanel.FontSize = 14;
            app.SaveOptionsPanel.Position = [26 354 194 158];

            % Create Label
            app.Label = uilabel(app.SaveOptionsPanel);
            app.Label.HorizontalAlignment = 'center';
            app.Label.WordWrap = 'on';
            app.Label.FontSize = 14;
            app.Label.Position = [11 56 171 69];
            app.Label.Text = 'Choose where to automatically save the test report once the test is complete';

            % Create BrowseButton
            app.BrowseButton = uibutton(app.SaveOptionsPanel, 'push');
            app.BrowseButton.FontSize = 14;
            app.BrowseButton.Position = [37 17 119 25];
            app.BrowseButton.Text = 'Browse';
        end
        
    end
end