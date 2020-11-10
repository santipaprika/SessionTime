-- ADDON MAIN BEHAVIOR --

sessionTime = 0; -- initialize time counter variable

-- CREATE FRAME --
mainFrame = CreateFrame("Frame", "MainFrame", UIParent, "BasicFrameTemplate")
mainFrame:SetWidth(256);
mainFrame:SetHeight(150);
mainFrame:SetPoint("CENTER",0,350)
mainFrame:Hide()

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

-- CREATE DISPLAY TRIGGER BUTTON --
local mainButton = CreateFrame("Button", "MainButton", UIParent, "UIPanelButtonTemplate");
mainButton:SetWidth(108); mainButton:SetHeight(48); mainButton:SetPoint("CENTER", 400, -350);

local fsMainButton = mainButton:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsMainButton:SetText("SESSION TIME")
fsMainButton:SetPoint("CENTER",mainButton,"CENTER",0,0)

-- CLICK UP BUTTON EVENT --
mainButton:RegisterForClicks("AnyUp");
mainButton:SetScript("OnClick", function (self, button, down)
    if mainFrame:IsShown() then
        mainFrame:Hide()
    else
        FormatSessionTime()
        mainFrame:Show()
    end
end);

function CreateEvents()
    MakeMovable(mainFrame);
    MakeMovable(mainButton);
end





