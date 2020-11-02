-- DISPLAY OLD SESSIONS --
function CreateHistoryFrame()
    
    -- OLD SESSIONS FRAME --
    local histFrame = CreateFrame("Frame", "HistFrame", UIParent, "BasicFrameTemplate");
    MakeMovable(histFrame);
    histFrame:SetWidth(380);
    histFrame:SetHeight(200);
    histFrame:SetPoint("CENTER",0,0);

    histFrame.text = histFrame:CreateFontString("SessionsFS", "OVERLAY", "GameTooltipText");
    histFrame.text:SetPoint("TOPLEFT",histFrame,"TOPLEFT",10,-30);
    histFrame.text:SetWidth(histFrame:GetWidth() - 10);
    histFrame.text:SetHeight(histFrame:GetHeight() - 40);
    histFrame.text:SetSpacing(10);
    histFrame.text:SetTextColor(1,0.8,0.8,1);

    histFrame:Hide();

    local sessionsTableString = {"OLD SESSIONS", " "}
    for i = sessionsCounter, 1, -1 do -- Prepare the data to be displaed
        color = i % 2 == 0 and "|cffcccccc" or "|cffffffff";
        table.insert(sessionsTableString, color .. sessionsTable[i][1] .. " - " .. SecondsToHMSString(sessionsTable[i][2]))
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
    histFrameSlider:SetMinMaxValues(0, sessionsCounter - entriesPerPage);
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
    local dataToDisplay = subrange(sessionsTableString, 1, entriesPerPage)
    sessionsString = table.concat(dataToDisplay, "\n") .. "\n";
    histFrame.text:SetText(sessionsString);

    histFrameSlider:SetScript("OnValueChanged", function (self, value)
        dataToDisplay = subrange(sessionsTableString, floor(value)+1, floor(value)+entriesPerPage);
        sessionsString = table.concat(dataToDisplay, "\n") .. "\n"
        histFrame.text:SetText(sessionsString);
    end);


    -- CREATE "SHOW OLD SESSIONS" BUTTON --
    local histFrameButton = CreateFrame("Button", "SessionHistorialButton", mainFrame, "UIPanelButtonTemplate");
    histFrameButton:SetWidth(120); 
    histFrameButton:SetHeight(35); 
    histFrameButton:SetPoint("BOTTOM", mainFrame, -50, 15);

    local fsHistButton = histFrameButton:CreateFontString(nil,"OVERLAY","GameTooltipText");
    fsHistButton:SetText("Show all sessions");
    fsHistButton:SetPoint("CENTER",histFrameButton,"CENTER",0,0);

    -- CLICK UP BUTTON EVENT --
    histFrameButton:RegisterForClicks("AnyUp");
    histFrameButton:SetScript("OnClick", function (self, button, down)
        if histFrame:IsShown() then
            histFrame:Hide()
        else
            histFrame:Show()
        end
    end);

end