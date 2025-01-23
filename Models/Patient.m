classdef Patient < handle
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
        function obj = Patient(idIn, DOB, sex)
            obj.ID = idIn;
            obj.DOB = DOB;
            obj.sex = sex;
        end

        function setPatientHearing(obj, leftDevice, leftYears, rightDevice, rightYears)
            obj.leftEarDevice = leftDevice;
            obj.leftEarDeviceYears = leftYears;
            obj.rightEarDevice = rightDevice;
            obj.rightEarDeviceYears = rightYears;
        end
    end
end