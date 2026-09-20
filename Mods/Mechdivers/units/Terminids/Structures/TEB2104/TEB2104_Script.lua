#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2101/UEB2101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Light Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local AcidWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').AcidWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

TEB2104 = Class(TStructureUnit) {
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
		self.unit:GetWeaponByLabel('AAGun'):SetTargetEntity(self.unit:GetTargetEntity())
		self.unit:GetWeaponByLabel('MainGun'):SetEnabled(false)
		self.unit:GetWeaponByLabel('AAGun'):SetEnabled(true)
		end
		if self.unit:GetTargetEntity() and self.unit:GetBlueprint().CategoriesHash["LAND"] or self.unit:GetBlueprint().CategoriesHash["NAVAL"] then
		LOG('Ground')
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

TypeClass = TEB2104