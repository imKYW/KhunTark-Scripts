hooksecurefunc('BuffFrame_UpdateAllBuffAnchors',function()
    -- Buff Frame
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -10, -3)

    -- Debuff Button
    for i = 1, 16 do
        local button = _G['DebuffButton'..i]
        if not button then break end
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("TOPRIGHT", Minimap, "LEFT", -10, 0)
        elseif i == 9 then
            button:SetPoint("TOP", DebuffButton1, "BOTTOM", 0, -10)
        else
            button:SetPoint("RIGHT", _G['DebuffButton'..i-1], "LEFT", -2, 0)
        end
    end
end)
