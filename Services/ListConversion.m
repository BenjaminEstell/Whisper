% Converts a list of Sound objects to a list of sound names suitable for a
% UI list
% Called when the test report UI is constructed
% Returns: listOut      a list of strings
function listOut = ListConversion(listIn)
    listOut = {};
    for ii = 1:length(listIn)
        listOut{end + 1} = char(string(listIn{ii}.name));
    end
end