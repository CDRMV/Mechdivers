#****************************************************************************
#**
#**  File     :  /data/units/XAL0203/XAL0203_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  Aeon Assault Tank Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local AHoverLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ADFLightningBeam = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').ADFLightningBeam

CSKMDAL0200 = Class(AHoverLandUnit) {
    Weapons = {
		LightningWeapon = Class(ADFLightningBeam) {
		IdleState = State (ADFLightningBeam.IdleState) {
        Main = function(self)
           ADFLightningBeam.IdleState.Main(self)
        end,
                
        OnGotTarget = function(self)
			self.unit:AddToggleCap('RULEUTC_WeaponToggle')
			self.unit.Scan:SetMesh('/mods/Mechdivers/Decorations/AeonScan_Alert_mesh') 
			ADFLightningBeam.OnGotTarget(self)
        end,                
        },
       
        
        OnLostTarget = function(self)
			self.unit:RemoveToggleCap('RULEUTC_WeaponToggle')
			self.unit.Scan:SetMesh('/mods/Mechdivers/Decorations/AeonScan_mesh') 
            ADFLightningBeam.OnLostTarget(self)
        end,  			
		},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
		ForkThread(function()
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		ScanMesh = '/mods/Mechdivers/Decorations/AeonScan_mesh'
		self.Scan = import('/lua/sim/Entity.lua').Entity()
		self.Scan:AttachBoneTo( -2, self, 'Scan' )
		self.Scan:SetMesh(ScanMesh)
		self.Scan:SetDrawScale(0.1)
		self.Scan:SetVizToAllies('Intel')
		self.Scan:SetVizToNeutrals('Intel')
		self.Scan:SetVizToEnemies('Intel')
		self:ForkThread(self.CreateIntelEntity,'Scan', 'Vision')
		--
		-- Lets check the TerrianType of the Drones current position
        -- The Drone should not be able to call in Land Reinforcements on Water			
		--
		
		self.check = false
		while true do
		local position = self:GetPosition()
        local terrain = GetTerrainType(position[1], position[3])
		self.check = string.find(terrain.Name, "Water")
		
		-- self.check = nil (The drone is over Water)
		-- self.check = 1 or any Value which is not nil (The drone is over Land)
		
		WaitSeconds(0.1)
		end
		end)
        AHoverLandUnit.OnStopBeingBuilt(self,builder,layer)
    end,
	
	CreateIntelEntity = function(self, bone, intel)
	local radius = 20
    if not self.IntelEntity then
        self.IntelEntity = {}
    end
    if not self:BeenDestroyed() and radius > 0 then
        local counter = 1
		local anglevalue = 1
        while counter <= radius do
		anglevalue = anglevalue + 1
            local angle = math.ceil((anglevalue) / 3.14)
            if counter + angle < radius then
                ent = import('/lua/sim/Entity.lua').Entity({Owner = self,})
                table.insert(self.IntelEntity, ent)
                self.Trash:Add(ent)					
                ent:AttachBoneTo( -1, self, bone or 0 )
                local pos = self:CalculateWorldPositionFromRelative({0, 0, counter})
                ent:SetParentOffset(Vector(0,0, counter))
                ent:SetVizToFocusPlayer('Always')
                ent:SetVizToAllies('Always')
                ent:SetVizToNeutrals('Never')
                ent:SetVizToEnemies('Never')
				LOG(angle)
                ent:InitIntel(self:GetArmy(), intel, angle)
                ent:EnableIntel(intel)
            end
            counter = counter + 1
        end	
    end
end,
	
	OnScriptBitSet = function(self, bit)
        AHoverLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		if self.check == nil then
		ForkThread(function()
		self.Scan:SetVizToAllies('Never')
		self.Scan:SetVizToNeutrals('Never')
		self.Scan:SetVizToEnemies('Never')
		self:SetImmobile(true)
		self.Effect1 = CreateAttachedEmitter(self, 'Body', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect01_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(1)
		self.Effect2 = CreateAttachedEmitter(self, 'Body', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect03_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(0.5)
		WaitSeconds(5)
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		local location = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local ShieldUnit =CreateUnitHPR('CSKMDAL0200b', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self.Scan:SetVizToAllies('Intel')
		self.Scan:SetVizToNeutrals('Intel')
		self.Scan:SetVizToEnemies('Intel')
		self:SetImmobile(false)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		WaitSeconds(100)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		end)
		else

		end
		end
    end,

    OnScriptBitClear = function(self, bit)
        AHoverLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		if self.check == nil then
		ForkThread(function()
		self.Scan:SetVizToAllies('Never')
		self.Scan:SetVizToNeutrals('Never')
		self.Scan:SetVizToEnemies('Never')
		self:SetImmobile(true)
		self.Effect1 = CreateAttachedEmitter(self, 'Body', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect01_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(1)
		self.Effect2 = CreateAttachedEmitter(self, 'Body', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect03_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(0.5)
		WaitSeconds(5)
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		local location = self:GetPosition()
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local ShieldUnit =CreateUnitHPR('CSKMDAL0200b', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self.Scan:SetVizToAllies('Intel')
		self.Scan:SetVizToNeutrals('Intel')
		self.Scan:SetVizToEnemies('Intel')
		self:SetImmobile(false)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		WaitSeconds(100)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		end)
		else

		end
		end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.Scan then
		self.Scan:Destroy()
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
}
TypeClass = CSKMDAL0200