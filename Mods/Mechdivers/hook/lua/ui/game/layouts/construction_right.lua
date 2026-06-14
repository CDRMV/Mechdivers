function LayoutTabs(controls)

local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then 

    local prevControl = false
    
    local tabFiles = {
        construction = '/game/construct-tab_btn/top_tab_btn_',
        selection = '/game/construct-tab_btn/mid_tab_btn_',
        enhancement = '/game/construct-tab_btn/bot_tab_btn_',
    }
	
	local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK-Units" then return mod.location end end end
	local CSKUnitsPath = GetCSKUnitsPath()
	
	local techFiles = {}
	
	if CSKUnitsPath then
	local factions = import('/lua/factions.lua').Factions
	local focusarmy = GetFocusArmy()
    local armyInfo = GetArmiesTable()
	local currentFaction = ''
    if focusarmy >= 1 then
	currentFaction = factions[armyInfo.armiesTable[focusarmy].faction+1].Key
	LOG('currentFaction: ', currentFaction)
	end
	
	    techFiles = {
        t1 = '/game/construct-tech_btn/t1_btn_',
        t2 = '/game/construct-tech_btn/t2_btn_',
        t3 = '/game/construct-tech_btn/t3_btn_',
		t35 = '/mods/Commander Survival Kit Units/icons/Techlevels/' .. currentFaction .. '/game/construct-tech_btn/t35_btn_',
        t4 = '/game/construct-tech_btn/t4_btn_',
		t5 = '/mods/Commander Survival Kit Units/icons/Techlevels/' .. currentFaction .. '/game/construct-tech_btn/t5_btn_',
		t6 = '/mods/Commander Survival Kit Units/icons/Techlevels/' .. currentFaction .. '/game/construct-tech_btn/t6_btn_',
        templates = '/game/construct-tech_btn/template_btn_',
        LCH = '/game/construct-tech_btn/left_upgrade_btn_',
        RCH = '/game/construct-tech_btn/r_upgrade_btn_',
        Back = '/game/construct-tech_btn/m_upgrade_btn_',
		Skin = '/game/construct-tech_btn/m_upgrade_btn_',
    }
	else
	
    techFiles = {
        t1 = '/game/construct-tech_btn/t1_btn_',
        t2 = '/game/construct-tech_btn/t2_btn_',
        t3 = '/game/construct-tech_btn/t3_btn_',
        t4 = '/game/construct-tech_btn/t4_btn_',
        templates = '/game/construct-tech_btn/template_btn_',
        LCH = '/game/construct-tech_btn/left_upgrade_btn_',
        RCH = '/game/construct-tech_btn/r_upgrade_btn_',
        Back = '/game/construct-tech_btn/m_upgrade_btn_',
		Skin = '/game/construct-tech_btn/m_upgrade_btn_',
    }
	
	end
    
    local function GetTabTextures(id)
        if tabFiles[id] then
            local pre = tabFiles[id]
            return UIUtil.UIFile(pre..'up_bmp.dds'), UIUtil.UIFile(pre..'sel_bmp.dds'),
                UIUtil.UIFile(pre..'over_bmp.dds'), UIUtil.UIFile(pre..'down_bmp.dds'), 
                UIUtil.UIFile(pre..'dis_bmp.dds'), UIUtil.UIFile(pre..'dis_bmp.dds')
        elseif techFiles[id] then
            local pre = techFiles[id]
            return UIUtil.UIFile(pre..'up.dds'), UIUtil.UIFile(pre..'selected.dds'),
                UIUtil.UIFile(pre..'over.dds'), UIUtil.UIFile(pre..'down.dds'), 
                UIUtil.UIFile(pre..'dis.dds'), UIUtil.UIFile(pre..'dis.dds')
        end
    end
    
    local function SetupTab(control)
        control:SetNewTextures(GetTabTextures(control.ID))
        control:UseAlphaHitTest(false)
               
        control.OnDisable = function(self)
            self.disabledGroup:Enable()
            Checkbox.OnDisable(self)
        end
        
        control.disabledGroup.Height:Set(25)
        control.disabledGroup.Width:Set(40)
        LayoutHelpers.AtCenterIn(control.disabledGroup, control)
        
        control.OnEnable = function(self)
            self.disabledGroup:Disable()
            Checkbox.OnEnable(self)
        end
    end
    
    if table.getsize(controls.tabs) > 0 then
        for id, control in controls.tabs do
            SetupTab(control)
             
            if not prevControl then
                LayoutHelpers.AtLeftTopIn(control, controls.minBG, 82, 0)
            else
                local offset = 0
                LayoutHelpers.RightOf(control, prevControl, offset)
            end
            
            prevControl = control
        end
        controls.midBG1:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_bmp_m1.dds'))
        controls.midBG1.Right:Set(prevControl.Right)
        controls.midBG2:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_bmp_m2.dds'))
        controls.midBG3:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_bmp_m3.dds'))
        controls.minBG:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_bmp_l.dds'))
        LayoutHelpers.AtLeftIn(controls.minBG, controls.constructionGroup, 67)
        LayoutHelpers.AtBottomIn(controls.maxBG, controls.minBG, 1)
        LayoutHelpers.AtBottomIn(controls.minBG, controls.constructionGroup, 4)
    else
        controls.midBG1:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_s_bmp_m.dds'))
        controls.midBG2:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_s_bmp_m.dds'))
        controls.midBG3:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_s_bmp_m.dds'))
        controls.minBG:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_s_bmp_l.dds'))
        LayoutHelpers.AtLeftIn(controls.minBG, controls.constructionGroup, 69)
        LayoutHelpers.AtBottomIn(controls.maxBG, controls.minBG, 0)
        LayoutHelpers.AtBottomIn(controls.minBG, controls.constructionGroup, 5)
    end
    
    SetupTab(controls.constructionTab)
    LayoutHelpers.AtLeftTopIn(controls.constructionTab, controls.constructionGroup, 0, 14)
    SetupTab(controls.selectionTab)
    LayoutHelpers.Below(controls.selectionTab, controls.constructionTab, -16)
    SetupTab(controls.enhancementTab)
    LayoutHelpers.Below(controls.enhancementTab, controls.selectionTab, -16)
    
	
