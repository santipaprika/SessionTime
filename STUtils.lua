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

    lo = lo or 1;
    hi = hi or #numberTable;
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


function STCreateFrame(ftype, name, width, height, strata, isMovable, parent, template, pointParams)
    -- defaults
    template = template or "BasicFrameTemplate";
    parent = parent or UIParent;
    strata = strata or "MEDIUM";
    pointParams = pointParams or {"CENTER", parent, 0, 0}

    local frame = CreateFrame(ftype, name, parent, template);
    if (isMovable) then MakeMovable(frame); end
    frame:SetWidth(width);
    frame:SetHeight(height);
    frame:SetPoint(pointParams[1],pointParams[2],pointParams[3]);
    frame:SetFrameStrata(strata);
    return frame;
end


function STRegisterButtonFrameDisplay(STbutton, STframe, functionToApply)
    functionToApply = functionToApply or (function() end);
    STbutton:RegisterForClicks("AnyUp");
    STbutton:SetScript("OnClick", function (self, button, down)
        if STframe:IsShown() then
            STframe:Hide()
        else
            functionToApply();
            STframe:Show()
        end
    end);
end


function STCreateFrameFontString(frame, name, pointParams, width, height, color, layer, font)
    -- defaults
    pointParams = pointParams or {"CENTER",0,0};
    color = color or {1,1,1,1};
    layer = layer or "OVERLAY";
    font = font or "GameTooltipText";

    local frameFS = frame:CreateFontString(name, layer, font);
    if (#pointParams == 5) then
        frameFS:SetPoint(pointParams[1],pointParams[2],pointParams[3],pointParams[4],pointParams[5]);
    else
        frameFS:SetPoint(pointParams[1],pointParams[2],pointParams[3]);
    end

    if (width) then frameFS:SetWidth(width); end
    if (height) then frameFS:SetHeight(height); end
    frameFS:SetTextColor(color[1],color[2],color[3],color[4]);

    return frameFS;
end