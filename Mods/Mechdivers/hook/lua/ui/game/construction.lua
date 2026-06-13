function OnClickHandler(button, modifiers)
    PlaySound(Sound({Cue = "UI_MFD_Click", Bank = "Interface"}))
    local item = button.Data
	
	local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

	if version < 3652 then
    if item.type == 'item' then
        ClearBuildTemplates()
        local blueprint = __blueprints[item.id]
        local count = 1
        local performUpgrade = false
        local buildCmd = "build"

        if modifiers.Ctrl or modifiers.Shift then
            count = 5
        end

        if modifiers.Left then
            # see if we are issuing an upgrade order
            if blueprint.General.UpgradesFrom == 'none' then
                performUpgrade = false
            else
                for i,v in sortedOptions.selection do
                    if v then   # it's possible that your unit will have died by the time this gets to it
                        local unitBp = v:GetBlueprint()
                        if blueprint.General.UpgradesFrom == unitBp.BlueprintId then
                            performUpgrade = true
                        elseif blueprint.General.UpgradesFrom == unitBp.General.UpgradesTo then
                            performUpgrade = true
                        elseif blueprint.General.UpgradesFromBase != "none" then
                            # try testing against the base
                            if blueprint.General.UpgradesFromBase == unitBp.BlueprintId then
                                performUpgrade = true
                            elseif blueprint.General.UpgradesFromBase == unitBp.General.UpgradesFromBase then
                                performUpgrade = true
                            end
                        end                        
                    end
                end
            end

            if performUpgrade then
                IssueBlueprintCommand("UNITCOMMAND_Upgrade", item.id, 1, false)
            else
                if blueprint.Physics.MotionType == 'RULEUMT_None' or EntityCategoryContains(categories.NEEDMOBILEBUILD, item.id) then
                    # stationary means it needs to be placed, so go in to build mobile mode
					import('/lua/ui/game/commandmode.lua').StartCommandMode(buildCmd, {name=item.id})
                else
                    # if the item to build can move, it must be built by a factory
                    #TODO -what about mobile factories?
                    IssueBlueprintCommand("UNITCOMMAND_BuildFactory", item.id, count)
                end
            end
        else
            local unitIndex = false
            for index, unitStack in currentCommandQueue do
                if unitStack.id == item.id then
                    unitIndex = index
                end
            end
            if unitIndex != false then
                DecreaseBuildCountInQueue(unitIndex, count)
            end
        end
    elseif item.type == 'unitstack' then
        if modifiers.Left then
            SelectUnits(item.units)
        elseif modifiers.Right then
            local selection = {}
            for _, unit in sortedOptions.selection do
                local found = false
                for _, checkUnit in item.units do
                    if checkUnit == unit then
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(selection, unit)
                end
            end
            SelectUnits(selection)
        end
    elseif item.type == 'attachedunit' then
        if modifiers.Left then
            -- Toggling selection of the entity
            button:OnAltToggle()
    
            -- Add or Remove the entity to the session selection
            if button.mAltToggledFlag then
                AddToSessionExtraSelectList(item.unit)
            else
                RemoveFromSessionExtraSelectList(item.unit)
            end
        end
    elseif item.type == 'templates' then
        ClearBuildTemplates()
        if modifiers.Right then
            if button.OptionMenu then
                button.OptionMenu:Destroy()
                button.OptionMenu = nil
            else
                button.OptionMenu = CreateTemplateOptionsMenu(button)
            end
            for _, otherBtn in controls.choices.Items do
                if button != otherBtn and otherBtn.OptionMenu then
                    otherBtn.OptionMenu:Destroy()
                    otherBtn.OptionMenu = false
                end
            end
        else
            import('/lua/ui/game/commandmode.lua').StartCommandMode('build', {name=item.template.templateData[3][1]})
            SetActiveBuildTemplate(item.template.templateData)
        end
    elseif item.type == 'enhancement' then
        local existingEnhancements = EnhanceCommon.GetEnhancements(sortedOptions.selection[1]:GetEntityId())
        if existingEnhancements[item.enhTable.Slot] and existingEnhancements[item.enhTable.Slot] != item.enhTable.Prerequisite then
            if existingEnhancements[item.enhTable.Slot] != item.id then
			local selection = GetSelectedUnits()
			if EntityCategoryContains(categories.NOENHANCEMENTCONFIMATION, selection[1]) then
			            ForkThread(function()
                            local orderData = {
                                # UserVerifyScript='/lua/ui/game/EnhanceCommand.lua',
                                TaskName = "EnhanceTask",
                                Enhancement = existingEnhancements[item.enhTable.Slot]..'Remove',
                            }
                            IssueCommand("UNITCOMMAND_Script", orderData, true)
                            WaitSeconds(.5)
                            orderData = {
                                # UserVerifyScript='/lua/ui/game/EnhanceCommand.lua',
                                TaskName = "EnhanceTask",
                                Enhancement = item.id,
                            }
                            IssueCommand("UNITCOMMAND_Script", orderData, true)
                        end)
			else
            UIUtil.QuickDialog(GetFrame(0), "<LOC enhancedlg_0000>Choosing this enhancement will destroy the existing enhancement in this slot.  Are you sure?", 
                "<LOC _Yes>", function()
                        ForkThread(function()
                            local orderData = {
                                # UserVerifyScript='/lua/ui/game/EnhanceCommand.lua',
                                TaskName = "EnhanceTask",
                                Enhancement = existingEnhancements[item.enhTable.Slot]..'Remove',
                            }
                            IssueCommand("UNITCOMMAND_Script", orderData, true)
                            WaitSeconds(.5)
                            orderData = {
                                # UserVerifyScript='/lua/ui/game/EnhanceCommand.lua',
                                TaskName = "EnhanceTask",
                                Enhancement = item.id,
                            }
                            IssueCommand("UNITCOMMAND_Script", orderData, true)
                        end)
                    end,
                "<LOC _No>", nil,
                nil, nil,
                true,  {worldCover = true, enterButton = 1, escapeButton = 2})
            end
			end
        else
            local orderData = {
                # UserVerifyScript='/lua/ui/game/EnhanceCommand.lua',
                TaskName = "EnhanceTask",
                Enhancement = item.id,
            }
            IssueCommand("UNITCOMMAND_Script", orderData, true)
        end
    elseif item.type == 'queuestack' then
        local count = 1
        if modifiers.Shift or modifiers.Ctrl then
            count = 5
        end
        if modifiers.Left then
            IncreaseBuildCountInQueue(item.position, count)
        elseif modifiers.Right then
            DecreaseBuildCountInQueue(item.position, count)
        end
    end
	
	else
	    if options.gui_improved_unit_deselection ~= 0 then
        -- Improved unit deselection -ghaleon
        if item.type == 'unitstack' then
            if modifiers.Right then
                if modifiers.Shift or modifiers.Ctrl or (modifiers.Shift and modifiers.Ctrl) then -- we have one of our modifiers
                    local selectionx = {}
                    local countx = 0
                    if modifiers.Shift then countx = 1 end
                    if modifiers.Ctrl then countx = 5 end
                    if modifiers.Shift and modifiers.Ctrl then countx = 10 end
                    for _, unit in sortedOptions.selection do
                        local foundx = false
                        for _, checkUnit in item.units do
                            if checkUnit == unit and countx > 0 then
                                foundx = true
                                countx = countx - 1
                                break
                            end
                        end
                        if not foundx then
                            table.insert(selectionx, unit)
                        end
                    end
                    SelectUnits(selectionx)
                else -- Default right-click behavior
                    local selection = {}
                    for _, unit in sortedOptions.selection do
                        local found = false
                        for _, checkUnit in item.units do
                            if checkUnit == unit then
                                found = true
                                break
                            end
                        end
                        if not found then
                            table.insert(selection, unit)
                        end
                    end
                    SelectUnits(selection)
                end

                return
            end
        end
    end

    if item.type == "templates" and allFactories then

        if modifiers.Right then
            -- Options menu
            if button.OptionMenu then
                button.OptionMenu:Destroy()
                button.OptionMenu = nil
            else
                button.OptionMenu = CreateFacTemplateOptionsMenu(button)
            end
            for _, otherBtn in controls.choices.Items do
                if button ~= otherBtn and otherBtn.OptionMenu then
                    otherBtn.OptionMenu:Destroy()
                    otherBtn.OptionMenu = false
                end
            end
        else
            -- Add template to build queue
            for _, data in ipairs(item.template.templateData) do
                local blueprint = __blueprints[data.id]
                if blueprint.General.UpgradesFrom == 'none' then
                    IssueBlueprintCommand("UNITCOMMAND_BuildFactory", data.id, data.count)
                else
                    IssueBlueprintCommand("UNITCOMMAND_Upgrade", data.id, 1, false)
                end
            end
        end
    elseif item.type == 'item' then
        ClearBuildTemplates()
        local itembp = __blueprints[item.id]
        local count = 1
        local performUpgrade = false
        local buildCmd = "build"

        if modifiers.Ctrl or modifiers.Shift then
            count = 5
        end

        if modifiers.Left then
            -- See if we are issuing an upgrade order
            if itembp.General.UpgradesFrom == 'none' then
                performUpgrade = false
            else
                for i, v in sortedOptions.selection do
                    if v then -- Its possible that your unit will have died by the time this gets to it
                        local unitBp = v:GetBlueprint()
                        if itembp.General.UpgradesFrom == unitBp.BlueprintId then
                            performUpgrade = true
                        elseif itembp.General.UpgradesFrom == unitBp.General.UpgradesTo then
                            performUpgrade = true
                        elseif itembp.General.UpgradesFromBase ~= "none" then
                            -- Try testing against the base
                            if itembp.General.UpgradesFromBase == unitBp.BlueprintId then
                                performUpgrade = true
                            elseif itembp.General.UpgradesFromBase == unitBp.General.UpgradesFromBase then
                                performUpgrade = true
                            end
                        end
                    end
                end
            end

            -- Hold alt to reset queue, same as hotbuild
            if modifiers.Alt then
                ResetOrderQueues(sortedOptions.selection)
            end

            if performUpgrade then
                IssueUpgradeOrders(sortedOptions.selection, item.id)
            else
                if itembp.Physics.MotionType == 'RULEUMT_None' or EntityCategoryContains(categories.NEEDMOBILEBUILD, item.id) then
                    -- Stationary means it needs to be placed, so go in to build mobile mode
                    import("/lua/ui/game/commandmode.lua").StartCommandMode(buildCmd, {name = item.id})
                else
                    -- If the item to build can move, it must be built by a factory
                    -- Mobile factories: we check for platforms (the attached units can be given orders as normal)
                    -- If we've got platforms, we take our selected units (minus the platforms), then add the
                    -- external factories to that list, then give orders with 
                    -- IssueBlueprintCommandToUnits (which can give orders to an arbitrary list of units)
                    -- instead of IssueBlueprintCommand (which gives orders to the current selection)
                    local selection = GetSelectedUnits()
                    local exFacs = EntityCategoryFilterDown(categories.EXTERNALFACTORY, selection)
                    if not table.empty(exFacs) then
                        local exFacUnits = EntityCategoryFilterOut(categories.EXTERNALFACTORY, selection)
                        for _, exFac in exFacs do
                            table.insert(exFacUnits, exFac:GetCreator())
                        end
                        -- in case we've somehow selected both the platform and the factory, only put the fac in once
                        exFacUnits = table.unique(exFacUnits)
                        IssueBlueprintCommandToUnits(exFacUnits, "UNITCOMMAND_BuildFactory", item.id, count)
                    else
                        IssueBlueprintCommand("UNITCOMMAND_BuildFactory", item.id, count)
                    end
                end
            end
        else
            local unitIndex = false
            for index, unitStack in currentCommandQueue or {} do
                if unitStack.id == item.id then
                    unitIndex = index
                end
            end
            if unitIndex ~= false then
                DecreaseBuildCountInQueue(unitIndex, count)
            end
        end
        RefreshUI()
    elseif item.type == 'unitstack' then
        if modifiers.Left then
            SelectUnits(item.units)
        elseif modifiers.Right then
            local selection = {}
            for _, unit in sortedOptions.selection do
                local found = false
                for _, checkUnit in item.units do
                    if checkUnit == unit then
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(selection, unit)
                end
            end
            SelectUnits(selection)
        end
    elseif item.type == 'attachedunit' then
        if modifiers.Left then
            -- Toggling selection of the entity
            button:ToggleOverride()

            -- Add or Remove the entity to the session selection
            if button:GetOverrideEnabled() then
                AddToSessionExtraSelectList(item.unit)
            else
                RemoveFromSessionExtraSelectList(item.unit)
            end
        end
    elseif item.type == 'templates' then
        ClearBuildTemplates()
        if modifiers.Right then
            if button.OptionMenu then
                button.OptionMenu:Destroy()
                button.OptionMenu = nil
            else
                button.OptionMenu = CreateTemplateOptionsMenu(button)
            end
            for _, otherBtn in controls.choices.Items do
                if button ~= otherBtn and otherBtn.OptionMenu then
                    otherBtn.OptionMenu:Destroy()
                    otherBtn.OptionMenu = false
                end
            end
        else
            import("/lua/ui/game/commandmode.lua").StartCommandMode('build', {name = item.template.templateData[3][1]})
            SetActiveBuildTemplate(item.template.templateData)
        end

    elseif item.type == 'enhancement' and button.Data.TooltipOnly == false then
        local doOrder = true
        local clean = not modifiers.Shift
        local enhancementQueue = getEnhancementQueue()

        local enhId = item.id
        local enh = item.enhTable
        local slot = enh.Slot
        local prereqs = GetPrerequisites(enh)
        for _, unit in sortedOptions.selection do
            local unitId = unit:GetEntityId()
            local existingEnhancements = EnhanceCommon.GetEnhancements(unitId)
            local existingEnh = existingEnhancements[slot]
            if not existingEnh or table.find(prereqs, existingEnh) then
                continue
            end

            local alreadyWarned = false
            for _, enhancement in enhancementQueue[unitId] or {} do
                if enhancement.ID == existingEnh .. 'Remove' then
                    alreadyWarned = true
                    break
                end
            end
            if alreadyWarned then
                continue
            end

            if existingEnh ~= enhId then
			local selection = GetSelectedUnits()
			if EntityCategoryContains(categories.NOENHANCEMENTCONFIMATION, selection[1]) then
			safecall("OrderEnhancement", OrderEnhancement, item, clean, true)
			else
                UIUtil.QuickDialog(GetFrame(0), "<LOC enhancedlg_0000>Choosing this enhancement will destroy the existing enhancement in this slot.  Are you sure?",
                    "<LOC _Yes>", function()
                        safecall("OrderEnhancement", OrderEnhancement, item, clean, true)
                    end,
                    "<LOC _No>", function()
                        safecall("OrderEnhancement", OrderEnhancement, item, clean, false)
                    end,
                    nil, nil,
                    true,  {worldCover = true, enterButton = 1, escapeButton = 2}
                )
                doOrder = false
                break
			end	
            end
        end

        if doOrder then
            OrderEnhancement(item, clean, false)
        end
    elseif item.type == 'queuestack' then
        local count = 1
        if modifiers.Shift or modifiers.Ctrl then
            count = 5
        end

        if modifiers.Left then
            IncreaseBuildCountInQueue(item.position, count)
            
        elseif modifiers.Right then
            DecreaseBuildCountInQueue(item.position, count)
        end
        RefreshUI()
    end
	end
