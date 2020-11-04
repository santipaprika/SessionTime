
function ProcessUserStats()

    -- "STATS" FRAME --
    local statsFrame = CreateFrame("Frame", "statsFrame", UIParent, "BasicFrameTemplate");
    MakeMovable(statsFrame);
    statsFrame:SetWidth(380);
    statsFrame:SetHeight(200);
    statsFrame:SetPoint("CENTER",0,0);

    statsFrame.text = statsFrame:CreateFontString("StatsFS", "OVERLAY", "GameTooltipText");
    statsFrame.text:SetPoint("TOPLEFT",statsFrame,"TOPLEFT",10,-30);
    statsFrame.text:SetWidth(statsFrame:GetWidth() - 10);
    statsFrame.text:SetHeight(statsFrame:GetHeight() - 40);
    statsFrame.text:SetSpacing(10);
    statsFrame.text:SetTextColor(1,0.8,0.8,1);

    statsFrame:Hide();

    -- CREATE "SHOW STATS" BUTTON --
    local showStatsButton = CreateFrame("Button", "ShowStatsButton", mainFrame, "UIPanelButtonTemplate");
    showStatsButton:SetWidth(90); 
    showStatsButton:SetHeight(35); 
    showStatsButton:SetPoint("BOTTOM", 60, 15);
    
    showStatsButton.text = showStatsButton:CreateFontString(nil,"OVERLAY","GameTooltipText");
    showStatsButton.text:SetText("Show Stats");
    showStatsButton.text:SetPoint("CENTER",0,0);

    showStatsButton:RegisterForClicks("AnyUp");
    showStatsButton:SetScript("OnClick", function (self, button, down)
        if statsFrame:IsShown() then
            statsFrame:Hide()
        else
            statsFrame:Show()
        end
    end);

    -- AVERAGE TIME PER DAY --
    local dayDate = string.sub(sessionsTable[sessionsCounter][1], 1,9);
    local dayTimeSum = sessionsTable[sessionsCounter][2];
    local dayTimeTable = {}

    for i = sessionsCounter-1, 1, -1 do -- Prepare the data to be displaed
        sessionDate = string.sub(sessionsTable[i][1], 1, 9);
        
        if (sessionDate == dayDate) then
            dayTimeSum = dayTimeSum + sessionsTable[i][2];
        else
            print("Time played on " .. dayDate .. ": " .. dayTimeSum);
            table.insert(dayTimeTable, dayTimeSum);
            dayTimeSum = sessionsTable[i][2];
            dayDate = sessionDate;
        end
    end

    statsFrame.text:SetText("USER STATS\n\n|cffffffffDay Average Time: |cffcccc44" .. SecondsToHMSString( ComputeMean(dayTimeTable) ))

end