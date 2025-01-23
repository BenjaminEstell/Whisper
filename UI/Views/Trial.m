classdef Trial < matlab.apps.AppBase
    % Trial 
    % The Trial class is the UI for each trial performed in the test. 
    properties
        UIFigure                    matlab.ui.Figure
        RecognitionPanel            matlab.ui.container.Panel
        JButton                     matlab.ui.control.StateButton
        FButton                     matlab.ui.control.StateButton
        SoundLabel                  matlab.ui.control.Label
        DifferentLabel              matlab.ui.control.Label
        SameLabel                   matlab.ui.control.Label
        HearSoundsButton            matlab.ui.control.Button
        TestTrialCountLabel         matlab.ui.control.Label
        TestSoundCountLabel         matlab.ui.control.Label
        currentSoundName            string
        currentSoundNumber          int16
        numSounds                   int16
        currentTrial                int16 
        numTrials                   int16
        System                      Whisper
    end
    
    methods

        % Trial Constructor
        % Constructs a Trial object, generates the Trial UI, and begins the
        % trial. The trial object is reused for every trial of the sound.
        % It is destroyed by its parent object (a SoundCard) when the sound
        % is finished.
        % Args
            % currentSoundName      string
            % currentSoundNumber    int     index of the current sound within the sounds array of the test
            % numSounds             int     the number of sounds in the test
            % numTrials             int     the number of trials for each sound
            % system                Whisper a reference to the global system object
            % UIFigure              matlab.ui.Figure    a reference to the figure used to display the trial
        % Returns: the constructed Trial object
        function obj = Trial(currentSoundName, currentSoundNumber, numSounds, numTrials, system, UIFigure)
            obj.currentSoundName = currentSoundName;
            obj.currentSoundNumber = currentSoundNumber;
            obj.currentTrial = 1;
            obj.numSounds = numSounds;
            obj.numTrials = numTrials;
            obj.System = system;
            obj.UIFigure = UIFigure;
            % Generate the stimuli for the trials
            obj.System.test.getCurrentSound().generateStimulusMatrix();
            % Generate the UI for the trials
            obj.createTestComponents();
            pause(0.3);
            % Begin the first trial
            obj.playSounds();
        end

        % Keyboard shortcuts
        % Args
            % KeyData       the value of the key that was pressed
        % Returns: Nothing
        function processKeyPress(app, ~, KeyData)
            if KeyData.Key == 'j'
                app.JButton.Value = true;
                app.nextTrial();
            elseif KeyData.Key == 'f'
                app.FButton.Value = true;
                app.nextTrial();
            elseif KeyData.Key == 'space'
                app.System.test.playSounds(app.currentTrial);
            end
        end

        % Advances to the next trial in the test
        % Called when the user makes a selection
        % Returns: Nothing
        function nextTrial(app, ~)
            % Updates the model
            if app.System.test.nextTrial(app.FButton.Value, app.JButton.Value)
                % If there are more trials remaining
                % Updates the UI from the updated model
                app.currentTrial = app.currentTrial + 1;
                app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrial) + ' of ' + string(app.numTrials);
                app.FButton.Value = false;
                app.JButton.Value = false;
                
                % Play sounds
                app.System.test.playSounds(app.currentTrial);
            end
            % If no trials remain, the Test directs the SoundCard to
            % advance to the next Sound in the Test, deleting the Trial.
        end

        % Plays the sounds for the trial
        % Called when the trial begins or when users request that the
        % sounds be played again
        % Returns: Nothing
        function playSounds(app, ~)
            app.System.test.playSounds(app.currentTrial);
        end


        % Constructs the UI for the Trial
        % Returns: Nothing
        function createTestComponents(app)
            % Allows the UIFigure to respond to keyboard inputs
            set(app.UIFigure, 'KeyPressFcn', @app.processKeyPress);

            % Create RecognitionPanel
            app.RecognitionPanel = uipanel(app.UIFigure);
            app.RecognitionPanel.Title = 'Syllable Recognition';
            app.RecognitionPanel.FontSize = 14;
            app.RecognitionPanel.Position = [16 16 970 670];

            % Create FButton
            app.FButton = uibutton(app.RecognitionPanel, 'state');
            app.FButton.ValueChangedFcn = createCallbackFcn(app, @nextTrial, false);
            app.FButton.Text = 'F';
            app.FButton.FontSize = 48;
            app.FButton.Position = [300 316 90 97];

            % Create JButton
            app.JButton = uibutton(app.RecognitionPanel, 'state');
            app.JButton.ValueChangedFcn = createCallbackFcn(app, @nextTrial, true);
            app.JButton.Text = 'J';
            app.JButton.FontSize = 48;
            app.JButton.Position = [593 317 90 97];

            % Create HearSoundsButton
            app.HearSoundsButton = uibutton(app.RecognitionPanel, 'push');
            app.HearSoundsButton.ButtonPushedFcn = createCallbackFcn(app, @playSounds, true);
            app.HearSoundsButton.FontSize = 18;
            app.HearSoundsButton.Position = [260 149 450 50];
            app.HearSoundsButton.Text = 'Hear Sounds';

            % Create SameLabel
            app.SameLabel = uilabel(app.RecognitionPanel);
            app.SameLabel.HorizontalAlignment = 'center';
            app.SameLabel.WordWrap = 'on';
            app.SameLabel.FontSize = 18;
            app.SameLabel.Position = [280 279 130 41];
            app.SameLabel.Text = 'Similar';

            % Create DifferentLabel
            app.DifferentLabel = uilabel(app.RecognitionPanel);
            app.DifferentLabel.HorizontalAlignment = 'center';
            app.DifferentLabel.WordWrap = 'on';
            app.DifferentLabel.FontSize = 18;
            app.DifferentLabel.Position = [573 280 130 41];
            app.DifferentLabel.Text = 'Different';

            % Create SoundLabel
            app.SoundLabel = uilabel(app.RecognitionPanel);
            app.SoundLabel.HorizontalAlignment = 'center';
            app.SoundLabel.FontSize = 48;
            app.SoundLabel.FontWeight = 'bold';
            app.SoundLabel.Position = [388 472 193 63];
            app.SoundLabel.Text = '/' + app.currentSoundName + '/';

            % Create TestSoundCountLabel
            app.TestSoundCountLabel = uilabel(app.RecognitionPanel);
            app.TestSoundCountLabel.FontSize = 14;
            app.TestSoundCountLabel.Position = [425 647 115 22];
            app.TestSoundCountLabel.Text = 'Sound ' + string(app.currentSoundNumber) + ' of ' + string(app.numSounds);

            % Create TestTrialCountLabel
            app.TestTrialCountLabel = uilabel(app.RecognitionPanel);
            app.TestTrialCountLabel.FontSize = 14;
            app.TestTrialCountLabel.Position = [865 648 94 22];
            app.TestTrialCountLabel.Text = 'Trial ' + string(app.currentTrial) + ' of ' + string(app.numTrials);
        end
    end
end

