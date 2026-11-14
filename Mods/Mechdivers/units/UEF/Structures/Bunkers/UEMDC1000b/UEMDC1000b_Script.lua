#****************************************************************************
#** 
#**  File     :  /cdimage/units/UEC1101/UEC1101_script.lua 
#** 
#** 
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TCivilianStructureUnit = import('/lua/defaultunits.lua').StructureUnit

UEMDC1000b = Class(TCivilianStructureUnit) {

	OnCreate = function(self)
		TCivilianStructureUnit.OnCreate(self)
		self.animator = CreateAnimator(self)
        self.animator:PlayAnim('/Mods/Mechdivers/units/UEF/Structures/Bunkers/UEMDC1000b/UEMDC1000b_Aopen.sca', false):SetRate(0)
    end,

	OnScriptBitSet = function(self, bit)
        TCivilianStructureUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
        if bit == 1 then 
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self.animator:SetRate(0.3)
			WaitFor(self.animator)
			local number = math.random(1,3)
			if number == 1 then
			self:GiveMass()
			elseif number == 2 then
			self:GiveEnergy()
			elseif number == 3 then
			end
        end
		end)
    end,

    OnScriptBitClear = function(self, bit)
        TCivilianStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
			self.animator:SetRate(-0.3)
        end
    end,
	
	GiveMass = function(self)
		local aiBrain = self:GetAIBrain()
		aiBrain:GiveStorage('Mass', 1000)
		aiBrain:GiveResource('Mass', 1000)
    end,
	
	GiveEnergy = function(self)
		local aiBrain = self:GetAIBrain()
		aiBrain:GiveStorage('Energy', 1000)
		aiBrain:GiveResource('Energy', 1000)
    end,

}


TypeClass = UEMDC1000b

