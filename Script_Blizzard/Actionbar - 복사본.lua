local SCALE = 0.8
local MICRO_BAGS_HIDE = true

-----------------------------------------
local KBJactionbar = CreateFrame("Frame", "KBJactionbar_main", UIParent)
KBJactionbar:SetSize(498, 45)
KBJactionbar:SetPoint("BOTTOM", 0 , 5)
KBJactionbar:Show()
KBJactionbar:SetScale(SCALE)
-----------------------------------------

-- Hide Script
MainMenuBarArtFrame.LeftEndCap:Hide()
MainMenuBarArtFrame.RightEndCap:Hide()
MainMenuBarArtFrame.PageNumber:Hide()
ActionBarUpButton:Hide()
ActionBarDownButton:Hide()
MainMenuBarArtFrameBackground:Hide()
MicroButtonAndBagsBar.MicroBagBar:Hide()
StatusTrackingBarManager:Hide()

for i = 1,2  do _G["PossessBackground"..i]:SetTexture(nil) end                                  --Art of Possess(When Bar Bottomleft hide )
for i = 0,1  do _G["SlidingActionBarTexture"..i]:SetTexture(nil) end                            --Art of Pet    (When Bar Bottomleft hide)
for _, tex in next, {StanceBarLeft, StanceBarMiddle, StanceBarRight} do tex:SetTexture(nil) end --BG of Stance

-- set the blank area unclickable, in order to make the other addons work
for _, bar in next, {
    MainMenuBar,
    MultiBarBottomLeft,
    MultiBarBottomRight,
    MultiBarLeft,
    MultiBarRight,
    MultiBar5,
    MultiBar6,
    MultiBar7,
    PetActionBarFrame,
    PossessBarFrame,
    StanceBarFrame
} do
    bar:EnableMouse(false);
end

for _, bar in next, {
    MainMenuBar,
    MultiBarLeft,
    MultiBarRight,
} do
    bar:SetParent(KBJactionbar)   -- in order to scale them
end

local function KBJactionbar_layout()
    if InCombatLockdown() then return end
    ActionButton1:ClearAllPoints();
    ActionButton1:SetPoint("BOTTOMLEFT", KBJactionbar, "BOTTOM", -498/2, 4+2);
    MultiBarBottomLeftButton1:ClearAllPoints();
    MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 6);
    MultiBarBottomRightButton1:ClearAllPoints()
    MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 6)
    MultiBarBottomRightButton7:ClearAllPoints()
    MultiBarBottomRightButton7:SetPoint("LEFT", MultiBarBottomRightButton6, "RIGHT", 6, 0)

    for i=1, 12 do
        local button = _G['MultiBarLeftButton'..i]
        if not button then break end
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("LEFT", MultiBarBottomRightButton12, "RIGHT", 20, 0)
        elseif i == 5 then
            button:SetPoint("TOP", MultiBarLeftButton1, "BOTTOM", 0, -6)
        elseif i == 9 then
            button:SetPoint("TOP", MultiBarLeftButton5, "BOTTOM", 0, -6)
        else
            button:SetPoint("LEFT", _G['MultiBarLeftButton'..i-1], "RIGHT", 6, 0)
        end
    end

    for i=1, 12 do
        local button = _G['MultiBarRightButton'..i]
        if not button then break end
        button:ClearAllPoints()
        if i == 1 then
            button:SetPoint("RIGHT", MultiBarBottomRightButton1, "LEFT", -20, 0)
        elseif i == 5 then
            button:SetPoint("TOP", MultiBarRightButton1, "BOTTOM", 0, -6)
        elseif i == 9 then
            button:SetPoint("TOP", MultiBarRightButton5, "BOTTOM", 0, -6)
        else
            button:SetPoint("RIGHT", _G['MultiBarRightButton'..i-1], "LEFT", -6, 0)
        end
    end

    local petx,pety
    if (not SHOW_MULTI_ACTIONBAR_1 and  not SHOW_MULTI_ACTIONBAR_2 ) then       -- show bar 1 only
        pety = 0
    elseif ( SHOW_MULTI_ACTIONBAR_1 and not SHOW_MULTI_ACTIONBAR_2 ) then       -- show BL only; what about show BR only, joy me?
        pety = 36 + 6       -- bar2 button height is 36 & gap is 8
    else                                                                        -- show BL&BR
        pety = (36+6) * 2
    end

    if ( StanceBarFrame and GetNumShapeshiftForms() > 0 ) then petx = 127 else petx = 127/2  end       --set PetBar right when StanceBar
    PetActionButton1:ClearAllPoints()
    PetActionButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "BOTTOMLEFT", petx+60, pety)

    StanceButton1:ClearAllPoints()
    StanceButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "BOTTOMLEFT", 0, pety)
    PossessButton1:ClearAllPoints()
    PossessButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "BOTTOMLEFT", 0, pety)
    MainMenuBarVehicleLeaveButton:ClearAllPoints()
    MainMenuBarVehicleLeaveButton:SetPoint("BOTTOMRIGHT", MultiBarBottomLeftButton12, "BOTTOMRIGHT", 0, pety + 30 + 6)    --higher than pet button

    ExtraActionButton1:ClearAllPoints()
    ExtraActionButton1:SetPoint("BOTTOM", KBJactionbar, 0, 200)

    --hide the background of stancebar when actionbar1 only
    for i = 1, NUM_STANCE_SLOTS do
        if _G["StanceButton"..i]:GetNormalTexture():GetWidth() ~= 52 then
            _G["StanceButton"..i]:GetNormalTexture():SetWidth(52)
            _G["StanceButton"..i]:GetNormalTexture():SetHeight(52)
        end
    end
 end
