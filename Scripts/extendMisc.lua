
--[[
-- Set BattlefieldMapFrame
local kbjFuncBattleMap = CreateFrame('Frame')
kbjFuncBattleMap:SetScript('OnEvent', function()
    if not BattlefieldMapFrame then
        LoadAddOn('Blizzard_BattlefieldMap')
    end

    local BFMF = CreateFrame('Frame', nil, BattlefieldMapFrame)
    BFMF:SetFrameStrata('LOW')
    BFMF:SetPoint('TOPLEFT', BattlefieldMapFrame, 'TOPLEFT', -1, 3)
    BFMF:SetPoint('BOTTOMRIGHT', BattlefieldMapFrame, 'BOTTOMRIGHT', -2, 2)
    BFMF:SetBackdrop({
        bgFile =  "Interface\\ChatFrame\\ChatFrameBackground",
        edgeFile = "Interface\\Buttons\\WHITE8x8", edgeSize = 1,
        insets = {left = 1, right = 1, top = 1, bottom = 1}
    })
    BFMF:SetBackdropColor(0, 0, 0, 1)
    BFMF:SetBackdropBorderColor(0, 0, 0, 1)

    BattlefieldMapFrame:SetScale(0.83)
    BattlefieldMapFrame:SetPoint('TOPLEFT', Minimap, 'TOPRIGHT', 542, -3)
    BattlefieldMapFrame.BorderFrame:Hide()
    BattlefieldMapFrame:Show()
end)
kbjFuncBattleMap:RegisterEvent('PLAYER_ENTERING_WORLD')
]]

--------------------------------------------------------------------------------------------------------
-- Move ZoneAbilityFrame
--------------------------------------------------------------------------------------------------------
ZoneAbilityFrame:SetParent(UIParent)
ZoneAbilityFrame:ClearAllPoints()
ZoneAbilityFrame:SetScale(0.9)
ZoneAbilityFrame:SetPoint("BOTTOM", 0, 170)
ZoneAbilityFrame.ignoreFramePositionManager = true
