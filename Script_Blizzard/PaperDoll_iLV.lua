local KTS_PaperDoll_iLV_FontSize = 11

local _Itemslots = {
    "HeadSlot",
    "NeckSlot",
    "ShoulderSlot",
    "BackSlot",
    "ChestSlot",
    "WristSlot",
    "MainHandSlot",
    "SecondaryHandSlot",
    "HandsSlot",
    "WaistSlot",
    "LegsSlot",
    "FeetSlot",
    "Finger0Slot",
    "Finger1Slot",
    "Trinket0Slot",
    "Trinket1Slot",
}

local _FontStrings = {}

local scantip = nil
local level_txt = string.gsub(ITEM_LEVEL, "%%d", "(.+)")
local level_txt2 = string.gsub(ITEM_LEVEL, "%%d", "(.+) \((.+)\)")
local update = 0

local function getItemLevel(unit, slot)
    if scantip == nil then
        scantip = CreateFrame("GameTooltip", "asItemLevelTip", nil, "GameTooltipTemplate")
        scantip:SetOwner(UIParent, "ANCHOR_NONE")
    end
    scantip:SetInventoryItem(unit, slot)

    for i = 2, scantip:NumLines() do
        local text = _G["asItemLevelTipTextLeft" .. i]:GetText() or ""
        local iLevel = string.match(text, level_txt)

        if iLevel ~= nil then
            local retval = tonumber(iLevel)
            if(retval ~= nil) then
                return retval
            else
                local iLevel2 = string.match(text, level_txt2)
                if iLevel2 ~= nil then
                    local retval2 = tonumber(iLevel2)
                    if(retval2 ~= nil) then
                        return retval2
                    end
                end
            end
        end
    end
end

local function getAvgItemLevel(unit)
    local t, c = 0, 0
    local min = 0xFFFFFFFF
    local max = 0
    local weapon_lvl
    local weapon_count = 0
    local two_head = nil

    for i = 1, #_Itemslots do
        local idx = GetInventorySlotInfo(_Itemslots[i])
        local k = GetInventoryItemLink(unit, idx)

        if k then
            local name, _, quality = GetItemInfo(k)
            local lvl = getItemLevel(unit, idx)

            if lvl and lvl > 0 and quality  then
                _FontStrings[unit][i]:SetText(lvl)
                local r, g, b = GetItemQualityColor(quality)
                _FontStrings[unit][i]:SetTextColor(r, g, b)
            end

            if idx == 16 or idx == 17 then
                weapon_count = weapon_count+1
                two_head = lvl
            end

            if lvl and lvl > 0  then
                t = t+lvl
                c = c+1
                if quality < min then
                    min = quality
                end

                if quality > max then
                    max = quality
                end
            end
        else
            _FontStrings[unit][i]:SetText("");
        end

    end

    if weapon_lvl then
        t = t+(weapon_lvl*2)
        c = c+2
    end

    if weapon_count == 1 and two_head then
        t = t+two_head
        c = c+1
    end

    if min == 0xFFFFFFFF then
        min = 0
    end

    return floor(t/c), max, min
end


local function updatePlayerPaperDoll(self)
    if CheckInCombat then return end
    local Avg, Max, Min = getAvgItemLevel("player")
    local Red, Green, Blue = GetItemQualityColor(Min)
    PAvg:SetText(Avg)
    PAvg:SetTextColor(Red, Green, Blue)
end

local function updateInspectPaperDoll(self, elapsed)
    update = update+elapsed
    if update >= 1  then
        update = 0
    else
        return
    end

    --local frame = _G["TargetGearScore"]

    if CheckInCombat then return end
    local Avg, Max, Min = getAvgItemLevel("target")
    local Red, Green, Blue = GetItemQualityColor(Min)
    TAvg:SetText(Avg)
    TAvg:SetTextColor(Red, Green, Blue)
end

-------------------------------------------------------------------------------

local ktsPaperDoll_iLV_OnEvent = function(self, event)
    if event == "PLAYER_REGEN_ENABLED" then
    	CheckInCombat = false
    	return
    end
    if event == "PLAYER_REGEN_DISABLED" then
    	CheckInCombat = true
    	return
    end
    if event == "PLAYER_EQUIPMENT_CHANGED" then
        updatePlayerPaperDoll()
    end
end

------------------------ GUI PROGRAMS -------------------------------------------------------

local f = CreateFrame("Frame", "KTS_PaperDoll_iLV", UIParent);
local font, _, flags = NumberFontNormal:GetFont()

f:SetScript("OnEvent", ktsPaperDoll_iLV_OnEvent)
f:RegisterEvent("PLAYER_EQUIPMENT_CHANGED");
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")

CharacterModelFrame:HookScript("OnShow", updatePlayerPaperDoll)
CharacterModelFrame:CreateFontString("PTxt")
PTxt:SetFont(font, KTS_PaperDoll_iLV_FontSize, flags)
PTxt:SetText("ItemLevel")
PTxt:SetPoint("BOTTOMLEFT",CharacterModelFrame,"TOPLEFT",10,-280)
PTxt:Show()

CharacterModelFrame:CreateFontString("PAvg")
PAvg:SetFont(font, KTS_PaperDoll_iLV_FontSize+2, flags)
PAvg:SetText("Avg: 0")
PAvg:SetPoint("BOTTOMLEFT",CharacterModelFrame,"TOPLEFT",10,-295)
PAvg:Show()

inspectframe = _G["InspectModelFrame"]
inspectframe:HookScript("OnUpdate", updateInspectPaperDoll)
inspectframe:CreateFontString("TTxt")
TTxt:SetFont(font, KTS_PaperDoll_iLV_FontSize, flags)
TTxt:SetText("ItemLevel")
TTxt:SetPoint("BOTTOMLEFT",inspectframe,"TOPLEFT",10,-280)
TTxt:Show()

inspectframe:CreateFontString("TAvg")
TAvg:SetFont(font, KTS_PaperDoll_iLV_FontSize+2, flags)
TAvg:SetText("Avg: 0")
TAvg:SetPoint("BOTTOMLEFT",inspectframe,"TOPLEFT",10,-295)
TAvg:Show()

_FontStrings["player"] = {};
_FontStrings["target"] = {};

for slot,n in pairs(_Itemslots) do
    local gslot = _G["Character"..n]
    _FontStrings["player"][slot] = gslot:CreateFontString(nil, "OVERLAY")
    _FontStrings["player"][slot]:SetFont(font, KTS_PaperDoll_iLV_FontSize, flags)
    _FontStrings["player"][slot]:SetPoint("TOP", gslot, "TOP", 0, -3)
    _FontStrings["player"][slot]:SetTextColor(1, 1, 1)
end

for slot,n in pairs(_Itemslots) do
    local gslot = _G["Inspect"..n]
    _FontStrings["target"][slot] = gslot:CreateFontString(nil, "OVERLAY")
    _FontStrings["target"][slot]:SetFont(font, KTS_PaperDoll_iLV_FontSize, flags)
    _FontStrings["target"][slot]:SetPoint("TOP", gslot, "TOP", 0, -3)
    _FontStrings["target"][slot]:SetTextColor(1,1,1)
end
