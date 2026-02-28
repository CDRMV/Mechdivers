#****************************************************************************
#**
#**  File     :  /cdimage/units/URA0104/URA0104_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Cybran T2 Air Transport Script
#**
#**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CAirUnit = import('/lua/defaultunits.lua').AirUnit
local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon

CSKMDCA0301b = Class(CAirUnit) {
    EngineRotateBones = {'Jet_Front', 'Jet_Back',},

    Weapons = {
		Missile01 = Class(CAAMissileNaniteWeapon) {},
    },


    BeamExhaustIdle = '/effects/emitters/missile_exhaust_fire_beam_05_emit.bp',
    BeamExhaustCruise = '/effects/emitters/missile_exhaust_fire_beam_04_emit.bp',
	
	OnCreate = function(self)
        CAirUnit.OnCreate(self)
        self.EngineManipulators = {}

        # create the engine thrust manipulators
        for key, value in self.EngineRotateBones do
            table.insert(self.EngineManipulators, CreateThrustController(self, "thruster", value))
        end

        # set up the thursting arcs for the engines
        for key,value in self.EngineManipulators do
            #                          XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
            value:SetThrustingParam( 0, 0.0, 0, 0, 0, 0, 0,      0 )
        end
    end,
		

    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetSpeedMult(2)

        # set up the thursting arcs for the engines
        for key,value in self.EngineManipulators do
            #                          XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
            value:SetThrustingParam( -0.0, 0.0, -0.25, 0.25, -0.1, 0.1, 1.0,      0.25 )
        end
        
        for k, v in self.EngineManipulators do
            self.Trash:Add(v)
        end
		
		EffectMesh = '/mods/Mechdivers/Decorations/CybranTransportEffect_mesh'
		self.Effect = import('/lua/sim/Entity.lua').Entity()
		self.Effect:AttachBoneTo( -2, self, 'Effect' )
		self.Effect:SetMesh(EffectMesh)
		self.Effect:SetDrawScale(0.05)
		self.Effect:SetVizToAllies('Never')
		self.Effect:SetVizToNeutrals('Never')
		self.Effect:SetVizToEnemies('Never')
		self:SpawnUnits()
    end,
	
	SpawnUnits = function(self)
		local position = self:GetPosition()
		self.unit1 = CreateUnitHPR('CSKMDCL0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.unit1:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml02')
		self.unit2 = CreateUnitHPR('CSKMDCL0103', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.unit2:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml03')
		self.unit3 = CreateUnitHPR('CSKMDCL0100', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.unit3:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml08')
		self.unit4 = CreateUnitHPR('CSKMDCL0100', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.unit4:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml09')
		self.unit5 = CreateUnitHPR('CSKMDCL0101', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.unit5:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml14')
		self.unit6 = CreateUnitHPR('CSKMDCL0105', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.unit6:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml15')
		self.unit7 = CreateUnitHPR('CSKMDCL0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.unit7:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml17')
		self.unit8 = CreateUnitHPR('CSKMDCL0104', self:GetArmy(), position.x, position.y, position.z, 0, 0, 0)
		self.unit8:AttachBoneTo('AttachPoint', self, 'Attachpoint_sml18')
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.Effect then
		self.Effect:Destroy()
		end
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
		self:CreateWreckage(overkillRatio or self.overkillRatio)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
	OnReclaimed = function(self, reclaimer)
		if self.Effect then
		self.Effect:Destroy()
		end
    end,
	
	OnTransportAttach = function(self, bone, attachee)
        CAirUnit.OnTransportDetach(self, bone, attachee)
		ForkThread(function()
		local rate = attachee.Blueprint.Display.TransportAnimationSpeed
		attachee:TransportAnimation(rate)
        self.Effect:SetVizToAllies('Intel')
		self.Effect:SetVizToNeutrals('Intel')
		self.Effect:SetVizToEnemies('Intel')
		WaitSeconds(1)
		self.Effect:SetVizToAllies('Never')
		self.Effect:SetVizToNeutrals('Never')
		self.Effect:SetVizToEnemies('Never')
		end)
    end,
	
	 OnTransportDetach = function(self, bone, attachee)
        CAirUnit.OnTransportDetach(self, bone, attachee)
		ForkThread(function()
        self.Effect:SetVizToAllies('Intel')
		self.Effect:SetVizToNeutrals('Intel')
		self.Effect:SetVizToEnemies('Intel')
		WaitSeconds(1)
		self.Effect:SetVizToAllies('Never')
		self.Effect:SetVizToNeutrals('Never')
		self.Effect:SetVizToEnemies('Never')
		if attachee:GetBlueprint().General.UnitName == 'Hunter II' then
		attachee:SetUnSelectable(true)
		WaitSeconds(1)
		attachee:DisableShield()
		attachee:SetUnSelectable(false)
		end
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
		end)
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

TypeClass = CSKMDCA0301b

