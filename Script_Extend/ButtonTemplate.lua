local A, L = ...

rButtonTemplate = {}
rButtonTemplate.addonName = A

-----------------------------
-- Init
-----------------------------

local function CallButtonFunctionByName(button, func, ...)
  if button and func and button[func] then
    button[func](button, ...)
  end
end

local function ResetAlpha(self,a)
  if not self.__alpha then return end
  if a == self.__alpha then return end
  self:SetAlpha(self.__alpha)
  print(self:GetName(),a)
end

local function ResetNormalTexture(self, file)
  if not self.__normalTextureFile then return end
  if file == self.__normalTextureFile then return end
  self:SetNormalTexture(self.__normalTextureFile)
end

local function ResetTexture(self, file)
  if not self.__textureFile then return end
  if file == self.__textureFile then return end
  self:SetTexture(self.__textureFile)
end

local function ResetVertexColor(self,r,g,b,a)
  if not self.__vertexColor then return end
  local r2,g2,b2,a2 = unpack(self.__vertexColor)
  if not a2 then a2 = 1 end
  if r ~= r2 or g ~= g2 or b ~= b2 or a ~= a2 then
    self:SetVertexColor(r2,g2,b2,a2)
  end
end

local function ApplyPoints(self, points)
  if not points then return end
  self:ClearAllPoints()
  for i, point in next, points do
    self:SetPoint(unpack(point))
  end
end

local function ApplyTexCoord(texture,texCoord)
  if not texCoord then return end
  texture:SetTexCoord(unpack(texCoord))
end

local function ApplyBlendMode(texture,blendMode)
  if not blendMode then return end
  texture:SetBlendMode(blendMode)
end

local function ApplySizeFactor(texture,sizeFactor)
  if not sizeFactor then return end
  local w,h = texture:GetParent():GetSize()
  texture:SetSize(w*sizeFactor,h*sizeFactor)
end

local function ApplyVertexColor(texture,color)
  if not color then return end
  texture.__vertexColor = color
  texture:SetVertexColor(unpack(color))
  hooksecurefunc(texture, "SetVertexColor", ResetVertexColor)
end

local function ApplyAlpha(region,alpha)
  if not alpha then return end
  --region.__alpha = alpha
  region:SetAlpha(alpha)
  --hooksecurefunc(region, "SetAlpha", ResetAlpha)
end

local function ApplyFont(fontString,font)
  if not font then return end
  fontString:SetFont(unpack(font))
end

local function ApplyHorizontalAlign(fontString,align)
  if not align then return end
  fontString:SetJustifyH(align)
end

local function ApplyVerticalAlign(fontString,align)
  if not align then return end
  fontString:SetJustifyV(align)
end

local function ApplyTexture(texture,file)
  if not file then return end
  texture.__textureFile = file
  texture:SetTexture(file)
  hooksecurefunc(texture, "SetTexture", ResetTexture)
end

local function ApplyNormalTexture(button,file)
  if not file then return end
  button.__normalTextureFile = file
  button:SetNormalTexture(file)
  hooksecurefunc(button, "SetNormalTexture", ResetNormalTexture)
end

local function SetupTexture(texture,cfg,func,button)
  if not texture or not cfg then return end
  ApplyTexCoord(texture,cfg.texCoord)
  ApplyBlendMode(texture,cfg.blendMode)
  ApplySizeFactor(texture,cfg.sizeFactor)
  ApplyPoints(texture,cfg.points)
  ApplyVertexColor(texture,cfg.color)
  ApplyAlpha(texture,cfg.alpha)
  if func == "SetTexture" then
    ApplyTexture(texture,cfg.file)
  elseif func == "SetNormalTexture" then
    ApplyNormalTexture(button,cfg.file)
  elseif cfg.file then
    CallButtonFunctionByName(button,func,cfg.file)
  end
end

local function SetupFontString(fontString,cfg)
  if not fontString or not cfg then return end
  ApplyPoints(fontString, cfg.points)
  ApplyFont(fontString,cfg.font)
  ApplyAlpha(fontString,cfg.alpha)
  ApplyHorizontalAlign(fontString,cfg.halign)
  ApplyVerticalAlign(fontString,cfg.valign)
end

