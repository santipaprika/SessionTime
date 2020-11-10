local dayMean;
local day7Mean;
local todayTime;
local numDays = 0;

function ProcessUserStats()
    
    -- "STATS" FRAME --
    statsFrame = CreateFrame("Frame", "statsFrame", UIParent, "BasicFrameTemplate");
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
    statsFrame:SetFrameStrata("DIALOG");

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
    
    local dayAverageTimeSTR;
    local day7AverageTimeSTR;
    local todayTimeSTR;

    if (sessionsCounter > 0) then
        local dayDate = string.sub(sessionsTable[sessionsCounter][1], 1,9);
        local dayTimeSum = 0;
        local dayTimeTable = {}
        
        for i = sessionsCounter, 1, -1 do -- Prepare the data to be displaed
            sessionDate = string.sub(sessionsTable[i][1], 1, 9);
            
            if (sessionDate == dayDate) then
                dayTimeSum = dayTimeSum + sessionsTable[i][2];
            else
                table.insert(dayTimeTable, dayTimeSum);
                dayTimeSum = sessionsTable[i][2];
                dayDate = sessionDate;
                numDays = numDays + 1;
            end

            if (i == 1) then 
                table.insert(dayTimeTable, dayTimeSum);
                numDays = numDays + 1;
            end
        end

        dayMean = ComputeMean(dayTimeTable);
        todayTime = dayTimeTable[1];

        dayAverageTimeSTR = SecondsToHMSString(dayMean);
        todayTimeSTR = SecondsToHMSString(todayTime);


        if (#dayTimeTable >= 7) then
            day7Mean = ComputeMean(dayTimeTable, 1, 7);
            day7AverageTimeSTR = SecondsToHMSString(day7Mean);
        else
            day7Mean = dayMean;
            day7AverageTimeSTR = dayAverageTimeSTR;
        end
        
    else
        dayMean, day7Mean, todayTime = 0, 0, 0;
        dayAverageTimeSTR, day7AverageTimeSTR, todayTimeSTR = SecondsToHMSString(0), SecondsToHMSString(0), SecondsToHMSString(0);
    end


    STStats = {{"Day Average Time", dayAverageTimeSTR} , {"Last 7 Days Average Time",day7AverageTimeSTR}, {"Today's Time", todayTimeSTR}}
    WriteStatsFrame();
end

function UpdateStats()
    local todayTimeUpdated = todayTime + sessionTime;
    STStats[3][2] = todayTimeUpdated;
    local dayMeanUpdated = dayMean + sessionTime/numDays;
    STStats[1][2] = dayMeanUpdated;
    local day7MeanUpdated;
    if (numDays > 7) then
        day7MeanUpdated = day7Mean + sessionTime/7;
    else
        day7MeanUpdated = dayMean + sessionTime/numDays;
    end
    STStats[2][2] = day7MeanUpdated;

    WriteStatsFrame();
end

function WriteStatsFrame()
    local statsTableString = {"USER STATS", " "}
    if (sessionsCounter > 0) then
        for i = 1, #STStats, 1 do -- Prepare the data to be displaed
            local color = BlendColorFromTime(STStats[i][2], {0,255,0}, 3600, {255,255,0}, 10800, {255,0,0})
            table.insert(statsTableString, "|cffffffff" .. STStats[i][1] .. ": " .. color .. SecondsToHMSString(STStats[i][2]))
        end
    end

    local statsString = table.concat(statsTableString, "\n") .. "\n";
    statsFrame.text:SetText(statsString);
end