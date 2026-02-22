#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0305/UEA0305_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Heavy Gunship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local TWeapons = import('/lua/terranweapons.lua')
local TDFGaussCannonWeapon = TWeapons.TDFGaussCannonWeapon

CSKMDTA0301b = Class(TAirUnit) {
    
    EngineRotateBones = {'Jet_Front',},
    BeamExhaustCruise = '/effects/emitters/gunship_thruster_beam_01_emit.bp',
    BeamExhaustIdle = '/effects/emitters/gunship_thruster_beam_02_emit.bp',
    
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'AC_Muzzle' then
		CreateAttachedEmitter(self.unit, 'AC_Shell', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		},
    },
	
	OnCreate = function(self)
        TAirUnit.OnCreate(self)
        self.EngineManipulators = {}

        # create the engine thrust manipulators
        for key, value in self.EngineRotateBones do
            table.insert(self.EngineManipulators, CreateThrustController(self, "thruster", value))
        end

        # set up the thursting arcs for the engines
        for key,value in self.EngineManipulators do
            #                          XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
            value:SetThrustingParam( 0, 0.0, 0, 0, 0, 0, 0,      0 )
        end
    end,
    
    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		self.AnimationManipulator:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTA0301/CSKMDTA0301_UnpackAll.sca', false):SetRate(1)
        self.EngineManipulators = {}

        # set up the thursting arcs for the engines
        for key,value in self.EngineManipulators do
            #                          XMAX, XMIN, YMAX,YMIN, ZMAX,ZMIN, TURNMULT, TURNSPEED
            value:SetThrustingParam( -0.0, 0.0, -0.25, 0.25, -0.1, 1, 1.0,      0.25 )
        end

        for k, v in self.EngineManipulators do
            self.Trash:Add(v)
        end
		
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.unit = CreateUnitHPR('CSKMDTL0303', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		self.unit:AttachBoneTo('AttachPoint', self, 'SpawnAttachpoint1')
		SetIgnoreArmyUnitCap(self:GetArmy(), false)

    end,
	
	OnTransportDetach = function(self, attachBone, unit)
        TAirUnit.OnTransportDetach(self, attachBone, unit)
		ForkThread(function()
		local Dummy = unit:GetWeaponByLabel('Dummy')
        local LCannon = unit:GetWeaponByLabel('L_Cannon')
		local RCannon = unit:GetWeaponByLabel('R_Cannon')
		local LMissileLauncher = unit:GetWeaponByLabel('L_MissileLauncher')
		local RMissileLauncher = unit:GetWeaponByLabel('R_MissileLauncher')
		local LGatlingCannon = unit:GetWeaponByLabel('L_GatlingCannon')
		local RGatlingCannon = unit:GetWeaponByLabel('R_GatlingCannon')
		Dummy:SetEnabled(true)
		LCannon:SetEnabled(true)
		RCannon:SetEnabled(true)
		LMissileLauncher:SetEnabled(false)
		RMissileLauncher:SetEnabled(false)
		LGatlingCannon:SetEnabled(false)
		RGatlingCannon:SetEnabled(false)
		self.unit:SetUnSelectable(false)
		local position = self:GetPosition()
		IssueMove({self}, {position[1] + 120, position[2], position[3] + 120})
		WaitSeconds(10)
		self:Destroy()
		end)
    end,
	

}
TypeClass = CSKMDTA0301b