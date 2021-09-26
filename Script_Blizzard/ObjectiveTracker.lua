-- Move ObjectiveTracker
local anchor = "TOPRIGHT"
local xOff = -10
local yOff = -44

if not IsAddOnLoaded("Blizzard_ObjectiveTracker") then
    LoadAddOn("Blizzard_ObjectiveTracker")
end

local _G = _G
local otFrame = _G.ObjectiveTrackerFrame
local GetScreenHeight = GetScreenHeight
local GetInstanceInfo = GetInstanceInfo
local RegisterStateDriver = RegisterStateDriver

local function SetHeightFrame()
    local frameTop = otFrame:GetTop() or 0
    local screenHeight = GetScreenHeight()
    local gapFromTop = screenHeight - frameTop
    local maxHeight = screenHeight - gapFromTop
    local objectiveTrackerFrameHeight = math.min(maxHeight, 600)

    otFrame:SetHeight(objectiveTrackerFrameHeight)
end

local function SetAutoHide()
    if not otFrame.AutoHider then return end
    RegisterStateDriver(otFrame.AutoHider, "objectiveHider", "[@arena1,exists][@arena2,exists][@arena3,exists][@arena4,exists][@arena5,exists][@boss1,exists][@boss2,exists][@boss3,exists][@boss4,exists] 1;0")
end

otFrame:ClearAllPoints()
otFrame:SetMovable(true)
otFrame:SetUserPlaced(true)
otFrame:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", 0, -10)
SetHeightFrame()
otFrame:SetMovable(false)

otFrame.AutoHider = CreateFrame('Frame', nil, otFrame, 'SecureHandlerStateTemplate')
otFrame.AutoHider:SetAttribute("_onstate-objectiveHider", [[
    if newstate == 1 then
        self:Hide()
    else
        self:Show()
    end
]])
otFrame.AutoHider:SetScript("OnHide", function()
    local _, _, difficultyID = GetInstanceInfo()
    if difficultyID and difficultyID ~= 8 then
        _G.ObjectiveTracker_Collapse()
    end
end)
otFrame.AutoHider:SetScript("OnShow", _G.ObjectiveTracker_Expand)

SetAutoHide()

-- 내구도 위치 조정
DurabilityFrame:ClearAllPoints()
DurabilityFrame:SetAlpha(1)
DurabilityFrame:SetScale(1.2)
DurabilityFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 250)
DurabilityFrame.SetPoint = function() end

-- 다인승 탈것 위치 조정
VehicleSeatIndicator:ClearAllPoints()
VehicleSeatIndicator:SetScale(0.8)
VehicleSeatIndicator:SetPoint("BOTTOM", UIParent, "BOTTOM", 670, 7)
VehicleSeatIndicator.SetPoint = function() end

-- 어둠땅 쐐기 령 위치 조정
MawBuffsBelowMinimapFrame:SetAlpha(0.75)
MawBuffsBelowMinimapFrame:SetScale(0.9)
MawBuffsBelowMinimapFrame:SetPoint("TOPRIGHT", otFrame, "TOPLEFT", -35, 11)
MawBuffsBelowMinimapFrame.SetPoint = function() end
