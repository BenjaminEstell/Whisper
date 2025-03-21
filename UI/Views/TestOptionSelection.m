classdef TestOptionSelection < matlab.apps.AppBase
    % Test Option Selection 
    % Class that constructs the UI for selecting test options

    properties (Access = private)
        UIFigure                   matlab.ui.Figure
        TestOptionsPanel           matlab.ui.container.Panel
        SaveOptionsPanel           matlab.ui.container.Panel
        BrowseButton               matlab.ui.control.Button
        Label                      matlab.ui.control.Label
        NumTrialsLabel2            matlab.ui.control.Label
        NextPatientDataButton      matlab.ui.control.Button
        SelectNumberofTrialsPanel  matlab.ui.container.Panel
        trialsEditField            matlab.ui.control.NumericEditField
        trialsEditFieldLabel       matlab.ui.control.Label
        SelectWordsPanel           matlab.ui.container.Panel
        NumWordsLabel              matlab.ui.control.Label
        wordsEditField             matlab.ui.control.NumericEditField
        wordsEditFieldLabel        matlab.ui.control.Label
        SelectSyllablesPanel       matlab.ui.container.Panel
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
        SyllableRecognitionButton  matlab.ui.control.RadioButton
        System                     Whisper
        practiceTestCheckBox       matlab.ui.control.CheckBox
        OtherOptionsPanel          matlab.ui.container.Panel
        selectedTestType           % UI Element
    end

    properties (Access = private)
        numCheckedSyllables = 0;    % Gives the number of syllable checkboxes that are checked
        savedPathChosen = false;    % Logical
    end
    

    methods (Access = public)

        % Test Option Selection constructor
        function obj = TestOptionSelection(UIFigure, WhisperIn)
            obj.System = WhisperIn;
            obj.UIFigure = UIFigure;
            obj.createComponents();
        end

    end

    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create TestOptionsPanel
            app.TestOptionsPanel = uipanel(app.UIFigure);
            app.TestOptionsPanel.Title = 'Test Options';
            app.TestOptionsPanel.Position = [16 16 970 670];

            % Create SelectTestTypeButtonGroup
            app.SelectTestTypeButtonGroup = uibuttongroup(app.TestOptionsPanel);
            app.SelectTestTypeButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @testTypeSelection, true);
            app.SelectTestTypeButtonGroup.Title = 'Select Test Type';
            app.SelectTestTypeButtonGroup.FontSize = 14;
            app.SelectTestTypeButtonGroup.Position = [26 541 194 89];

            % Create SyllableRecognitionButton
            app.SyllableRecognitionButton = uiradiobutton(app.SelectTestTypeButtonGroup);
            app.SyllableRecognitionButton.Text = 'Syllable Recognition';
            app.SyllableRecognitionButton.FontSize = 14;
            app.SyllableRecognitionButton.Position = [11 39 159 22];
            app.SyllableRecognitionButton.Value = true;

            % Create WordRecognitionButton
            app.WordRecognitionButton = uiradiobutton(app.SelectTestTypeButtonGroup);
            app.WordRecognitionButton.Text = 'Word Recognition';
            app.WordRecognitionButton.FontSize = 14;
            app.WordRecognitionButton.Position = [10 9 133 22];

            % Create SelectSyllablesPanel
            app.SelectSyllablesPanel = uipanel(app.TestOptionsPanel);
            app.SelectSyllablesPanel.Title = 'Select Syllables';
            app.SelectSyllablesPanel.FontSize = 14;
            app.SelectSyllablesPanel.Position = [246 237 444 393];

            % Create SelectWordsPanel
            app.SelectWordsPanel = uipanel(app.TestOptionsPanel);
            app.SelectWordsPanel.Enable = 'off';
            app.SelectWordsPanel.Title = 'Select Words';
            app.SelectWordsPanel.FontSize = 14;
            app.SelectWordsPanel.Position = [246 86 444 124];

            % Create baCheckBox
            app.baCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.baCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.baCheckBox.Text = '/ba/';
            app.baCheckBox.FontSize = 14;
            app.baCheckBox.Position = [20 330 45 22];

            % Create daCheckBox
            app.daCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.daCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.daCheckBox.Text = '/da/';
            app.daCheckBox.FontSize = 14;
            app.daCheckBox.Position = [130 331 45 22];

            % Create maCheckBox
            app.maCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.maCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.maCheckBox.Text = '/ma/';
            app.maCheckBox.FontSize = 14;
            app.maCheckBox.Position = [130 282 49 22];

            % Create taCheckBox
            app.taCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.taCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.taCheckBox.Text = '/ta/';
            app.taCheckBox.FontSize = 14;
            app.taCheckBox.Position = [130 234 41 22];

            % Create xdaCheckBox
            app.xdaCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.xdaCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.xdaCheckBox.Text = '/xda/';
            app.xdaCheckBox.FontSize = 14;
            app.xdaCheckBox.Position = [350 235 52 22];

            % Create vaCheckBox
            app.vaCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.vaCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.vaCheckBox.Text = '/va/';
            app.vaCheckBox.FontSize = 14;
            app.vaCheckBox.Position = [240 235 44 22];

            % Create xzaCheckBox
            app.xzaCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.xzaCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.xzaCheckBox.Text = '/xza/';
            app.xzaCheckBox.FontSize = 14;
            app.xzaCheckBox.Position = [240 182 51 22];

            % Create hawedCheckBox
            app.hawedCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.hawedCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.hawedCheckBox.Text = '/hawed/';
            app.hawedCheckBox.FontSize = 14;
            app.hawedCheckBox.Position = [240 132 71 22];

            % Create heedCheckBox
            app.heedCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.heedCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.heedCheckBox.Text = '/heed/';
            app.heedCheckBox.FontSize = 14;
            app.heedCheckBox.Position = [350 82 61 22];

            % Create hoodCheckBox
            app.hoodCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.hoodCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.hoodCheckBox.Text = '/hood/';
            app.hoodCheckBox.FontSize = 14;
            app.hoodCheckBox.Position = [130 31 61 22];

            % Create kaCheckBox
            app.kaCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.kaCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.kaCheckBox.Text = '/ka/';
            app.kaCheckBox.FontSize = 14;
            app.kaCheckBox.Position = [21 280 44 22];

            % Create saCheckBox
            app.saCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.saCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.saCheckBox.Text = '/sa/';
            app.saCheckBox.FontSize = 14;
            app.saCheckBox.Position = [22 230 44 22];

            % Create xsaCheckBox
            app.xsaCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.xsaCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.xsaCheckBox.Text = '/xsa/';
            app.xsaCheckBox.FontSize = 14;
            app.xsaCheckBox.Position = [22 180 51 22];

            % Create xtaCheckBox
            app.xtaCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.xtaCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.xtaCheckBox.Text = '/xta/';
            app.xtaCheckBox.FontSize = 14;
            app.xtaCheckBox.Position = [130 181 48 22];

            % Create hodCheckBox
            app.hodCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.hodCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.hodCheckBox.Text = '/hod/';
            app.hodCheckBox.FontSize = 14;
            app.hodCheckBox.Position = [130 131 53 22];

            % Create heardCheckBox
            app.heardCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.heardCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.heardCheckBox.Text = '/heard/';
            app.heardCheckBox.FontSize = 14;
            app.heardCheckBox.Position = [130 81 65 22];

            % Create hidCheckBox
            app.hidCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.hidCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.hidCheckBox.Text = '/hid/';
            app.hidCheckBox.FontSize = 14;
            app.hidCheckBox.Position = [240 82 48 22];

            % Create hayedCheckBox
            app.hayedCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.hayedCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.hayedCheckBox.Text = '/hayed/';
            app.hayedCheckBox.FontSize = 14;
            app.hayedCheckBox.Position = [22 80 68 22];

            % Create gaCheckBox
            app.gaCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.gaCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.gaCheckBox.Text = '/ga/';
            app.gaCheckBox.FontSize = 14;
            app.gaCheckBox.Position = [350 331 45 22];

            % Create naCheckBox
            app.naCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.naCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.naCheckBox.Text = '/na/';
            app.naCheckBox.FontSize = 14;
            app.naCheckBox.Position = [240 283 45 22];

            % Create faCheckBox
            app.faCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.faCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.faCheckBox.Text = '/fa/';
            app.faCheckBox.FontSize = 14;
            app.faCheckBox.Position = [240 331 41 22];

            % Create paCheckBox
            app.paCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.paCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.paCheckBox.Text = '/pa/';
            app.paCheckBox.FontSize = 14;
            app.paCheckBox.Position = [350 284 45 22];

            % Create zaCheckBox
            app.zaCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.zaCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.zaCheckBox.Text = '/za/';
            app.zaCheckBox.FontSize = 14;
            app.zaCheckBox.Position = [350 183 44 22];

            % Create headCheckBox
            app.headCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.headCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.headCheckBox.Text = '/head/';
            app.headCheckBox.FontSize = 14;
            app.headCheckBox.Position = [350 133 61 22];

            % Create hadCheckBox
            app.hadCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.hadCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.hadCheckBox.Text = '/had/';
            app.hadCheckBox.FontSize = 14;
            app.hadCheckBox.Position = [22 130 53 22];

            % Create hoedCheckBox
            app.hoedCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.hoedCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.hoedCheckBox.Text = '/hoed/';
            app.hoedCheckBox.FontSize = 14;
            app.hoedCheckBox.Position = [22 30 61 22];

            % Create hudCheckBox
            app.hudCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.hudCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.hudCheckBox.Text = '/hud/';
            app.hudCheckBox.FontSize = 14;
            app.hudCheckBox.Position = [240 31 53 22];

            % Create hooedCheckBox
            app.hooedCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.hooedCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleOneSyllable, true);
            app.hooedCheckBox.Text = '/hooed/';
            app.hooedCheckBox.FontSize = 14;
            app.hooedCheckBox.Position = [350 31 68 22];

            % Create allCheckBox
            app.allCheckBox = uicheckbox(app.SelectSyllablesPanel);
            app.allCheckBox.ValueChangedFcn = createCallbackFcn(app, @toggleAllSyllables, true);
            app.allCheckBox.Text = 'all';
            app.allCheckBox.FontSize = 14;
            app.allCheckBox.FontWeight = 'bold';
            app.allCheckBox.Position = [399 371 37 22];

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
            app.wordsEditField.ValueChangedFcn = createCallbackFcn(app, @wordSelection, true);
            app.wordsEditField.FontSize = 14;
            app.wordsEditField.Position = [169 17 51 22];
            app.wordsEditField.Value = 5;

            % Create NumWordsLabel
            app.NumWordsLabel = uilabel(app.SelectWordsPanel);
            app.NumWordsLabel.WordWrap = 'on';
            app.NumWordsLabel.FontSize = 14;
            app.NumWordsLabel.Position = [20 49 398 41];
            app.NumWordsLabel.Text = 'Choose how many words you would like to include in the test';

            % Create SelectNumberofTrialsPanel
            app.SelectNumberofTrialsPanel = uipanel(app.TestOptionsPanel);
            app.SelectNumberofTrialsPanel.Enable = 'off';
            app.SelectNumberofTrialsPanel.FontSize = 14;
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
            app.trialsEditField.ValueChangedFcn = createCallbackFcn(app, @numberOfTrialsSelection, true);
            app.trialsEditField.FontSize = 14;
            app.trialsEditField.Position = [69 59 61 22];
            app.trialsEditField.Value = 100;

            % Create NumTrialsLabel2
            app.NumTrialsLabel2 = uilabel(app.SelectNumberofTrialsPanel);
            app.NumTrialsLabel2.HorizontalAlignment = 'center';
            app.NumTrialsLabel2.WordWrap = 'on';
            app.NumTrialsLabel2.FontSize = 14;
            app.NumTrialsLabel2.Position = [49 1 135 59];
            app.NumTrialsLabel2.Text = 'will be performed for each sound';

            % Create NextPatientDataButton
            app.NextPatientDataButton = uibutton(app.TestOptionsPanel, 'push');
            app.NextPatientDataButton.ButtonPushedFcn = createCallbackFcn(app, @toPatientInformation, true);
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
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @browseSaveLocation, true);
            app.BrowseButton.FontSize = 14;
            app.BrowseButton.Position = [37 17 119 25];
            app.BrowseButton.Text = 'Browse';

            % Create OtherOptionsPanel
            app.OtherOptionsPanel = uipanel(app.TestOptionsPanel);
            app.OtherOptionsPanel.Title = 'Other Options';
            app.OtherOptionsPanel.FontSize = 14;
            app.OtherOptionsPanel.Position = [715 418 232 77];

            % Create PracticeTestButton
            app.practiceTestCheckBox = uicheckbox(app.OtherOptionsPanel);
            app.practiceTestCheckBox.ValueChangedFcn = createCallbackFcn(app, @togglePracticeTestSelection, true);
            app.practiceTestCheckBox.Text = 'Practice Round';
            app.practiceTestCheckBox.FontSize = 14;
            app.practiceTestCheckBox.Position = [13 15 117 22];

            app.selectedTestType = app.SyllableRecognitionButton;
        end

        % Selects the test type
        function testTypeSelection(app, ~)
            app.selectedTestType = app.SelectTestTypeButtonGroup.SelectedObject;
            % Update buttons
            app.updateNextButton();
            app.updateTestTypePanel();
        end

        % Value changed function: allCheckBox
        function toggleAllSyllables(app, ~)
            value = app.allCheckBox.Value;
            % set value of all syllable checkboxes to value
            for ii = 0:length(app.SelectSyllablesPanel.Children)
                app.SelectSyllablesPanel.Children(ii).Value = value;
            end

            if app.allCheckBox.Value
                app.numCheckedSyllables = 26;
            else
                app.numCheckedSyllables = 0;
            end
            % Update buttons
            app.updateNextButton();
            app.updateTestTypePanel();
        end

        % Value changed function: wordsEditField
        function wordSelection(app, ~)
            % Update buttons
            app.updateNextButton();
            app.updateTestTypePanel();
        end

        % Value changed function: baCheckBox, daCheckBox, faCheckBox, 
        % ...and 25 other components
        function toggleOneSyllable(app, event)
            value = event.Source.Value;
            if value
                app.numCheckedSyllables = app.numCheckedSyllables + 1;
            else
                app.numCheckedSyllables = app.numCheckedSyllables - 1;
            end
            % Update buttons
            app.updateNextButton();
            app.updateTestTypePanel();
        end

        % Value changed function: trialsEditField
        function numberOfTrialsSelection(app, ~)
            app.NextPatientDataButton.Enable = true;
            app.System.test.setNumTrials(app.trialsEditField.Value);
        end


        % Opens the dialog box for saving the dataset into a folder
        function browseSaveLocation(app, ~)
            f = figure('Renderer', 'painters', 'Position', [-100 -100 0 0]);
            path = uigetdir();
            delete(f);
            app.System.test.setSavePath(path);

            % Display folder on button
            folders = split(path, '\');
            folder = folders(end);
            app.BrowseButton.Text = '\' + string(folder);
            app.savedPathChosen = true;
            % Update buttons
            app.updateNextButton();
            app.updateTestTypePanel();
        end

        % Updates the clickability of the next button
        % Users must have chosen a save path, selected a test type, and
        % selected at least one sound to proceed.
        function updateNextButton(app)
            if ~app.savedPathChosen
                app.NextPatientDataButton.Enable = false;
            else
                if app.selectedTestType == app.SyllableRecognitionButton
                    if app.numCheckedSyllables == 0
                        app.NextPatientDataButton.Enable = false;
                    else
                        app.NextPatientDataButton.Enable = true;
                    end
                elseif app.selectedTestType == app.WordRecognitionButton
                    app.NextPatientDataButton.Enable = true;
                end
            end
        end

        % Updates the visibility of the the UI panels based on user
        % selections
        function updateTestTypePanel(app)
            if app.selectedTestType == app.SyllableRecognitionButton
                app.SelectSyllablesPanel.Enable = true;
                app.SelectWordsPanel.Enable = false;
                if app.savedPathChosen
                    if app.numCheckedSyllables == 0
                        app.SelectNumberofTrialsPanel.Enable = false;                    
                    else
                        app.SelectNumberofTrialsPanel.Enable = true;
                    end
                    if app.numCheckedSyllables ~= 26
                        app.allCheckBox.Value = false;
                    elseif app.numCheckedSyllables == 26
                        app.allCheckBox.Value = true;
                    end
                else
                    app.SelectNumberofTrialsPanel.Enable = false;                    
                end
            elseif app.selectedTestType == app.WordRecognitionButton
                app.SelectSyllablesPanel.Enable = false;
                app.SelectWordsPanel.Enable = true;
                if app.savedPathChosen
                    app.SelectNumberofTrialsPanel.Enable = true;
                else
                    app.SelectNumberofTrialsPanel.Enable = false;
                end
            end
        end

        % Triggered by User Event
        function togglePracticeTestSelection(app, ~)
            app.System.setPracticeTest(app.practiceTestCheckBox.Value)
        end

        % Navigates to the next screen
        function toPatientInformation(app, ~)
            % Saves test selections
            if app.SelectTestTypeButtonGroup.SelectedObject == app.SyllableRecognitionButton
                app.System.test.setTestMode(TestType.syllable);
                % collect all syllables that will be used in the Test
                for ii = 1:length(app.SelectSyllablesPanel.Children)
                    if app.SelectSyllablesPanel.Children(ii).Value == true && ~strcmp(app.SelectSyllablesPanel.Children(ii).Text,"all")
                        % Gets the syllable name from the element on the page
                        temp = split(app.SelectSyllablesPanel.Children(ii).Text, '/');
                        temp2 = split(temp(2), '/');
                        % construct a Sound object for the sound
                        app.System.test.createSound(string(temp2(1)), TestType.syllable);
                    end
                end  
                app.System.test.finishSoundSelection();
            else
                app.System.test.setTestMode(TestType.cnc);
                % generate cnc sounds
                app.System.test.generateCNCSounds(app.wordsEditField.Value);
            end
            
            % Build patient data UI
            app.System.toPatientData();
        end
    end
end