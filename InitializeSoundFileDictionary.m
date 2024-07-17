% InitializeSoundFileDictionary

% Initializes a dictionary that maps Sound names to filenames


function soundToFilename = InitializeSoundFileDictionary()s
    soundToFilename = configureDictionary("string", "string");
    soundToFilename.insert("ba", "phoneme_sounds/ba.wav");
    soundToFilename.insert("da", "phoneme_sounds/da.wav");
    soundToFilename.insert("fa", "phoneme_sounds/fa.wav");
    soundToFilename.insert("ga", "phoneme_sounds/ga.wav");
    soundToFilename.insert("had", "phoneme_sounds/had.wav");
    soundToFilename.insert("hawed", "phoneme_sounds/hawed.wav");
    soundToFilename.insert("hayed", "phoneme_sounds/hayed.wav");
    soundToFilename.insert("head", "phoneme_sounds/head.wav");
    soundToFilename.insert("heard", "phoneme_sounds/heard.wav");
    soundToFilename.insert("heed", "phoneme_sounds/heed.wav");
    soundToFilename.insert("hid", "phoneme_sounds/hid.wav");
    soundToFilename.insert("hod", "phoneme_sounds/hod.wav");
    soundToFilename.insert("hood", "phoneme_sounds/hood.wav");
    soundToFilename.insert("hooed", "phoneme_sounds/hooed.wav");
    soundToFilename.insert("howed", "phoneme_sounds/howed.wav");
    soundToFilename.insert("hud", "phoneme_sounds/hud.wav");
    soundToFilename.insert("ka", "phoneme_sounds/ka.wav");
    soundToFilename.insert("ma", "phoneme_sounds/ma.wav");
    soundToFilename.insert("na", "phoneme_sounds/na.wav");
    soundToFilename.insert("pa", "phoneme_sounds/pa.wav");
    soundToFilename.insert("sa", "phoneme_sounds/sa.wav");
    soundToFilename.insert("ta", "phoneme_sounds/ta.wav");
    soundToFilename.insert("va", "phoneme_sounds/va.wav");
    soundToFilename.insert("xda", "phoneme_sounds/xda.wav");
    soundToFilename.insert("xsa", "phoneme_sounds/xsa.wav");
    soundToFilename.insert("xta", "phoneme_sounds/xta.wav");
    soundToFilename.insert("xza", "phoneme_sounds/xza.wav");
    soundToFilename.insert("za", "phoneme_sounds/za.wav");
end