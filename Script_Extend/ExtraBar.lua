-- Hide function
local function Extrabar_SetFrame(vAlpha)
    for i = 1, 42 do
        _G['ExtraBarButton'..i]:SetAlpha(vAlpha)
    end
end

local function HideButtonFrame(frame, button, offAlpha)
    if not frame then return end
    frame:SetAlpha(offAlpha)
    frame:EnableMouse(true)
    button:HookScript("OnEnter", function() Extrabar_SetFrame(1) end)
    button:HookScript("OnLeave", function() Extrabar_SetFrame(offAlpha) end)
end

for i=13, 24 do
    local button = CreateFrame("CheckButton", "ExtraBarButton"..i-12, UIParent, "ActionBarButtonTemplate")
    if not button then break end
    button:ClearAllPoints()
    button:SetAttribute("action", i)
    button:SetID(i)
    button:SetScale(0.8)
    if i == 13 then
        button:SetPoint("RIGHT", MultiBarRightButton4, "LEFT", -20, 0)
    elseif i == 17 then
        button:SetPoint("TOP", ExtraBarButton1, "BOTTOM", 0, -6)
    elseif i == 21 then
        button:SetPoint("TOP", ExtraBarButton5, "BOTTOM", 0, -6)
    else
        button:SetPoint("RIGHT", _G['ExtraBarButton'..i-13], "LEFT", -6, 0)
    end

    -- Show Grid
    _G['ExtraBarButton'..i-12]:SetAttribute('showgrid', 1)
    _G['ExtraBarButton'..i-12]:ShowGrid(1)

    -- Hide
    HideButtonFrame(button, _G['ExtraBarButton'..i-12], 0.7)
end

for i=85, 114 do
    local button = CreateFrame("CheckButton", "ExtraBarButton"..i-72, UIParent, "ActionBarButtonTemplate")
    if not button then break end
    button:ClearAllPoints()
    button:SetAttribute("action", i)
    button:SetID(i)
    button:SetScale(0.8)
    if i == 85 then
        button:SetPoint("LEFT", MultiBarLeftButton4, "RIGHT", 20, 0)
    elseif i == 95 then
        button:SetPoint("TOP", ExtraBarButton13, "BOTTOM", 0, -6)
    elseif i == 105 then
        button:SetPoint("TOP", ExtraBarButton23, "BOTTOM", 0, -6)
    else
        button:SetPoint("LEFT", _G['ExtraBarButton'..i-73], "RIGHT", 6, 0)
    end

    -- Show Grid
    _G['ExtraBarButton'..i-72]:SetAttribute('showgrid', 1)
    _G['ExtraBarButton'..i-72]:ShowGrid(1)

    -- Hide
    HideButtonFrame(button, _G['ExtraBarButton'..i-72], 0.7)
end

-- Set Key Binding
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
BINDING_NAME_EXTRABARBUTTON13 = "ExtraBar Button 13"
BINDING_NAME_EXTRABARBUTTON14 = "ExtraBar Button 14"
BINDING_NAME_EXTRABARBUTTON15 = "ExtraBar Button 15"
BINDING_NAME_EXTRABARBUTTON16 = "ExtraBar Button 16"
BINDING_NAME_EXTRABARBUTTON17 = "ExtraBar Button 17"
BINDING_NAME_EXTRABARBUTTON18 = "ExtraBar Button 18"
BINDING_NAME_EXTRABARBUTTON19 = "ExtraBar Button 19"
BINDING_NAME_EXTRABARBUTTON20 = "ExtraBar Button 20"
BINDING_NAME_EXTRABARBUTTON21 = "ExtraBar Button 21"
BINDING_NAME_EXTRABARBUTTON22 = "ExtraBar Button 22"
BINDING_NAME_EXTRABARBUTTON23 = "ExtraBar Button 23"
BINDING_NAME_EXTRABARBUTTON24 = "ExtraBar Button 24"
BINDING_NAME_EXTRABARBUTTON25 = "ExtraBar Button 25"
BINDING_NAME_EXTRABARBUTTON26 = "ExtraBar Button 26"
BINDING_NAME_EXTRABARBUTTON27 = "ExtraBar Button 27"
BINDING_NAME_EXTRABARBUTTON28 = "ExtraBar Button 28"
BINDING_NAME_EXTRABARBUTTON29 = "ExtraBar Button 29"
BINDING_NAME_EXTRABARBUTTON30 = "ExtraBar Button 30"
BINDING_NAME_EXTRABARBUTTON31 = "ExtraBar Button 31"
BINDING_NAME_EXTRABARBUTTON32 = "ExtraBar Button 32"
BINDING_NAME_EXTRABARBUTTON33 = "ExtraBar Button 33"
BINDING_NAME_EXTRABARBUTTON34 = "ExtraBar Button 34"
BINDING_NAME_EXTRABARBUTTON35 = "ExtraBar Button 35"
BINDING_NAME_EXTRABARBUTTON36 = "ExtraBar Button 36"
BINDING_NAME_EXTRABARBUTTON37 = "ExtraBar Button 37"
BINDING_NAME_EXTRABARBUTTON38 = "ExtraBar Button 38"
BINDING_NAME_EXTRABARBUTTON39 = "ExtraBar Button 39"
BINDING_NAME_EXTRABARBUTTON40 = "ExtraBar Button 40"
BINDING_NAME_EXTRABARBUTTON41 = "ExtraBar Button 41"
BINDING_NAME_EXTRABARBUTTON42 = "ExtraBar Button 42"

--54 55
-- for i=85, 96 do
