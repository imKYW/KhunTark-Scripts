--------------------------------------------------------------------------------------------------------
-- 이동속도 표시 by 아로s
-- http://www.inven.co.kr/board/powerbbs.php?come_idx=17&l=30068
--------------------------------------------------------------------------------------------------------
PAPERDOLL_STATCATEGORIES[1].stats[7] = { stat = "ATTACK_AP" }
hooksecurefunc("PaperDollFrame_SetAttackPower", function(statFrame, unit)
    statFrame:Show()
end)

PAPERDOLL_STATCATEGORIES[1].stats[8] = { stat = "MOVESPEED" }
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
-- /console WorldTextScale 1.5 데미지 폰트 스케일   ///    /script SetCVar("WorldTextScale", 1.5)

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
    SetMacroItem("!HP",GetItemCount("생명석") == 0 and "영적인 치유 물약" or "생명석")
end)
kbjFuncHealPotMacroIcon:RegisterEvent('PLAYER_LOGIN')
kbjFuncHealPotMacroIcon:RegisterEvent('PLAYER_ENTERING_WORLD')
kbjFuncHealPotMacroIcon:RegisterEvent('BAG_UPDATE')
