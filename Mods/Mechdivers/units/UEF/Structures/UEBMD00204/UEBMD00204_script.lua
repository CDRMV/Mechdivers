#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2304/UEB2304_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Advanced AA System Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').ModularFactoryUnit
local CreateDefaultBuildBeams = import('/lua/effectutilities.lua').CreateDefaultBuildBeams
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

UEBMD00204 = Class(TStructureUnit) {

	Weapons = {
		Dummy = Class(DummyTurretWeapon) {},	
		Dummy2 = Class(DummyTurretWeapon) {},	
	},	
	
	OnCreate = function(self)
		self:CreateEnhancement('MMFacLeftEmpty')
		self:CreateEnhancement('MMFacEmpty')
		self:CreateEnhancement('MMFacRightEmpty')
		self:CreateEnhancement('MMDefaultSkin')
		if not self.ElevatorAnim then
            self.ElevatorAnim = CreateAnimator(self):PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00204/UEBMD00204_AElevator.sca', false):SetRate(2)
            self.Trash:Add(self.ElevatorAnim)
		end	
        TStructureUnit.OnCreate(self)
    end,
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self.CenterUpgrade = nil
		self.RightUpgrade = nil
		self.LeftUpgrade = nil
		if not self.LCraneAnim then
            self.LCraneAnim = CreateAnimator(self):PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00204/UEBMD00204_LCrane.sca', true):SetRate(0)
            self.Trash:Add(self.LCraneAnim)
		end	
		if not self.RCraneAnim then
            self.RCraneAnim = CreateAnimator(self):PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00204/UEBMD00204_RCrane.sca', true):SetRate(0)
            self.Trash:Add(self.RCraneAnim)
		end	
		if not self.CCraneAnim then
            self.CCraneAnim = CreateAnimator(self):PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00204/UEBMD00204_CenterCrane.sca', true):SetRate(0)
            self.Trash:Add(self.CCraneAnim)
		end	
		if not self.CCrane2Anim then
            self.CCrane2Anim = CreateAnimator(self):PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00204/UEBMD00204_CenterCrane2.sca', true):SetRate(0)
            self.Trash:Add(self.CCrane2Anim)
		end	
		if not self.CCraneSlideAnim then
            self.CCraneSlideAnim = CreateAnimator(self):PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00204/UEBMD00204_CenterCrane_Slide.sca', true):SetRate(0)
            self.Trash:Add(self.CCraneSlideAnim)
		end	
		if not self.CCraneSlide2Anim then
            self.CCraneSlide2Anim = CreateAnimator(self):PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00204/UEBMD00204_CenterCrane2_Slide.sca', true):SetRate(0)
            self.Trash:Add(self.CCraneSlide2Anim)
		end	
		self.BuildProgress = false
		self.Unit = nil
	end,
	

    RemoveandInstallModulesThread = function(self)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self.BuildProgress = true
		local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MODULARMECH, self:GetPosition(), 1, 'Ally')
        for _,unit in units do
			if unit and not unit.Dead then
			self.Unit = unit
			end
        end
		if self.Unit == nil then
		
		else
		self.Unit:RemoveCommandCap('RULEUCC_Move')
		self.Unit:RemoveCommandCap('RULEUCC_Attack')
		self.Unit:RemoveCommandCap('RULEUCC_Patrol')
		self.Unit:RemoveCommandCap('RULEUCC_Guard')
		self.Unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
		self.Unit:RemoveCommandCap('RULEUCC_Stop')
		self.Unit:CreateEnhancement('ModularLeftEmpty')
		self.Unit:CreateEnhancement('ModularEmpty')
		self.Unit:CreateEnhancement('ModularRightEmpty')
		self.CenterUpgradeEntity = import('/lua/sim/Entity.lua').Entity()
		self.CenterUpgradeEntity:SetDrawScale(0.42)
		self.CenterUpgradeEntity:SetVizToAllies('Intel')
		self.CenterUpgradeEntity:SetVizToNeutrals('Intel')
		self.CenterUpgradeEntity:SetVizToEnemies('Intel')
		self.RightUpgradeEntity = import('/lua/sim/Entity.lua').Entity()
		self.RightUpgradeEntity:SetDrawScale(0.42)
		self.RightUpgradeEntity:SetVizToAllies('Intel')
		self.RightUpgradeEntity:SetVizToNeutrals('Intel')
		self.RightUpgradeEntity:SetVizToEnemies('Intel')
		self.LeftUpgradeEntity = import('/lua/sim/Entity.lua').Entity()
		self.LeftUpgradeEntity:SetDrawScale(0.42)
		self.LeftUpgradeEntity:SetVizToAllies('Intel')
		self.LeftUpgradeEntity:SetVizToNeutrals('Intel')
		self.LeftUpgradeEntity:SetVizToEnemies('Intel')
		
		local BeamBuildEmtBp = '/effects/emitters/build_beam_01_emit.bp'
		
		self.LBeam = nil
		self.RBeam = nil
		self.CBeam = nil
		self.LEffect = nil
		self.REffect = nil
		self.CEffect = nil
		
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
		
		if self:HasEnhancement( 'MMDefaultSkin' ) then
			self.Unit:CreateEnhancement('ModularDefaultSkin')
		end	
		
		if self:HasEnhancement( 'MMSkin1' ) then
			self.Unit:CreateEnhancement('ModularSkin1')
		end	
		
		local number = nil
		local Modpath = '/mods/Mechdivers/Decorations/Modules/Turrets/'
		local LModpath = '/mods/Mechdivers/Decorations/Modules/Left Arm/'
		local RModpath = '/mods/Mechdivers/Decorations/Modules/Right Arm/'
		
		if self:HasEnhancement( 'MMFacEmpty' ) then
		self.CenterUpgrade = 'ModularEmpty'
		end
		if self:HasEnhancement( 'MMFacAutocannonTurret' ) then
		self.CenterUpgrade = 'ModularAutocannonTurret'
		self.CenterUpgradeEntity:SetMesh(Modpath .. 'Autocannon_mesh')
		self.CenterUpgradeEntity:AttachBoneTo( 0, self.Unit, 'AttachSpecial01' )
		end
		if self:HasEnhancement( 'MMFacGatlingTurret' ) then
		self.CenterUpgrade = 'ModularGatlingTurret'
		self.CenterUpgradeEntity:SetMesh(Modpath .. 'Gatling_mesh')
		self.CenterUpgradeEntity:AttachBoneTo( 0, self.Unit, 'AttachSpecial01' )
		end
		
		if self:HasEnhancement( 'MMFacRightEmpty' ) then
		self.RightUpgrade = 'ModularRightEmpty'
		end
		if self:HasEnhancement( 'MMFacRightBalisticShield' ) then
		self.RightUpgrade = 'ModularRightBalisticShield'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_BalisticShield_mesh')
		self.RightUpgradeEntity:AttachBoneTo('BalisticShield_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightAntiTankCannon' ) then
		self.RightUpgrade = 'ModularRightAntiTankCannon'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_AntiTankCannon_mesh')
		self.RightUpgradeEntity:AttachBoneTo('AntiTankCannon_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightFlameThrower' ) then
		self.RightUpgrade = 'ModularRightFlameThrower'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Flamethrower_mesh')
		self.RightUpgradeEntity:AttachBoneTo('FlameThrower_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightAutoCannon' ) then
		self.RightUpgrade = 'ModularRightAutoCannon'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Autocannon_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Cannon_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightGatling' ) then
		self.RightUpgrade = 'ModularRightGatling'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Gatling_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Gatling_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightMissileLauncher' ) then
		self.RightUpgrade = 'ModularRightMissileLauncher'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_MissileLauncher_mesh')
		self.RightUpgradeEntity:AttachBoneTo('MissileLauncher_Attach', self.Unit, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightScatterGun' ) then
		self.RightUpgrade = 'ModularRightScatterGun'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Shotgun_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Launcher_Attach', self.Unit, 'AttachSpecial03')
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) then
		self.LeftUpgrade = 'ModularLeftEmpty'
		end
		if self:HasEnhancement( 'MMFacLeftBalisticShield' ) then
		self.LeftUpgrade = 'ModularLeftBalisticShield'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_BalisticShield_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('BalisticShield_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftAntiTankCannon' ) then
		self.LeftUpgrade = 'ModularLeftAntiTankCannon'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_AntiTankCannon_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('AntiTankCannon_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftFlameThrower' ) then
		self.LeftUpgrade = 'ModularLeftFlameThrower'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Flamethrower_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('FlameThrower_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftAutoCannon' ) then
		self.LeftUpgrade = 'ModularLeftAutoCannon'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Autocannon_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Cannon_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftGatling' ) then
		self.LeftUpgrade = 'ModularLeftGatling'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Gatling_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Gatling_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftMissileLauncher' ) then
		self.LeftUpgrade = 'ModularLeftMissileLauncher'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_MissileLauncher_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('MissileLauncher_Attach', self.Unit, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftScatterGun' ) then
		self.LeftUpgrade = 'ModularLeftScatterGun'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Shotgun_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Launcher_Attach', self.Unit, 'AttachSpecial02')
		end
		
		 local LeftArmPos = self.Unit:GetPosition('AttachSpecial02')
		 local RightArmPos = self.Unit:GetPosition('AttachSpecial03')
		 local LeftCraneMuzzlePos = self:GetPosition('L_Crane_Muzzle')
		 local RightCraneMuzzlePos = self:GetPosition('R_Crane_Muzzle')
		 
		local XZDist = import("/lua/utilities.lua").XZDistanceTwoVectors
		
		local RightDistance = XZDist(RightCraneMuzzlePos, LeftArmPos)
		local LeftDistance = XZDist(LeftCraneMuzzlePos, RightArmPos)
		
		if LeftDistance > RightDistance then
		     
		if self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		self.RCraneAnim:SetRate(0.5)
		self.RBeam = AttachBeamEntityToEntity(self, 'R_Crane_Muzzle', self.Unit, 'AttachSpecial03', self:GetArmy(), BeamBuildEmtBp)
		self.REffect = CreateAttachedEmitter( self.Unit, 'AttachSpecial03', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false then
		self.LCraneAnim:SetRate(0.5)
		self.LBeam = AttachBeamEntityToEntity(self, 'L_Crane_Muzzle', self.Unit, 'AttachSpecial02', self:GetArmy(), BeamBuildEmtBp)
		self.LEffect = CreateAttachedEmitter( self.Unit, 'AttachSpecial02', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		
		elseif RightDistance > LeftDistance then
		
		if self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		self.RCraneAnim:SetRate(0.5)
		self.RBeam = AttachBeamEntityToEntity(self, 'R_Crane_Muzzle', self.Unit, 'AttachSpecial02', self:GetArmy(), BeamBuildEmtBp)
		self.REffect = CreateAttachedEmitter( self.Unit, 'AttachSpecial02', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false then
		self.LCraneAnim:SetRate(0.5)
		self.LBeam = AttachBeamEntityToEntity(self, 'L_Crane_Muzzle', self.Unit, 'AttachSpecial03', self:GetArmy(), BeamBuildEmtBp)
		self.LEffect = CreateAttachedEmitter( self.Unit, 'AttachSpecial03', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		end
		
		
		if self:HasEnhancement( 'MMFacEmpty' ) == false then
		self.CCraneAnim:SetRate(0.5)
		self.CCraneSlideAnim:SetRate(0.3)
		self.CBeam = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', self.Unit, 'AttachSpecial01', self:GetArmy(), BeamBuildEmtBp)
		self.CCrane2Anim:SetRate(0.5)
		self.CCraneSlide2Anim:SetRate(0.3)
		self.CBeam2 = AttachBeamEntityToEntity(self, 'Center_Crane2_Muzzle', self.Unit, 'AttachSpecial01', self:GetArmy(), BeamBuildEmtBp)
		self.CEffect2 = CreateAttachedEmitter( self.Unit, 'AttachSpecial01', self.Unit:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		
		local CenterUpgradeEntityPos = self.Unit:GetPosition('AttachSpecial01')
		 
		 
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacEmpty' ) == true and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 90
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacEmpty' ) == true and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 30
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacEmpty' ) == false and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 30
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacEmpty' ) == false and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 30
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacEmpty' ) == false and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacEmpty' ) == true and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacEmpty' ) == true and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacEmpty' ) == false and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 0
		end
		
        while self and not self.Dead do
			if number == 90 then
			number = 0
			self:GetWeaponByLabel('Dummy'):SetTargetGround(self:GetPosition())
			self:GetWeaponByLabel('Dummy2'):SetTargetGround(self:GetPosition())
			self.BuildProgress = false
			if self.LBeam then 
			self.LBeam:Destroy()
			end
			if self.RBeam then 
			self.RBeam:Destroy()
			end
			if self.CBeam then 
			self.CBeam:Destroy()
			end
			if self.CBeam2 then 
			self.CBeam2:Destroy()
			end
			if self.LEffect then
			self.LEffect:Destroy()
			end
			if self.REffect then
			self.REffect:Destroy()
			end
			if self.CEffect then
			self.CEffect:Destroy()
			end
			if self.CEffect2 then
			self.CEffect2:Destroy()
			end
			self.CCraneAnim:SetRate(0)
			self.CCraneSlideAnim:SetRate(0)
			self.CCrane2Anim:SetRate(0)
			self.CCraneSlide2Anim:SetRate(0)
			self.LCraneAnim:SetRate(0)
			self.RCraneAnim:SetRate(0)
			if self.LeftUpgradeEntity then
			self.LeftUpgradeEntity:Destroy()
			end
			if self.CenterUpgradeEntity then
			self.CenterUpgradeEntity:Destroy()
			end
			if self.RightUpgradeEntity then
			self.RightUpgradeEntity:Destroy()
			end
			self.Unit:CreateEnhancement(self.LeftUpgrade)
			self.Unit:CreateEnhancement(self.CenterUpgrade)
			self.Unit:CreateEnhancement(self.RightUpgrade)
			self.Unit:AddCommandCap('RULEUCC_Move')
			self.Unit:AddCommandCap('RULEUCC_Attack')
			self.Unit:AddCommandCap('RULEUCC_Patrol')
			self.Unit:AddCommandCap('RULEUCC_Guard')
			self.Unit:AddCommandCap('RULEUCC_RetaliateToggle')
			self.Unit:AddCommandCap('RULEUCC_Stop')
			break
			else
			if self:HasEnhancement( 'MMFacEmpty' ) == true then
			self:GetWeaponByLabel('Dummy'):SetTargetGround(self:GetPosition())
			self:GetWeaponByLabel('Dummy2'):SetTargetGround(self:GetPosition())
			WaitSeconds(0.1)
			number = number + 1
			else
			self:GetWeaponByLabel('Dummy'):SetTargetGround(CenterUpgradeEntityPos)
			self:GetWeaponByLabel('Dummy2'):SetTargetGround(CenterUpgradeEntityPos)
			WaitSeconds(0.1)
			number = number + 1
			end
			end
        end
		WaitSeconds(5)
		
		self:SetBusy(false)
        self:SetBlockCommandQueue(false)
		end
		self:AddToggleCap('RULEUTC_WeaponToggle')
    end,
	
	OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
		if bit == 1 then 
		self.RemoveandInstallModulesThreadHandle = self:ForkThread(self.RemoveandInstallModulesThread)
		self:SetScriptBit('RULEUTC_WeaponToggle', false)
		end
    end,

    OnScriptBitClear = function(self, bit)
        TStructureUnit.OnScriptBitClear(self, bit)
		if bit == 1 then 
		
		end
    end,
	
	
	OnKilled = function(self, instigator, type, overkillRatio)
		if self.BuildProgress == true then
			if self.LBeam then 
			self.LBeam:Destroy()
			end
			if self.RBeam then 
			self.RBeam:Destroy()
			end
			if self.CBeam then 
			self.CBeam:Destroy()
			end
			if self.CBeam2 then 
			self.CBeam2:Destroy()
			end
			if self.LEffect then
			self.LEffect:Destroy()
			end
			if self.REffect then
			self.REffect:Destroy()
			end
			if self.CEffect then
			self.CEffect:Destroy()
			end
			if self.CEffect2 then
			self.CEffect2:Destroy()
			end
			self.CCraneAnim:SetRate(0)
			self.CCraneSlideAnim:SetRate(0)
			self.CCrane2Anim:SetRate(0)
			self.CCraneSlide2Anim:SetRate(0)
			self.LCraneAnim:SetRate(0)
			self.RCraneAnim:SetRate(0)
			if self.LeftUpgradeEntity then
			self.LeftUpgradeEntity:Destroy()
			end
			if self.CenterUpgradeEntity then
			self.CenterUpgradeEntity:Destroy()
			end
			if self.RightUpgradeEntity then
			self.RightUpgradeEntity:Destroy()
			end
			
			if self.Unit and not self.Unit.Dead then
			self.Unit:AddCommandCap('RULEUCC_Move')
			self.Unit:AddCommandCap('RULEUCC_Attack')
			self.Unit:AddCommandCap('RULEUCC_Patrol')
			self.Unit:AddCommandCap('RULEUCC_Guard')
			self.Unit:AddCommandCap('RULEUCC_RetaliateToggle')
			self.Unit:AddCommandCap('RULEUCC_Stop')
			end
		end
        TStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
	
	OnReclaimed = function(self, reclaimer)
		if self.BuildProgress == true then
			if self.LBeam then 
			self.LBeam:Destroy()
			end
			if self.RBeam then 
			self.RBeam:Destroy()
			end
			if self.CBeam then 
			self.CBeam:Destroy()
			end
			if self.CBeam2 then 
			self.CBeam2:Destroy()
			end
			if self.LEffect then
			self.LEffect:Destroy()
			end
			if self.REffect then
			self.REffect:Destroy()
			end
			if self.CEffect then
			self.CEffect:Destroy()
			end
			if self.CEffect2 then
			self.CEffect2:Destroy()
			end
			self.CCraneAnim:SetRate(0)
			self.CCraneSlideAnim:SetRate(0)
			self.CCrane2Anim:SetRate(0)
			self.CCraneSlide2Anim:SetRate(0)
			self.LCraneAnim:SetRate(0)
			self.RCraneAnim:SetRate(0)
			if self.LeftUpgradeEntity then
			self.LeftUpgradeEntity:Destroy()
			end
			if self.CenterUpgradeEntity then
			self.CenterUpgradeEntity:Destroy()
			end
			if self.RightUpgradeEntity then
			self.RightUpgradeEntity:Destroy()
			end
			
			if self.Unit and not self.Unit.Dead then
			self.Unit:AddCommandCap('RULEUCC_Move')
			self.Unit:AddCommandCap('RULEUCC_Attack')
			self.Unit:AddCommandCap('RULEUCC_Patrol')
			self.Unit:AddCommandCap('RULEUCC_Guard')
			self.Unit:AddCommandCap('RULEUCC_RetaliateToggle')
			self.Unit:AddCommandCap('RULEUCC_Stop')
			end
		end
        TStructureUnit.OnReclaimed(self, reclaimer)
    end,	

}

TypeClass = UEBMD00204