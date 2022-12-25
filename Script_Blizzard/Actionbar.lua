local SCALE = 0.8

-----------------------------------------
local KBJactionbar = CreateFrame("Frame", "KBJactionbar_main", UIParent)
--KBJactionbar:SetSize(498, 45)
KBJactionbar:SetPoint("BOTTOM", 0 , 5)
KBJactionbar:Show()
--KBJactionbar:SetScale(SCALE)
-----------------------------------------

for _, bar in next, {
    MainMenuBar,
    MultiBarBottomLeft,
    MultiBarBottomRight,
    MultiBarLeft,
    MultiBarRight,
    MultiBar5,
    MultiBar6,
    MultiBar7
} do
    bar:SetParent(KBJactionbar)   -- in order to scale them
end

-- Hide Script

--MainMenuBar.EndCaps.LeftEndCap:Hide()
--MainMenuBar.EndCaps.RightEndCap:Hide()


--PossessActionBar
local function KTS_Actionbar_layout()
    MainMenuBar:ClearAllPoints()
    MainMenuBar:SetScale(SCALE)
    MainMenuBar:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 10)
    MultiBarBottomLeft:ClearAllPoints()
    MultiBarBottomLeft:SetScale(SCALE)
    MultiBarBottomLeft:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, 2)
    MultiBarBottomRight:ClearAllPoints()
    MultiBarBottomRight:SetScale(SCALE)
    MultiBarBottomRight:SetPoint("BOTTOM", MultiBarBottomLeft, "TOP", 0, 2)
    MultiBarBottomRight:SetAttribute("showgrid", expected)
    MultiBarLeft:ClearAllPoints()
    MultiBarLeft:SetScale(SCALE)            
    MultiBarLeft:SetPoint("BOTTOMRIGHT", MainMenuBar, "BOTTOMLEFT", -10, 0)
    MultiBarRight:ClearAllPoints()
    MultiBarRight:SetScale(SCALE)
    MultiBarRight:SetPoint("BOTTOMRIGHT", MultiBarLeft, "BOTTOMLEFT", -10, 0)
    MultiBar5:ClearAllPoints()
    MultiBar5:SetScale(SCALE-0.1)
    MultiBar5:SetPoint("LEFT", MainMenuBar, "RIGHT", 10, 0)
    MultiBar6:ClearAllPoints()
    MultiBar6:SetScale(SCALE-0.1)
    MultiBar6:SetPoint("LEFT", MultiBarBottomLeft, "RIGHT", 10, 0)    
    MultiBar7:ClearAllPoints()
    MultiBar7:SetScale(SCALE-0.1)
    MultiBar7:SetPoint("LEFT", MultiBarBottomRight, "RIGHT", 10, 0)
    StanceBar:ClearAllPoints()
    StanceBar:SetScale(SCALE+0.2)
    StanceBar:SetPoint("BOTTOMRIGHT", MultiBarLeft, "TOPRIGHT", -1, 5)
    PetActionBar:ClearAllPoints()
    --PetActionBar:SetScale(SCALE)
    PetActionBar:SetPoint("BOTTOMLEFT", MultiBarBottomRight, "TOPLEFT", 3, 5)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetScale(SCALE+0.4)
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMRIGHT", MultiBarBottomRight, "TOPRIGHT", -2, 5)
end
hooksecurefunc("UIParent_ManageFramePositions",  KTS_Actionbar_layout)
