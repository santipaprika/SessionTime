local dayMean;
local day7Mean;
local todayTime;
local numDays = 0;
local isFirstDaySession = true;
local STStats;

function InitializeUserStats()
    
    -- "STATS" FRAME --
    statsFrame = STCreateFrame("Frame", "statsFrame", 380, 200, "DIALOG", true);
    statsFrame.text = STCreateFrameFontString(statsFrame, "StatsFS", {"TOPLEFT",statsFrame,"TOPLEFT",10,-30}, statsFrame:GetWidth() - 10, statsFrame:GetHeight() - 40, {1,0.8,0.8,1})
    statsFrame.text:SetSpacing(10);
    statsFrame:Hide();

    -- CREATE "SHOW STATS" BUTTON --
    local showStatsButton = STCreateFrame("Button", "ShowStatsButton", 90, 35, "MEDIUM", false, mainFrame, "UIPanelButtonTemplate", {"BOTTOM", 60, 15})
    
    showStatsButton.text = STCreateFrameFontString(showStatsButton, "StatsButtonFS", {"CENTER",0,0})
    showStatsButton.text:SetText("Show Stats");

    STRegisterButtonFrameDisplay(showStatsButton, statsFrame, UpdateStats);

    -- -------------------------------------------------------------------------------------------------

    -- STATS COMPUTATION --
    local currentDate = date("%m/%d/%y"); -- check whether it is the first session this day (if it is, it won't be registered yet)
    
    
    if (sessionsCounter > 0) then -- not first session        
        isFirstDaySession = (currentDate ~= string.sub(sessionsTable[sessionsCounter][1], 1, 8))
        local dayTimeTable = computeDayTimeTable()
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
    local dayDate = isFirstDaySession and date("%m/%d/%y") or string.sub(sessionsTable[sessionsCounter][1], 1,8);
    local dayTimeSum = 0;
    local dayTimeTable = {}
    

    prevMonth,prevDay,prevYear=dayDate:match("(%d+)/(%d+)/(%d+)")   -- initialize data and timestamp with first day (notice inverse loop)
    prevDayTimestamp = time({month=prevMonth, day=prevDay, year=(2000 + prevYear)})
    for i = sessionsCounter, 1, -1 do -- Prepare the data to be displaed
        sessionDate = string.sub(sessionsTable[i][1], 1, 8);
        
        if (sessionDate == dayDate) then
            dayTimeSum = dayTimeSum + sessionsTable[i][2];
        else
            table.insert(dayTimeTable, dayTimeSum);

            month,day,year=sessionDate:match("(%d+)/(%d+)/(%d+)")   -- get data from current sessoin date string
            local dayTimestamp = time({month=month, day=day, year=(2000 + year)})   -- get timestamp
            local daysBetween = floor((prevDayTimestamp - dayTimestamp)/ 86400);    -- compare consecutive listed days timestamp
            prevDayTimestamp = dayTimestamp;
            for j = 2, daysBetween, 1 do    -- add as empty days as days in between found in previous step
                table.insert(dayTimeTable, 0);
                numDays = numDays + 1;
            end

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


function DefineStats(dayTimeTable)
    todayTime = isFirstDaySession and 0 or dayTimeTable[1]
    dayMean = ComputeMean(dayTimeTable) * (isFirstDaySession and numDays/(numDays+1) or 1); -- if not first day session, current day will already be on dayTimeTable

    dayAverageTimeSTR = SecondsToHMSString(dayMean);
    todayTimeSTR = SecondsToHMSString(todayTime);


    if (numDays >= 7) then
        day7Mean = isFirstDaySession and ComputeMean(dayTimeTable, 1, 6)*(6/7) or ComputeMean(dayTimeTable, 1, 7);
        day7AverageTimeSTR = SecondsToHMSString(day7Mean);
    else
        day7Mean = dayMean;
        day7AverageTimeSTR = dayAverageTimeSTR;
    end
end


function UpdateStats() 
    local todayTimeUpdated = todayTime + sessionTime;
    STStats[3][2] = todayTimeUpdated;
    local dayMeanUpdated = dayMean + sessionTime/(numDays + ((sessionsCounter > 0) and (isFirstDaySession and 1 or 0) or 0));
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