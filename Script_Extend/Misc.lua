
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
-- 이동속도 표시 by 아로s
-- http://www.inven.co.kr/board/powerbbs.php?come_idx=17&l=30068
--------------------------------------------------------------------------------------------------------
PAPERDOLL_STATCATEGORIES[1].stats[7] = { stat = "MOVESPEED" };
hooksecurefunc("PaperDollFrame_SetMovementSpeed", function(statFrame, unit)
    statFrame:Show()
end)

hooksecurefunc("MovementSpeed_OnEnter", function(statFrame, unit)
    statFrame.UpdateTooltip = nil
end)

--------------------------------------------------------------------------------------------------------
-- 데미지 폰트 변경
--------------------------------------------------------------------------------------------------------
DAMAGE_TEXT_FONT = "Fonts\\FRIZQT__.ttf"

--------------------------------------------------------------------------------------------------------
-- /console reloadui
--------------------------------------------------------------------------------------------------------
SlashCmdList.RELOAD = ReloadUI
SLASH_RELOAD1 = "/rl"
SLASH_RELOAD2 = "/기"

--------------------------------------------------------------------------------------------------------
-- /전투 준비
--------------------------------------------------------------------------------------------------------
SlashCmdList.RDYCHK = function() DoReadyCheck() end
SLASH_RDYCHK1 = "/ww"
SLASH_RDYCHK2 = "/ㅈㅈ"

--------------------------------------------------------------------------------------------------------
-- 생명석/물약 매크로 이미지 스왑 -- Ancient Healing Potion/Healthstone
--------------------------------------------------------------------------------------------------------
local kbjFuncHealPotMacroIcon = CreateFrame('Frame')
kbjFuncHealPotMacroIcon:SetScript('OnEvent', function(self, event, ...)
    SetMacroItem("!HP",GetItemCount("생명석") == 0 and "심연 치유 물약" or "생명석")
end)
kbjFuncHealPotMacroIcon:RegisterEvent('PLAYER_LOGIN')
kbjFuncHealPotMacroIcon:RegisterEvent('BAG_UPDATE')

--------------------------------------------------------------------------------------------------------
-- Move ZoneAbilityFrame
--------------------------------------------------------------------------------------------------------
ZoneAbilityFrame:SetParent(UIParent)
ZoneAbilityFrame:ClearAllPoints()
ZoneAbilityFrame:SetScale(0.9)
ZoneAbilityFrame:SetPoint("BOTTOM", 0, 170)
ZoneAbilityFrame.ignoreFramePositionManager = true
