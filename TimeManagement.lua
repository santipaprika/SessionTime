-- TIME CONTROL, MANAGEMENT AND UPDATES ---

local function delay(tick)
    local th = coroutine.running()
    C_Timer.After(tick, function() coroutine.resume(th) end)
    coroutine.yield()
end

local function CountTime()
    while(true) do
        delay(1); -- every second
        sessionTime = sessionTime + 1; -- add one second
        if (f:IsShown()) then
            FormatSessionTime(); -- it is not needed to update the font string unless it is being shown
        end
    end
end
 
-- CALL FUNCTION AS COROUTINE
coroutine.wrap(CountTime)(0)