-- function HelloWorld() 
--     print(time() - log_time) 
-- end

-- function HelloWorld_OnLoad()
--   SLASH_HELLOWORLD1= '/helloworld';
--   SlashCmdList["HELLOWORLD"] = HelloWorld_SlashCommand;
-- end

-- function HelloWorld_SlashCommand()
--   print(time() - log_time)
--   HelloWorldFrame:Show()
-- end


local log_time = time() -- login time
local sessionTime = 0;

local f = CreateFrame("Frame", "HelloWorldFrame", UIParent, "BasicFrameTemplate")
-- f:SetFrameStrata("BACKGROUND");
f:SetWidth(256); -- Set these to whatever height/width is needed 
f:SetHeight(100); -- for your Texture

local fsTitle = f:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsTitle:SetText("Total time played this session:")
fsTitle:SetPoint("CENTER",f,"CENTER",0,5)

local fsSessionTime = f:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsSessionTime:SetText("0 hours, 0 minutes, 0 seconds")
fsSessionTime:SetPoint("CENTER",f,"CENTER",0,-25)

f:SetPoint("CENTER",0,350)
f:Hide()

local function FormatSessionTime()
    hours = floor(sessionTime / 3600);
    minutes = floor( (sessionTime - hours * 3600)  / 60 );
    seconds = sessionTime - hours * 3600 - minutes * 60;
    fsSessionTime:SetText(string.format("%i hours, %i minutes, %i seconds", hours, minutes, seconds))
end

local b = CreateFrame("Button", "SessionTimeButton", UIParent, "UIPanelButtonTemplate");
b:SetWidth(108); b:SetHeight(48); b:SetPoint("CENTER", 400, -350);
local fsButton = b:CreateFontString(nil,"OVERLAY","GameTooltipText")
fsButton:SetText("SESSION TIME")
fsButton:SetPoint("CENTER",b,"CENTER",0,0)
b:RegisterForClicks("AnyUp");
b:SetScript("OnClick", function (self, button, down)
    if f:IsShown() then
        f:Hide()
    else
        FormatSessionTime()
        f:Show()
    end

end);

local function delay(tick)
    local th = coroutine.running()
    C_Timer.After(tick, function() coroutine.resume(th) end)
    coroutine.yield()
end
 
function CountTime()
    while(true) do
        delay(1);
        sessionTime = sessionTime + 1;
        if (f:IsShown()) then
            FormatSessionTime();
        end
    end
end
 
-- Call the function as coroutine
coroutine.wrap(CountTime)(0)

-- b:SetScript("OnClick", function(self, arg1)
--     print(arg1)
-- end)
-- b:Click("foo bar") -- will print "foo bar" in the chat frame.
-- b:Click("blah blah") -- will print "blah blah" in the chat frame.

-- f:SetBackdrop(nil)
-- f:SetBackdropColor(0.1,0.1,0.1,0.9)
-- red, _, _, _ = f:GetBackdropColor()
-- print(red)





