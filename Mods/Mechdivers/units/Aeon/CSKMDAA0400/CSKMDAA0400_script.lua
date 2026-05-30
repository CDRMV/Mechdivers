#****************************************************************************
#**
#**  File     :  /cdimage/units/UAA0310/UAA0310_script.lua
#**  Author(s):  John Comes
#**
#**  Summary  :  Aeon CZAR Script
#**
#**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AAirUnit = import('/lua/defaultunits.lua').MobileUnit
local aWeapons = import('/lua/aeonweapons.lua')
local ADFQuantumBeam = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').ADFQuantumBeam
local ADFQuantumBeam2 = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').ADFQuantumBeam2
local explosion = import('/lua/defaultexplosions.lua')
local ADFCannonQuantumWeapon = aWeapons.ADFCannonQuantumWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

CSKMDAA0400 = Class(AAirUnit) {
    DestroyNoFallRandomChance = 1.1,
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {},
        QuantumBeamGeneratorWeapon = Class(ADFQuantumBeam2){
		
		PlayFxWeaponUnpackSequence = function(self)
		self.unit.OpenAnimManip:Destroy()
		ADFQuantumBeam.PlayFxWeaponUnpackSequence(self)
		end,
		
			PlayFxWeaponPackSequence = function(self)
				self.unit.OpenAnimManip = CreateAnimator(self.unit)
				self.unit.OpenAnimManip:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAA0400/CSKMDAA0400_Fly.sca', true):SetRate(0.1)
                ADFQuantumBeam.PlayFxWeaponPackSequence(self)
            end,
		},
		QuantumGun01 = Class(ADFCannonQuantumWeapon) {},
		QuantumGun02 = Class(ADFCannonQuantumWeapon) {},
		QuantumGun03 = Class(ADFCannonQuantumWeapon) {},
		QuantumGun04 = Class(ADFCannonQuantumWeapon) {},
		QuantumBeam1 = Class(ADFQuantumBeam) {},
		QuantumBeam2 = Class(ADFQuantumBeam) {},
		QuantumBeam3 = Class(ADFQuantumBeam) {},
		QuantumBeam4 = Class(ADFQuantumBeam) {},
    },

    OnKilled = function(self, instigator, type, overkillRatio)
        local wep = self:GetWeaponByLabel('QuantumBeamGeneratorWeapon')
        for k, v in wep.Beams do
            v.Beam:Disable()
        end

        self.detector = CreateCollisionDetector(self)
        self.Trash:Add(self.detector)
        self.detector:WatchBone('Left_Turret01_Muzzle')
        self.detector:WatchBone('Right_Turret01_Muzzle')
        self.detector:WatchBone('Left_Turret02_WepFocus')
        self.detector:WatchBone('Right_Turret02_WepFocus')
        self.detector:WatchBone('Left_Turret03_Muzzle')
        self.detector:WatchBone('Right_Turret03_Muzzle')
        self.detector:WatchBone('Attachpoint01')
        self.detector:WatchBone('Attachpoint02')
        self.detector:EnableTerrainCheck(true)
        self.detector:Enable()


        AAirUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    OnAnimTerrainCollision = function(self, bone,x,y,z)
        DamageArea(self, {x,y,z}, 5, 1000, 'Default', true, false)
        explosion.CreateDefaultHitExplosionAtBone( self, bone, 5.0 )
        explosion.CreateDebrisProjectiles(self, explosion.GetAverageBoundingXYZRadius(self), {self:GetUnitSizes()})
    end,

    BuildAttachBone = 'CSKMDAA0400',

    OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.OpenAnimManip = CreateAnimator(self)
		self.Trash:Add(self.OpenAnimManip)
		self.OpenAnimManip:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAA0400/CSKMDAA0400_Fly.sca', true):SetRate(0.1)
        ChangeState(self, self.IdleState)
		self:HideBone('Center_Beam',false)
    end,

    OnFailedToBuild = function(self)
        AAirUnit.OnFailedToBuild(self)
        ChangeState(self, self.IdleState)
    end,

    IdleState = State {
        Main = function(self)
            self:DetachAll(self.BuildAttachBone)
            self:SetBusy(false)
        end,

        OnStartBuild = function(self, unitBuilding, order)
            AAirUnit.OnStartBuild(self, unitBuilding, order)
            self.UnitBeingBuilt = unitBuilding
            ChangeState(self, self.BuildingState)
        end,
    },

    BuildingState = State {
        Main = function(self)
            local unitBuilding = self.UnitBeingBuilt
            self:SetBusy(true)
            local bone = self.BuildAttachBone
            self:DetachAll(bone)
            unitBuilding:HideBone(0, true)
            self.UnitDoneBeingBuilt = false
        end,

        OnStopBuild = function(self, unitBeingBuilt)
            AAirUnit.OnStopBuild(self, unitBeingBuilt)
            ChangeState(self, self.FinishedBuildingState)
        end,
    },

    FinishedBuildingState = State {
        Main = function(self)
            self:SetBusy(true)
            local unitBuilding = self.UnitBeingBuilt
            unitBuilding:DetachFrom(true)
            self:DetachAll(self.BuildAttachBone)
            if self:TransportHasAvailableStorage() then
                self:AddUnitToStorage(unitBuilding)
            else
                local worldPos = self:CalculateWorldPositionFromRelative({0, 0, -20})
                IssueMoveOffFactory({unitBuilding}, worldPos)
                unitBuilding:ShowBone(0,true)
            end
            self:SetBusy(false)
            self:RequestRefreshUI()
            ChangeState(self, self.IdleState)
        end,
    },
}

TypeClass = CSKMDAA0400