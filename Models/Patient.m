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
        left250
        left500
        left1000
        left2000
        left4000
        left8000
        right250
        right500
        right1000
        right2000
        right4000
        right8000
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

        function setHearingThresholds(app, ear, a, b, c, d, e, f)
            if strcmp(ear, 'left')
                app.left250 = a;
                app.left500 = b;
                app.left1000 = c;
                app.left2000 = d;
                app.left4000 = e;
                app.left8000 = f;
            elseif strcmp(ear, 'right')
                app.right250 = a;
                app.right500 = b;
                app.right1000 = c;
                app.right2000 = d;
                app.right4000 = e;
                app.right8000 = f;
            end
        end
    end
end