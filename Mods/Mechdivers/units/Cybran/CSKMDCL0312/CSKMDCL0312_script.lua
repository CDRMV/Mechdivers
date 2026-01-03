#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0106/URL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Light Infantry Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local CDFFusionMortarWeapon = ModWeaponsFile.CDFFusionMortarWeapon

CSKMDCL0309 = Class(CWalkingLandUnit) {
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {},
        Flamethrower = Class(TDFMachineGunWeapon) {},
		MainGun = Class(CDFFusionMortarWeapon) {},
    },
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(2)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(1)
        end
    end,
	
	OnCreate = function(self)
		CWalkingLandUnit.OnCreate(self)
		self.FireEffect = CreateAttachedEmitter(self,'L_Arm_Fire',self:GetArmy(), '/effects/emitters/op_ambient_fire_01_emit.bp'):ScaleEmitter(0.05)
		EffectMesh = '/mods/Mechdivers/Decorations/CybranBanner1Effect_mesh'
		self.Effect = import('/lua/sim/Entity.lua').Entity()
		self.Effect:AttachBoneTo( -2, self, 'Banner' )
		self.Effect:SetMesh(EffectMesh)
		self.Effect:SetDrawScale(0.12)
        self.Effect:SetVizToAllies('Intel')
		self.Effect:SetVizToNeutrals('Intel')
		self.Effect:SetVizToEnemies('Intel')
		EffectMesh2 = '/mods/Mechdivers/Decorations/CybranBannerSymbol_mesh'
		self.Effect2 = import('/lua/sim/Entity.lua').Entity()
		self.Effect2:AttachBoneTo( -2, self, 'Banner_Symbol' )
		self.Effect2:SetMesh(EffectMesh2)
		self.Effect2:SetDrawScale(0.05)
        self.Effect2:SetVizToAllies('Intel')
		self.Effect2:SetVizToNeutrals('Intel')
		self.Effect2:SetVizToEnemies('Intel')
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.Effect then
		self.Effect:Destroy()
		end
		if self.Effect2 then
		self.Effect2:Destroy()
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
		if self.Effect2 then
		self.Effect2:Destroy()
		end
    end,
}

TypeClass = CSKMDCL0309