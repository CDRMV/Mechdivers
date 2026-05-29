#****************************************************************************
#**
#**  File     :  /units/UEL0303b/UEL0303b_script.lua
#**  Author(s):  CDRMV
#**
#**  Summary  :  UEF Patroit/Emancipator Mech Script
#**
#**  Copyright © 2025, Commander Survival Kit Project
#****************************************************************************

local DummyUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon


Autocannon = Class(DummyUnit) {

    Weapons = {
		Cannon = Class(TDFGaussCannonWeapon){
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'Autocannon_Turret_Muzzle' then
		CreateAttachedEmitter(self.unit, 'Autocannon_Turret_Shell', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
    },  
	
	Parent = nil,

    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.Pod = podName
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Parent:NotifyOfPodDeath(self.Pod)
        self.Parent = nil
        DummyUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
	
	OnScriptBitSet = function(self, bit)
        DummyUnit.OnScriptBitSet(self, bit)
		if bit == 1 then 
		self.GetTargetThreadHandle = self:ForkThread(self.GetTargetThread)
		elseif bit == 7 then
		IssueClearCommands({self})
		self:SetScriptBit('RULEUTC_SpecialToggle', false)
		end
    end,

    OnScriptBitClear = function(self, bit)
        DummyUnit.OnScriptBitClear(self, bit)
		if bit == 1 then 
		IssueClearCommands({self})
		KillThread(self.GetTargetThreadHandle)
		elseif bit == 7 then

		end
    end,
	
	GetTargetThread = function(self)
		while self and not self.Dead do
		if self:GetCurrentMoveLocation() then
		local Target = self:GetAIBrain():GetUnitsAroundPoint(categories.ALLUNITS, self:GetCurrentMoveLocation(), 1, 'Enemy')
		if Target[1] == nil then
		self:GetWeaponByLabel('Cannon'):SetTargetGround(self:GetCurrentMoveLocation())
		else
		self:GetWeaponByLabel('Cannon'):SetTargetEntity(Target[1])
		end
		end
		
		WaitSeconds(1)
		end
    end,
	  
}
TypeClass = Autocannon