#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0106/UAL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Aeon Light Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AWalkingLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ADFCannonQuantumWeapon = import('/lua/aeonweapons.lua').ADFCannonQuantumWeapon

CSKMDAL0202 = Class(AWalkingLandUnit) {
    Weapons = {
MainGun = Class(ADFCannonQuantumWeapon) {
IdleState = State (ADFCannonQuantumWeapon.IdleState) {
        Main = function(self)
			self.unit:SetSpeedMult(1)
           ADFCannonQuantumWeapon.IdleState.Main(self)
        end,
                
        OnGotTarget = function(self)
			self.unit:SetSpeedMult(2)
			ChangeState(self, self.WeaponUnpackingState)
			ADFCannonQuantumWeapon.OnGotTarget(self)
        end,                
        },
       
        
        OnLostTarget = function(self)
			self.unit:SetSpeedMult(1)
			ChangeState(self, self.RackSalvoReloadState)
			ChangeState(self, self.IdleState)
            ADFCannonQuantumWeapon.OnLostTarget(self)
        end,  			


		    PlayFxWeaponPackSequence = function(self)
				ForkThread(function()
				self.unit.UnpackAnimManip:SetRate(-2)
				WaitFor(self.unit.UnpackAnimManip)
				end)
                ADFCannonQuantumWeapon.PlayFxWeaponPackSequence(self)
            end,
			
			PlayFxWeaponUnpackSequence = function(self)
				ForkThread(function()
				self.unit:RemoveToggleCap('RULEUTC_WeaponToggle')
				if self.unit.ArmAnimManip then
				self.unit.ArmAnimManip:Destroy()
				end
				self.unit.UnpackAnimManip:SetRate(2)
				WaitFor(self.unit.UnpackAnimManip)
				end)
                ADFCannonQuantumWeapon.PlayFxWeaponUnpackSequence(self)
            end,

            PlayFxRackSalvoChargeSequence = function(self)
				self.unit.ChargeAnimManip:SetRate(0.5)
                ADFCannonQuantumWeapon.PlayFxRackSalvoChargeSequence(self)
            end,            
            
            PlayFxRackSalvoReloadSequence = function(self)
				self.unit.ChargeAnimManip:SetRate(-0.5)
                ADFCannonQuantumWeapon.PlayFxRackSalvoChargeSequence(self)
            end,

}
    },
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread(function()
		self.ChargeAnimManip = CreateAnimator(self)
		self.Trash:Add(self.ChargeAnimManip)
		self.ChargeAnimManip:PlayAnim('/mods/Mechdivers/units/Aeon/CSKMDAL0202/CSKMDAL0202_Charge.sca', false):SetRate(0)
		self.UnpackAnimManip = CreateAnimator(self)
		self.Trash:Add(self.UnpackAnimManip)
		self.UnpackAnimManip:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0202/CSKMDAL0202_Attack.sca', false):SetRate(0)
		end)
    end,

	OnMotionHorzEventChange = function(self, new, old)
        AWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
		ForkThread( function()
		if old == 'Stopped' then
		self.MainGun = self:GetWeaponByLabel('MainGun')
		if self.MainGun:WeaponHasTarget() == true then
			if self.ArmAnimManip then
			self.ArmAnimManip:Destroy()
			end
			self.OpenAnimManip = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip)
			self.OpenAnimManip:PlayAnim('/mods/Mechdivers/units/Aeon/CSKMDAL0202/CSKMDAL0202_Awalk02.sca', true):SetRate(1)
		else
			self.OpenAnimManip = CreateAnimator(self)
			self.Trash:Add(self.OpenAnimManip)
			self.OpenAnimManip:PlayAnim('/mods/Mechdivers/units/Aeon/CSKMDAL0202/CSKMDAL0202_Awalk01.sca', true):SetRate(1)
			self.ArmAnimManip = CreateAnimator(self)
			self.Trash:Add(self.ArmAnimManip)
			self.ArmAnimManip:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAL0202/CSKMDAL0202_AArm01.sca', true):SetRate(1)
		end
        elseif new == 'Stopped' then
			if self.OpenAnimManip then
			self.OpenAnimManip:Destroy()
			end
			if self.ArmAnimManip then
			self.ArmAnimManip:Destroy()
			end
        end
		end)
    end,

}


TypeClass = CSKMDAL0202