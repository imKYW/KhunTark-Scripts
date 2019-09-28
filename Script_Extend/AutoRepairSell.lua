local A, L = ...

local gg = true -- 길드 수리비 사용 한다(true), 안한다(false)
local stop = true
local list = {}

local function RepairNow()
    local co = GetRepairAllCost()
    if (not co or co == 0) then return
    elseif gg and CanGuildBankRepair() then
        local _, _, gI = GetGuildInfo("player")
        self:RegisterEvent('UI_ERROR_MESSAGE')

        if  (gI~=0 and GetGuildBankWithdrawMoney()<co) or GetGuildBankMoney()==0
        or  (GetGuildBankMoney()<co and GetGuildBankMoney()>0) then
            RepairAllItems()
            print("|cFFFFCC00 수리비 : ", GetMoneyString(co).."  |c0000CC00(길드 수리비 부족)" )
        else
            RepairAllItems(1)
            print("|cFFFFCC00 수리비 |c0000CC00(길드) |cFFFFCC00: ", GetMoneyString(co))
        end
        self:UnregisterEvent('UI_ERROR_MESSAGE')
    elseif  GetMoney() < co then
        print("|cFFFFCC00 수리비 부족")
    else
        RepairAllItems()
        print("|cFFFFCC00 수리비 : ", GetMoneyString(co))
    end
end

local function SellGray()
    if stop then return end
    for bag=0,4 do
        for slot=0,GetContainerNumSlots(bag) do
            if stop then return end
            local link = GetContainerItemLink(bag, slot)
            if link and select(3, GetItemInfo(link)) == 0 and not list["b"..bag.."s"..slot] then
                print(A,"selling",link,"bag",bag,"slot",slot)
                list["b"..bag.."s"..slot] = true
                UseContainerItem(bag, slot)
                C_Timer.After(0.2, SellGray)
                return
            end
        end
    end
end

local function AutoRepairSell_OnEvent(self,event)
    if event == "MERCHANT_SHOW" then
        stop = false
        if CanMerchantRepair() then RepairNow() end
        wipe(list)
        SellGray()
    elseif event == "MERCHANT_CLOSED" then
        stop = true
    end
end

-- Event Handler
local AutoRepairSell_Handler = CreateFrame("Frame")
AutoRepairSell_Handler:RegisterEvent("MERCHANT_SHOW")
AutoRepairSell_Handler:RegisterEvent("MERCHANT_CLOSED")
AutoRepairSell_Handler:SetScript("OnEvent", AutoRepairSell_OnEvent)
