-- DISPLAY OLD SESSIONS --
function CreateHistoryFrame()
    
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

    histFrame:Hide();

    local sessionsTableString = {}
    for i = sessionsCounter, 1, -1 do -- Prepare the data to be displaed
        table.insert(sessionsTableString, sessionsTable[i][1] .. " - " .. SecondsToHMSString(sessionsTable[i][2]))
    end

    -- FRAME SLIDER --
    local histFrameSlider = CreateFrame("Slider", "HistFrameSlider", histFrame, "UIPanelScrollBarTemplate");
    histFrameSlider:ClearAllPoints();
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

    -- INITIAL DISPLAYED DATA
    print(sessionsTableString[1]);
    local dataToDisplay = subrange(sessionsTableString, 1, 9) -- table.unpack(sessionsTableString, 1, 9);
    print("hola");
    sessionsString = table.concat(dataToDisplay, "\n") .. "\n"
    print(sessionsString);
    histFrame.text:SetText(sessionsString);

    histFrameSlider:SetScript("OnValueChanged", function (self, value)
        dataToDisplay = subrange(sessionsTableString, floor(value)+1, floor(value)+9);
        sessionsString = table.concat(dataToDisplay, "\n") .. "\n"
        histFrame.text:SetText(sessionsString);
    end);


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
        if histFrame:IsShown() then
            histFrame:Hide()
        else
            histFrame:Show()
        end
    end);

end