hooksecurefunc("UIParent_ManageFramePositions",  KBJactionbar_layout)

-------------------------------------------------
-- OverrideBar patch from rActionBarStyler
OverrideActionBar:SetScale(SCALE)
for _,tex in next,{
    "_BG",
    "EndCapL",
    "EndCapR",
    "_Border",
    "Divider1",
    "Divider2",
    "Divider3",
    "ExitBG",
    "MicroBGL",
    "MicroBGR",
    "_MicroBGMid",
    "ButtonBGL",
    "ButtonBGR",
    "_ButtonBGMid"
} do
    OverrideActionBar[tex]:Hide()
end

local HideOverride = CreateFrame("frame")
HideOverride:Hide()
for _,f in next,{
    OverrideActionBarExpBar,
    OverrideActionBarHealthBar,
    OverrideActionBarPowerBar,
    OverrideActionBarPitchFrame
} do
    f:SetParent(HideOverride)
end

for i=1, 6 do
    local button = OverrideActionBar["SpellButton"..i];
    if not button then break end
    button:ClearAllPoints()
    if i == 1 then
        button:SetPoint("BOTTOMLEFT", ActionButton1)
    else
        button:SetPoint("LEFT", OverrideActionBar["SpellButton"..i-1], "RIGHT", 6, 0)
    end
end
OverrideActionBar.LeaveButton:ClearAllPoints()
OverrideActionBar.LeaveButton:SetPoint("BOTTOMRIGHT", ActionButton12)

hooksecurefunc("OverrideActionBar_Leave", function() ShowPetActionBar(true) end)

-------------------------------------------------------------------------
-- Action Bar BG FIX
local function KBJactionbar_show_button_slot()
    if InCombatLockdown() then return end
    for i = 1, NUM_ACTIONBAR_BUTTONS do
        local button = _G["ActionButton"..i]
        button.noGrid = nil  --20180728: fix button slot disappear when open/close spellbook
        if ( ALWAYS_SHOW_MULTIBARS == "1" or ALWAYS_SHOW_MULTIBARS == 1 ) then
            button:SetAttribute("showgrid", 1)
            button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
        else
            button:SetAttribute("showgrid", 0)
            button:HideGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
            --button:HideGrid()
        end
    end
    for i = 1, NUM_ACTIONBAR_BUTTONS / 2 do
        local button = _G["MultiBarBottomRightButton"..i]
        button.noGrid = nil  --20180728: fix button slot disappear when open/close spellbook
        if ( ALWAYS_SHOW_MULTIBARS == "1" or ALWAYS_SHOW_MULTIBARS == 1 ) then
            button:SetAttribute("showgrid", 1)
            button:ShowGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
        else
            button:SetAttribute("showgrid", 0)
            button:HideGrid(ACTION_BUTTON_SHOW_GRID_REASON_EVENT)
            --button:HideGrid()
        end
    end
end
hooksecurefunc("MultiActionBar_UpdateGridVisibility", KBJactionbar_show_button_slot)