local function SetupCooldown(cooldown,cfg)
  if not cooldown or not cfg then return end
  cooldown:SetFrameLevel(cooldown:GetParent():GetFrameLevel())
  ApplyPoints(cooldown, cfg.points)
end

local function SetupBackdrop(button,backdrop)
  if not backdrop then return end
  local bg = CreateFrame("Frame", nil, button, BackdropTemplateMixin and "BackdropTemplate")

  ApplyPoints(bg, backdrop.points)
  bg:SetFrameLevel(button:GetFrameLevel()-1)
  bg:SetBackdrop(backdrop)
  if backdrop.backgroundColor then
    bg:SetBackdropColor(unpack(backdrop.backgroundColor))
  end
  if backdrop.borderColor then
    bg:SetBackdropBorderColor(unpack(backdrop.borderColor))
  end
end

function rButtonTemplate:StyleActionButton(button, cfg)
  if not button then return end
  if button.__styled then return end

  local buttonName = button:GetName()
  local icon = _G[buttonName.."Icon"]
  local flash = _G[buttonName.."Flash"]
  local flyoutBorder = _G[buttonName.."FlyoutBorder"]
  local flyoutBorderShadow = _G[buttonName.."FlyoutBorderShadow"]
  local flyoutArrow = _G[buttonName.."FlyoutArrow"]
  local hotkey = _G[buttonName.."HotKey"]
  local count = _G[buttonName.."Count"]
  local name = _G[buttonName.."Name"]
  local border = _G[buttonName.."Border"]
  local NewActionTexture = button.NewActionTexture
  local cooldown = _G[buttonName.."Cooldown"]
  local normalTexture = button:GetNormalTexture()
  local pushedTexture = button:GetPushedTexture()
  local highlightTexture = button:GetHighlightTexture()
  --normal buttons do not have a checked texture, but checkbuttons do and normal actionbuttons are checkbuttons
  local checkedTexture = nil
  if button.GetCheckedTexture then checkedTexture = button:GetCheckedTexture() end
  local floatingBG = _G[buttonName.."FloatingBG"]

  --hide stuff
  if floatingBG then floatingBG:Hide() end

  --backdrop
  SetupBackdrop(button,cfg.backdrop)

  --textures
  SetupTexture(icon,cfg.icon,"SetTexture",icon)
  SetupTexture(flash,cfg.flash,"SetTexture",flash)
  SetupTexture(flyoutBorder,cfg.flyoutBorder,"SetTexture",flyoutBorder)
  SetupTexture(flyoutBorderShadow,cfg.flyoutBorderShadow,"SetTexture",flyoutBorderShadow)
  SetupTexture(border,cfg.border,"SetTexture",border)
  SetupTexture(normalTexture,cfg.normalTexture,"SetNormalTexture",button)
  SetupTexture(pushedTexture,cfg.pushedTexture,"SetPushedTexture",button)
  SetupTexture(highlightTexture,cfg.highlightTexture,"SetHighlightTexture",button)
  SetupTexture(checkedTexture,cfg.checkedTexture,"SetCheckedTexture",button)

  --cooldown
  SetupCooldown(cooldown,cfg.cooldown)

  --no clue why but blizzard created count and duration on background layer, need to fix that
  local overlay = CreateFrame("Frame",nil,button)
  overlay:SetAllPoints()
  if count then count:SetParent(overlay) end
  if hotkey then hotkey:SetParent(overlay) end
  if name then name:SetParent(overlay) end

  --hotkey+count+name
  SetupFontString(hotkey,cfg.hotkey)
  SetupFontString(count,cfg.count)
  SetupFontString(name,cfg.name)

  button.__styled = true
end

