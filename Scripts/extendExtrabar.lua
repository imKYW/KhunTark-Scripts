local A, L = ...

L.Funcs = {}

local MyFuncs = L.Funcs

local f = CreateFrame("Frame", nil, UIParent)

function MyFuncs.OnEvent(self, event, ...)
    if event == "ACTIONBAR_PAGE_CHANGED" then
        if GetActionBarPage() ~= 1 then ChangeActionBarPage(1) end
    elseif event == "UPDATE_BINDINGS" then
        MyFuncs.UpdateBindings()
    elseif event == "PLAYER_LOGIN" then
        BINDING_HEADER_EXTRABAR = "ExtraBar"
        BINDING_NAME_EXTRABARBUTTON1 = "ExtraBar Button 1"
        BINDING_NAME_EXTRABARBUTTON2 = "ExtraBar Button 2"
        BINDING_NAME_EXTRABARBUTTON3 = "ExtraBar Button 3"
        BINDING_NAME_EXTRABARBUTTON4 = "ExtraBar Button 4"
        BINDING_NAME_EXTRABARBUTTON5 = "ExtraBar Button 5"
        BINDING_NAME_EXTRABARBUTTON6 = "ExtraBar Button 6"
        BINDING_NAME_EXTRABARBUTTON7 = "ExtraBar Button 7"
        BINDING_NAME_EXTRABARBUTTON8 = "ExtraBar Button 8"
        BINDING_NAME_EXTRABARBUTTON9 = "ExtraBar Button 9"
        BINDING_NAME_EXTRABARBUTTON10 = "ExtraBar Button 10"
        BINDING_NAME_EXTRABARBUTTON11 = "ExtraBar Button 11"
        BINDING_NAME_EXTRABARBUTTON12 = "ExtraBar Button 12"
    end
end

function MyFuncs.UpdateBindings()
    for i=1,12,1 do
        local button = _G["ExtraBarButton"..i]
        local id = button:GetID()

        local hotkey = _G[button:GetName().."HotKey"]
        local key = GetBindingKey("EXTRABARBUTTON"..i)
        local text = GetBindingText(key, "KEY_", 1)

        if text == "" then
            hotkey:SetText(RANGE_INDICATOR)
            hotkey:SetPoint("TOPLEFT", button, "TOPLEFT", 1, -2)
            hotkey:Hide()
        else
            hotkey:SetText(text)
            hotkey:SetPoint("TOPLEFT", button, "TOPLEFT", -2, -2)
            hotkey:Show()
            SetOverrideBindingClick(button, true, key, button:GetName(), "LeftButton")
        end
    end
end

f:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
f:RegisterEvent("UPDATE_BINDINGS")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", MyFuncs.OnEvent)

for i=13, 24 do
    local button = CreateFrame("CheckButton", "ExtraBarButton"..i-12, UIParent, "ActionBarButtonTemplate")
    if not button then break end
    button:ClearAllPoints()
    button:SetAttribute("action", i)
    button:SetID(i)
    button:SetScale(0.8)
    if i == 13 then
        button:SetPoint("LEFT", MultiBarLeftButton4, "RIGHT", 20, 0)
    elseif i == 17 then
        button:SetPoint("TOP", ExtraBarButton1, "BOTTOM", 0, -6)
    elseif i == 21 then
        button:SetPoint("TOP", ExtraBarButton5, "BOTTOM", 0, -6)
    else
        button:SetPoint("LEFT", _G['ExtraBarButton'..i-13], "RIGHT", 6, 0)
    end
    --button:Show()
    _G["ExtraBarButton"..i-12]:Show()
end
