local function SetDefaultAnchor(self,parent)
    if InCombatLockdown() and not C_PetBattles.IsInBattle() then
        self:SetOwner(parent, "ANCHOR_NONE")
        self:ClearAllPoints()
        self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -575, 135)
    else
        self:ClearAllPoints()
        self:SetOwner(parent, "ANCHOR_CURSOR")
    end
end

hooksecurefunc("GameTooltip_SetDefaultAnchor", SetDefaultAnchor)
