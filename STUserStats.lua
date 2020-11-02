-- CREATE "SHOW STATS" BUTTON --
local showStatsButton = CreateFrame("Button", "ShowStatsButton", mainFrame, "UIPanelButtonTemplate");
showStatsButton:SetWidth(120); 
showStatsButton:SetHeight(35); 
showStatsButton:SetPoint("BOTTOM", mainFrame, 50, 15);

local showStatsButton.text = showStatsButton:CreateFontString(nil,"OVERLAY","GameTooltipText");
showStatsButton.text:SetText("Show Stats");
showStatsButton.text:SetPoint("CENTER",showStatsButton,"CENTER",0,0);