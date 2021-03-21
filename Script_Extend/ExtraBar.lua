for i=13, 24 do
    local button = CreateFrame("CheckButton", "ExtraBarButton"..i-12, UIParent, "ActionBarButtonTemplate")
    if not button then break end
    button:ClearAllPoints()
    button:SetAttribute("action", i)
    button:SetID(i)
    button:SetScale(0.8)
    if i == 13 then
        button:SetPoint("BOTTOMRIGHT", _G[MICRO_BUTTONS[1]], "BOTTOMLEFT", -7, 1)
    elseif i%2 ~= 0 then
        button:SetPoint("BOTTOM", _G['ExtraBarButton'..i-14], "TOP", 0, 4)
    else
        button:SetPoint("RIGHT", _G['ExtraBarButton'..i-13], "LEFT", -4, 0)
    end

    -- Show Grid
    _G['ExtraBarButton'..i-12]:SetAttribute("showgrid", 1)
    _G['ExtraBarButton'..i-12]:ShowGrid(1)
end

------------------------------------------------------------------------------------------
-- Set Key Binding and some func for safty
------------------------------------------------------------------------------------------
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

local function Extrabar_UpdateBindings()
    for i=1, 12 do
        local button = _G["ExtraBarButton"..i]
        local id = button:GetID()

        local hotkey = _G[button:GetName().."HotKey"]
        local key = GetBindingKey("EXTRABARBUTTON"..i)
        local text = GetBindingText(key, "KEY_", true)

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

local function Extrabar_OnEvent(self, event, ...)
    if event == "ACTIONBAR_PAGE_CHANGED" then
        if GetActionBarPage() ~= 1 then ChangeActionBarPage(1) end
    elseif event == "PLAYER_ENTERING_WORLD" or event == "UPDATE_BINDINGS" then
        Extrabar_UpdateBindings()
    end
end

local f = CreateFrame("Frame", nil, UIParent)
f:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
f:RegisterEvent("UPDATE_BINDINGS")
f:RegisterEvent('PLAYER_ENTERING_WORLD')
f:SetScript("OnEvent", Extrabar_OnEvent)
