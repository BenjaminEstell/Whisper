DataFolder = "\Data\Pilot Dataset\Bimodal Data";
PatientFolder = "\Juliet August-19-Sep-2024 13.16.07";
Sound = "\fa";

% Load Sounds
freqDivisor = 4;
filename = "\Sounds\syllable_sounds" + Sound + ".wav";
[originalSoundAudio, samplingRate] = audioread(filename);
numSamples = size(originalSoundAudio, 1);
% Convert to frequency domain
resizedFrequencyDomain = imresize(fft(originalSoundAudio), [freqDivisor*numSamples 1], "nearest");
originalSoundFrequency = resizedFrequencyDomain(1:numSamples);
numFreqs = floor(numSamples/freqDivisor);
numSamples = numFreqs * freqDivisor;
originalSound = abs(imresize(originalSoundFrequency, [numFreqs; 1], "nearest"));

% Load RC sound
pathToRCSound = DataFolder + PatientFolder + "\Sounds" + Sound + "\InternalRepresentation.txt";
RCSound = readmatrix(pathToRCSound);
internalRepresentation = imresize(RCSound, [numFreqs 1], "nearest");
match = rms(originalSound) / rms(internalRepresentation);
internalRepresentation = abs(internalRepresentation).*match;

% Smooth both sounds
originalSoundSmooth1 = SegmentedSmooth(originalSound, 20, 2);
internalRepresentationSmooth1 = SegmentedSmooth(internalRepresentation, 20, 2);


originalColor = "#B700FF";
RCColor = "#D89B00";

% figure(1);
% x = 1:numFreqs;
% area(x, originalSoundSmooth1, FaceColor=originalColor, EdgeColor=originalColor, FaceAlpha=0.7, EdgeAlpha=0.8);
% hold on;
% area(x, internalRepresentationSmooth1, FaceColor=RCColor, EdgeColor=RCColor, FaceAlpha=0.5, EdgeAlpha=0.8);
% legend('Original Sound', 'RC Sound');
% title("NH4 /da/")
% xlabel("Frequency (Hz)");
% ylabel("Amplitude");
% hold off;


% Just for fun, let's make a chart of original sound - internal
% representation
% figure(2);
% diff = originalSoundSmooth1 - internalRepresentationSmooth1;
% plot(x, diff, 'blue');
% hold on;
% horizontalLine = zeros(numFreqs);
% plot(x, horizontalLine, '--');
% xlabel("Frequency (Hz)");
% ylabel("Amplitude");
% title("Difference between Original Sound and RC Sound (NH4 /da/)");
% hold off;



% Make a series of 5 charts of stimuli
pathToStimMatrix = DataFolder + PatientFolder + "\Sounds" + Sound + "\StimulusMatrix.txt";

% stimulusMatrix = readmatrix(pathToStimMatrix);
% for i= 1:5
%     stimFrequencyDomain = imresize(stimulusMatrix(i, :)', [numFreqs 1], "nearest");
%     freqSmooth = SegmentedSmooth(abs(stimFrequencyDomain), 20, 2);
%     figure(i);
%     plot(freqSmooth, "LineWidth", 2);
% end


% Make an RC chart
figure(3);
plot(SegmentedSmooth(internalRepresentation, 20, 2), "LineWidth", 2);

% NH Charts
figure(6);
smooth2 = SegmentedSmooth(internalRepresentationSmooth1, 30, 2);
plot(originalSoundSmooth1, 'black');
hold on;
plot(smooth2, "--");
hold off;
xlabel("Frequency (Hz)", "FontSize",17);
ylabel("Amplitude", "FontSize", 17);
lg = legend('Original Sound', 'Integrated Sound');
fontsize(lg, 12, "points");
title("/fa/", "FontSize", 17);
set(gca, "FontSize", 14);

% figure(7);
% smooth2 = SegmentedSmooth(internalRepresentationSmooth1, 30, 2);
% plot(originalSoundSmooth1, 'black');
% hold on;
% plot(smooth2, "--");
% hold off;
% xlabel("Frequency (Hz)", "FontSize",17);
% ylabel("Amplitude", "FontSize", 17);
% lg = legend('Original Sound', 'Integrated Sound');
% fontsize(lg, 12, "points");
% title("NH2 /ba/", "FontSize", 17);
% set(gca, "FontSize", 14);
% 
% figure(8);
% smooth2 = SegmentedSmooth(internalRepresentationSmooth1, 30, 2);
% plot(originalSoundSmooth1, 'black');
% hold on;
% plot(smooth2, "--");
% hold off;
% xlabel("Frequency (Hz)", "FontSize",17);
% ylabel("Amplitude", "FontSize", 17);
% lg = legend('Original Sound', 'Integrated Sound');
% fontsize(lg, 12, "points");
% title("NH3 /ba/", "FontSize",  17);
% set(gca, "FontSize", 14);