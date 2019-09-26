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
    local objectiveTrackerFrameHeight = math.min(maxHeight, 880)

    otFrame:SetHeight(objectiveTrackerFrameHeight)
end

local function SetAutoHide()
    if not otFrame.AutoHider then return end
    RegisterStateDriver(otFrame.AutoHider, "objectiveHider", "[@arena1,exists][@arena2,exists][@arena3,exists][@arena4,exists][@arena5,exists][@boss1,exists][@boss2,exists][@boss3,exists][@boss4,exists] 1;0")
end

otFrame:ClearAllPoints()
otFrame:SetMovable(true)
otFrame:SetUserPlaced(true)
otFrame:SetPoint(anchor, UIParent, anchor, xOff, yOff)
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