function rButtonTemplate:StyleExtraActionButton(cfg)

  local button = ExtraActionButton1

  if button.__styled then return end

  local buttonName = button:GetName()

  local icon = _G[buttonName.."Icon"]
  --local flash = _G[buttonName.."Flash"] --wierd the template has two textures of the same name
  local hotkey = _G[buttonName.."HotKey"]
  local count = _G[buttonName.."Count"]
  local buttonstyle = button.style --artwork around the button
  local cooldown = _G[buttonName.."Cooldown"]

  local normalTexture = button:GetNormalTexture()
  local pushedTexture = button:GetPushedTexture()
  local highlightTexture = button:GetHighlightTexture()
  local checkedTexture = button:GetCheckedTexture()

  --backdrop
  SetupBackdrop(button,cfg.backdrop)

  --textures
  SetupTexture(icon,cfg.icon,"SetTexture",icon)
  SetupTexture(buttonstyle,cfg.buttonstyle,"SetTexture",buttonstyle)
  SetupTexture(normalTexture,cfg.normalTexture,"SetNormalTexture",button)
  SetupTexture(pushedTexture,cfg.pushedTexture,"SetPushedTexture",button)
  SetupTexture(highlightTexture,cfg.highlightTexture,"SetHighlightTexture",button)
  SetupTexture(checkedTexture,cfg.checkedTexture,"SetCheckedTexture",button)

  --cooldown
  SetupCooldown(cooldown,cfg.cooldown)

  --hotkey, count
  SetupFontString(hotkey,cfg.hotkey)
  SetupFontString(count,cfg.count)

  button.__styled = true
end

function rButtonTemplate:StyleItemButton(button,cfg)

  if not button then return end
  if button.__styled then return end

  local buttonName = button:GetName()
  local icon = _G[buttonName.."IconTexture"]
  local count = _G[buttonName.."Count"]
  local stock = _G[buttonName.."Stock"]
  local searchOverlay = _G[buttonName.."SearchOverlay"]
  local border = button.IconBorder
  local normalTexture = button:GetNormalTexture()
  local pushedTexture = button:GetPushedTexture()
  local highlightTexture = button:GetHighlightTexture()
  --the new ItemButton frame type introduced in 8.1.5 does not have a checked texture
  local checkedTexture = nil
  if button.GetCheckedTexture then checkedTexture = button:GetCheckedTexture() end

  --backdrop
  SetupBackdrop(button,cfg.backdrop)

  --textures
  SetupTexture(icon,cfg.icon,"SetTexture",icon)
  SetupTexture(searchOverlay,cfg.searchOverlay,"SetTexture",searchOverlay)
  SetupTexture(border,cfg.border,"SetTexture",border)
  SetupTexture(normalTexture,cfg.normalTexture,"SetNormalTexture",button)
  SetupTexture(pushedTexture,cfg.pushedTexture,"SetPushedTexture",button)
  SetupTexture(highlightTexture,cfg.highlightTexture,"SetHighlightTexture",button)
  SetupTexture(checkedTexture,cfg.checkedTexture,"SetCheckedTexture",button)

  --count+stock
  SetupFontString(count,cfg.count)
  SetupFontString(stock,cfg.stock)

  button.__styled = true

end

function rButtonTemplate:StyleAllActionButtons(cfg)
  for i = 1, NUM_ACTIONBAR_BUTTONS do
    rButtonTemplate:StyleActionButton(_G["ActionButton"..i],cfg)
    rButtonTemplate:StyleActionButton(_G["MultiBarBottomLeftButton"..i],cfg)
    rButtonTemplate:StyleActionButton(_G["MultiBarBottomRightButton"..i],cfg)
    rButtonTemplate:StyleActionButton(_G["MultiBarRightButton"..i],cfg)
    rButtonTemplate:StyleActionButton(_G["MultiBarLeftButton"..i],cfg)
    rButtonTemplate:StyleActionButton(_G["ExtraBarButton"..i],cfg)
  end
  for i = 1, 6 do
    rButtonTemplate:StyleActionButton(_G["OverrideActionBarButton"..i],cfg)
  end
  --petbar buttons
  for i=1, NUM_PET_ACTION_SLOTS do
    rButtonTemplate:StyleActionButton(_G["PetActionButton"..i],cfg)
  end
  --stancebar buttons
  for i=1, NUM_STANCE_SLOTS do
    rButtonTemplate:StyleActionButton(_G["StanceButton"..i],cfg)
  end
  --possess buttons
  for i=1, NUM_POSSESS_SLOTS do
    rButtonTemplate:StyleActionButton(_G["PossessButton"..i],cfg)
  end
end