end



function GetBackgroundTextures(unitID)
    local bp = __blueprints[unitID]
    local validIcons = {land = true, air = true, sea = true, amph = true, orbit = true, none = true}
    local icon = "land"
	local Modpath = "/mods/Mechdivers"
    if unitID and unitID ~= 'default' then
        if not validIcons[bp.General.Icon] then
            if bp.General.Icon then WARN(debug.traceback(nil, "Invalid icon" .. bp.General.Icon .. " for unit " .. tostring(unitID))) end
            bp.General.Icon = "land"
		else
			icon = bp.General.Icon
		end
    end
	return UIUtil.UIFile(Modpath .. '/icons/units/backgrounds/' .. icon .. '_up.dds'),
			UIUtil.UIFile(Modpath .. '/icons/units/backgrounds/' .. icon .. '_down.dds'),
			UIUtil.UIFile(Modpath .. '/icons/units/backgrounds/' .. icon .. '_over.dds'),
			UIUtil.UIFile(Modpath .. '/icons/units/backgrounds/' .. icon .. '_up.dds')
end

function GetEnhancementPrefix(unitID, iconID)
LOG('unitID: ', unitID)
    local factionPrefix = ''
    if string.sub(unitID, 6, 6) == 'a' or string.sub(unitID, 2, 2) == 'a' then
        factionPrefix = 'aeon-enhancements/' 
    elseif string.sub(unitID, 6, 6) == 't' or string.sub(unitID, 2, 2) == 'e' then
        factionPrefix = 'uef-enhancements/'
    elseif string.sub(unitID, 6, 6) == 'c' or string.sub(unitID, 2, 2) == 'r' then
        factionPrefix = 'cybran-enhancements/'
    elseif string.sub(unitID, 6, 6) == 's' or string.sub(unitID, 2, 2) == 's' then
        factionPrefix = 'seraphim-enhancements/'
    end
    local prefix = '/game/' .. factionPrefix .. iconID
	LOG('prefix: ', prefix)
    --# If it is a stock icon...
    if not DiskGetFileInfo('/textures/ui/common'..prefix..'_btn_up.dds') then
        --# return a path to shared icons
        local altPathEX =  '/mods/Mechdivers/icons/'
        prefix = altPathEX .. factionPrefix .. iconID
    end
    return prefix
