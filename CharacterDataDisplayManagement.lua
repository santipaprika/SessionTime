local useCharacterDataCB = STCreateFrame("CheckButton", "UseCharacterDataCheckButton", 20, 20, "MEDIUM", false, mainFrame, "UICheckButtonTemplate", {"CENTER", -65,-65});

local function displayCharacterData()
    showCharacterData = useCharacterDataCB:GetChecked();
    
    if (sessionsCounter > 0) then
        local dayTimeTable = computeDayTimeTable()
        DefineStats(dayTimeTable)
    end
    UpdateStats()
        
    BuildSessionsTableString();
end

STRegisterCheckboxChange(useCharacterDataCB, displayCharacterData )


local checkButtonFS = STCreateFrameFontString(useCharacterDataCB, "CheckButtonFS", {"CENTER",70,0}, nil, nil, {1,1,0,1})
checkButtonFS:SetText("View character data")