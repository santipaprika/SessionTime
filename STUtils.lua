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


function BlendColorFromTime(timeSeconds, colorGoodTime, midTime, colorMidTime, badTime, colorBadTime)
    local color;
    if (timeSeconds < midTime) then
        color = rgbToHex(LerpColor(colorGoodTime, colorMidTime, math.min(timeSeconds / midTime, 1)));
    else
        color = rgbToHex(LerpColor(colorMidTime, colorBadTime, math.min((timeSeconds - midTime) / (badTime - midTime), 1)));
    end
    return color;
end


function LerpColor(color0, color1, factor)
    out_color = {}
    for c = 1,3,1 do
        out_color[c] = math.floor(color0[c] * (1 - factor) + color1[c] * factor)
    end
    return out_color;
end


-- function based in https://gist.github.com/marceloCodget/3862929
function rgbToHex(rgb)
	local hexadecimal = "|cff"

	for key, value in pairs(rgb) do
		local hex = ''

		while(value > 0)do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789abcdef', index, index) .. hex			
		end

		if(string.len(hex) == 0)then
			hex = '00'

		elseif(string.len(hex) == 1)then
			hex = '0' .. hex
		end

		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end