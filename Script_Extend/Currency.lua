-- Config
local position_Align = 'RIGHT'
local font = 'Fonts\\FRIZQT__.ttf'
-- /Config

local playerRealm = _G.GetRealmName()
local playerFaction = select(1, _G.UnitFactionGroup('player'))
local playerName = _G.UnitName('player')
local playerClass = select(2, _G.UnitClass('player'))

-- Funtion ----------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
local function KBJcurrencyEmblems_Format(amount, icon)
    if amount > 0 then
        local CURRENCY_TEXTURE = "%s\124T"..icon..":%d:%d:2:0\124t"
        return format(CURRENCY_TEXTURE.." ", BreakUpLargeNumbers(amount), 11, 11)
    else
        return ""
    end
end

local MAX_WATCHED_TOKENS = 8
local function KBJcurrencyEmblems_Update()
    local currencystr
    for i=1, MAX_WATCHED_TOKENS do
        local cInfo = _G.C_CurrencyInfo.GetBackpackCurrencyInfo(i)
        if cInfo then
            if currencystr then
                currencystr = currencystr..KBJcurrencyEmblems_Format(cInfo.quantity, cInfo.iconFileID).." "
            else
                currencystr = KBJcurrencyEmblems_Format(cInfo.quantity, cInfo.iconFileID).." "
            end
        end
    end
    return currencystr
end

local function GetGoldString(money)
    return ("%d"):format(money/10000).."|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t"
    --return GetMoneyString((("%d"):format(money/10000))*10000).." "
end

function KBJcurrencyEmblems()
    local currencystr = KBJcurrencyEmblems_Update()

    if currencystr then
        currencystr = "|cFFFFFFFF"..currencystr
    else
        currencystr = ""
    end

    return currencystr
end

function KBJcurrencyMoney()
    return GetCoinTextureString(GetMoney(), 0)
end

