local function KTS_PaperDoll()
    local statformat = "%.2f%%"
    local multiplier = 100

    function PaperDollFrame_SetItemLevel(statFrame, unit)
        if ( unit ~= "player" ) then
            statFrame:Hide();
            return;
        end

        local avgItemLevel, avgItemLevelEquipped, avgItemLevelPvP = GetAverageItemLevel();
        local minItemLevel = C_PaperDollInfo.GetMinItemLevel();

        local displayItemLevel = math.max(minItemLevel or 0, avgItemLevelEquipped);

        --displayItemLevel = floor(displayItemLevel);
        --avgItemLevel = floor(avgItemLevel);

        PaperDollFrame_SetLabelAndText(statFrame, STAT_AVERAGE_ITEM_LEVEL, format("%.1f", displayItemLevel).." / "..format("%.1f", avgItemLevel), false, displayItemLevel);
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_AVERAGE_ITEM_LEVEL).." "..avgItemLevel;
        if ( displayItemLevel ~= avgItemLevel ) then
            statFrame.tooltip = statFrame.tooltip .. "  " .. format(STAT_AVERAGE_ITEM_LEVEL_EQUIPPED, avgItemLevelEquipped);
        end
        statFrame.tooltip = statFrame.tooltip .. FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = STAT_AVERAGE_ITEM_LEVEL_TOOLTIP;

        if ( avgItemLevel ~= avgItemLevelPvP ) then
            statFrame.tooltip2 = statFrame.tooltip2.."\n\n"..STAT_AVERAGE_PVP_ITEM_LEVEL:format(avgItemLevelPvP);
        end
    end

    function PaperDollFrame_SetCritChance(statFrame, unit)
        if ( unit ~= "player" ) then
            statFrame:Hide();
            return;
        end

        local rating;
        local spellCrit, rangedCrit, meleeCrit;
        local critChance;

        -- Start at 2 to skip physical damage
        local holySchool = 2;
        local minCrit = GetSpellCritChance(holySchool);
        statFrame.spellCrit = {};
        statFrame.spellCrit[holySchool] = minCrit;
        local spellCrit;
        for i=(holySchool+1), MAX_SPELL_SCHOOLS do
            spellCrit = GetSpellCritChance(i);
            minCrit = min(minCrit, spellCrit);
            statFrame.spellCrit[i] = spellCrit;
        end
        spellCrit = minCrit
        rangedCrit = GetRangedCritChance();
        meleeCrit = GetCritChance();

        if (spellCrit >= rangedCrit and spellCrit >= meleeCrit) then
            critChance = spellCrit;
            rating = CR_CRIT_SPELL;
        elseif (rangedCrit >= meleeCrit) then
            critChance = rangedCrit;
            rating = CR_CRIT_RANGED;
        else
            critChance = meleeCrit;
            rating = CR_CRIT_MELEE;
        end

        local extraCritChance = GetCombatRatingBonus(rating);
        local extraCritRating = GetCombatRating(rating);

        PaperDollFrame_SetLabelAndText(statFrame, STAT_CRITICAL_STRIKE.." ["..extraCritRating.."]", format("%.2f%%", critChance), false, critChance);

        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_CRITICAL_STRIKE)..FONT_COLOR_CODE_CLOSE;
        if (GetCritChanceProvidesParryEffect()) then
            statFrame.tooltip2 = format(CR_CRIT_PARRY_RATING_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance, GetCombatRatingBonusForCombatRatingValue(CR_PARRY, extraCritRating));
        else
            statFrame.tooltip2 = format(CR_CRIT_TOOLTIP, BreakUpLargeNumbers(extraCritRating), extraCritChance);
        end
        statFrame:Show();
    end

    function PaperDollFrame_SetHaste(statFrame, unit)
        if ( unit ~= "player" ) then
            statFrame:Hide();
            return;
        end

        local haste = GetHaste();
        local rating = CR_HASTE_MELEE;

        local hasteFormatString;
        if (haste < 0 and not GetPVPGearStatRules()) then
            hasteFormatString = RED_FONT_COLOR_CODE.."%s"..FONT_COLOR_CODE_CLOSE;
        else
            hasteFormatString = "%s";
        end

        local extraHasteChance = GetCombatRatingBonus(rating);
        local extraHasteRating = GetCombatRating(rating);

        PaperDollFrame_SetLabelAndText(statFrame, STAT_HASTE.." ["..extraHasteRating.."]", format(hasteFormatString, format("%.2f%%", haste)), false, haste);
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_HASTE)..FONT_COLOR_CODE_CLOSE;

        local _, class = UnitClass(unit);
        statFrame.tooltip2 = _G["STAT_HASTE_"..class.."_TOOLTIP"];
        if (not statFrame.tooltip2) then
            statFrame.tooltip2 = STAT_HASTE_TOOLTIP;
        end
        statFrame.tooltip2 = statFrame.tooltip2 .. format(STAT_HASTE_BASE_TOOLTIP, BreakUpLargeNumbers(extraHasteRating), extraHasteChance);
        statFrame:Show();
    end

    function PaperDollFrame_SetMastery(statFrame, unit)
        if ( unit ~= "player" ) then
            statFrame:Hide();
            return;
        end

        local mastery = GetMasteryEffect();
        local extraMasteryRating = GetCombatRating(CR_MASTERY);

        PaperDollFrame_SetLabelAndText(statFrame, STAT_MASTERY.." ["..extraMasteryRating.."]", format("%.2f%%", mastery), false, mastery);
        statFrame.onEnterFunc = Mastery_OnEnter;
        statFrame:Show();
    end

    function PaperDollFrame_SetVersatility(statFrame, unit)
        if ( unit ~= "player" ) then
            statFrame:Hide();
            return;
        end

        local versatility = GetCombatRating(CR_VERSATILITY_DAMAGE_DONE);
        local versatilityDamageBonus = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_DONE);
        local versatilityDamageTakenReduction = GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_TAKEN) + GetVersatilityBonus(CR_VERSATILITY_DAMAGE_TAKEN);

        PaperDollFrame_SetLabelAndText(statFrame, STAT_VERSATILITY.." ["..versatility.."]", format("%.2f%%", versatilityDamageBonus).." / "..format("%.2f%%", versatilityDamageTakenReduction), false, versatilityDamageBonus);
        statFrame.tooltip = HIGHLIGHT_FONT_COLOR_CODE..format(PAPERDOLLFRAME_TOOLTIP_FORMAT, STAT_VERSATILITY)..FONT_COLOR_CODE_CLOSE;
        statFrame.tooltip2 = format(CR_VERSATILITY_TOOLTIP, versatilityDamageBonus, versatilityDamageTakenReduction, BreakUpLargeNumbers(versatility), versatilityDamageBonus, versatilityDamageTakenReduction);
        statFrame:Show();
    end

end

local function ktsPaperDoll_OnEvent(self, event)
    if event == "PLAYER_LOGIN" then
        KTS_PaperDoll()
    end
end

-- Event Handler
local ktsPaperdoll_Handler = _G.CreateFrame("Frame")
ktsPaperdoll_Handler:RegisterEvent("PLAYER_LOGIN")
ktsPaperdoll_Handler:SetScript("OnEvent", ktsPaperDoll_OnEvent)