else
    local prevControl = false

    local tabFiles = {
        construction = '/game/construct-tab_btn/top_tab_btn_',
        selection = '/game/construct-tab_btn/mid_tab_btn_',
        enhancement = '/game/construct-tab_btn/bot_tab_btn_',
    }
	local GetCSKUnitsPath = function() for i, mod in __active_mods do if mod.CSKProjectModName == "CSK-Units" then return mod.location end end end
	local CSKUnitsPath = GetCSKUnitsPath()
	
	local techFiles = {}
	
	if CSKUnitsPath then
	local factions = import('/lua/factions.lua').Factions
	local focusarmy = GetFocusArmy()
    local armyInfo = GetArmiesTable()
	local currentFaction = ''
    if focusarmy >= 1 then
	currentFaction = factions[armyInfo.armiesTable[focusarmy].faction+1].Key
	LOG('currentFaction: ', currentFaction)
	end
	
	    techFiles = {
        t1 = '/game/construct-tech_btn/t1_btn_',
        t2 = '/game/construct-tech_btn/t2_btn_',
        t3 = '/game/construct-tech_btn/t3_btn_',
		t35 = '/mods/Commander Survival Kit Units/icons/Techlevels/' .. currentFaction .. '/game/construct-tech_btn/t35_btn_',
        t4 = '/game/construct-tech_btn/t4_btn_',
		t5 = '/mods/Commander Survival Kit Units/icons/Techlevels/' .. currentFaction .. '/game/construct-tech_btn/t5_btn_',
		t6 = '/mods/Commander Survival Kit Units/icons/Techlevels/' .. currentFaction .. '/game/construct-tech_btn/t6_btn_',
        templates = '/game/construct-tech_btn/template_btn_',
        LCH = '/game/construct-tech_btn/left_upgrade_btn_',
        RCH = '/game/construct-tech_btn/r_upgrade_btn_',
        Back = '/game/construct-tech_btn/m_upgrade_btn_',
		Skin = '/game/construct-tech_btn/m_upgrade_btn_',
    }
	else
	
    techFiles = {
        t1 = '/game/construct-tech_btn/t1_btn_',
        t2 = '/game/construct-tech_btn/t2_btn_',
        t3 = '/game/construct-tech_btn/t3_btn_',
        t4 = '/game/construct-tech_btn/t4_btn_',
        templates = '/game/construct-tech_btn/template_btn_',
        LCH = '/game/construct-tech_btn/left_upgrade_btn_',
        RCH = '/game/construct-tech_btn/r_upgrade_btn_',
        Back = '/game/construct-tech_btn/m_upgrade_btn_',
		Skin = '/game/construct-tech_btn/m_upgrade_btn_',
    }
	
	end

    local function GetTabTextures(id)
        if tabFiles[id] then
            local pre = tabFiles[id]
            return UIUtil.UIFile(pre..'up_bmp.dds'), UIUtil.UIFile(pre..'sel_bmp.dds'),
                UIUtil.UIFile(pre..'over_bmp.dds'), UIUtil.UIFile(pre..'down_bmp.dds'),
                UIUtil.UIFile(pre..'dis_bmp.dds'), UIUtil.UIFile(pre..'dis_bmp.dds')
        elseif techFiles[id] then
            local pre = techFiles[id]
            return UIUtil.UIFile(pre..'up.dds'), UIUtil.UIFile(pre..'selected.dds'),
                UIUtil.UIFile(pre..'over.dds'), UIUtil.UIFile(pre..'down.dds'),
                UIUtil.UIFile(pre..'dis.dds'), UIUtil.UIFile(pre..'dis.dds')
        end
    end

    local function SetupTab(control)
        control:SetNewTextures(GetTabTextures(control.ID))
        control:UseAlphaHitTest(false)

        control.OnDisable = function(self)
            self.disabledGroup:Enable()
            Checkbox.OnDisable(self)
        end

        LayoutHelpers.SetDimensions(control.disabledGroup, 40, 25)
        LayoutHelpers.AtCenterIn(control.disabledGroup, control)

        control.OnEnable = function(self)
            self.disabledGroup:Disable()
            Checkbox.OnEnable(self)
        end
    end

    if not table.empty(controls.tabs) then
        for id, control in controls.tabs do
            SetupTab(control)

            if not prevControl then
                LayoutHelpers.AtLeftTopIn(control, controls.minBG, 82, 0)
            else
                local offset = 0
                LayoutHelpers.RightOf(control, prevControl, offset)
            end

            prevControl = control
        end
        controls.midBG1:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_bmp_m1.dds'))
        controls.midBG1.Right:Set(prevControl.Right)
        controls.midBG2:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_bmp_m2.dds'))
        controls.midBG3:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_bmp_m3.dds'))
        controls.minBG:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_bmp_l.dds'))
        LayoutHelpers.SetDimensions(controls.minBG, controls.minBG.BitmapWidth(), controls.minBG.BitmapHeight()) -- TODO: This is an ugly hack for the problem described above
        LayoutHelpers.SetDimensions(controls.midBG1, controls.midBG1.BitmapWidth(), controls.midBG1.BitmapHeight()) -- TODO
        LayoutHelpers.SetDimensions(controls.midBG2, controls.midBG2.BitmapWidth(), controls.midBG2.BitmapHeight()) -- TODO
        LayoutHelpers.SetDimensions(controls.midBG3, controls.midBG3.BitmapWidth(), controls.midBG3.BitmapHeight()) -- TODO
        LayoutHelpers.AtLeftIn(controls.minBG, controls.constructionGroup, 67)
        LayoutHelpers.AtBottomIn(controls.maxBG, controls.minBG, 1)
        LayoutHelpers.AtBottomIn(controls.minBG, controls.constructionGroup, 4)
    else
        controls.midBG1:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_s_bmp_m.dds'))
        controls.midBG2:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_s_bmp_m.dds'))
        controls.midBG3:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_s_bmp_m.dds'))
        controls.minBG:SetTexture(UIUtil.UIFile('/game/construct-panel/construct-panel_s_bmp_l.dds'))
        LayoutHelpers.SetDimensions(controls.minBG, controls.minBG.BitmapWidth(), controls.minBG.BitmapHeight()) -- TODO
        LayoutHelpers.SetDimensions(controls.midBG1, controls.midBG1.BitmapWidth(), controls.midBG1.BitmapHeight()) -- TODO
        LayoutHelpers.SetDimensions(controls.midBG2, controls.midBG2.BitmapWidth(), controls.midBG2.BitmapHeight()) -- TODO
        LayoutHelpers.SetDimensions(controls.midBG3, controls.midBG3.BitmapWidth(), controls.midBG3.BitmapHeight()) -- TODO
        LayoutHelpers.AtLeftIn(controls.minBG, controls.constructionGroup, 69)
        LayoutHelpers.AtBottomIn(controls.maxBG, controls.minBG, 0)
        LayoutHelpers.AtBottomIn(controls.minBG, controls.constructionGroup, 5)
    end

    SetupTab(controls.constructionTab)
    LayoutHelpers.AtLeftTopIn(controls.constructionTab, controls.constructionGroup, 0, 14)
    SetupTab(controls.selectionTab)
    LayoutHelpers.Below(controls.selectionTab, controls.constructionTab, -16)
    SetupTab(controls.enhancementTab)
    LayoutHelpers.Below(controls.enhancementTab, controls.selectionTab, -16) 
end	
end