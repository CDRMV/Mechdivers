#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0106/UEL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Light Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TWalkingLandUnit = import('/lua/Defaultunits.lua').WalkingLandUnit
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat

TEL0102 = Class(TWalkingLandUnit) {
    Weapons = {
		Melee = Class(DummyTurretWeapon) {
		
		OnWeaponFired = function(self)
			ForkThread( function()
			local animator = CreateAnimator(self.unit)
            animator:PlayAnim('/Mods/Mechdivers/units/Terminids/TEL0102/TEL0102_AMelee01.sca', false):SetRate(2)
			WaitFor(animator)
			animator:Destroy()
			end)
		end,
			},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.Slider= CreateSlider(self, 'Body', 0, 0, 0, 0.5)
		self.Trash:Add(self.Slider)
		self.DoMeleeThreadHandle = self:ForkThread(self.DoMeleeThread)
    end,
	
	OnMotionHorzEventChange = function(self, new, old)
        TWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
		if old == 'Stopped' then
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
        elseif new == 'Stopped' then
			self:AddToggleCap('RULEUTC_WeaponToggle')
        end
    end,
	
	OnScriptBitSet = function(self, bit)
        TWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		ForkThread(function()
		self:SetDoNotTarget(true)
		self:RemoveCommandCap("RULEUCC_Attack")
		self:RemoveCommandCap('RULEUCC_Stop')
		self:RemoveCommandCap("RULEUCC_Move")
		self:RemoveCommandCap('RULEUCC_Patrol')
		self:RemoveCommandCap('RULEUCC_Guard')
		self:RemoveCommandCap('RULEUCC_RetaliateToggle')
		local rotation = RandomFloat(0,2*math.pi)
		self.ArrivalAnimManip = CreateAnimator(self)
        self.Trash:Add(self.ArrivalAnimManip)
        self.ArrivalAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationWalk, true):SetRate(2)
		self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(1):SetEmitterParam('LIFETIME', 10)
		self.Trash:Add(self.Effect1)
		self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/dust_cloud_06_emit.bp'):ScaleEmitter(1):SetEmitterParam('LIFETIME', 10):OffsetEmitter(0,-1,0)
		self.Trash:Add(self.Effect2)
		CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', 2, 2, 150, 150, self:GetArmy())
		self.Slider:SetGoal(0,-1,0)
		WaitFor(self.Slider)
		self.ArrivalAnimManip:SetRate(0)
		self.ArrivalAnimManip:Destroy()
		self.Effect1:Destroy()
		self.Effect2:Destroy()
		self:SetCollisionShape('None')
		end)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		ForkThread(function()
		self.ArrivalAnimManip = CreateAnimator(self)
        self.Trash:Add(self.ArrivalAnimManip)
		self:RevertCollisionShape()
        self.ArrivalAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationWalk, true):SetRate(2)
		self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/dust_cloud_05_emit.bp'):ScaleEmitter(1):SetEmitterParam('LIFETIME', 10)
		self.Trash:Add(self.Effect1)
		self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), '/effects/emitters/dust_cloud_06_emit.bp'):ScaleEmitter(1):SetEmitterParam('LIFETIME', 10):OffsetEmitter(0,-1,0)
		self.Trash:Add(self.Effect2)
		self.Slider:SetGoal(0,0,0)
		WaitFor(self.Slider)	
		self.ArrivalAnimManip:SetRate(0)	
		self.ArrivalAnimManip:Destroy()	
		self.Effect1:Destroy()
		self.Effect2:Destroy()	
		self:AddCommandCap("RULEUCC_Attack")
		self:AddCommandCap('RULEUCC_Stop')
		self:AddCommandCap("RULEUCC_Move")
		self:AddCommandCap('RULEUCC_Patrol')
		self:AddCommandCap('RULEUCC_Guard')
		self:AddCommandCap('RULEUCC_RetaliateToggle')	
		self:SetDoNotTarget(false)		
		end)
        end
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
TypeClass = TEL0102

