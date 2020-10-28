-- ADDON MAIN BEHAVIOR --

sessionTime = 0;

-- CREATE FRAME --
timeDispFrame = CreateFrame("Frame", "TimeDisplayFrame", UIParent, "BasicFrameTemplate")
timeDispFrame:SetWidth(256);
timeDispFrame:SetHeight(100);
timeDispFrame:SetPoint("CENTER",0,350)
timeDispFrame:Hide()

-- CREATE FRAME TITLE --
local fsTitle = timeDispFrame:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsTitle:SetText("Total time played this session:")
fsTitle:SetPoint("CENTER",timeDispFrame,"CENTER",0,5)

-- CREATE TIME DISPLAY FONT STRING --
local fsSessionTime = timeDispFrame:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsSessionTime:SetText("0 hours, 0 minutes, 0 seconds")
fsSessionTime:SetPoint("CENTER",timeDispFrame,"CENTER",0,-25)

-- MODIFY TIME DISPLAY TO MATCH CURRENT TIME --
function FormatSessionTime()
    hours = floor(sessionTime / 3600);
    minutes = floor( (sessionTime - hours * 3600)  / 60 );
    seconds = sessionTime - hours * 3600 - minutes * 60;
    fsSessionTime:SetText(string.format("%i hours, %i minutes, %i seconds", hours, minutes, seconds))
end

-- CREATE BUTTON --
local timeDispButton = CreateFrame("Button", "SessionTimeButton", UIParent, "UIPanelButtonTemplate");
timeDispButton:SetWidth(108); timeDispButton:SetHeight(48); timeDispButton:SetPoint("CENTER", 400, -350);
local fsButton = timeDispButton:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsButton:SetText("SESSION TIME")
fsButton:SetPoint("CENTER",timeDispButton,"CENTER",0,0)

-- CLICK UP BUTTON EVENT --
timeDispButton:RegisterForClicks("AnyUp");
timeDispButton:SetScript("OnClick", function (self, button, down)
    if timeDispFrame:IsShown() then
        timeDispFrame:Hide()
    else
        FormatSessionTime()
        timeDispFrame:Show()
    end
end);





