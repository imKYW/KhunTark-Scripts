local A, L = ...

local stop = true
local list = {}

local function RepairNow()
    local cost = GetRepairAllCost()
    local gbmoney = GetGuildBankMoney()
    if cost > 0 and CanGuildBankRepair() then
        if GetGuildBankWithdrawMoney() >= cost and gbmoney >= cost then
            RepairAllItems(1)
            print(format("|cff00ff00수리비(길드) : %.2fg|r", cost * 0.0001))
        elseif GetMoney() >= cost then
            RepairAllItems()
            print(format("|cffffff00수리비 : %.2fg|r", cost * 0.0001))
        else
            print(format("|cffff0000수리비 부족!!|r"))
        end
    elseif cost > 0 and GetMoney() >= cost then
        RepairAllItems()
        print(format("|cffffff00수리비 : %.2fg|r", cost * 0.0001))
    elseif GetMoney() < cost then
        print(format("|cffff0000수리비 부족!!|r"))
    end
end

local function SellGray()
    if stop then return end
    for bag=0,4 do
        for slot=0,C_Container.GetContainerNumSlots(bag) do
            if stop then return end
            local link = C_Container.GetContainerItemLink(bag, slot)
            if link and select(3, GetItemInfo(link)) == 0 and not list["b"..bag.."s"..slot] then
                print(A,"selling",link,"bag",bag,"slot",slot)
                list["b"..bag.."s"..slot] = true
                C_Container.UseContainerItem(bag, slot)
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
