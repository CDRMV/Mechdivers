#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0106/UEL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Light Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local AcidWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').AcidWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon


TEL0103 = Class(TWalkingLandUnit) {
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {
		IdleState = State (DummyTurretWeapon.IdleState) {
        Main = function(self)
                    DummyTurretWeapon.IdleState.Main(self)
                end,
                
        OnGotTarget = function(self)
		ForkThread( function()
		self:PlayFxWeaponUnpackSequence()
		end)
		if self.unit:GetTargetEntity() and self.unit:GetBlueprint().CategoriesHash["AIR"] then
		LOG('Air')
		self.unit:GetWeaponByLabel('Dummy'):ChangeMaxRadius(44)
		self.unit:GetWeaponByLabel('Dummy'):ChangeMinRadius(0)
		self.unit:GetWeaponByLabel('AAGun'):SetTargetEntity(self.unit:GetTargetEntity())
		self.unit:GetWeaponByLabel('MainGun'):SetEnabled(false)
		self.unit:GetWeaponByLabel('AAGun'):SetEnabled(true)
		end
		if self.unit:GetTargetEntity() and self.unit:GetBlueprint().CategoriesHash["LAND"] or self.unit:GetBlueprint().CategoriesHash["NAVAL"] then
		LOG('Ground')
		self.unit:GetWeaponByLabel('Dummy'):ChangeMaxRadius(30)
		self.unit:GetWeaponByLabel('Dummy'):ChangeMinRadius(5)
		self.unit:GetWeaponByLabel('MainGun'):SetTargetEntity(self.unit:GetTargetEntity())
		self.unit:GetWeaponByLabel('AAGun'):SetEnabled(false)
		self.unit:GetWeaponByLabel('MainGun'):SetEnabled(true)
		end
               DummyTurretWeapon.OnGotTarget(self)
        end,                
            },
        OnLostTarget = function(self)
		self.unit:GetWeaponByLabel('AAGun'):ResetTarget()
		self.unit:GetWeaponByLabel('MainGun'):ResetTarget()
		DummyTurretWeapon.OnLostTarget(self)
        end, 
		},
        MainGun = Class(AcidWeapon) {},
		AAGun = Class(AcidWeapon) {},
    },
}
TypeClass = TEL0103