end

function GetEnhancementTextures(unitID, iconID)
    local factionPrefix = ''
    if string.sub(unitID, 6, 6) == 'a' or string.sub(unitID, 2, 2) == 'a' then
        factionPrefix = 'aeon-enhancements/' 
    elseif string.sub(unitID, 6, 6) == 't' or string.sub(unitID, 2, 2) == 'e' then
        factionPrefix = 'uef-enhancements/'
    elseif string.sub(unitID, 6, 6) == 'c' or string.sub(unitID, 2, 2) == 'r' then
        factionPrefix = 'cybran-enhancements/'
    elseif string.sub(unitID, 6, 6) == 's' or string.sub(unitID, 2, 2) == 's' then
        factionPrefix = 'seraphim-enhancements/'
    end
    
    local prefix = '/game/' .. factionPrefix .. iconID
    --# If it is a stock icon...
    if DiskGetFileInfo('/textures/ui/common'..prefix..'_btn_up.dds') then
        return UIUtil.UIFile(prefix..'_btn_up.dds'),
            UIUtil.UIFile(prefix..'_btn_down.dds'),
            UIUtil.UIFile(prefix..'_btn_over.dds'),
            UIUtil.UIFile(prefix..'_btn_up.dds'),
            UIUtil.UIFile(prefix..'_btn_sel.dds')
    else
        --# return a path to shared icons
        local altPathEX =  '/mods/Mechdivers/icons/'
        prefix = altPathEX .. factionPrefix .. iconID
        --# Bypass UIFile as these icons 
        --# are not skinabble!
        return prefix..'_btn_up.dds',
            prefix..'_btn_down.dds',
            prefix..'_btn_over.dds',
            prefix..'_btn_up.dds',
            prefix..'_btn_sel.dds'
    end
end