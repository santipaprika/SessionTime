-- DISPLAY OLD SESSIONS --
function CreateHistoryFrame()
    
    -- OLD SESSIONS FRAME --
    local histFrame = STCreateFrame("Frame", "HistFrame", 380, 200, "HIGH");

    histFrame.text = histFrame:CreateFontString("SessionsFS", "OVERLAY", "GameTooltipText");
    histFrame.text:SetPoint("TOPLEFT",histFrame,"TOPLEFT",10,-30);
    histFrame.text:SetWidth(histFrame:GetWidth() - 10);
    histFrame.text:SetHeight(histFrame:GetHeight() - 40);
    histFrame.text:SetSpacing(10);
    histFrame.text:SetTextColor(1,0.8,0.8,1);

    histFrame:Hide();


    -- CREATE "SHOW OLD SESSIONS" BUTTON --
    local histFrameButton = STCreateFrame("Button", "SessionHistorialButton", 120, 35, "MEDIUM", mainFrame, "UIPanelButtonTemplate", {"BOTTOM", -50, 15})

    local fsHistButton = histFrameButton:CreateFontString(nil,"OVERLAY","GameTooltipText");
    fsHistButton:SetText("Show all sessions");
    fsHistButton:SetPoint("CENTER",histFrameButton,"CENTER",0,0);

    -- CLICK UP BUTTON EVENT --
    histFrameButton:RegisterForClicks("AnyUp");
    STRegisterButtonFrameDisplay(histFrameButton, histFrame)

    local sessionsTableString = {"OLD SESSIONS", " "}

    if (sessionsCounter > 0) then
        for i = sessionsCounter, 1, -1 do -- Prepare the data to be displaed
            local color = BlendColorFromTime(sessionsTable[i][2], {0,255,0}, 3600, {255,255,0}, 7200, {255,0,0});
            table.insert(sessionsTableString, color .. sessionsTable[i][1] .. " - " .. SecondsToHMSString(sessionsTable[i][2]))
        end
    end


    local entriesPerPage = 7;

    -- FRAME SLIDER --
    local histFrameSlider = CreateFrame("Slider", "HistFrameSlider", histFrame, "UIPanelScrollBarTemplate");
    histFrameSlider:ClearAllPoints();
    histFrameSlider:SetWidth(20);
    histFrameSlider:SetHeight(histFrame:GetHeight() - 60);
    histFrameSlider:SetOrientation('VERTICAL');
    histFrameSlider:SetPoint("CENTER", histFrame, histFrame:GetWidth() / 2 - 15, - 10);
    histFrameSlider:SetScript("OnValueChanged", nil);

    local dataToDisplay;

    if (sessionsCounter + 2 <= entriesPerPage) then
        histFrameSlider:SetMinMaxValues(0,0);
        histFrameSlider:Hide();
        dataToDisplay = sessionsTableString;
    else
        histFrameSlider:SetMinMaxValues(0, sessionsCounter + 2 - entriesPerPage);
        dataToDisplay = subrange(sessionsTableString, 1, entriesPerPage)
    end

    histFrameSlider:SetValue(0);

    histFrameSlider:EnableMouseWheel(true);
    histFrame:EnableMouseWheel(true);
    histFrame:SetScript("OnMouseWheel", function(self, delta)
        histFrameSlider:SetValue(histFrameSlider:GetValue() - delta);
    end)
    histFrameSlider:SetScript("OnMouseWheel", function(self, delta)
        histFrameSlider:SetValue(histFrameSlider:GetValue() - delta);
    end)


    -- INITIAL DISPLAYED DATA

    sessionsString = table.concat(dataToDisplay, "\n") .. "\n";
    histFrame.text:SetText(sessionsString);

    histFrameSlider:SetScript("OnValueChanged", function (self, value)
        dataToDisplay = subrange(sessionsTableString, floor(value)+1, floor(value)+entriesPerPage);
        sessionsString = table.concat(dataToDisplay, "\n") .. "\n"
        histFrame.text:SetText(sessionsString);
    end);

end