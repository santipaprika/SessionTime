-- ADDON MAIN BEHAVIOR --

sessionTime = 0;

-- CREATE FRAME --
f = CreateFrame("Frame", "TimeDisplayFrame", UIParent, "BasicFrameTemplate")
f:SetWidth(256);
f:SetHeight(100);
f:SetPoint("CENTER",0,350)
f:Hide()

-- CREATE FRAME TITLE --
local fsTitle = f:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsTitle:SetText("Total time played this session:")
fsTitle:SetPoint("CENTER",f,"CENTER",0,5)

-- CREATE TIME DISPLAY FONT STRING --
local fsSessionTime = f:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsSessionTime:SetText("0 hours, 0 minutes, 0 seconds")
fsSessionTime:SetPoint("CENTER",f,"CENTER",0,-25)

-- MODIFY TIME DISPLAY TO MATCH CURRENT TIME --
function FormatSessionTime()
    hours = floor(sessionTime / 3600);
    minutes = floor( (sessionTime - hours * 3600)  / 60 );
    seconds = sessionTime - hours * 3600 - minutes * 60;
    fsSessionTime:SetText(string.format("%i hours, %i minutes, %i seconds", hours, minutes, seconds))
end

-- CREATE BUTTON --
local b = CreateFrame("Button", "SessionTimeButton", UIParent, "UIPanelButtonTemplate");
b:SetWidth(108); b:SetHeight(48); b:SetPoint("CENTER", 400, -350);
local fsButton = b:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsButton:SetText("SESSION TIME")
fsButton:SetPoint("CENTER",b,"CENTER",0,0)

-- CLICK UP BUTTON EVENT --
b:RegisterForClicks("AnyUp");
b:SetScript("OnClick", function (self, button, down)
    if f:IsShown() then
        f:Hide()
    else
        FormatSessionTime()
        f:Show()
    end
end);