function rButtonTemplate:StyleAuraButton(button, cfg)
  if not button then return end
  if button.__styled then return end

  local buttonName = button:GetName()
  local icon = _G[buttonName.."Icon"]
  local count = _G[buttonName.."Count"]
  local duration = _G[buttonName.."Duration"]
  local border = _G[buttonName.."Border"]
  local symbol = button.symbol

  --backdrop
  SetupBackdrop(button,cfg.backdrop)

  --textures
  SetupTexture(icon,cfg.icon,"SetTexture",icon)
  SetupTexture(border,cfg.border,"SetTexture",border)

  --create a normal texture on the aura button
  if cfg.normalTexture and cfg.normalTexture.file then
    button:SetNormalTexture(cfg.normalTexture.file)
    local normalTexture = button:GetNormalTexture()
    SetupTexture(normalTexture,cfg.normalTexture,"SetNormalTexture",button)
  end

  --no clue why but blizzard created count and duration on background layer, need to fix that
  local overlay = CreateFrame("Frame",nil,button)
  overlay:SetAllPoints()
  if count then count:SetParent(overlay) end
  if duration then duration:SetParent(overlay) end

  --count,duration,symbol
  SetupFontString(count,cfg.count)
  SetupFontString(duration,cfg.duration)
  SetupFontString(symbol,cfg.symbol)

  button.__styled = true
end

--style player BuffFrame buff buttons
local buffButtonIndex = 1
function rButtonTemplate:StyleBuffButtons(cfg)
  local function UpdateBuffButtons()
    if buffButtonIndex > BUFF_MAX_DISPLAY then return end
    for i = buffButtonIndex, BUFF_MAX_DISPLAY do
      local button = _G["BuffButton"..i]
      if not button then break end
      rButtonTemplate:StyleAuraButton(button, cfg)
      if button.__styled then buffButtonIndex = i+1 end
    end
  end
  hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateBuffButtons)
end

--style player BuffFrame debuff buttons
function rButtonTemplate:StyleDebuffButtons(cfg)
  local function UpdateDebuffButton(buttonName, i)
    local button = _G["DebuffButton"..i]
    rButtonTemplate:StyleAuraButton(button, cfg)
  end
  hooksecurefunc("DebuffButton_UpdateAnchors", UpdateDebuffButton)
end

--style player TempEnchant buttons
function rButtonTemplate:StyleTempEnchants(cfg)
  rButtonTemplate:StyleAuraButton(TempEnchant1, cfg)
  rButtonTemplate:StyleAuraButton(TempEnchant2, cfg)
  rButtonTemplate:StyleAuraButton(TempEnchant3, cfg)
end

--style all aura buttons
function rButtonTemplate:StyleAllAuraButtons(cfg)
  rButtonTemplate:StyleBuffButtons(cfg)
  rButtonTemplate:StyleDebuffButtons(cfg)
  rButtonTemplate:StyleTempEnchants(cfg)
end





-------------------
-------------------





local mediapath = "Interface\\AddOns\\KhunTark-Scripts\\Media\\"
local copyTable = KTL.CopyTable

-----------------------------
-- actionButtonConfig
-----------------------------

local actionButtonConfig = {}
--make the config available for other addons (like rFilter)
rButtonTemplate_Zork_ActionButtonConfig = actionButtonConfig

--backdrop
actionButtonConfig.backdrop = {
  bgFile = mediapath.."Template_BTN_Backdrop",
  edgeFile = mediapath.."Template_BTN_BackdropBorder",
  tile = false,
  tileSize = 32,
  edgeSize = 5,
  insets = {
    left = 5,
    right = 5,
    top = 5,
    bottom = 5,
  },
  backgroundColor = {0.1,0.1,0.1,0.8},
  borderColor = {0,0,0,1},
  points = {
    {"TOPLEFT", -3, 3 },
    {"BOTTOMRIGHT", 3, -3 },
  },
}

--icon
actionButtonConfig.icon = {
  texCoord = {0.1,0.9,0.1,0.9},
  points = {
    {"TOPLEFT", 1, -1 },
    {"BOTTOMRIGHT", -1, 1 },
  },
}

--flyoutBorder
actionButtonConfig.flyoutBorder = {
  file = ""
}

--flyoutBorderShadow
actionButtonConfig.flyoutBorderShadow = {
  file = ""
}

--border
actionButtonConfig.border = {
  file = _G["ActionButton1Border"]:GetTexture(),
  blendMode = "ADD",
  sizeFactor = 1.8,
  texCoord = {0,1,0,1},
}

