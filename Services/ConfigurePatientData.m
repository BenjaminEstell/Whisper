function patient = ConfigurePatientData(app)
    app.System.test.patient.ID = app.PatientIDEditField.Value;
    app.System.test.patient.DOB = app.DateofBirthDatePicker.Value;
    app.System.test.patient.sex = app.SexDropDown.Value;
    app.System.test.patient.leftEarDevice = app.LeftEarHearingDeviceDropDown.Value;
    app.System.test.patient.leftEarDeviceYears = app.YearssinceleftearhearingdeviceinsertionEditField.Value;
    app.System.test.patient.rightEarDevice = app.RightEarHearingDeviceDropDown.Value;
    app.System.test.patient.rightEarDeviceYears = app.YearssincerightearhearingdeviceinsertionEditField.Value;
    patient = app.System.test.patient;
end

