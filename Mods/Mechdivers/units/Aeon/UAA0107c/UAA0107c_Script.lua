#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0107/UAA0107_script.lua
#**  Author(s):  John Comes
#**
#**  Summary  :  Aeon T1 Transport Script
#**
#**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit

UAA0107c = Class(AAirUnit) {

    Weapons = {
    },
	OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
        LOG('*ATTACHING UNITS TO TRANS!!')
        local position = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Station08 = CreateUnitHPR('ual0106', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_01')
		self.Station09 = CreateUnitHPR('ual0106', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_02')
		self.Station10 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_03')
		self.Station11 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_04')
		self.Station10 = CreateUnitHPR('ual0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_05')
		self.Station11 = CreateUnitHPR('ual0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo('AttachPoint', self, 'Attachpoint_Small_06')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		AAirUnit.OnStopBeingBuilt(self,builder,layer)
    end,
	
	OnTransportDetach = function(self, attachBone, unit)
	 	ForkThread( function()
		WaitSeconds(1)
		IssueClearCommands({self})
		self:RemoveCommandCap('RULEUCC_Attack')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		local pos = self.CachePosition or self:GetPosition()
        local BorderPos, OppBorPos

        local x, z = pos[1] / ScenarioInfo.size[1] - 0.5, pos[3] / ScenarioInfo.size[2] - 0.6

        if math.abs(x) <= math.abs(z) then
            BorderPos = {pos[1], nil, math.ceil(z) * ScenarioInfo.size[2]}
            OppBorPos = {pos[1], nil, BorderPos[3]==0 and ScenarioInfo.size[2] or 0}
            x, z = 1, 0
        else
            BorderPos = {math.ceil(x) * ScenarioInfo.size[1], nil, pos[3]}
            OppBorPos = {BorderPos[1]==0 and ScenarioInfo.size[1] or 0, nil, pos[3]}
            x, z = 0, 1
        end

        BorderPos[2] = GetTerrainHeight(BorderPos[1], BorderPos[3])
        OppBorPos[2] = GetTerrainHeight(OppBorPos[1], OppBorPos[3])

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)
		
		IssueMove({self}, oppoposition)
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then

            elseif orders == 1 then
            elseif orders == 0 then
				self:Destroy()
            end
		WaitSeconds(1)	
        end
		end
        )
	 end,
	 
	GetPlayableArea = function()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
	end,

	GetNearestPlayablePoint = function(self,position)

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	local playableArea = self.GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
local playableArea = self.GetPlayableArea()
if playableArea[1] == 0 and playableArea[2] == 0 then
return position
else

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end
end	
	else
	return position
	end
end,
}

TypeClass = UAA0107c