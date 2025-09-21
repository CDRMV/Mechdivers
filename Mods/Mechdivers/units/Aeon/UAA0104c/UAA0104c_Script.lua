#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0104/UAA0104_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Aeon T2 Transport Script
#**
#**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').AirUnit
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local AAASonicPulseBatteryWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon

UAA0104c = Class(AAirUnit) {

    AirDestructionEffectBones = { 'Exhaust', 'Wing_Right', 'Wing_Left', 'Turret_Right', 'Turret_Left',
                                  'Slots_Left01', 'Slots_Left02', 'Slots_Right01', 'Slots_Right02',
                                  'Right_AttachPoint01', 'Right_AttachPoint02', 'Right_AttachPoint03', 'Right_AttachPoint04',
                                  'Left_AttachPoint01', 'Left_AttachPoint02', 'Left_AttachPoint03', 'Left_AttachPoint04', },

    Weapons = {
        SonicPulseBattery1 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery2 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery3 = Class(AAASonicPulseBatteryWeapon) {},
        SonicPulseBattery4 = Class(AAASonicPulseBatteryWeapon) {},
    },

	OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.AnimManip = CreateAnimator(self)
        self.Trash:Add(self.AnimManip)
        self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false):SetRate(1)
        LOG('*ATTACHING UNITS TO TRANS!!')
        local position = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Station08 = CreateUnitHPR('ual0106', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo('AttachPoint', self, 'Left_Attachpoint01')
		self.Station09 = CreateUnitHPR('ual0106', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo('AttachPoint', self, 'Left_Attachpoint02')
		self.Station10 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo('AttachPoint', self, 'Left_Attachpoint03')
		self.Station11 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo('AttachPoint', self, 'Left_Attachpoint04')
		self.Station10 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo('AttachPoint', self, 'Left_Attachpoint05')
		self.Station11 = CreateUnitHPR('ual0201', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo('AttachPoint', self, 'Left_Attachpoint06')
		self.Station08 = CreateUnitHPR('ual0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station08:AttachBoneTo('AttachPoint', self, 'Right_Attachpoint01')
		self.Station09 = CreateUnitHPR('ual0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station09:AttachBoneTo('AttachPoint', self, 'Right_Attachpoint02')
		self.Station10 = CreateUnitHPR('ual0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo('AttachPoint', self, 'Right_Attachpoint03')
		self.Station11 = CreateUnitHPR('ual0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo('AttachPoint', self, 'Right_Attachpoint04')
		self.Station10 = CreateUnitHPR('ual0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station10:AttachBoneTo('AttachPoint', self, 'Right_Attachpoint05')
		self.Station11 = CreateUnitHPR('ual0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.Station11:AttachBoneTo('AttachPoint', self, 'Right_Attachpoint06')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		AAirUnit.OnStopBeingBuilt(self,builder,layer)
    end,

    # Override air destruction effects so we can do something custom here
    CreateUnitAirDestructionEffects = function( self, scale )
        self:ForkThread(self.AirDestructionEffectsThread, self )
    end,

    AirDestructionEffectsThread = function( self )
        local numExplosions = math.floor( table.getn( self.AirDestructionEffectBones ) * 0.5 )
        for i = 0, numExplosions do
            explosion.CreateDefaultHitExplosionAtBone( self, self.AirDestructionEffectBones[util.GetRandomInt( 1, numExplosions )], 0.5 )
            WaitSeconds( util.GetRandomFloat( 0.2, 0.9 ))
        end
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

TypeClass = UAA0104c