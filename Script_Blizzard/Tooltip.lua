local cfg = {}
cfg.textColor = {0.4,0.4,0.4}
cfg.bossColor = {1,0,0}
cfg.eliteColor = {1,0,0.5}
cfg.rareeliteColor = {1,0.5,0}
cfg.rareColor = {1,0.5,0}
cfg.levelColor = {0.8,0.8,0.5}
cfg.deadColor = {0.5,0.5,0.5}
cfg.targetColor = {1,0.5,0.5}
cfg.guildColor = {1,0,1}
cfg.afkColor = {0,1,1}
cfg.scale = 1
cfg.fontFamily = STANDARD_TEXT_FONT
cfg.backdrop = {
    bgFile = "Interface\\Buttons\\WHITE8x8",
    bgColor = {0.08, 0.08, 0.1, 0.92},
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    borderColor = {0.1, 0.1, 0.1, 0.6},
    itemBorderColorAlpha = 0.9,
    azeriteBorderColor = {1, 0.3, 0, 0.9},
    tile = false,
    tileEdge = false,
    tileSize = 16,
    edgeSize = 16,
    insets = {left=3, right=3, top=3, bottom=3}
}

local _G = _G

local function GetHexColor(color)
    if color.r then
        return ("%.2x%.2x%.2x"):format(color.r*255, color.g*255, color.b*255)
    else
        local r,g,b,a = unpack(color)
        return ("%.2x%.2x%.2x"):format(r*255, g*255, b*255)
    end
end

local function OnTooltipSetUnit(self)
    local unit = select(2, self:GetUnit())
    if not unit then return end
    if not UnitIsPlayer(unit) then
        --unit is not a player
        --color textleft1 and statusbar by faction color
        local reaction = UnitReaction(unit, "player")
        if reaction then
            local color = FACTION_BAR_COLORS[reaction]
            if color then
                cfg.barColor = color
                GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
            end
        end
    else
        --unit is any player
        local _, unitClass = UnitClass(unit)
        --color textleft1 and statusbar by class color
        local color = RAID_CLASS_COLORS[unitClass]
        cfg.barColor = color
        GameTooltipTextLeft1:SetTextColor(color.r,color.g,color.b)
        --color textleft2 by guildcolor
        local unitGuild = GetGuildInfo(unit)
        if unitGuild then
            GameTooltipTextLeft2:SetText("<"..unitGuild..">")
            GameTooltipTextLeft2:SetTextColor(unpack(cfg.guildColor))
        end
        if UnitIsAFK(unit) then
            self:AppendText((" |cff%s<AFK>|r"):format(cfg.afkColorHex))
        end
    end
    --dead?
    if UnitIsDeadOrGhost(unit) then
        GameTooltipTextLeft1:SetTextColor(unpack(cfg.deadColor))
    end
end

--local ignoreSubType = {
--    [L["Other"]] = true,
--    [L["Item Enhancement"]] = true,
--}
--local function OnTooltipSetItem(self)
--    local name, link = self:GetItem()
--    if not link then return end
--    self.currentItem = link
--
--    local name, _, quality, _, _, type, subType, stackCount, _, icon, sellPrice = GetItemInfo(link)
--    if not quality then
--        quality = 0
--    end
--
--    if stackCount and stackCount > 1 and self.count then
--        self.count:SetText(stackCount)
--    end
--
--    local r, g, b
--    if type == L["Quest"] then
--        r, g, b = 1, 0.82, 0.2
--    elseif type == L["Tradeskill"] and not ignoreSubType[subType] and quality < 2 then
--        r, g, b = 0.4, 0.73, 1
--    elseif subType == L["Companion Pets"] then
--        local _, id = C_PetJournal.FindPetIDByName(name)
--        if id then
--            local _, _, _, _, petQuality = C_PetJournal.GetPetStats(id)
--            if petQuality then
--                quality = petQuality - 1
--            end
--        end
--    end
--    if quality > 1 and not r then
--        r, g, b = GetItemQualityColor(quality)
--    end
--    if r then
--        self:SetBackdropBorderColor(r, g, b)
--        if self.icon then
--            self.icon:SetBackdropBorderColor(r, g, b)
--        end
--    end
--end

