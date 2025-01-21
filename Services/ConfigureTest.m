 % Called when the User is completed configuring the test
 % Updates the Test with the selected user options
 function test = ConfigureTest(app)
    % record mode and sounds chosen
    if app.SelectTestTypeButtonGroup.SelectedObject == app.SyllableRecognitionButton
        app.System.test.mode = TestType.syllable;
        % collect all syllables that will be used in the Test
        for ii = 1:length(app.SelectSyllablesPanel.Children)
            if app.SelectSyllablesPanel.Children(ii).Value == true && ~strcmp(app.SelectSyllablesPanel.Children(ii).Text,"all")
                % Gets the syllable name from the element on the page
                temp = split(app.SelectSyllablesPanel.Children(ii).Text, '/');
                temp2 = split(temp(2), '/');
                % construct a Sound object for the sound
                newSound = Sound(string(temp2(1)), TestType.syllable, app.System.test.numTrials);
                % store the new Sound in the Test
                app.System.test.sounds{end+1} = newSound;
            end
        end
        app.System.test.numSounds = length(app.System.test.sounds);
    else
        app.System.test.mode = TestType.cnc;
        cncMap = mapCNCNames();
        % choose numSounds random cnc sounds
        app.System.test.numSounds = app.wordsEditField.Value;
        % pick random numbers between 100 and 1049 
        randomNumberSet = randperm(499, app.System.test.numSounds);
        % for each random number, construct a Sound object
        for ii = 1:size(randomNumberSet, 1)
            newSound = Sound(string(randomNumberSet(ii)), TestType.cnc, app.System.test.numTrials);
            newSound = newSound.setName(lookup(cncMap, newSound.name));
            % store the new Sound in the Test
            app.System.test.sounds{end+1} = newSound;
        end
    end
    test = app.System.test;
end