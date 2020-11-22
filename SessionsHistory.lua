-- DISPLAY OLD SESSIONS --
function CreateHistoryFrame()
    
    -- OLD SESSIONS FRAME --
    histFrame = STCreateFrame("Frame", "HistFrame", 380, 200, "HIGH", true);

    histFrame.text = STCreateFrameFontString(histFrame, "SessionsFS", {"TOPLEFT",histFrame,"TOPLEFT",10,-30}, histFrame:GetWidth() - 10, histFrame:GetHeight() - 40, {1,0.8,0.8,1})
    histFrame.text:SetSpacing(10);
    histFrame:Hide();


    -- CREATE "SHOW OLD SESSIONS" BUTTON --
    local histFrameButton = STCreateFrame("Button", "SessionHistorialButton", 120, 35, "MEDIUM", false, mainFrame, "UIPanelButtonTemplate", {"BOTTOM", -50, 15})

    histFrameButton.text = STCreateFrameFontString(histFrameButton, "HistButtonFS")
    histFrameButton.text:SetText("Show all sessions");

    -- CLICK UP BUTTON EVENT --
    STRegisterButtonFrameDisplay(histFrameButton, histFrame)

    -- FRAME SLIDER --
    histFrameSlider = STCreateFrame("Slider", "HistFrameSlider", 20, histFrame:GetHeight() - 60, "HIGH", false, histFrame, "UIPanelScrollBarTemplate", {"RIGHT", -4, -10})
    histFrameSlider:SetOrientation('VERTICAL');
    histFrameSlider:SetScript("OnValueChanged", nil);

    BuildSessionsTableString()

end

function BuildSessionsTableString()
    local sessionsTableString = showCharacterData and {"OLD SESSIONS (" .. characters[characterIdx] .. "):", " "} or {"OLD SESSIONS", " "}

    if (sessionsCounter > 0) then
        for i = sessionsCounter, 1, -1 do -- Prepare the data to be displaed
            if (sessionsTable[i][3] == characterIdx or not showCharacterData) then
                local color = BlendColorFromTime(sessionsTable[i][2], {0,255,0}, 3600, {255,255,0}, 7200, {255,0,0});
                table.insert(sessionsTableString, color .. sessionsTable[i][1] .. " - " .. SecondsToHMSString(sessionsTable[i][2]))
            end
        end
    end

    local entriesPerPage = 7;


    local dataToDisplay;

    if (#sessionsTableString <= entriesPerPage) then
        histFrameSlider:SetMinMaxValues(0,0);
        histFrameSlider:Hide();
        dataToDisplay = sessionsTableString;
    else
        histFrameSlider:SetMinMaxValues(0, #sessionsTableString - entriesPerPage);
        dataToDisplay = subrange(sessionsTableString, 1, entriesPerPage)
    end

    histFrameSlider:SetValue(0);

    histFrame:SetScript("OnMouseWheel", function(self, delta)
        histFrameSlider:SetValue(histFrameSlider:GetValue() - delta);
    end)
    histFrameSlider:SetScript("OnMouseWheel", function(self, delta)
        histFrameSlider:SetValue(histFrameSlider:GetValue() - delta);
    end)

    sessionsString = table.concat(dataToDisplay, "\n") .. "\n";
    histFrame.text:SetText(sessionsString);

    histFrameSlider:SetScript("OnValueChanged", function (self, value)
        dataToDisplay = subrange(sessionsTableString, floor(value)+1, floor(value)+entriesPerPage);
        sessionsString = table.concat(dataToDisplay, "\n") .. "\n"
        histFrame.text:SetText(sessionsString);
    end);

end