----directory----

----significant operators imported from external sources----
local CreateText = import('/lua/maui/text.lua').Text 
local CreateWindow = import('/lua/maui/window.lua').Window
local UIUtil = import('/lua/ui/uiutil.lua')
local UIFile = import('/lua/ui/uiutil.lua').UIFile
local factions = import('/lua/factions.lua').Factions
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local UIPing = import('/lua/ui/game/ping.lua')
local cmdMode = import('/lua/ui/game/commandmode.lua')
----parameters----
local Border = {
        tl = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_ul.dds'),
        tr = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_ur.dds'),
        tm = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_horz_um.dds'),
        ml = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_vert_l.dds'),
        m = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_m.dds'),
        mr = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_vert_r.dds'),
        bl = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_ll.dds'),
        bm = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_lm.dds'),
        br = UIUtil.UIFile('/game/mini-map-brd/mini-map_brd_lr.dds'),
        borderColor = 'ff415055',
}
	
local Position = {
	Left = 330, 
	Top = 280, 
	Bottom = 450, 
	Right = 640
}


   
----actions----
UI = CreateWindow(GetFrame(0),'Call Reinforcements',nil,false,false,true,false,'Reinforcements',Position,Border) 



for i,j in Position do
	UI[i]:Set(j)
end



local focusarmy = GetFocusArmy()
local armyInfo = GetArmiesTable()	


if focusarmy >= 1 then
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'AEON' then
		Ref1button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-aeon_btn/medium-aeon', nil, 11, 0, 0)
		Ref2button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-aeon_btn/medium-aeon', nil, 11, 0, 0)
		Ref3button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-aeon_btn/medium-aeon', nil, 11, 0, 0)
		Ref4button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-aeon_btn/medium-aeon', nil, 11, 0, 0)	
		Ref5button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-aeon_btn/medium-aeon', nil, 11, 0, 0)
		Ref6button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-aeon_btn/medium-aeon', nil, 11, 0, 0)	
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'CYBRAN' then
		Ref1button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-cybran_btn/medium-cybran', nil, 11, 0, 0)
		Ref2button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-cybran_btn/medium-cybran', nil, 11, 0, 0)
		Ref3button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-cybran_btn/medium-cybran', nil, 11, 0, 0)
		Ref4button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-cybran_btn/medium-cybran', nil, 11, 0, 0)
		Ref5button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-cybran_btn/medium-cybran', nil, 11, 0, 0)
		Ref6button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-cybran_btn/medium-cybran', nil, 11, 0, 0)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'UEF' then
		Ref1button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-uef_btn/UEBMD0113', nil, 11, 0, 0)
		Ref2button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-uef_btn/CSKMDTL0205', nil, 11, 0, 0)
		Ref3button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-uef_btn/CSKMDTL0305', nil, 11, 0, 0)
		Ref4button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-uef_btn/CSKMDTL0304', nil, 11, 0, 0)
		Ref5button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-uef_btn/CSKMDTL0303', nil, 11, 0, 0)
		Ref6button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-uef_btn/CSKMDTL0300', nil, 11, 0, 0)
	end
	if factions[armyInfo.armiesTable[focusarmy].faction+1].Category == 'SERAPHIM' then
		Ref1button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-seraphim_btn/medium-seraphim', nil, 11, 0, 0)
		Ref2button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-seraphim_btn/medium-seraphim', nil, 11, 0, 0)
		Ref3button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-seraphim_btn/medium-seraphim', nil, 11, 0, 0)
		Ref4button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-seraphim_btn/medium-seraphim', nil, 11, 0, 0)
		Ref5button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-seraphim_btn/medium-seraphim', nil, 11, 0, 0)
		Ref6button = UIUtil.CreateButtonStd(UI, '/mods/Mechdivers/textures/medium-seraphim_btn/medium-seraphim', nil, 11, 0, 0)
	end
end


Ref1button.OnClick = function(self)
	local selection = GetSelectedUnits()
	local selposition = selection[1]:GetPosition()
	local flag = IsKeyDown('Shift')
	SimCallback({Func = 'SpawnDropPodRef',Args = {id = 'UEBMD0113', pos = selposition, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
end

Ref2button.OnClick = function(self)
	local selection = GetSelectedUnits()
	local selposition = selection[1]:GetPosition()
	local flag = IsKeyDown('Shift')
	SimCallback({Func = 'SpawnAirDropRef',Args = {id = 'CSKMDTA0301c', pos = selposition, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
end

Ref3button.OnClick = function(self)
	local selection = GetSelectedUnits()
	local selposition = selection[1]:GetPosition()
	local flag = IsKeyDown('Shift')
	SimCallback({Func = 'SpawnAirDropRef',Args = {id = 'CSKMDTA0301d', pos = selposition, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
end

Ref4button.OnClick = function(self)
	local selection = GetSelectedUnits()
	local selposition = selection[1]:GetPosition()
	local flag = IsKeyDown('Shift')
	SimCallback({Func = 'SpawnAirDropRef',Args = {id = 'CSKMDTA0301a', pos = selposition, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
end

Ref5button.OnClick = function(self)
	local selection = GetSelectedUnits()
	local selposition = selection[1]:GetPosition()
	local flag = IsKeyDown('Shift')
	SimCallback({Func = 'SpawnAirDropRef',Args = {id = 'CSKMDTA0301b', pos = selposition, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
end

Ref6button.OnClick = function(self)
	local selection = GetSelectedUnits()
	local selposition = selection[1]:GetPosition()
	local flag = IsKeyDown('Shift')
	SimCallback({Func = 'SpawnAirDropRef',Args = {id = 'CSKMDTA0301e', pos = selposition, yes = not flag, ArmyIndex = GetFocusArmy()}},true)
end

UI:Hide()


function ManageUI(Value)
if Value == true then
UI:Show()
UI._closeBtn:Hide()
elseif Value == false then
UI:Hide()
end
end

LayoutHelpers.SetWidth(Ref1button, 64)
LayoutHelpers.SetHeight(Ref1button, 64)
LayoutHelpers.AtCenterIn(Ref1button, UI, -25, -120)
LayoutHelpers.DepthOverParent(Ref1button, UI, 10)
LayoutHelpers.SetWidth(Ref2button, 64)
LayoutHelpers.SetHeight(Ref2button, 64)
LayoutHelpers.AtCenterIn(Ref2button, UI, -25, -50)
LayoutHelpers.DepthOverParent(Ref2button, UI, 10)
LayoutHelpers.SetWidth(Ref3button, 64)
LayoutHelpers.SetHeight(Ref3button, 64)
LayoutHelpers.AtCenterIn(Ref3button, UI, -25, 20)
LayoutHelpers.DepthOverParent(Ref3button, UI, 10)
LayoutHelpers.SetWidth(Ref4button, 64)
LayoutHelpers.SetHeight(Ref4button, 64)
LayoutHelpers.AtCenterIn(Ref4button, UI, 45, -120)
LayoutHelpers.DepthOverParent(Ref4button, UI, 10)
LayoutHelpers.SetWidth(Ref5button, 64)
LayoutHelpers.SetHeight(Ref5button, 64)
LayoutHelpers.AtCenterIn(Ref5button, UI, 45, -50)
LayoutHelpers.DepthOverParent(Ref5button, UI, 10)
LayoutHelpers.SetWidth(Ref6button, 64)
LayoutHelpers.SetHeight(Ref6button, 64)
LayoutHelpers.AtCenterIn(Ref6button, UI, 45, 20)
LayoutHelpers.DepthOverParent(Ref6button, UI, 10)

