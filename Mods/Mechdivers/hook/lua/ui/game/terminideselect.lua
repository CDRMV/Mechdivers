
local UIUtil = import("/lua/ui/uiutil.lua")
local LayoutHelpers = import("/lua/maui/layouthelpers.lua")
local Group = import("/lua/maui/group.lua").Group
local Bitmap = import("/lua/maui/bitmap.lua").Bitmap
local Tooltip = import("/lua/ui/game/tooltip.lua")
local Prefs = import("/lua/user/prefs.lua")

local factionData = {
	{name = 'No', icon = '/mods/Mechdivers/textures/ui/No_Button', key = 'no', color = 'ff00d7ff', sound = 'UI_UEF_Rollover'},
    {name = 'Terminids', icon = '/mods/Mechdivers/textures/ui/Terminide_Button', key = 'terminids', color = 'ff00d7ff', sound = 'UI_UEF_Rollover'},
}
    
function RequestPlayerFaction(parent)
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

	if version < 3652 then
	
	else
    GetCursor():Show()
    function Callback(faction)
        SimCallback({Func = 'FactionSelection', Args = {Faction = faction}})
    end
    local top = Bitmap(parent, UIUtil.UIFile('/mods/Mechdivers/textures/ui/terminide-selection-panel.dds'))
    LayoutHelpers.AtCenterIn(top, parent, -80)
    top.Depth:Set(10000)
    
    local bg = Bitmap(top)
    bg:SetSolidColor('aa000000')
    bg.Depth:Set(function() return top.Depth() - 1 end)
    LayoutHelpers.FillParent(bg, parent)
    
    local title = UIUtil.CreateText(top, "Play as Terminids?", 18)
	title:SetColor('FF734B30')
    LayoutHelpers.AtCenterIn(title, top, -50)
    
    local buttons = {}
    for index, data in factionData do
        local key = data.key
        buttons[index] = UIUtil.CreateButton(top,
            data.icon..'_btn_up.dds',
            data.icon..'_btn_sel.dds',
            data.icon..'_btn_over.dds',
            data.icon..'_btn_dis.dds')
        Tooltip.AddButtonTooltip(buttons[index], 'faction_select_'..data.key)
        buttons[index].cue = data.sound
        buttons[index].OnRolloverEvent = function(self, event)
            if event == 'enter' then
                PlaySound(Sound({Bank = 'Interface', Cue = self.cue}))
            end
        end
        buttons[index].OnClick = function(self, modifiers)
		if key == 'no' then
		Sync.Terminids = false
		top:Destroy()
        Callback(key)
		else
            PlaySound(Sound({Bank = 'Interface', Cue = 'UI_Menu_MouseDown'}))
            if Prefs.GetOption('skin_change_on_start') != 'no' then
                local factions = import('/lua/factions.lua')
                if factions.Factions[factions.FactionIndexMap[key]].DefaultSkin then
                    UIUtil.SetCurrentSkin(factions.Factions[factions.FactionIndexMap[key]].DefaultSkin)
					if key == 'terminids' then
					Sync.Terminids = true
					import('/mods/Mechdivers/UI/MainPanel.lua').Contract()
					else
					Sync.Terminids = false
					import('/mods/Mechdivers/UI/MainPanel.lua').ShowPanel()
					end
                end
            end
            top:Destroy()
            Callback(key)
		end	
        end
    end
    LayoutHelpers.AtCenterIn(buttons[2], top, 9, 35)
    LayoutHelpers.LeftOf(buttons[1], buttons[2], -5)
    UIUtil.MakeInputModal(top)
	end
end