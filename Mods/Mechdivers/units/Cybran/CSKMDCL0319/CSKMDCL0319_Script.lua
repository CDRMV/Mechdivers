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
local CDFLaserHydrogenWeapon = ModWeaponsFile.CDFLaserHydrogenWeapon
local CDFHLaserHydrogenWeapon = ModWeaponsFile.CDFHLaserHydrogenWeapon
local ModEffects = '/mods/Mechdivers/effects/emitters/'
local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone

CSKMDCL0319 = Class(CLandUnit) {
    Weapons = {
        GatlingGuns = Class(CDFLaserHydrogenWeapon) {},
		MainGun = Class(CDFHLaserHydrogenWeapon) {},
        Missile01 = Class(CAAMissileNaniteWeapon) {},
    },
	
	OnCreate = function(self)
		self:HideBone('R_Turret_Muzzle_Effect', false)
		self:HideBone('L_Turret_Muzzle_Effect', false)
		self.Beam1 = CreateBeamEmitterOnEntity(self, 'Left_Gatling_Scan', self:GetArmy(), '/mods/Mechdivers/effects/emitters/vox_beam_01_emit.bp')
		self.Beam2 = CreateBeamEmitterOnEntity(self, 'Right_Gatling_Scan', self:GetArmy(), '/mods/Mechdivers/effects/emitters/vox_beam_01_emit.bp')
		--[[
		ScanMesh = '/mods/Mechdivers/Decorations/CybranVoxScan_mesh'
			self.Scan = import('/lua/sim/Entity.lua').Entity()
			self.Scan:AttachBoneTo( -2, self, 'Left_Gatling_Scan' )
			self.Scan:SetMesh(ScanMesh)
			self.Scan:SetDrawScale(0.02)
			self.Scan:SetVizToAllies('Intel')
			self.Scan:SetVizToNeutrals('Intel')
			self.Scan:SetVizToEnemies('Intel')
			self.Scan2 = import('/lua/sim/Entity.lua').Entity()
			self.Scan2:AttachBoneTo( -2, self, 'Right_Gatling_Scan' )
			self.Scan2:SetMesh(ScanMesh)
			self.Scan2:SetDrawScale(0.02)
			self.Scan2:SetVizToAllies('Intel')
			self.Scan2:SetVizToNeutrals('Intel')
			self.Scan2:SetVizToEnemies('Intel')
		]]--	
		CLandUnit.OnCreate(self)
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		self.Beam1:Destroy()
		self.Beam2:Destroy()
		local army = self:GetArmy()
		CreateAttachedEmitter(self, 'Left_Gatling_Barrel', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'Left_Gatling_Barrel', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'Left_Gatling_Barrel', 3.0)
		explosion.CreateFlash( self, 'Left_Gatling_Barrel', 2.0, army )
		WaitSeconds(1)
		self:HideBone("Left_Gatling_Barrel", true)
		
		CreateAttachedEmitter(self, 'L_Turret_Barrel', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'L_Turret_Barrel', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'L_Turret_Barrel', 3.0)
		explosion.CreateFlash( self, 'L_Turret_Barrel', 2.0, army )
		WaitSeconds(1)
		self:HideBone("L_Turret_Barrel", true)
		
		CreateAttachedEmitter(self, 'Right_Gatling_Barrel', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'Right_Gatling_Barrel', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'Right_Gatling_Barrel', 3.0)
		explosion.CreateFlash( self, 'Right_Gatling_Barrel', 2.0, army )
		WaitSeconds(1)
		self:HideBone("Right_Gatling_Barrel", true)
		
		CreateAttachedEmitter(self, 'R_Turret_Barrel', army, '/effects/emitters/destruction_explosion_concussion_ring_03_emit.bp')
        CreateAttachedEmitter(self,'R_Turret_Barrel', army, '/effects/emitters/explosion_fire_sparks_02_emit.bp')
		CreateDeathExplosion( self, 'R_Turret_Barrel', 3.0)
		explosion.CreateFlash( self, 'R_Turret_Barrel', 2.0, army )
		WaitSeconds(1)
		self:HideBone("R_Turret_Barrel", true)
		
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

TypeClass = CSKMDCL0319