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
                LayoutHelpers.AtLeftTopIn(control, controls.minBG, 134, 60)
            else
                local offset = 0
                LayoutHelpers.Below(control, prevControl, offset)
            end
            
            prevControl = control
        end
    end
    
    SetupTab(controls.constructionTab)
    LayoutHelpers.AtLeftTopIn(controls.constructionTab, controls.constructionGroup, 20, 7)
    SetupTab(controls.selectionTab)
    LayoutHelpers.RightOf(controls.selectionTab, controls.constructionTab, 0)
    SetupTab(controls.enhancementTab)
    LayoutHelpers.RightOf(controls.enhancementTab, controls.selectionTab, 0)
	
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
                LayoutHelpers.AtLeftTopIn(control, controls.minBG, 134, 60)
            else
                local offset = 0
                LayoutHelpers.Below(control, prevControl, offset)
            end

            prevControl = control
        end
    end

    SetupTab(controls.constructionTab)
    LayoutHelpers.AtLeftTopIn(controls.constructionTab, controls.constructionGroup, 20, 7)
    SetupTab(controls.selectionTab)
    LayoutHelpers.RightOf(controls.selectionTab, controls.constructionTab, 0)
    SetupTab(controls.enhancementTab)
    LayoutHelpers.RightOf(controls.enhancementTab, controls.selectionTab, 0)  
end	
end
