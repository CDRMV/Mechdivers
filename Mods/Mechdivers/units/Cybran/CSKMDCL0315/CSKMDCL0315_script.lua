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
local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities

CSKMDCL0315 = Class(CWalkingLandUnit) {
    Weapons = {
        MainGun = Class(CDFLaserFusionWeapon) {},
		Dummy = Class(DummyTurretWeapon) {},
    },
	
	OnCreate = function(self)
        CWalkingLandUnit.OnCreate(self)
		self.Effect = false
		self:SetScriptBit('RULEUTC_JammingToggle', false)
		self:SetScriptBit('RULEUTC_JammingToggle', true)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetScriptBit('RULEUTC_JammingToggle', false)
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
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 2 then 
		self:SetMaintenanceConsumptionInactive()
		KillThread(self.AutomaticDisableShieldThreadHandle)
		self.Effect = false
		if self.MySpinner then
        self.MySpinner:SetTargetSpeed(0)
		end
		if self.effect then
		self.effect:Destroy()
		self.effect = nil
		end
		if self.Beam then
		self.Beam:Destroy()
		self.Beam = nil
		end
		end
		local unitPos = self:GetPosition()
		local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 30, 'Enemy')
		for _,unit in units do
			unit:EnableShield()	
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 2 then
		ForkThread(function()
		self:SetMaintenanceConsumptionActive()
		self.Effect = true
		self.AutomaticDisableShieldThreadHandle = self:ForkThread(self.AutomaticDisableShieldThread)
		if self.effect then
		self.effect:Destroy()
		self.effect = nil
		end
		if self.Beam then
		self.Beam:Destroy()
		self.Beam = nil
		end
		self.Beam = CreateBeamEmitter('/mods/Mechdivers/effects/emitters/jammer_beam_01_emit.bp', self:GetArmy())
		AttachBeamToEntity(self.Beam, self, 'BeamEffect', self:GetArmy())
        if not self.MySpinner then
            self.MySpinner = CreateRotator(self, 'Spinner', 'y', nil, 0, 45, 180)
            self.Trash:Add(self.MySpinner)
        end
        CWalkingLandUnit.OnIntelEnabled(self)
        self.MySpinner:SetTargetSpeed(180)
		while true do
		if self.Effect == true and not self:IsDead() then
        self.effect = CreateAttachedEmitter(self, 'JammerEffect', self:GetArmy(), ModEffects .. 'cybran_jammer_ambient_01_emit.bp'):ScaleEmitter(0.2):OffsetEmitter(0,0,-1) 
		end
		WaitSeconds(4.5)
		end
		end)		
		end
    end,

	AutomaticDisableShieldThread = function(self)
		local army = self:GetArmy()
 		while not self:IsDead() do
			local unitPos = self:GetPosition()
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 30, 'Enemy')
            for _,unit in units do
			    if GetDistanceBetweenTwoEntities(unit, self) < 29 then
                    unit:DisableShield()
				elseif GetDistanceBetweenTwoEntities(unit, self) > 29 then
					unit:EnableShield()	
                end
            end
            WaitSeconds(0.1)
		end	
    end,
	
}

TypeClass = CSKMDCL0315