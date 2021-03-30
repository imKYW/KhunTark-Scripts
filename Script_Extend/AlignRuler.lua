local alignRuler

SlashCmdList["AR"] = function()
	if alignRuler then
		alignRuler:Hide()
		alignRuler = nil
	else
		alignRuler = CreateFrame('Frame', nil, UIParent)
		alignRuler:SetAllPoints(UIParent)
		local w = GetScreenWidth() / 64
		local h = GetScreenHeight() / 36
		for i = 0, 64 do
			local scaler = alignRuler:CreateTexture(nil, 'BACKGROUND')
			if i == 32 then
				scaler:SetColorTexture(1, 1, 0, 0.5)
			else
				scaler:SetColorTexture(1, 1, 1, 0.15)
			end
			scaler:SetPoint('TOPLEFT', alignRuler, 'TOPLEFT', i * w - 1, 0)
			scaler:SetPoint('BOTTOMRIGHT', alignRuler, 'BOTTOMLEFT', i * w + 1, 0)
		end
		for i = 0, 36 do
			local scaler = alignRuler:CreateTexture(nil, 'BACKGROUND')
			if i == 18 then
				scaler:SetColorTexture(1, 1, 0, 0.5)
			else
				scaler:SetColorTexture(1, 1, 1, 0.15)
			end
			scaler:SetPoint('TOPLEFT', alignRuler, 'TOPLEFT', 0, -i * h + 1)
			scaler:SetPoint('BOTTOMRIGHT', alignRuler, 'TOPRIGHT', 0, -i * h - 1)
		end
	end
end
SLASH_AR1 = "/align"
