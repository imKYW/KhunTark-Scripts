--------------------------------------------------------------------------------------------------------
-- XP Bar
--------------------------------------------------------------------------------------------------------
StatusTrackingBarManager:ClearAllPoints()
StatusTrackingBarManager:SetPoint('TOP', UIParent, 'TOP', 0, 0)

--------------------------------------------------------------------------------------------------------
-- Micro Buttons and Bags
--------------------------------------------------------------------------------------------------------
local MICRO_BUTTONS = {
    'CharacterMicroButton',
    'SpellbookMicroButton',
    'TalentMicroButton',
    'AchievementMicroButton',
    'QuestLogMicroButton',
    'GuildMicroButton',
    'LFDMicroButton',
    'CollectionsMicroButton',
    'EJMicroButton',
    'StoreMicroButton',
    'MainMenuMicroButton'
}

MicroButtonAndBagsBar:SetScale(0.9)
MicroButtonAndBagsBar:SetParent(UIParent) -- show microbuttons when vehicle

local KTS_UI_MicroButtonAndBagsBar = function()
    -- bags
    MainMenuBarBackpackButton:ClearAllPoints()
    MainMenuBarBackpackButton:SetScale(1.2)
    MainMenuBarBackpackButton:SetPoint('BOTTOMRIGHT', UIParent, 'BOTTOMRIGHT', -8, 4)
    CharacterBag0Slot:ClearAllPoints()
    CharacterBag0Slot:SetPoint('BOTTOMRIGHT', MainMenuBarBackpackButton, 'BOTTOMLEFT', -10, 0)

    -- micro menu bar
    UpdateMicroButtonsParent(MicroButtonAndBagsBar)
    _G[MICRO_BUTTONS[1]]:ClearAllPoints()
    _G[MICRO_BUTTONS[1]]:SetPoint('BOTTOMRIGHT', CharacterReagentBag0Slot, 'BOTTOMLEFT', -210, 1)
end

local KTS_UI_MoveBags = function()
    ContainerFrameCombinedBags:ClearAllPoints()
    ContainerFrameCombinedBags:SetPoint('BOTTOMRIGHT', MainMenuBarBackpackButton, 'TOPRIGHT', 0, 5);
end

hooksecurefunc('UpdateMicroButtons', KTS_UI_MicroButtonAndBagsBar)
hooksecurefunc('UpdateContainerFrameAnchors', KTS_UI_MoveBags)

--------------------------------------------------------------------------------------------------------
-- Move ZoneAbilityFrame
--------------------------------------------------------------------------------------------------------
ZoneAbilityFrame:SetParent(UIParent)
ZoneAbilityFrame:ClearAllPoints()
ZoneAbilityFrame:SetScale(0.9)
ZoneAbilityFrame:SetPoint('BOTTOM', 0, 170)
ZoneAbilityFrame.ignoreFramePositionManager = true


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
        bgFile = "Interface\\ChatFrame\\ChatFrameBackground",
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

--[[ 큐버튼
/run local f=QueueStatusButton; f:SetMovable(true); f:EnableMouse(true); f:SetUserPlaced(true); f:SetScript(“onmousedown”, f.StartMoving); f:SetScript(“onmouseup”, f.StopMovingOrSizing);
]]
