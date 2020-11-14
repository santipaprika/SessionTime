local dayMean;
local day7Mean;
local todayTime;
local numDays = 0;

function InitializeUserStats()
    
    -- "STATS" FRAME --
    statsFrame = STCreateFrame("Frame", "statsFrame", 380, 200, "DIALOG");
    statsFrame.text = statsFrame:CreateFontString("StatsFS", "OVERLAY", "GameTooltipText");
    statsFrame.text:SetPoint("TOPLEFT",statsFrame,"TOPLEFT",10,-30);
    statsFrame.text:SetWidth(statsFrame:GetWidth() - 10);
    statsFrame.text:SetHeight(statsFrame:GetHeight() - 40);
    statsFrame.text:SetSpacing(10);
    statsFrame.text:SetTextColor(1,0.8,0.8,1);

    statsFrame:Hide();

    -- CREATE "SHOW STATS" BUTTON --
    local showStatsButton = STCreateFrame("Button", "ShowStatsButton", 90, 35, "MEDIUM", mainFrame, "UIPanelButtonTemplate", {"BOTTOM", 60, 15})
    showStatsButton:SetPoint("BOTTOM", 60, 15);
    
    showStatsButton.text = showStatsButton:CreateFontString(nil,"OVERLAY","GameTooltipText");
    showStatsButton.text:SetText("Show Stats");
    showStatsButton.text:SetPoint("CENTER",0,0);

    STRegisterButtonFrameDisplay(showStatsButton, statsFrame);

    -- -------------------------------------------------------------------------------------------------

    -- STATS COMPUTATION --
    if (sessionsCounter > 0) then -- not first session        
        local dayTimeTable = computeDayTimeTable()
        print("Number of days: " .. numDays);
        for i = 1, numDays do
            print("Day " .. i .. ": " .. dayTimeTable[i])
        end
        DefineStats(dayTimeTable);
    else
        dayMean, day7Mean, todayTime = 0, 0, 0;
        numDays = 1;
    end

    -- dayAverageTimeSTR, day7AverageTimeSTR, todayTimeSTR = SecondsToHMSString(dayMean), SecondsToHMSString(day7Mean), SecondsToHMSString(0);
    STStats = {{"Day Average Time", dayMean} , {"Last 7 Days Average Time",day7Mean}, {"Today's Time", todayTime}}
    WriteStatsFrame();
end


function computeDayTimeTable()
    local dayDate = string.sub(sessionsTable[sessionsCounter][1], 1,8);
    local dayTimeSum = 0;
    local dayTimeTable = {}
    
    for i = sessionsCounter, 1, -1 do -- Prepare the data to be displaed
        sessionDate = string.sub(sessionsTable[i][1], 1, 8);
        
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

    return dayTimeTable;
end


local firstDaySession;
function DefineStats(dayTimeTable)
    
    
    currentDate = date("%m/%d/%y");
    if (currentDate ~= string.sub(sessionsTable[sessionsCounter][1], 1, 8)) then
        todayTime = 0;
        firstDaySession = true;
    else
        todayTime = dayTimeTable[1];
        firstDaySession = false;
    end
    
    dayMean = ComputeMean(dayTimeTable) * (firstDaySession and numDays/(numDays+1) or 1); -- if not first day session, current day will already be on dayTimeTable

    dayAverageTimeSTR = SecondsToHMSString(dayMean);
    todayTimeSTR = SecondsToHMSString(todayTime);


    if (numDays >= 7) then
        day7Mean = firstDaySession and ComputeMean(dayTimeTable, 1, 6)*(6/7) or ComputeMean(dayTimeTable, 1, 7);
        day7AverageTimeSTR = SecondsToHMSString(day7Mean);
    else
        day7Mean = dayMean;
        day7AverageTimeSTR = dayAverageTimeSTR;
    end
end


function UpdateStats() 
    local todayTimeUpdated = todayTime + sessionTime;
    STStats[3][2] = todayTimeUpdated;
    local dayMeanUpdated = dayMean + sessionTime/(numDays + (firstDaySession and 1 or 0));
    STStats[1][2] = dayMeanUpdated;
    local day7MeanUpdated = (numDays >= 7) and (day7Mean + sessionTime/7) or dayMeanUpdated;
    STStats[2][2] = day7MeanUpdated;
    WriteStatsFrame();
end


function WriteStatsFrame()
    local statsTableString = {"USER STATS", " "}
    for i = 1, #STStats, 1 do -- Prepare the data to be displayed
        local color = BlendColorFromTime(STStats[i][2], {0,255,0}, 3600, {255,255,0}, 10800, {255,0,0})
        table.insert(statsTableString, "|cffffffff" .. STStats[i][1] .. ": " .. color .. SecondsToHMSString(STStats[i][2]))
    end

    local statsString = table.concat(statsTableString, "\n") .. "\n";
    statsFrame.text:SetText(statsString);
end