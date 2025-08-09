#****************************************************************************
#**
#**  File     :  /cdimage/units/URB2301/URB2301_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Heavy Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities
ModBpPath = '/mods/Mechdivers/effects/emitters/'

URBMD0101 = Class(CStructureUnit) {
    OnCreate = function(self)
        CStructureUnit.OnCreate(self)
		self.Effect = false
		self:SetScriptBit('RULEUTC_JammingToggle', false)
		self:SetScriptBit('RULEUTC_JammingToggle', true)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        CStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self.Effect = false
		self:SetScriptBit('RULEUTC_JammingToggle', false)
    end,
	
	
	OnScriptBitSet = function(self, bit)
        CStructureUnit.OnScriptBitSet(self, bit)
        if bit == 2 then 
		self:SetMaintenanceConsumptionInactive()
		KillThread(self.AutomaticDisableShieldThreadHandle)
		self.Effect = false
        self.MySpinner:SetTargetSpeed(0)
		if self.effect then
		self.effect:Destroy()
		self.effect = nil
		end
		if self.Beam then
		self.Beam:Destroy()
		self.Beam = nil
		end
		end
		local unitPos = self:GetPosition()
		local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 30, 'Enemy')
		for _,unit in units do
			unit:EnableShield()	
        end
    end,

    OnScriptBitClear = function(self, bit)
        CStructureUnit.OnScriptBitClear(self, bit)
        if bit == 2 then
		ForkThread(function()
		self:SetMaintenanceConsumptionActive()
		self.Effect = true
		self.AutomaticDisableShieldThreadHandle = self:ForkThread(self.AutomaticDisableShieldThread)
		if self.effect then
		self.effect:Destroy()
		self.effect = nil
		end
		if self.Beam then
		self.Beam:Destroy()
		self.Beam = nil
		end
		self.Beam = CreateBeamEmitter('/mods/Mechdivers/effects/emitters/jammer_beam_01_emit.bp', self:GetArmy())
		AttachBeamToEntity(self.Beam, self, 'Effect2', self:GetArmy())
        if not self.MySpinner then
            self.MySpinner = CreateRotator(self, 'Spinner', 'y', nil, 0, 45, 180)
            self.Trash:Add(self.MySpinner)
        end
        CStructureUnit.OnIntelEnabled(self)
        self.MySpinner:SetTargetSpeed(180)
		while true do
		if self.Effect == true then
        self.effect = CreateAttachedEmitter(self, 'Effect', self:GetArmy(), ModBpPath .. 'cybran_jammer_ambient_01_emit.bp'):ScaleEmitter(0.2):OffsetEmitter(0,0,-1) 
		end
		WaitSeconds(4.5)
		end
		end)		
		end
    end,

	AutomaticDisableShieldThread = function(self)
		local army = self:GetArmy()
 		while not self:IsDead() do
			local unitPos = self:GetPosition()
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 30, 'Enemy')
            for _,unit in units do
			    if GetDistanceBetweenTwoEntities(unit, self) < 29 then
                    unit:DisableShield()
				elseif GetDistanceBetweenTwoEntities(unit, self) > 29 then
					unit:EnableShield()	
                end
            end
            WaitSeconds(0.1)
		end	
    end,	
}

TypeClass = URBMD0101