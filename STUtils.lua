-- UTILS FUNCTIONS --

function subrange(tab, first, last)
    local sub = {}
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
