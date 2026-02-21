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
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local ModEffects = '/mods/Mechdivers/effects/emitters/'
local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon		
CSKMDCL0319 = Class(CLandUnit) {
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {},
        HeadGuns = Class(CDFLaserHydrogenWeapon) {},
		MainGun = Class(CDFHLaserHydrogenWeapon) {},
		LMainGun = Class(CDFHLaserHydrogenWeapon) {},
		RMainGun = Class(CDFHLaserHydrogenWeapon) {},
        Missile01 = Class(CAAMissileNaniteWeapon) {},
    },
	
	OnCreate = function(self)
		self:HideBone('R_Turret_Muzzle_Effect', false)
		self:HideBone('L_Turret_Muzzle_Effect', false)
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
		CLandUnit.OnCreate(self)
    end,
}

TypeClass = CSKMDCL0319