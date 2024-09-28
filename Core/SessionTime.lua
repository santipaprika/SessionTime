-- CREATE FRAME --
mainFrame = STCreateFrame("Frame", "MainFrame", 256, 180, nil, true, nil, nil, {"CENTER",0,300})
mainFrame:Hide()
tinsert(UISpecialFrames, mainFrame:GetName())
mainFrame:HookScript("OnShow", function(self) PlaySound(SOUNDKIT.IG_CHARACTER_INFO_OPEN) end)
mainFrame:HookScript("OnHide", function(self) PlaySound(SOUNDKIT.IG_CHARACTER_INFO_CLOSE) end)

-- CREATE LDB --
local sTime = LibStub("AceAddon-3.0"):NewAddon("SessionTime", "AceConsole-3.0")
local sTimeLDB = LibStub("LibDataBroker-1.1"):NewDataObject("SessionTime", {
type = "data source",
text = "Session Time",
icon = "Interface\\AddOns\\SessionTime\\Textures\\stime-minimap-icon",
OnClick = function() 
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        FormatSessionTime()
        mainFrame:Show()
    end
end,
OnTooltipShow = function(tooltip)
    tooltip:AddLine("Session Time", 1, 1, 1)
    tooltip:AddLine("Current session: " .. GetFormattedTimeString(sessionTime))
    tooltip:AddLine("Total today: " .. GetFormattedTimeString(GetTodaysTotalTime()))
end,
})
local icon = LibStub("LibDBIcon-1.0")


function sTime:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SessionTimeDB", { 
        profile = { minimap = { hide = false, }, }, }) 
    icon:Register("SessionTime", sTimeLDB, self.db.profile.minimap)
end

sessionTime = 0; -- initialize time counter variable
showCharacterData = false;

-- CREATE FRAME TITLE --
local fsTitle = STCreateFrameFontString(mainFrame, "titleFS", {"TOP",mainFrame,"TOP",0,-45})
fsTitle:SetText("Total time played this session:")

-- CREATE TIME DISPLAY FONT STRING --
local fsSessionTime = STCreateFrameFontString(mainFrame, "sessionTimeFS", {"TOP",mainFrame,"TOP",0,-75})
fsSessionTime:SetText("0 hours, 0 minutes, 0 seconds")

-- MODIFY TIME DISPLAY TO MATCH CURRENT SESSION TIME --
function GetFormattedTimeString(time)
    color = BlendColorFromTime(time, {0,255,0}, 3600, {255,255,0}, 7200, {255,0,0})
    return color .. SecondsToHMSString(time)
end

function FormatSessionTime()
    fsSessionTime:SetText(GetFormattedTimeString(sessionTime))
end
