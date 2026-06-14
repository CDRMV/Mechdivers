
local MechdiversTooltipInfo = import('/mods/Mechdivers/lua/CustomTooltips.lua')

function CreateMouseoverDisplay(parent, ID, delay, extendedBool, hotkeyID)
    if mouseoverDisplay then
        mouseoverDisplay:Destroy()
        mouseoverDisplay = false
    end
        
    if not Prefs.GetOption('tooltips') then return end
    local createDelay = 0
    if delay and Prefs.GetOption('tooltip_delay') then
        createDelay = math.max(delay, Prefs.GetOption('tooltip_delay'))
    else
        createDelay = Prefs.GetOption('tooltip_delay') or 0
    end
    local totalTime = 0
    local alpha = 0.0
    local text = ""
    local body = ""
    if type(ID) == 'string' then
        if TooltipInfo['Tooltips'][ID] then
            text = LOC(TooltipInfo['Tooltips'][ID]['title'])
            body = LOC(TooltipInfo['Tooltips'][ID]['description'])
            if TooltipInfo['Tooltips'][ID]['keyID'] and TooltipInfo['Tooltips'][ID]['keyID'] != "" then
                for i, v in Keymapping do
                    if v == TooltipInfo['Tooltips'][ID]['keyID'] then
                        local properkeyname = import('/lua/ui/dialogs/keybindings.lua').formatkeyname(i)
                        text = LOCF("%s (%s)", text, properkeyname)
                        break
                    end
                end
            end
		elseif MechdiversTooltipInfo['NewTooltips'][ID] then
            text = LOC(MechdiversTooltipInfo['NewTooltips'][ID]['title'])
            body = LOC(MechdiversTooltipInfo['NewTooltips'][ID]['description'])
            if MechdiversTooltipInfo['NewTooltips'][ID]['keyID'] and MechdiversTooltipInfo['NewTooltips'][ID]['keyID'] != "" then
                for i, v in Keymapping do
                    if v == MechdiversTooltipInfo['NewTooltips'][ID]['keyID'] then
                        local properkeyname = import('/lua/ui/dialogs/keybindings.lua').formatkeyname(i)
                        text = LOCF("%s (%s)", text, properkeyname)
                        break
                    end
                end
            end	
        else
            if extendedBool then
                WARN("No tooltip in table for key: "..ID)
            end
            text = ID
            body = "No Description"
        end
    elseif type(ID) == 'table' then
        text = LOC(ID.text)
        body = LOC(ID.body)
    else
        WARN('UNRECOGNIZED TOOLTIP ENTRY - Not a string or table! ', repr(ID))
    end
	if extendedBool then
        mouseoverDisplay = CreateExtendedToolTip(parent, text, body)
    else
        mouseoverDisplay = CreateToolTip(parent, text)
    end
    if extendedBool then
        local Frame = GetFrame(0)
        if parent.Top() - mouseoverDisplay.Height() < 0 then
            mouseoverDisplay.Top:Set(function() return parent.Bottom() + 10 end)
        else
            mouseoverDisplay.Bottom:Set(parent.Top)
        end
        if (parent.Left() + (parent.Width() / 2)) - (mouseoverDisplay.Width() / 2) < 0 then
            mouseoverDisplay.Left:Set(parent.Right)
        elseif (parent.Right() - (parent.Width() / 2)) + (mouseoverDisplay.Width() / 2) > Frame.Right() then
            mouseoverDisplay.Right:Set(parent.Left)
        else
            LayoutHelpers.AtHorizontalCenterIn(mouseoverDisplay, parent)
        end
    else
        local Frame = GetFrame(0)
        mouseoverDisplay.Bottom:Set(parent.Top)
        if (parent.Left() + (parent.Width() / 2)) - (mouseoverDisplay.Width() / 2) < 0 then
            mouseoverDisplay.Left:Set(4)
        elseif (parent.Right() - (parent.Width() / 2)) + (mouseoverDisplay.Width() / 2) > Frame.Right() then
            mouseoverDisplay.Right:Set(function() return Frame.Right() - 4 end)
        else
            LayoutHelpers.AtHorizontalCenterIn(mouseoverDisplay, parent)
        end
    end
    if ID == "mfd_defense" then
        local size = table.getn(mouseoverDisplay.desc)
        mouseoverDisplay.desc[size]:SetColor('ffff0000')
        mouseoverDisplay.desc[size-1]:SetColor('ffffff00')
        mouseoverDisplay.desc[size-2]:SetColor('ff00ff00')
        mouseoverDisplay.desc[size-3]:SetColor('ff4f77f4')
    end
    mouseoverDisplay:SetAlpha(alpha, true)
    mouseoverDisplay:SetNeedsFrameUpdate(true)
    mouseoverDisplay.OnFrame = function(self, deltaTime)
        if totalTime > createDelay then
            if parent then
                if alpha < 1 then
                    mouseoverDisplay:SetAlpha(alpha, true)
                    alpha = alpha + (deltaTime * 4)
                else
                    mouseoverDisplay:SetAlpha(1, true)
                    mouseoverDisplay:SetNeedsFrameUpdate(false)
                end
            else
                WARN("NO PARENT SPECIFIED FOR TOOLTIP")
            end
        end
        totalTime = totalTime + deltaTime
    end
end