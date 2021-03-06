hooksecurefunc('BuffFrame_UpdateAllBuffAnchors',function()
    local enchantBuff = 0

    -- Buff Button
    for i = 1, 24 do
        local button = _G['BuffButton'..i]
        if not button then break end
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -10, -3)
        elseif i == 13 then
            button:SetPoint("TOP", BuffButton1, "BOTTOM", 0, -10)
        else
            button:SetPoint("RIGHT", _G['BuffButton'..i-1], "LEFT", -4, 0)
        end
        enchantBuff = enchantBuff+1
    end

    -- TempEnchant
    for i = 1, 2 do
        local enchantButton = _G['TempEnchant'..i]
        if not enchantButton then break end
        enchantButton:ClearAllPoints()
        if i == 1 then
            enchantButton:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMLEFT", -10, 3)
        else
            enchantButton:SetPoint("RIGHT", _G['TempEnchant'..i-1], "LEFT", -4, 0)
        end
    end

    -- Debuff Button
    for i = 1, 24 do
        local button = _G['DebuffButton'..i]
        if not button then break end
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("TOPRIGHT", Minimap, "LEFT", -10, 0)
        elseif i == 13 then
            button:SetPoint("TOP", DebuffButton1, "BOTTOM", 0, -10)
        else
            button:SetPoint("RIGHT", _G['DebuffButton'..i-1], "LEFT", -4, 0)
        end
    end
end)
