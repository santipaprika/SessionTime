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

    elseif event == "PLAYER_LOGOUT" then
        sessionsCounter = sessionsCounter + 1; -- Commit count to memory.
        sessionsTable[sessionsCounter] = {initialSessionDate, sessionTime, characterIdx}; -- Store session time and metadata to disk using the sessionCount (idx) as key.
    end
end

mainFrame:SetScript("OnEvent", mainFrame.OnEvent);