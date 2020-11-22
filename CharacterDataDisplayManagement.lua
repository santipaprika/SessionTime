local useCharacterDataCB = STCreateFrame("CheckButton", "UseCharacterDataCheckButton", 20, 20, "DIALOG", false, mainFrame, "UICheckButtonTemplate");

local function displayCharacterData()
    showCharacterData = useCharacterDataCB:GetChecked();

    local dayTimeTable = computeDayTimeTable()
    DefineStats(dayTimeTable);
    UpdateStats();

    BuildSessionsTableString();
end

STRegisterCheckboxChange(useCharacterDataCB, displayCharacterData )