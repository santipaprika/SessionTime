local useCharacterDataCB = STCreateFrame("CheckButton", "UseCharacterDataCheckButton", 20, 20, "DIALOG", false, mainFrame, "UICheckButtonTemplate", {"CENTER", -65,-65});

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


local checkButtonFS = STCreateFrameFontString(useCharacterDataCB, "CheckButtonFS", {"CENTER",70,0})
checkButtonFS:SetText("View character data")
checkButtonFS:SetTextColor(1,1,0,1);