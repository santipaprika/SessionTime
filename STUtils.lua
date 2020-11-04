-- UTILS FUNCTIONS --

function MakeMovable(f)
    f:SetMovable(true)
    f:EnableMouse(true)
    f:RegisterForDrag("LeftButton")
    f:SetScript("OnDragStart", f.StartMoving)
    f:SetScript("OnDragStop", f.StopMovingOrSizing)
end


function subrange(tab, first, last)
    local sub = {}
    
    if (#tab < last) then
        print("SessionTime_ERROR: Subrange size is greater than table size.")
    end

    for i=first,last do
        sub[#sub + 1] = tab[i]
    end
    return sub
end

  
function SecondsToHMSString(timeInSeconds)
    hours = floor(timeInSeconds / 3600);
    minutes = floor( (timeInSeconds - hours * 3600)  / 60 );
    seconds = timeInSeconds - hours * 3600 - minutes * 60;
    return string.format("%i hours, %i minutes, %i seconds", hours, minutes, seconds);
end


function ComputeMean(numberTable, lo, hi)

    if lo ~= false then lo = 1 end
    if hi ~= false then hi = #numberTable end
    local totalSum = 0;
    for i = lo, hi, 1 do
        totalSum = totalSum + numberTable[i]
    end
    return (totalSum / (hi - lo + 1))
end
