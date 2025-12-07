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
local ModEffects = '/mods/Mechdivers/effects/emitters/'

CSKMDCL0314 = Class(CWalkingLandUnit) {
    Weapons = {
        MainGun = Class(CDFLaserFusionWeapon) {},
		Dummy = Class(DummyTurretWeapon) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self.PrepareToBuildManipulator = CreateAnimator(self)
        self.PrepareToBuildManipulator:PlayAnim(self:GetBlueprint().Display.AnimationBuild, false):SetRate(0)
		self.AnimationManipulator = CreateAnimator(self)
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationDeco, true):SetRate(0.5)
		ChangeState(self, self.IdleState)
    end,
	
	OnFailedToBuild = function(self)
        CWalkingLandUnit.OnFailedToBuild(self)
        ChangeState(self, self.IdleState)
    end,
	
	IdleState = State {
        OnStartBuild = function(self, unitBuilding, order)
		    unitBuilding:HideStuff()
            self:SetBusy(true)
            CWalkingLandUnit.OnStartBuild(self, unitBuilding, order)
            self.UnitBeingBuilt = unitBuilding
            self.PrepareToBuildManipulator:SetRate(1)
            ChangeState(self, self.BuildingState)
        end,

        Main = function(self)
            self.PrepareToBuildManipulator:SetRate(-1)
            self:DetachAll('Build')
            self:SetBusy(false)
        end,

    },
	
	BuildingState = State {

        Main = function(self)
            local unitBuilding = self.UnitBeingBuilt
            self.PrepareToBuildManipulator:SetRate(1)
            local bone = 'Build'
            self:DetachAll(bone)
            if not self.UnitBeingBuilt:IsDead() then
                unitBuilding:AttachBoneTo( -2, self, bone )
            end
            WaitSeconds(3)
            WaitFor( self.PrepareToBuildManipulator )
            local unitBuilding = self.UnitBeingBuilt
            self.UnitDoneBeingBuilt = false
        end,

        OnStopBuild = function(self, unitBeingBuilt)
            CWalkingLandUnit.OnStopBuild(self, unitBeingBuilt)
			self.PrepareToBuildManipulator:SetRate(-1)
			self:DetachAll('Build')
			local  worldPos = self:CalculateWorldPositionFromRelative({0, 0, 5})
            IssueMoveOffFactory({unitBeingBuilt}, worldPos)
			ChangeState(self, self.IdleState)
        end,

    },
	
}

TypeClass = CSKMDCL0314