classdef Patient
    % Patient Class
    %   Class to hold patient data for a test

    properties
        ID                  string
        DOB                 string
        sex                 string
        leftEarDevice       string
        leftEarDeviceYears  int32
        rightEarDevice      string
        rightEarDeviceYears int32
    end

    methods
        % Class constructor
        function obj = Patient(idIn)
            obj.ID = idIn;
        end
    end
end