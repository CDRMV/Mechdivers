#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0202/UEL0202_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Tank Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local CLandUnit = import('/lua/defaultunits.lua').MobileUnit
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CDFFusionMortarWeapon = ModWeaponsFile.CDFFusionMortarWeapon
local CDFHLaserHydrogenWeapon = ModWeaponsFile.CDFHLaserHydrogenWeapon
local ModEffects = '/mods/Mechdivers/effects/emitters/'
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone

CSKMDCL0320 = Class(CLandUnit) {
    Weapons = {
		MainGun = Class(CDFHLaserHydrogenWeapon) {},
		Art = Class(CDFFusionMortarWeapon) {},
    },
	
	DeathThread = function( self, overkillRatio , instigator)  
		self.Beam1:Destroy()
		self.Beam2:Destroy()
		local army = self:GetArmy()
		
		CreateAttachedEmitter(self, 'L_Arm_Barrel', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'L_Arm_Barrel', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'L_Arm_Barrel', 3.0)
		explosion.CreateFlash( self, 'L_Arm_Barrel', 2.0, army )
		WaitSeconds(1)
		self:HideBone("L_Arm_Barrel", true)
		
		CreateAttachedEmitter(self, 'R_Arm_Barrel', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'R_Arm_Barrel', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'R_Arm_Barrel', 3.0)
		explosion.CreateFlash( self, 'R_Arm_Barrel', 2.0, army )
		WaitSeconds(1)
		self:HideBone("R_Arm_Barrel", true)
		
		CreateAttachedEmitter(self, 'Barrel', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'Barrel', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'Barrel', 3.0)
		explosion.CreateFlash( self, 'Barrel', 2.0, army )
		WaitSeconds(1)
		self:HideBone("Torso", true)

        self:DestroyAllDamageEffects()
        self:CreateWreckage( overkillRatio )
		
		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
}

TypeClass = CSKMDCL0320