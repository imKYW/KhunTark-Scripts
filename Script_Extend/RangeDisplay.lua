-- Setting
---- General
local ktRD_Font				= "Fonts\\FRIZQT__.ttf"
local ktRD_FontOutline		= "THINOUTLINE"
---- Target
local ktRD_Target_FontSize	= 20
local ktRD_Target_X       	= -63
local ktRD_Target_Y       	= -108
---- Focus
local ktRD_Focus_FontSize 	= 16
local ktRD_Focus_X        	= 172
local ktRD_Focus_Y        	= 83
-- /Setting

local ktRD_targetFrame = CreateFrame("Frame", "ktRD_Target", UIParent)
local ktRD_focusFrame = CreateFrame("Frame", "ktRD_Focus", UIParent)

local function ktRD_getRangeColor(range)
    if not range or range == 0 then return end

    if range > 40 then
        return 1, 0, 0
    elseif range > 30 then
        return 1.0, 0.82, 0
    elseif range > 20 then
        return 0.035, 0.865, 0.0
    elseif range > 5 then
        return 0.055, 0.875, 0.825
    end

    return 0.9, 0.9, 0.9
end

local function ktRD_OnLoad()
    ktRD_targetFrame:CreateFontString("ktRD_Target_RangeText", "OVERLAY")
    ktRD_Target_RangeText:SetFont(ktRD_Font, ktRD_Target_FontSize, ktRD_FontOutline)
    ktRD_Target_RangeText:SetPoint("LEFT", UIParent, "CENTER", ktRD_Target_X, ktRD_Target_Y)
    ktRD_Target_RangeText:SetJustifyH("LEFT")
    ktRD_Target_RangeText:SetText("")
    ktRD_Target_RangeText:Show()

    ktRD_focusFrame:CreateFontString("ktRD_Focus_RangeText", "OVERLAY")
    ktRD_Focus_RangeText:SetFont(ktRD_Font, ktRD_Focus_FontSize, ktRD_FontOutline)
    ktRD_Focus_RangeText:SetPoint("LEFT", UIParent, "CENTER", ktRD_Focus_X, ktRD_Focus_Y)
    ktRD_Focus_RangeText:SetJustifyH("LEFT")
    ktRD_Focus_RangeText:SetText("")
    ktRD_Focus_RangeText:Show()

    ktRD_targetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    ktRD_focusFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
end


local update = 0
function ktRD_Target_OnUpdate(self, elapsed)
    update = update + elapsed

    if update >= 0.25  then
        update = 0
        if UnitExists("target") then
            local range = KTL:checkRange("target")

            if range == 0 or range > 100 then
                ktRD_Target_RangeText:SetText("")
            else
                ktRD_Target_RangeText:SetText(range)
            end
            ktRD_Target_RangeText:SetTextColor(ktRD_getRangeColor(range))
        else
            ktRD_Target_RangeText:SetText("")
        end
    end
end

function ktRD_Focus_OnUpdate(self, elapsed)
    update = update + elapsed

    if update >= 0.25  then
        update = 0
        if UnitExists("focus") then
            local range = KTL:checkRange("focus")

            if range == 0 or range > 100 then
                ktRD_Focus_RangeText:SetText("")
            else
                ktRD_Focus_RangeText:SetText(range)
            end
            ktRD_Focus_RangeText:SetTextColor(ktRD_getRangeColor(range))
        else
            ktRD_Focus_RangeText:SetText("")
        end
    end
end

function ktRD_Target_OnEvent(self, event, arg1, arg2, arg3, ...)
    if event == "PLAYER_TARGET_CHANGED" then
        local range = KTL:checkRange("target")
        if range == 0 or range > 100 then
            ktRD_Target_RangeText:SetText("")
        else
            ktRD_Target_RangeText:SetText(range)
        end

        ktRD_Target_RangeText:SetTextColor(ktRD_getRangeColor(range))
    end
end

function ktRD_Focus_OnEvent(self, event, arg1, arg2, arg3, ...)
    if event == "PLAYER_FOCUS_CHANGED" then
        local range = KTL:checkRange("focus")
        if range == 0 or range > 100 then
            ktRD_Focus_RangeText:SetText("")
        else
            ktRD_Focus_RangeText:SetText(range)
        end

        ktRD_Focus_RangeText:SetTextColor(ktRD_getRangeColor(range))
    end
end

ktRD_targetFrame:SetScript("OnEvent", ktRD_Target_OnEvent)
ktRD_targetFrame:SetScript("OnUpdate", ktRD_Target_OnUpdate)
ktRD_focusFrame:SetScript("OnEvent", ktRD_Focus_OnEvent)
ktRD_focusFrame:SetScript("OnUpdate", ktRD_Focus_OnUpdate)
ktRD_OnLoad()