function KBJcurrencySave()
    if vKTSDB == nil then vKTSDB = { } end
    if not vKTSDB[playerRealm.."-"..playerFaction] then vKTSDB[playerRealm.."-"..playerFaction] = { } end

    local currencyDB = vKTSDB[playerRealm.."-"..playerFaction]
    local foundPlayer = false

    if currencyDB[1] == nil then
        currencyDB[1] = { playerName, playerClass, GetMoney() }
    else
        for i = 1, #currencyDB do
            if currencyDB[i][1] == playerName then
                currencyDB[i] = { playerName, playerClass, GetMoney() }
                foundPlayer = true
            end
        end
        if not foundPlayer then
            currencyDB[#currencyDB+1] = { playerName, playerClass, GetMoney() }
        end
    end
end

function KBJcurrencyTooltip(self)
    local realmGold = 0

    GameTooltip:ClearLines()
    GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')

    -- Realm Gold
    GameTooltip:AddLine("Currency in "..playerRealm.." ["..playerFaction.."]", 0.9, 0.7, 0.2)

    local realmCDB = vKTSDB[playerRealm.."-"..playerFaction]
    for i = 1, #realmCDB do
        local name, class, money = unpack(realmCDB[i])
        local color = RAID_CLASS_COLORS[class]

        GameTooltip:AddDoubleLine("- "..name, GetGoldString(money), color.r, color.g, color.b, 1, 1, 1)

        realmGold = realmGold + money
    end

    GameTooltip:AddDoubleLine("+ Total", GetGoldString(realmGold), 0.9, 0.7, 0.2)
    GameTooltip:AddLine(" ")

    -- TEST
    if not vKTSDB["아즈샤라-Horde"] then
        GameTooltip:AddLine("Currency in Account", 0.9, 0.7, 0.2)

        local tichondriusACDB = vKTSDB["Tichondrius-Alliance"]
        local tichondriusAGold = 0
        for i = 1, #tichondriusACDB do
            tichondriusAGold = tichondriusAGold + tichondriusACDB[i][3]
        end
        GameTooltip:AddDoubleLine("- Tichondrius", GetGoldString(tichondriusAGold), 0, 0.5, 0.9, 1, 1, 1)

        local tichondriusHCDB = vKTSDB["Tichondrius-Horde"]
        local tichondriusHGold = 0
        for i = 1, #tichondriusHCDB do
            tichondriusHGold = tichondriusHGold + tichondriusHCDB[i][3]
        end
        GameTooltip:AddDoubleLine("- Tichondrius", GetGoldString(tichondriusHGold), 0.8, 0.2, 0.2, 1, 1, 1)

        GameTooltip:AddDoubleLine("+ Total", GetGoldString(tichondriusAGold+tichondriusHGold), 0.9, 0.7, 0.2)
        GameTooltip:AddLine(" ")
    end

    -- Token
    local tokenPrice = C_WowTokenPublic.GetCurrentMarketPrice()
    if tokenPrice then
        GameTooltip:AddDoubleLine("Token Price", GetGoldString(tokenPrice), 0.9, 0.7, 0.2)
    end

    GameTooltip:Show()
end

-- Core -------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
local mainFrame = CreateFrame('frame', 'KBJcurrency', UIParent)
-- Emblems Event
mainFrame:RegisterEvent('CURRENCY_DISPLAY_UPDATE')
mainFrame:RegisterEvent('TRADE_CURRENCY_CHANGED')
-- Money Event
mainFrame:RegisterEvent('PLAYER_MONEY')
mainFrame:RegisterEvent('SEND_MAIL_MONEY_CHANGED')
mainFrame:RegisterEvent('SEND_MAIL_COD_CHANGED')
mainFrame:RegisterEvent('PLAYER_TRADE_MONEY')
mainFrame:RegisterEvent('TRADE_MONEY_CHANGED')
-- General
mainFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
mainFrame:RegisterEvent('MERCHANT_CLOSED')

mainFrame:SetWidth(50)
mainFrame:SetHeight(15)
mainFrame:SetPoint("TOPRIGHT", MultiBar7, "TOPRIGHT", 0, 18) --MainMenuBarBackpackButton

local currencyFrame = mainFrame:CreateFontString(nil, 'OVERLAY')
currencyFrame:SetPoint(position_Align, mainFrame, position_Align, 0, 0)
currencyFrame:SetFont(font, 12, nil)
currencyFrame:SetShadowOffset(1, -1)
currencyFrame:SetTextColor(1, 1, 1)
--currencyFrame:SetPoint('CENTER')

function KBJcurrencyOnEvent(self, event, ...)
    local emblems = KBJcurrencyEmblems()
    local money = KBJcurrencyMoney()
    if event == 'PLAYER_ENTERING_WORLD' then
        C_WowTokenPublic.UpdateMarketPrice()
        currencyFrame:SetText(money.."  "..emblems)
        mainFrame:SetWidth(currencyFrame:GetStringWidth())
        _G.C_Timer.After(2, function() KBJcurrencySave() end)
    elseif event == 'MERCHANT_CLOSED' then
        emblems = KBJcurrencyEmblems()
        money = KBJcurrencyMoney()
        currencyFrame:SetText(money.."  "..emblems)
        mainFrame:SetWidth(currencyFrame:GetStringWidth())
        KBJcurrencySave()
    elseif event == 'CURRENCY_DISPLAY_UPDATE'
    or event == 'TRADE_CURRENCY_CHANGED' then
        emblems = KBJcurrencyEmblems()
        currencyFrame:SetText(money.."  "..emblems)
        mainFrame:SetWidth(currencyFrame:GetStringWidth())
    elseif event == 'PLAYER_MONEY'
    or event == 'SEND_MAIL_MONEY_CHANGED'
    or event == 'SEND_MAIL_COD_CHANGED'
    or event == 'PLAYER_TRADE_MONEY'
    or event == 'TRADE_MONEY_CHANGED' then
        money = KBJcurrencyMoney()
        currencyFrame:SetText(money.."  "..emblems)
        mainFrame:SetWidth(currencyFrame:GetStringWidth())
        KBJcurrencySave()
    end
end

mainFrame:SetScript('OnEvent', KBJcurrencyOnEvent)
mainFrame:SetScript('OnEnter', function() KBJcurrencyTooltip(mainFrame) end)
mainFrame:SetScript('OnLeave', function() GameTooltip:Hide() end)

--[[
_G["TokenFramePopupBackpackCheckBox"]:HookScript("OnClick", function()
    currencyFrame:SetText(KBJcurrencyMoney().."  "..KBJcurrencyEmblems())
    mainFrame:SetWidth(currencyFrame:GetStringWidth())
end)
]]
