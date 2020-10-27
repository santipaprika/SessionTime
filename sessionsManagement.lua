f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("PLAYER_LOGOUT");

local initialSessionDate = date("%m/%d/%y %H:%M:%S"); -- this will be the key for the new entry of our saved table variable

function f:OnEvent(event, arg1)
    if event == "ADDON_LOADED" and arg1 == "SessionTime" then
        -- Saved variables are ready at this point. If there are none, variables will be set to nil.
        if (sessionsCounter == nil or sessionsTable == nil) then
            sessionsCounter = 0; -- This is the first time this addon is loaded; initialize the count to 0.
            sessionsTable = {}; -- And declare the table which will store each session time.
        end

    elseif event == "PLAYER_LOGOUT" then
        sessionsCounter = sessionsCounter + 1; -- Commit to memory.
        sessionsTable[initialSessionDate] = sessionTime; -- Add session time to memory using the initial date as key.

        -- (sessionsCounter not necessary atm. Pending to check whether it is more efficient to use a single table
        -- with dates and sessions time or two tables, one with index and date, and the other with index and session time,
        -- which allow easier sorting.)
    end
end

f:SetScript("OnEvent", f.OnEvent);