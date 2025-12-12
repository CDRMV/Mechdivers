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
local CDFLaserFusionWeapon = ModWeaponsFile.CDFLaserFusionWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

CSKMDCL0102 = Class(CWalkingLandUnit) {
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {
		
		IdleState = State (DummyTurretWeapon.IdleState) {
        Main = function(self)
            DummyTurretWeapon.IdleState.Main(self)
        end,
                
        OnGotTarget = function(self)
			   local wep1 = self.unit:GetWeaponByLabel('MainGun')
			   wep1:SetEnabled(false)
               DummyTurretWeapon.OnGotTarget(self)
        end,                
            },
        
        OnGotTarget = function(self)
			   local wep1 = self.unit:GetWeaponByLabel('MainGun')
			   wep1:SetEnabled(false)
               DummyTurretWeapon.OnGotTarget(self)
        end,
        
        OnLostTarget = function(self)
			local wep1 = self.unit:GetWeaponByLabel('MainGun')
			wep1:SetEnabled(true)
            DummyTurretWeapon.OnLostTarget(self)
        end,  
		
		OnWeaponFired = function(self)
			ForkThread( function()
			local animator = CreateAnimator(self.unit)
            animator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0102/CSKMDCL0102_ASword01.sca', false):SetRate(2)
			WaitFor(animator)
			animator:Destroy()
			end)
		end,
			},
        MainGun = Class(CDFLaserFusionWeapon) {},
    },
	
	OnCreate = function(self)
		CWalkingLandUnit.OnCreate(self)
		RifleMesh = '/mods/Mechdivers/Decorations/CybranBot_DropRifle_mesh'
		self.Rifle = import('/lua/sim/Entity.lua').Entity()
        self.Rifle:AttachBoneTo( -1, self, 'Pistol' )
        self.Rifle:SetMesh(RifleMesh)
        self.Rifle:SetDrawScale(0.020)
        self.Rifle:SetVizToAllies('Intel')
        self.Rifle:SetVizToNeutrals('Intel')
        self.Rifle:SetVizToEnemies('Intel')
		DropRifleMesh = '/mods/Mechdivers/Decorations/CybranBot_DropRifle_mesh'
		self.DropRifle = import('/lua/sim/Entity.lua').Entity()
        self.DropRifle:AttachBoneTo( -1, self, 'Pistol' )
        self.DropRifle:SetMesh(DropRifleMesh)
        self.DropRifle:SetDrawScale(0.020)
        self.DropRifle:SetVizToAllies('Never')
        self.DropRifle:SetVizToNeutrals('Never')
        self.DropRifle:SetVizToEnemies('Never')
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0102/CSKMDCL0102_ACallRef.sca', false):SetRate(0)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:HideBone('R_Arm_B04', true)
		self:HideBone('B01', true)
		--self:HideBone('L_Arm_B04', true)
	end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
        if bit == 1 then 
		self:SetSpeedMult(2)
		elseif bit == 7 then
		self:SetWeaponEnabledByLabel('MainGun', false)
		IssueClearCommands({self})
		self:SetImmobile(true)
		self.AnimationManipulator:SetRate(2)
		WaitFor(self.AnimationManipulator)
		self.PistolFlash = CreateAttachedEmitter(self, 'Pistol_Muzzle', self:GetArmy(), '/Mods/Mechdivers/effects/emitters/fusion_laser_muzzle_flash_01_emit.bp')
        self.PistolFlash2 = CreateAttachedEmitter(self, 'Pistol_Muzzle', self:GetArmy(), '/Mods/Mechdivers/effects/emitters/fusion_laser_muzzle_flash_02_emit.bp')
		WaitSeconds(1)
		local BonePos = self:GetPosition('Pistol_Muzzle')
		self.Flare = self:CreateProjectile('/Mods/Mechdivers/projectiles/CDFReinforcementFlare/CDFReinforcementFlare_proj.bp', 0, 0.5, 0, 0, 20, 0)
		Warp(self.Flare, BonePos)
		self.PistolFlash:Destroy()
		self.PistolFlash2:Destroy()
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		WaitSeconds(2)
		self.AnimationManipulator:SetRate(-2)
		WaitFor(self.AnimationManipulator)
		self:SetImmobile(false)
		self:SetWeaponEnabledByLabel('MainGun', true)
		WaitSeconds(60)
		self:AddToggleCap('RULEUTC_SpecialToggle')
		end
		end)
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(1)
		elseif bit == 7 then
		self:SetScriptBit('RULEUTC_SpecialToggle', true)
		end
    end,
	
	HideRifle = function(self)
		CWalkingLandUnit.OnCreate(self)
        self.Rifle:SetVizToAllies('Never')
        self.Rifle:SetVizToNeutrals('Never')
        self.Rifle:SetVizToEnemies('Never')
    end,
	
	ShowRifle = function(self)
		CWalkingLandUnit.OnCreate(self)
        self.Rifle:SetVizToAllies('Intel')
        self.Rifle:SetVizToNeutrals('Intel')
        self.Rifle:SetVizToEnemies('Intel')
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.Rifle then
		self.Rifle:Destroy()
		end
		
		if self.DeathAnimManip then 
            WaitFor(self.DeathAnimManip)
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

TypeClass = CSKMDCL0102