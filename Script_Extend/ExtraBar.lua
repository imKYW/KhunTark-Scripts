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

    -- Show Grid
    _G['ExtraBarButton'..i-12]:SetAttribute("showgrid", 1)
    _G['ExtraBarButton'..i-12]:ShowGrid(1)
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
