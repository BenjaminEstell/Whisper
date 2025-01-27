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
        left125             int32
        left250
        left500
        left1000
        left2000
        left3000
        left4000
        left8000
        right125             int32
        right250
        right500
        right1000
        right2000
        right3000
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

        function setHearingThresholds(app, ear, a, b, c, d, e, f, g, h)
            if strcmp(ear, 'right')
                app.left125 = a;
                app.left250 = b;
                app.left500 = c;
                app.left1000 = d;
                app.left2000 = e;
                app.left3000 = f;
                app.left4000 = g;
                app.left8000 = h;
            elseif strcmp(ear, 'left')
                app.right125 = a;
                app.right250 = b;
                app.right500 = c;
                app.right1000 = d;
                app.right2000 = e;
                app.right3000 = f;
                app.right4000 = g;
                app.right8000 = h;
            end
        end
    end
end