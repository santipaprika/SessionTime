-- ADDON MAIN BEHAVIOR --

sessionTime = 0; -- initialize time counter variable

-- CREATE FRAME --
mainFrame = CreateFrame("Frame", "MainFrame", UIParent, "BasicFrameTemplate")
mainFrame:SetWidth(256);
mainFrame:SetHeight(100);
mainFrame:SetPoint("CENTER",0,350)
mainFrame:Hide()

-- CREATE FRAME TITLE --
local fsTitle = mainFrame:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsTitle:SetText("Total time played this session:")
fsTitle:SetPoint("CENTER",mainFrame,"CENTER",0,5)

-- CREATE TIME DISPLAY FONT STRING --
local fsSessionTime = mainFrame:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsSessionTime:SetText("0 hours, 0 minutes, 0 seconds")
fsSessionTime:SetPoint("CENTER",mainFrame,"CENTER",0,-25)

-- MODIFY TIME DISPLAY TO MATCH CURRENT SESSION TIME --
function FormatSessionTime()
    fsSessionTime:SetText(SecondsToHMSString(sessionTime))
end

function SecondsToHMSString(timeInSeconds)
    print("SECONDS PROCESSING: " .. timeInSeconds);
    hours = floor(timeInSeconds / 3600);
    minutes = floor( (timeInSeconds - hours * 3600)  / 60 );
    seconds = timeInSeconds - hours * 3600 - minutes * 60;
    return string.format("%i hours, %i minutes, %i seconds", hours, minutes, seconds);
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

-- UTILS FUNCTION --
function MakeMovable(frame)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end