local function SetBackdropStyle(self,style)
    if self.TopOverlay then self.TopOverlay:Hide() end
    if self.BottomOverlay then self.BottomOverlay:Hide() end
    self:SetBackdrop(cfg.backdrop)
    self:SetBackdropColor(unpack(cfg.backdrop.bgColor))
    local _, itemLink = self:GetItem()
    if itemLink then
        local azerite = C_AzeriteEmpoweredItem.IsAzeriteEmpoweredItemByID(itemLink) or C_AzeriteItem.IsAzeriteItemByID(itemLink) or false
        local _, _, itemRarity = GetItemInfo(itemLink)
        local r,g,b = 1,1,1
        if itemRarity then r,g,b = GetItemQualityColor(itemRarity) end
        --use azerite coloring or item rarity
        if azerite and cfg.backdrop.azeriteBorderColor then
            self:SetBackdropBorderColor(unpack(cfg.backdrop.azeriteBorderColor))
        else
            self:SetBackdropBorderColor(r,g,b,cfg.backdrop.itemBorderColorAlpha)
        end
    else
        --no item, use default border
        self:SetBackdropBorderColor(unpack(cfg.backdrop.borderColor))
    end
end

local function SetDefaultAnchor(self,parent)
    self:ClearAllPoints()
    if InCombatLockdown() and not C_PetBattles.IsInBattle() then
        self:SetOwner(parent, "ANCHOR_NONE")
        self:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -470, 135)
    else
        self:SetOwner(parent, "ANCHOR_CURSOR")
    end
end

local classColorHex, factionColorHex = {}, {}

for class, color in next, RAID_CLASS_COLORS do
    classColorHex[class] = GetHexColor(color)
end
for i = 1, #FACTION_BAR_COLORS do
    factionColorHex[i] = GetHexColor(FACTION_BAR_COLORS[i])
end
cfg.afkColorHex = GetHexColor(cfg.afkColor)

GameTooltipHeaderText:SetFont(cfg.fontFamily, 14, "NONE")
GameTooltipHeaderText:SetShadowOffset(1,-2)
GameTooltipHeaderText:SetShadowColor(0,0,0,0.75)
GameTooltipText:SetFont(cfg.fontFamily, 12, "NONE")
GameTooltipText:SetShadowOffset(1,-2)
GameTooltipText:SetShadowColor(0,0,0,0.75)
Tooltip_Small:SetFont(cfg.fontFamily, 11, "NONE")
Tooltip_Small:SetShadowOffset(1,-2)
Tooltip_Small:SetShadowColor(0,0,0,0.75)

GameTooltipStatusBar:ClearAllPoints()
GameTooltipStatusBar:SetPoint("LEFT",5,0)
GameTooltipStatusBar:SetPoint("RIGHT",-5,0)
GameTooltipStatusBar:SetPoint("TOP",0,-2.5)
GameTooltipStatusBar:SetHeight(4)
GameTooltipStatusBar.bg = GameTooltipStatusBar:CreateTexture(nil,"BACKGROUND",nil,-8)
GameTooltipStatusBar.bg:SetAllPoints()
GameTooltipStatusBar.bg:SetColorTexture(1,1,1)
GameTooltipStatusBar.bg:SetVertexColor(0,0,0,0.5)

hooksecurefunc("GameTooltip_SetDefaultAnchor", SetDefaultAnchor)
hooksecurefunc("GameTooltip_SetBackdropStyle", SetBackdropStyle)
GameTooltip:HookScript("OnTooltipSetUnit", OnTooltipSetUnit)

--loop over tooltips
local tooltips = { GameTooltip, ItemRefTooltip, ShoppingTooltip1, ShoppingTooltip2, ShoppingTooltip3, ItemRefShoppingTooltip1, ItemRefShoppingTooltip2, WorldMapTooltip, WorldMapCompareTooltip1, WorldMapCompareTooltip2, SmallTextTooltip, EventTraceTooltip, FrameStackTooltip }
for i, tooltip in next, tooltips do
    tooltip:SetScale(cfg.scale)
    if tooltip:HasScript("OnTooltipCleared") then
        tooltip:HookScript("OnTooltipCleared", SetBackdropStyle)
    end
end

--loop over menues
local menues = {
    DropDownList1MenuBackdrop,
    DropDownList2MenuBackdrop,
}
for i, menu in next, menues do
    menu:SetScale(cfg.scale)
end
