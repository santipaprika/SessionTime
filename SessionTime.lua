-- ADDON MAIN BEHAVIOR --

-- CREATE FRAME --
mainFrame = CreateFrame("Frame", "MainFrame", UIParent, "BasicFrameTemplate")
mainFrame:SetWidth(256);
mainFrame:SetHeight(150);
mainFrame:SetPoint("CENTER",0,350)
mainFrame:Hide()

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
})
local icon = LibStub("LibDBIcon-1.0")

function sTime:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SessionTimeDB", { 
        profile = { minimap = { hide = false, }, }, }) 
    icon:Register("SessionTime", sTimeLDB, self.db.profile.minimap)
end

sessionTime = 0; -- initialize time counter variable

-- CREATE FRAME TITLE --
local fsTitle = mainFrame:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsTitle:SetText("Total time played this session:")
fsTitle:SetPoint("TOP",mainFrame,"TOP",0,-45)

-- CREATE TIME DISPLAY FONT STRING --
local fsSessionTime = mainFrame:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsSessionTime:SetText("0 hours, 0 minutes, 0 seconds")
fsSessionTime:SetPoint("TOP",mainFrame,"TOP",0,-75)

-- MODIFY TIME DISPLAY TO MATCH CURRENT SESSION TIME --
function FormatSessionTime()
    color = BlendColorFromTime(sessionTime, {0,255,0}, 3600, {255,255,0}, 7200, {255,0,0})
    fsSessionTime:SetText(color .. SecondsToHMSString(sessionTime))
end

function CreateEvents()
    MakeMovable(mainFrame);
end





