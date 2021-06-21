-- THIS SCRIPT ALSO CALLS SOME UNRELATED FUNCTIONS ONCE THE ADDON HAS BEEN LOADED 

mainFrame:RegisterEvent("ADDON_LOADED");
mainFrame:RegisterEvent("PLAYER_LOGOUT");

local initialSessionDate = date("%m/%d/%y %H:%M:%S");

function mainFrame:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "SessionTime" then
        -- Saved variables are ready at this point. If there are none, variables will be set to nil.
        if (sessionsCounter == nil or sessionsTable == nil) then
            sessionsCounter = 0; -- This is the first time this addon is loaded; initialize the count to 0.
            sessionsTable = {}; -- And declare the table which will store each session time.
        end

        if (characters == nil) then
            characters = {}
        end

        local characterName, _ = UnitName("player");   -- check if current player has been registered before.
        local currentCharacter = characterName .. " - " .. GetRealmName();

        characterIdx = -1;
        for key,value in ipairs(characters) do
            if (value == currentCharacter) then
                characterIdx = key;
            end
        end

        if characterIdx == -1 then 
            characters[#characters+1] = currentCharacter; 
            characterIdx = #characters;
        end
        
        CreateHistoryFrame();
        InitializeUserStats();
        CreateCSVFrame();

    elseif event == "PLAYER_LOGOUT" then
        sessionsCounter = sessionsCounter + 1; -- Commit count to memory.
        sessionsTable[sessionsCounter] = {initialSessionDate, sessionTime, characterIdx}; -- Store session time and metadata to disk using the sessionCount (idx) as key.
    end
end

function CreateCSVFrame()
    
    -- CSV SESSIONS FRAME --
    local CSVFrame = STCreateFrame("Frame", "CSVFrame", 600, 200, "HIGH", true);
    CSVFrame.text = STCreateFrameFontString(CSVFrame, "SessionsFS", {"TOPLEFT",CSVFrame,"TOPLEFT",10,40}, CSVFrame:GetWidth() - 10, CSVFrame:GetHeight() - 40, {1,0.8,0.8,1});
    CSVFrame.text:SetText("Select (Ctrl+A) and copy (Ctrl+C) the content in the box to get all your session data in CSV format.");
    CSVFrame:Hide();
    
    -- EDIT BOX BACKGROUND --
    local BGEditBox = STCreateFrame("Frame", "BgCSVFrame", CSVFrame:GetWidth() - 40, CSVFrame:GetHeight() - 60, "HIGH", false, CSVFrame, BackdropTemplateMixin and "BackdropTemplate");
    BGEditBox:SetPoint("CENTER", CSVFrame, "CENTER", -8, -25)
    BGEditBox:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })
    BGEditBox:SetBackdropColor(0, 0, .5, .5)
    
    -- SCROLL FOR EDIT BOX --
    local scrollFrame = CreateFrame("ScrollFrame", nil, BGEditBox, "UIPanelScrollFrameTemplate")
    scrollFrame:SetSize(BGEditBox:GetWidth() - 40, BGEditBox:GetHeight() - 10)
    scrollFrame:SetPoint("CENTER", -8, 0)
    
    -- CREATE EDIT BOX TO CONTAINING CSV DATA --
    local editBox = CreateFrame("EditBox", nil, scrollFrame)
    editBox:SetMultiLine(true)
    editBox:SetFontObject(ChatFontNormal)
    editBox:SetWidth(scrollFrame:GetWidth())
    editBox:SetHeight(scrollFrame:GetHeight())
    editBox:SetAutoFocus()
    editBox:HighlightText()
    scrollFrame:SetScrollChild(editBox)

    -- FILL WITH USER DATA --
    local outString = 'date' .. "," .. 'start-time' .. "," .. 'character' .. "," .. 'session-time' .. "\n"
    for _, session in pairs(sessionsTable) do
      local date = strsub(session[1], 1, 8)
      local time = strsub(session[1], 10)
      outString = outString .. date .. "," .. time .. "," .. characters[session[3]] .. "," .. session[2] .. "\n"
    end
    editBox:SetText(outString)

    -- CREATE BUTTON TO DISPLAY CSV DATA IN EDIT BOX --
    local CSVFrameButton = STCreateFrame("Button", "CSVFrameButton", 60, 19, "MEDIUM", false, mainFrame, "UIPanelButtonTemplate", {"TOP", 75, -1});
    CSVFrameButton.text = STCreateFrameFontString(CSVFrameButton, "CSVButtonFS", nil, nil, nil, nil, nil, "InvoiceFont_Small");
    CSVFrameButton.text:SetText("Get CSV");

    -- CLICK BUTTON EVENT --
    STRegisterButtonFrameDisplay(CSVFrameButton, CSVFrame)
end

mainFrame:SetScript("OnEvent", mainFrame.OnEvent);