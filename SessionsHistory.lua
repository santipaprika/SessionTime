-- DISPLAY OLD SESSIONS --
function CreateHistoryFrame()
    -- CREATE "SHOW OLD SESSIONS" BUTTON --
    local histFrameButton = CreateFrame("Button", "SessionHistorialButton", mainFrame, "UIPanelButtonTemplate");
    histFrameButton:SetWidth(120); 
    histFrameButton:SetHeight(35); 
    histFrameButton:SetPoint("CENTER", mainFrame, 0, -60);

    local fsHistButton = histFrameButton:CreateFontString(nil,"OVERLAY","GameTooltipText");
    fsHistButton:SetText("Show all sessions");
    fsHistButton:SetPoint("CENTER",histFrameButton,"CENTER",0,0);

    -- CLICK UP BUTTON EVENT --
    histFrameButton:RegisterForClicks("AnyUp");
    histFrameButton:SetScript("OnClick", function (self, button, down)
        if mainFrame:IsShown() then
            mainFrame:Hide()
        else
            FormatSessionTime()
            mainFrame:Show()
        end
    end);

    -- OLD SESSIONS FRAME --
    local histFrame = CreateFrame("Frame", "HistFrame", UIParent, "BasicFrameTemplate");
    MakeMovable(histFrame);
    histFrame:SetWidth(512);
    histFrame:SetHeight(200);
    histFrame:SetPoint("CENTER",0,0);

    histFrame.text = histFrame:CreateFontString("SessionsFS", "OVERLAY", "GameTooltipText");
    histFrame.text:SetPoint("TOPLEFT",histFrame,"TOPLEFT",10,-30)
    histFrame.text:SetWidth(histFrame:GetWidth() - 10)
    histFrame.text:SetHeight(histFrame:GetHeight() - 40)

    local sessionsTemp = {}
    for i = #sessionsTable, 1, -1 do
        table.insert(sessionsTemp, sessionsTable[i][1] .. " - " .. SecondsToHMSString(sessionsTable[i][2]))
    end

    sessionsString = table.concat(sessionsTemp, "\n") .. "\n"
    print(sessionsString);

    histFrame.text:SetText(sessionsString);

    local histFrameSlider = CreateFrame("Slider", "HistFrameSlider", histFrame, "UIPanelScrollBarTemplate");
    histFrameSlider:ClearAllPoints()
    histFrameSlider:SetWidth(20);
    histFrameSlider:SetHeight(histFrame:GetHeight() - 60);
    histFrameSlider:SetOrientation('VERTICAL');
    histFrameSlider:SetPoint("CENTER", histFrame, histFrame:GetWidth() / 2 - 15, - 10);
    histFrameSlider:SetScript("OnValueChanged", nil);
    histFrameSlider:SetMinMaxValues(0, sessionsCounter);
    histFrameSlider:SetValue(0);
    histFrameSlider:EnableMouseWheel(true);
    histFrameSlider:SetScript("OnMouseWheel", function(self, delta)
        histFrameSlider:SetValue(histFrameSlider:GetValue() - delta);
    end)
end