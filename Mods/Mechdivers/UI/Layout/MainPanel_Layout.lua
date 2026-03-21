local factions = import('/lua/factions.lua').Factions
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	
local UIUtil = import('/lua/ui/uiutil.lua')
local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
local Button = import('/lua/maui/button.lua').Button
local CreateText = import('/lua/maui/text.lua').Text
local StatusBar = import("/lua/maui/statusbar.lua").StatusBar
local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
local Tooltip = import("/lua/ui/game/tooltip.lua")
local Group = import("/lua/maui/group.lua").Group


local factions = import('/lua/factions.lua').Factions
local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()

function SetLayout()
    local controls = import('/mods/Mechdivers/UI/MainPanel.lua').controls
    local savedParent = import('/mods/Mechdivers/UI/MainPanel.lua').savedParent
    local multiControl = import('/mods/Mechdivers/hook/lua/ui/game/multifunction.lua').controls.bg
    
	

	controls.bg.panel:SetTexture(UIUtil.SkinnableFile('/game/unit-build-over-panel/build-over-back_bmp.dds'))
    controls.bg.LBracket:SetTexture(UIUtil.SkinnableFile('/game/bracket-left-energy/bracket_bmp.dds'))
    controls.bg.RBracket:SetTexture(UIUtil.SkinnableFile('/game/bracket-right-energy/bracket_bmp.dds'))

	picture = Bitmap(controls.bg.panel, '/mods/Mechdivers/textures/Superdestroyer.dds')
    
    LayoutHelpers.LeftOf(controls.bg, multiControl, 5) -- 5

	
    controls.bg.Height:Set(controls.bg.panel.Height)
    controls.bg.Width:Set(controls.bg.panel.Width)
	
	controls.bg.panel.Height:Set(70)
    controls.bg.panel.Width:Set(142)
    picture.Height:Set(55)
    picture.Width:Set(105)

	LayoutHelpers.AtLeftTopIn(controls.bg.panel, multiControl, 180, 0) 
	LayoutHelpers.AtLeftTopIn(controls.bg.LBracket, multiControl, 178, 2)
	LayoutHelpers.AtLeftTopIn(controls.bg.RBracket, multiControl, 310, 2)

	
	
	if focusarmy >= 1 then
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
FSButton = UIUtil.CreateButtonStd(controls.bg.panel, '/mods/Mechdivers/textures/medium-aeon_btn/small-aeon', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
FSButton = UIUtil.CreateButtonStd(controls.bg.panel, '/mods/Mechdivers/textures/medium-cybran_btn/small-cybran', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
FSButton = UIUtil.CreateButtonStd(controls.bg.panel, '/mods/Mechdivers/textures/medium-uef_btn/small-uef', nil, 11)
		end
		if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
FSButton = UIUtil.CreateButtonStd(controls.bg.panel, '/mods/Mechdivers/textures/medium-sera_btn/small-sera', nil, 11)
		end
	end
	

	
FSButton.OnClick = function(control)
UISelectionByCategory("SUPERDESTROYER", false, false, false, false)
end

   
FSButton.Height:Set(48)
FSButton.Width:Set(23)
LayoutHelpers.AtLeftTopIn(FSButton, controls.bg.panel, 112, 12)
LayoutHelpers.DepthOverParent(FSButton, controls.bg, 50)

LayoutHelpers.AtLeftTopIn(picture, controls.bg.panel, 6, 9)
LayoutHelpers.DepthOverParent(picture, controls.bg.panel, 20)

 
--Tooltip.AddButtonTooltip(FSButton, "FSBtn", 1)


--FSButton:Disable()
local Gametype = SessionGetScenarioInfo().type


--[[
HQComCenterDetected = import('/mods/Commander Survival Kit/UI/Layout/Values.lua').HQComCenterDetected


ForkThread(
	function()
	while true do 
		if Gametype == 'skirmish' or Gametype == 'campaign_coop' then
		while true do 
		if HQComCenterDisabled == false or HQComCentersIncluded == 1 then
		if HQComCenterDetected == false then
		CSKManagerNumber = 0
		RefButton:Disable()
		FSButton:Disable()
		else
		if CSKManagerNumber == 0 then
		RefButton:Enable()
		FSButton:Enable()
		CSKManagerNumber = 1
		end
		end
		elseif HQComCenterDisabled == true or HQComCentersIncluded == 2 then
		if CSKManagerNumber == 0 then
		RefButton:Enable()
		FSButton:Enable()
		CSKManagerNumber = 1
		end
		end
		WaitSeconds(1)
		end
		elseif Gametype == 'campaign' then
		while true do 
		if HQComCenterDisabled == false and HQComCentersIncluded == nil then
		if HQComCenterDetected == false then
		CSKManagerNumber = 0
		RefButton:Disable()
		FSButton:Disable()
		else
		if CSKManagerNumber == 0 then
		RefButton:Enable()
		FSButton:Enable()
		CSKManagerNumber = 1
		end
		end
		elseif HQComCenterDisabled == true and HQComCentersIncluded == nil then
		if CSKManagerNumber == 0 then
		RefButton:Enable()
		FSButton:Enable()
		CSKManagerNumber = 1
		end
		end
		WaitSeconds(1)
		end
		end
		end
	end
)
]]--
 
end