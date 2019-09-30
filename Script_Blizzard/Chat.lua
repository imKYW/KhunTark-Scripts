local _G = _G
local Noop = function() end

-- Template of Chat Frame
local function SkinChat(self)
    if not self then return end
    local name = self:GetName()
    --chat frame resizing
    self:SetClampRectInsets(0, 0, 0, 0)
    self:SetMaxResize(UIParent:GetWidth()/2, UIParent:GetHeight()/2)
    self:SetMinResize(100, 50)
    self:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
    self:SetShadowOffset(1, -1)
    self:SetShadowColor(0, 0, 0, 0.25)
    --chat fading
    self:SetFading(true)

    --Hide Sub Button
    local subButton = _G[name.."ButtonFrame"]
    subButton:HookScript("OnShow", subButton.Hide)
    subButton:Hide()

    --local ScrollTex = _G[name.."ThumbTexture"]
    --ScrollTex:Hide()

    --Set Edit Box
    local editBox = _G[name.."EditBox"]
    _G[name.."EditBoxLeft"]:Hide()
    _G[name.."EditBoxMid"]:Hide()
    _G[name.."EditBoxRight"]:Hide()

    editBox:ClearAllPoints()
    editBox:SetPoint("BOTTOM", _G.ChatFrame1, "TOP", 0, 22)
    editBox:SetPoint("LEFT", ChatFrame1, -5, 0)
    editBox:SetPoint("RIGHT", ChatFrame1, 6, 0)
    editBox:SetAltArrowKeyMode(false)
end

local function AddMessage(self, text, ...)
    --channel replace (Trade and such)
    text = text:gsub('|h%[(%d+)%. .-%]|h', '|h%1.|h')
    --Get URL
    text = text:gsub('([wWhH][wWtT][wWtT][%.pP]%S+[^%p%s])', '|cffffffff|Hurl:%1|h[%1]|h|r')
    return self.DefaultAddMessage(self, text, ...)
end

-- Function Mouse Scroll
local function OnMouseScroll(self, dir)
    if dir > 0 then
        if IsShiftKeyDown() then
            self:ScrollToTop()
        else
            self:ScrollUp()
        end
    else
        if IsShiftKeyDown() then
            self:ScrollToBottom()
        else
            self:ScrollDown()
        end
    end
end

--editbox font
ChatFontNormal:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
ChatFontNormal:SetShadowOffset(1, -1)
ChatFontNormal:SetShadowColor(0, 0, 0, 0.25)

--font size
CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

--tab
CHAT_TAB_HIDE_DELAY = 1
CHAT_FRAME_TAB_NORMAL_MOUSEOVER_ALPHA = 0.7
CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_SELECTED_MOUSEOVER_ALPHA = 0.7
CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
CHAT_FRAME_TAB_ALERTING_MOUSEOVER_ALPHA = 0.7
CHAT_FRAME_TAB_ALERTING_NOMOUSE_ALPHA = 0.7

--channels
CHAT_WHISPER_GET              = "From %s "
CHAT_WHISPER_INFORM_GET       = "To %s "
CHAT_BN_WHISPER_GET           = "From %s "
CHAT_BN_WHISPER_INFORM_GET    = "To %s "
CHAT_YELL_GET                 = "%s "
CHAT_SAY_GET                  = "%s "
CHAT_BATTLEGROUND_GET         = "|Hchannel:Battleground|hBG.|h %s: "
CHAT_BATTLEGROUND_LEADER_GET  = "|Hchannel:Battleground|hBGL.|h %s: "
CHAT_GUILD_GET                = "|Hchannel:Guild|hG.|h %s: "
CHAT_OFFICER_GET              = "|Hchannel:Officer|hGO.|h %s: "
CHAT_PARTY_GET                = "|Hchannel:Party|hP.|h %s: "
CHAT_PARTY_LEADER_GET         = "|Hchannel:Party|hPL.|h %s: "
CHAT_PARTY_GUIDE_GET          = "|Hchannel:Party|hPG.|h %s: "
CHAT_RAID_GET                 = "|Hchannel:Raid|hR.|h %s: "
CHAT_RAID_LEADER_GET          = "|Hchannel:Raid|hRL.|h %s: "
CHAT_RAID_WARNING_GET         = "|Hchannel:RaidWarning|hRW.|h %s: "
CHAT_INSTANCE_CHAT_GET        = "|Hchannel:Battleground|hI.|h %s: "
CHAT_INSTANCE_CHAT_LEADER_GET = "|Hchannel:Battleground|hIL.|h %s: "
--CHAT_MONSTER_PARTY_GET       = CHAT_PARTY_GET
--CHAT_MONSTER_SAY_GET         = CHAT_SAY_GET
--CHAT_MONSTER_WHISPER_GET     = CHAT_WHISPER_GET
--CHAT_MONSTER_YELL_GET        = CHAT_YELL_GET
CHAT_FLAG_AFK = "<AFK> "
CHAT_FLAG_DND = "<DND> "
CHAT_FLAG_GM = "<[GM]> "

--remove the annoying guild loot messages by replacing them with the original ones
YOU_LOOT_MONEY_GUILD = YOU_LOOT_MONEY
LOOT_MONEY_SPLIT_GUILD = LOOT_MONEY_SPLIT

-- Set Function Button
ChatFrameMenuButton:HookScript("OnShow", ChatFrameMenuButton.Hide)
ChatFrameMenuButton:Hide()
ChatFrameChannelButton:HookScript("OnShow", ChatFrameChannelButton.Hide)
ChatFrameChannelButton:Hide()
--ChatFrameToggleVoiceDeafenButton:HookScript("OnShow", ChatFrameToggleVoiceDeafenButton.Hide)
--ChatFrameToggleVoiceDeafenButton:Hide()
--ChatFrameToggleVoiceMuteButton:HookScript("OnShow", ChatFrameToggleVoiceMuteButton.Hide)
--ChatFrameToggleVoiceMuteButton:Hide()
local SocialBTN = _G.QuickJoinToastButton or _G.FriendsMicroButton
SocialBTN:ClearAllPoints()
SocialBTN:SetPoint("TOPLEFT", _G.ChatFrame1, "TOPLEFT", 0, -2)
SocialBTN.ClearAllPoints = Noop
SocialBTN.SetPoint = Noop

--QuickJoinToastButton:EnableMouse(false)


-- Set Main Chat Frame
for i = 1, NUM_CHAT_WINDOWS do
    local chatFrame = _G["ChatFrame"..i]
    SkinChat(chatFrame)
    if (i ~= 2) then
        chatFrame.DefaultAddMessage = chatFrame.AddMessage
        chatFrame.AddMessage = AddMessage
    end
end

FloatingChatFrame_OnMouseScroll = OnMouseScroll