--normalTexture
actionButtonConfig.normalTexture = {
  file = mediapath.."Template_BTN_Normal",
  color = {0.5,0.5,0.5,0.7},
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--[[
--highlightTexture
actionButtonConfig.highlightTexture = {
  file = mediapath.."Template_BTN_Highlight",
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}
--checkedTexture
actionButtonConfig.checkedTexture = {
  file = mediapath.."Template_BTN_Checked",
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}
]]--

--cooldown
actionButtonConfig.cooldown = {
  points = {
    {"TOPLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--name (macro name fontstring)
actionButtonConfig.name = {
  font = { STANDARD_TEXT_FONT, 10, "OUTLINE"},
  points = {
    {"BOTTOMLEFT", 0, 0 },
    {"BOTTOMRIGHT", 0, 0 },
  },
  alpha = 1,
}

--hotkey
actionButtonConfig.hotkey = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"TOPRIGHT", 0, 0 },
    {"TOPLEFT", 0, 0 },
  },
  alpha = 1,
}

--count
actionButtonConfig.count = {
  font = { STANDARD_TEXT_FONT, 11, "OUTLINE"},
  points = {
    {"BOTTOMRIGHT", 0, 0 },
  },
}

--rButtonTemplate:StyleAllActionButtons
rButtonTemplate:StyleAllActionButtons(actionButtonConfig)
--style rActionBar vehicle exit button
rButtonTemplate:StyleActionButton(_G["rActionBarVehicleExitButton"],actionButtonConfig)

-----------------------------
-- itemButtonConfig
-----------------------------

local itemButtonConfig = {}

itemButtonConfig.backdrop = copyTable(actionButtonConfig.backdrop)
itemButtonConfig.icon = copyTable(actionButtonConfig.icon)
itemButtonConfig.count = copyTable(actionButtonConfig.count)
itemButtonConfig.stock = copyTable(actionButtonConfig.name)
itemButtonConfig.stock.alpha = 1
itemButtonConfig.border = copyTable(actionButtonConfig.border)
itemButtonConfig.normalTexture = copyTable(actionButtonConfig.normalTexture)

--rButtonTemplate:StyleItemButton
local itemButtons = { MainMenuBarBackpackButton, CharacterBag0Slot, CharacterBag1Slot, CharacterBag2Slot, CharacterBag3Slot }
for i, button in next, itemButtons do
  rButtonTemplate:StyleItemButton(button, itemButtonConfig)
end

-----------------------------
-- extraButtonConfig
-----------------------------

local extraButtonConfig = copyTable(actionButtonConfig)
extraButtonConfig.buttonstyle = { file = "" }

--rButtonTemplate:StyleExtraActionButton
rButtonTemplate:StyleExtraActionButton(extraButtonConfig)

-----------------------------
-- auraButtonConfig
-----------------------------

local auraButtonConfig = {}

auraButtonConfig.backdrop = copyTable(actionButtonConfig.backdrop)
auraButtonConfig.icon = copyTable(actionButtonConfig.icon)
auraButtonConfig.border = copyTable(actionButtonConfig.border)
auraButtonConfig.normalTexture = copyTable(actionButtonConfig.normalTexture)
auraButtonConfig.count = copyTable(actionButtonConfig.count)
auraButtonConfig.duration = copyTable(actionButtonConfig.hotkey)
auraButtonConfig.duration.alpha = 1
auraButtonConfig.symbol = copyTable(actionButtonConfig.name)
auraButtonConfig.symbol.alpha = 1

--rButtonTemplate:StyleBuffButtons + rButtonTemplate:StyleTempEnchants
rButtonTemplate:StyleBuffButtons(auraButtonConfig)
rButtonTemplate:StyleTempEnchants(auraButtonConfig)

-----------------------------
-- debuffButtonConfig
-----------------------------

local debuffButtonConfig = copyTable(auraButtonConfig)
--change the font sizes a bit
debuffButtonConfig.count.font = { STANDARD_TEXT_FONT, 12.5, "OUTLINE"}
debuffButtonConfig.duration.font = { STANDARD_TEXT_FONT, 12.5, "OUTLINE"}

--rButtonTemplate:StyleDebuffButtons
rButtonTemplate:StyleDebuffButtons(debuffButtonConfig)
