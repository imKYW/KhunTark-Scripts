hooksecurefunc('BuffFrame_UpdateAllBuffAnchors',function()
    BuffFrame:ClearAllPoints()
    BuffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -10, -3)
end)
