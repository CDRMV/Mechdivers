#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0303/UAL0303_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Siege Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

CSKMDAL0301 = Class(AWalkingLandUnit) {    
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {
		
		OnWeaponFired = function(self)
			ForkThread( function()
			local animator = CreateAnimator(self.unit)
			local number = math.random(1,3)
			if number == 1 then
            animator:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0301/CSKMDAL0301_LClaw.sca', false):SetRate(2)
			elseif number == 2 then
			animator:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0301/CSKMDAL0301_RClaw.sca', false):SetRate(2)
			elseif number == 3 then
			animator:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0301/CSKMDAL0301_Fist.sca', false):SetRate(2)
			end
			WaitFor(animator)
			animator:Destroy()
			end)
		end,
		},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		--self.LGun = self:GetWeaponByLabel('LGun')
		--self.RGun = self:GetWeaponByLabel('RGun')
	    --self.LGatlingGun = self:GetWeaponByLabel('LGatlingGun')
		--self.RGatlingGun = self:GetWeaponByLabel('RGatlingGun')
		--self.LGatlingGun:SetEnabled(false)
		--self.RGatlingGun:SetEnabled(false)
		if self:GetAIBrain().BrainType == 'Human' then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.unit = CreateUnitHPR('UAL0106', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.unit:AttachBoneTo(-2, self, 'Spawn')
		self.unit:SetDoNotTarget(true)
		self.unit.CanTakeDamage = false
		self.unit.CanBeKilled = false
		self.unit:SetWeaponEnabledByLabel('ArmLaserTurret', false)
		self.unit:RemoveCommandCap('RULEUCC_Attack')
		self.unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self.unit:RemoveCommandCap('RULEUCC_Stop')
		self.unit:SetCollisionShape('Box', 0, 0, 0, 0, 0 ,0)
		self.unit:SetUnSelectable(true)
		--self.unit:HideRifle()
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		EffectMesh1 = '/effects/entities/AeonShield01/AeonShield01_mesh'
			self.Effect1 = import('/lua/sim/Entity.lua').Entity()
			self.Effect1:AttachBoneTo( -2, self, 'Shield' )
			self.Effect1:SetMesh(EffectMesh1)
			self.Effect1:SetDrawScale(0.6)
		end
		self:RemoveCommandCap('RULEUCC_Transport')
		self.DoMeleeThreadHandle = self:ForkThread(self.DoMeleeThread)
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
	if self.Effect1 then
	self.Effect1:Destroy()
	end	
	
	
	ForkThread(function()
	local RandomNumber = math.random(1, 2)
	if RandomNumber == 2 then
			self.unit:ShowBone(0, true)
			self.unit:SetDoNotTarget(false)
			self.unit:SetUnSelectable(false)
			self.unit.CanTakeDamage = true
			self.unit.CanBeKilled = true
			self.unit:SetWeaponEnabledByLabel('ArmLaserTurret', true)
			self.unit:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			self.unit:DetachFrom(true)
			self.unit:AddCommandCap('RULEUCC_Attack')
			self.unit:AddCommandCap('RULEUCC_RetaliateToggle')
			self.unit:AddCommandCap('RULEUCC_Stop')
	else
	self.unit:Destroy()
	end		
	end)
	
	AWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)	
    end,
	
	OnReclaimed = function(self, reclaimer)
	if self.Effect1 then
	self.Effect1:Destroy()
	end	
		
			self.unit:ShowBone(0, true)
			self.unit:SetDoNotTarget(false)
			self.unit:SetUnSelectable(false)
			self.unit.CanTakeDamage = true
			self.unit.CanBeKilled = true
			self.unit:SetWeaponEnabledByLabel('ArmLaserTurret', true)
			self.unit:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			self.unit:DetachFrom(true)
			self.unit:AddCommandCap('RULEUCC_Attack')
			self.unit:AddCommandCap('RULEUCC_RetaliateToggle')
			self.unit:AddCommandCap('RULEUCC_Stop')
    end,
	
	DoMeleeThread = function(self)
			local unitPos = self:GetPosition()
			local radius = self:GetBlueprint().Intel.VisionRadius
			while not self:IsDead() do
			if self:GetFireState() == 1 then
			
			else
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, radius, 'Enemy')
            for _,unit in units do
			IssueAttack({self}, unit)
            end
			end
			WaitSeconds(0.1)
			end
    end,
	

}

TypeClass = CSKMDAL0301