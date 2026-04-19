#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0106/URL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Light Infantry Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CybranWeaponsFile = import('/lua/cybranweapons.lua')
local CDFLaserHydrogenWeapon = ModWeaponsFile.CDFLaserHydrogenWeapon
local CIFGrenadeWeapon = CybranWeaponsFile.CIFGrenadeWeapon
local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities

CSKMDCL0208 = Class(CWalkingLandUnit) {
    Weapons = {
        MainGun = Class(CDFLaserHydrogenWeapon) {},
		OverCharge = Class(CDFLaserHydrogenWeapon) {
		    OnCreate = function(self)
                CDFLaserHydrogenWeapon.OnCreate(self)
                self:SetWeaponEnabled(false)
                self.AimControl:SetEnabled(false)
                self.AimControl:SetPrecedence(0)
                self.unit:SetOverchargePaused(false)
            end,

            OnEnableWeapon = function(self)
                if self:BeenDestroyed() then return end
                self:SetWeaponEnabled(true)
                self.unit:SetWeaponEnabledByLabel('MainGun', false)
                self.unit:ResetWeaponByLabel('MainGun')
                self.unit:BuildManipulatorSetEnabled(false)
                self.AimControl:SetEnabled(true)
                self.AimControl:SetPrecedence(20)
                self.AimControl:SetHeadingPitch( self.unit:GetWeaponManipulatorByLabel('MainGun'):GetHeadingPitch() )
            end,

            OnWeaponFired = function(self)
                CDFLaserHydrogenWeapon.OnWeaponFired(self)
                self:OnDisableWeapon()
                self:ForkThread(self.PauseOvercharge)
            end,
            
            OnDisableWeapon = function(self)
                if self.unit:BeenDestroyed() then return end
                self:SetWeaponEnabled(false)
                self.unit:SetWeaponEnabledByLabel('MainGun', true)
                self.unit:BuildManipulatorSetEnabled(false)
                self.AimControl:SetEnabled(false)
                self.AimControl:SetPrecedence(0)
                self.unit:GetWeaponManipulatorByLabel('MainGun'):SetHeadingPitch( self.AimControl:GetHeadingPitch() )
            end,
            
            PauseOvercharge = function(self)
                if not self.unit:IsOverchargePaused() then
                    self.unit:SetOverchargePaused(true)
                    WaitSeconds(1/self:GetBlueprint().RateOfFire)
                    self.unit:SetOverchargePaused(false)
                end
            end,
            
            OnFire = function(self)
                if not self.unit:IsOverchargePaused() then
                    CDFLaserHydrogenWeapon.OnFire(self)
                end
            end,
            IdleState = State(CDFLaserHydrogenWeapon.IdleState) {
                OnGotTarget = function(self)
                    if not self.unit:IsOverchargePaused() then
                        CDFLaserHydrogenWeapon.IdleState.OnGotTarget(self)
                    end
                end,            
                OnFire = function(self)
                    if not self.unit:IsOverchargePaused() then
                        ChangeState(self, self.RackSalvoFiringState)
                    end
                end,
            },
            RackSalvoFireReadyState = State(CDFLaserHydrogenWeapon.RackSalvoFireReadyState) {
                OnFire = function(self)
                    if not self.unit:IsOverchargePaused() then
                        CDFLaserHydrogenWeapon.RackSalvoFireReadyState.OnFire(self)
                    end
                end,
            }, 
		},
		Grenade = Class(CIFGrenadeWeapon) {
            FxMuzzleFlash = {
            },
            FxMuzzleFlashScale = 0,
        },
    },
	
	OnCreate = function(self)
		CWalkingLandUnit.OnCreate(self)
		self:SetWeaponEnabledByLabel('Grenade', false)
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:SetScriptBit('RULEUTC_ProductionToggle', true)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		--self:HideBone('B01', true)
	end,	
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
        if bit == 1 then 
		self:SetSpeedMult(2)
		elseif bit == 7 then
		self:SetWeaponEnabledByLabel('Grenade', true)
		local TargetUnit = self:GetWeaponByLabel('MainGun'):GetCurrentTarget()
		local TargetPos = self:GetWeaponByLabel('MainGun'):GetCurrentTargetPos()
		IssueClearCommands({self})
		self:SetWeaponEnabledByLabel('MainGun', false)
		if TargetUnit and TargetPos == nil then
		self:GetWeaponByLabel('Grenade'):SetTargetEntity(TargetUnit)
		elseif TargetUnit == nil and TargetPos then
		self:GetWeaponByLabel('Grenade'):SetTargetGround(TargetPos)
		end
		self:SetImmobile(true)
		WaitSeconds(2)
		IssueClearCommands({self})
		self:SetScriptBit('RULEUTC_SpecialToggle', false)
        end
		if bit == 4 then 
		KillThread(self.AutomaticRageFieldThreadHandle)
		self.RemoveRageFieldThreadHandle = self:ForkThread(self.RemoveAutomaticRageFieldThread)
		end
		end)
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(1)
		elseif bit == 7 then
		self:SetWeaponEnabledByLabel('Grenade', false)
		self:SetWeaponEnabledByLabel('MainGun', true)
		self:SetImmobile(false)
        end
		if bit == 4 then 
		KillThread(self.RemoveAutomaticRageFielddThreadHandle)
		self.AutomaticRageFieldThreadHandle = self:ForkThread(self.AutomaticRageFieldThread)
		end
    end,
	
	AutomaticRageFieldThread = function(self)
			local unitPos = self:GetPosition()
			local radius = self:GetBlueprint().Intel.VisionRadius
			while not self:IsDead() do
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, radius, 'Ally')
            for _,unit in units do
			    if GetDistanceBetweenTwoEntities(unit, self) < 22 then
				local regen = unit:GetBlueprint().Defense.RegenRate
				local maxhealth = unit:GetBlueprint().Defense.MaxHealth
				local health = unit:GetBlueprint().Defense.Health
				  unit:SetMaxHealth(maxhealth + 500)
				  unit:SetHealth(unit, health + 500)
                  unit:SetRegenRate(regen + 5)
				end
				if GetDistanceBetweenTwoEntities(unit, self) > 22 then
				local regen = unit:GetBlueprint().Defense.RegenRate
				local maxhealth = unit:GetBlueprint().Defense.MaxHealth
				local health = unit:GetBlueprint().Defense.Health
				  unit:SetMaxHealth(maxhealth)
				  unit:SetHealth(unit, health)
                  unit:SetRegenRate(regen)	
                end
            end
			WaitSeconds(0.1)
			end
    end,
	
	RemoveAutomaticRageFieldThread = function(self)
			local unitPos = self:GetPosition()
			local radius = self:GetBlueprint().Intel.VisionRadius
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, radius, 'Ally')
            for _,unit in units do
				local regen = unit:GetBlueprint().Defense.RegenRate
				local maxhealth = unit:GetBlueprint().Defense.MaxHealth
				local health = unit:GetBlueprint().Defense.Health
				  unit:SetMaxHealth(maxhealth)
				  unit:SetHealth(unit, health)
                  unit:SetRegenRate(regen)	
            end
    end,
}

TypeClass = CSKMDCL0208