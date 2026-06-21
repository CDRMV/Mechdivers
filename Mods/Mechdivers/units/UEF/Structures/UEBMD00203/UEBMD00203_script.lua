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

UEBMD00203 = Class(TStructureUnit) {

	Weapons = {
		Dummy = Class(DummyTurretWeapon) {},	
	},	
	
	OnCreate = function(self)
		self:CreateEnhancement('MMFacLeftEmpty')
		self:CreateEnhancement('MMFacEmpty')
		self:CreateEnhancement('MMFacLTurretEmpty')
		self:CreateEnhancement('MMFacRTurretEmpty')
		self:CreateEnhancement('MMFacRightEmpty')
		self:CreateEnhancement('MMDefaultSkin')
        TStructureUnit.OnCreate(self)
    end,
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		self.LTurretUpgrade = nil
		self.RTurretUpgrade = nil
		self.SubSystemsUpgrade = nil
		self.RightUpgrade = nil
		self.LeftUpgrade = nil
		self.ChassisUpgrade = nil
		if not self.LCraneAnim then
            self.LCraneAnim = CreateAnimator(self):PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00203/UEBMD00203_LCrane.sca', true):SetRate(0)
            self.Trash:Add(self.LCraneAnim)
		end	
		if not self.RCraneAnim then
            self.RCraneAnim = CreateAnimator(self):PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00203/UEBMD00203_RCrane.sca', true):SetRate(0)
            self.Trash:Add(self.RCraneAnim)
		end	
		if not self.CCraneAnim then
            self.CCraneAnim = CreateAnimator(self):PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00203/UEBMD00203_CenterCrane.sca', true):SetRate(0)
            self.Trash:Add(self.CCraneAnim)
		end	
		if not self.CCraneSlideAnim then
            self.CCraneSlideAnim = CreateAnimator(self):PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00203/UEBMD00203_CenterCrane_Slide.sca', true):SetRate(0)
            self.Trash:Add(self.CCraneSlideAnim)
		end	
		self.BuildProgress = false
	end,
	
	OnStartBuild = function(self, unitBeingBuilt, order )
        TStructureUnit.OnStartBuild(self, unitBeingBuilt, order )
		unitBeingBuilt:HideBone(0, true)
    end,
	
    OnStopBuild = function(self, unitBeingBuilt, order )
        TStructureUnit.OnStopBuild(self, unitBeingBuilt, order )
        unitBeingBuilt:ShowBone(0, true)
    end,
	

    FinishBuildThread = function(self, unitBeingBuilt, order )
		self.BuildProgress = true
		self.RTurretUpgradeEntity = import('/lua/sim/Entity.lua').Entity()
		self.RTurretUpgradeEntity:SetDrawScale(0.42)
		self.RTurretUpgradeEntity:SetVizToAllies('Intel')
		self.RTurretUpgradeEntity:SetVizToNeutrals('Intel')
		self.RTurretUpgradeEntity:SetVizToEnemies('Intel')
		self.LTurretUpgradeEntity = import('/lua/sim/Entity.lua').Entity()
		self.LTurretUpgradeEntity:SetDrawScale(0.42)
		self.LTurretUpgradeEntity:SetVizToAllies('Intel')
		self.LTurretUpgradeEntity:SetVizToNeutrals('Intel')
		self.LTurretUpgradeEntity:SetVizToEnemies('Intel')
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
		self.CBeam2 = nil
		self.LEffect = nil
		self.REffect = nil
		self.CEffect = nil
		self.CEffect2 = nil
		
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
		
		if self:HasEnhancement( 'MMDefaultSkin' ) then
			unitBeingBuilt:CreateEnhancement('ModularDefaultSkin')
		end	
		
		if self:HasEnhancement( 'MMSkin1' ) then
			unitBeingBuilt:CreateEnhancement('ModularSkin1')
		end	
		
		if self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true then
		self.ChassisUpgrade = 'ModularDefaultChassis'
		unitBeingBuilt:CreateEnhancement(self.ChassisUpgrade)	
		elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true then
		self.ChassisUpgrade = 'ModularLTurretChassis'
		unitBeingBuilt:CreateEnhancement(self.ChassisUpgrade)
		elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false then
		self.ChassisUpgrade = 'ModularRTurretChassis'
		unitBeingBuilt:CreateEnhancement(self.ChassisUpgrade)
		elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false then
		self.ChassisUpgrade = 'ModularBothTurretsChassis'
		unitBeingBuilt:CreateEnhancement(self.ChassisUpgrade)
		end
		
        local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationFinishBuildLand
        if bpAnim and EntityCategoryContains(categories.LAND, unitBeingBuilt) then
		if not self.RollOffAnim then
            self.RollOffAnim = CreateAnimator(self):PlayAnim(bpAnim)
            self.Trash:Add(self.RollOffAnim)
		end	
            WaitTicks(1)
			self.RollOffAnim:SetRate(0.2)			
            WaitFor(self.RollOffAnim)
        end
		local number = nil
		local Modpath = '/mods/Mechdivers/Decorations/Modules/Turrets/'
		local LModpath = '/mods/Mechdivers/Decorations/Modules/Left Arm/'
		local RModpath = '/mods/Mechdivers/Decorations/Modules/Right Arm/'
		
		
		if self:HasEnhancement( 'MMFacEmpty' ) then
		self.SubSystemsUpgrade = 'ModularEmpty'
		end
		
		if self:HasEnhancement( 'MMFacLTurretEmpty' ) then
		self.LTurretUpgrade = 'ModularLTurretEmpty'
		end
		
		if self:HasEnhancement( 'MMFacRTurretEmpty' ) then
		self.RTurretUpgrade = 'ModularRTurretEmpty'
		end
		
		if self:HasEnhancement( 'MMFacAutocannonTurret' ) then
		self.RTurretUpgrade = 'ModularAutocannonTurret'
		self.RTurretUpgradeEntity:SetMesh(Modpath .. 'Autocannon_mesh')
		self.RTurretUpgradeEntity:AttachBoneTo( 0, unitBeingBuilt, 'AttachSpecial01' )
		end
		if self:HasEnhancement( 'MMFacGatlingTurret' ) then
		self.RTurretUpgrade = 'ModularGatlingTurret'
		self.RTurretUpgradeEntity:SetMesh(Modpath .. 'Gatling_mesh')
		self.RTurretUpgradeEntity:AttachBoneTo( 0, unitBeingBuilt, 'AttachSpecial01' )
		end
		if self:HasEnhancement( 'MMFacAutocannonTurret2' ) then
		self.LTurretUpgrade = 'ModularAutocannonTurret2'
		self.LTurretUpgradeEntity:SetMesh(Modpath .. 'Autocannon_mesh')
		self.LTurretUpgradeEntity:AttachBoneTo( 0, unitBeingBuilt, 'AttachSpecial04' )
		end
		if self:HasEnhancement( 'MMFacGatlingTurret2' ) then
		self.LTurretUpgrade = 'ModularGatlingTurret2'
		self.LTurretUpgradeEntity:SetMesh(Modpath .. 'Gatling_mesh')
		self.LTurretUpgradeEntity:AttachBoneTo( 0, unitBeingBuilt, 'AttachSpecial04' )
		end
		
		if self:HasEnhancement( 'MMFacRightEmpty' ) then
		self.RightUpgrade = 'ModularRightEmpty'
		end
		if self:HasEnhancement( 'MMFacRightBalisticShield' ) then
		self.RightUpgrade = 'ModularRightBalisticShield'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_BalisticShield_mesh')
		self.RightUpgradeEntity:AttachBoneTo('BalisticShield_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightAntiTankCannon' ) then
		self.RightUpgrade = 'ModularRightAntiTankCannon'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_AntiTankCannon_mesh')
		self.RightUpgradeEntity:AttachBoneTo('AntiTankCannon_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightFlameThrower' ) then
		self.RightUpgrade = 'ModularRightFlameThrower'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Flamethrower_mesh')
		self.RightUpgradeEntity:AttachBoneTo('FlameThrower_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightAutoCannon' ) then
		self.RightUpgrade = 'ModularRightAutoCannon'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Autocannon_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Cannon_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightGatling' ) then
		self.RightUpgrade = 'ModularRightGatling'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Gatling_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Gatling_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightMissileLauncher' ) then
		self.RightUpgrade = 'ModularRightMissileLauncher'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_MissileLauncher_mesh')
		self.RightUpgradeEntity:AttachBoneTo('MissileLauncher_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightScatterGun' ) then
		self.RightUpgrade = 'ModularRightScatterGun'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Shotgun_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Launcher_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) then
		self.LeftUpgrade = 'ModularLeftEmpty'
		end
		if self:HasEnhancement( 'MMFacLeftBalisticShield' ) then
		self.LeftUpgrade = 'ModularLeftBalisticShield'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_BalisticShield_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('BalisticShield_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftAntiTankCannon' ) then
		self.LeftUpgrade = 'ModularLeftAntiTankCannon'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_AntiTankCannon_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('AntiTankCannon_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftFlameThrower' ) then
		self.LeftUpgrade = 'ModularLeftFlameThrower'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Flamethrower_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('FlameThrower_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftAutoCannon' ) then
		self.LeftUpgrade = 'ModularLeftAutoCannon'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Autocannon_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Cannon_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftGatling' ) then
		self.LeftUpgrade = 'ModularLeftGatling'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Gatling_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Gatling_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftMissileLauncher' ) then
		self.LeftUpgrade = 'ModularLeftMissileLauncher'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_MissileLauncher_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('MissileLauncher_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftScatterGun' ) then
		self.LeftUpgrade = 'ModularLeftScatterGun'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Shotgun_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Launcher_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		
		local BothTurretsUpgradeEntityPos = unitBeingBuilt:GetPosition()
		local LTurretUpgradeEntityPos = unitBeingBuilt:GetPosition('AttachSpecial01')
		local RTurretUpgradeEntityPos = unitBeingBuilt:GetPosition('AttachSpecial04')
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false then
		self.RCraneAnim:SetRate(0.5)
		self.RBeam = AttachBeamEntityToEntity(self, 'R_Crane_Muzzle', unitBeingBuilt, 'AttachSpecial02', self:GetArmy(), BeamBuildEmtBp)
		self.REffect = CreateAttachedEmitter( unitBeingBuilt, 'AttachSpecial02', unitBeingBuilt:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		if self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false then
		self.CCraneAnim:SetRate(0.5)
		self.CCraneSlideAnim:SetRate(0.3)
		self.CBeam = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', unitBeingBuilt, 'AttachSpecial01', self:GetArmy(), BeamBuildEmtBp)
		self.CEffect = CreateAttachedEmitter( unitBeingBuilt, 'AttachSpecial01', unitBeingBuilt:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		self.CBeam2 = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', unitBeingBuilt, 'AttachSpecial04', self:GetArmy(), BeamBuildEmtBp)
		self.CEffect2 = CreateAttachedEmitter( unitBeingBuilt, 'AttachSpecial04', unitBeingBuilt:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true then
		self.CCraneAnim:SetRate(0.5)
		self.CCraneSlideAnim:SetRate(0.3)
		self.CBeam = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', unitBeingBuilt, 'AttachSpecial04', self:GetArmy(), BeamBuildEmtBp)
		self.CEffect = CreateAttachedEmitter( unitBeingBuilt, 'AttachSpecial04', unitBeingBuilt:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false then
		self.CCraneAnim:SetRate(0.5)
		self.CCraneSlideAnim:SetRate(0.3)
		self.CBeam = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', unitBeingBuilt, 'AttachSpecial01', self:GetArmy(), BeamBuildEmtBp)
		self.CEffect = CreateAttachedEmitter( unitBeingBuilt, 'AttachSpecial01', unitBeingBuilt:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		if self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		self.LCraneAnim:SetRate(0.5)
		self.LBeam = AttachBeamEntityToEntity(self, 'L_Crane_Muzzle', unitBeingBuilt, 'AttachSpecial03', self:GetArmy(), BeamBuildEmtBp)
		self.LEffect = CreateAttachedEmitter( unitBeingBuilt, 'AttachSpecial03', unitBeingBuilt:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		 
		 
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 90
		end
		
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 30
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 30
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 30
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true  and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true  and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false  and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false  and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true  and self:HasEnhancement( 'MMFacRightEmpty' ) == true then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == true and self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true  and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 60
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false and self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		number = 0
		end
		
        while self and not self.Dead do
			if number == 90 then
			number = 0
			self:GetWeaponByLabel('Dummy'):SetTargetGround(self:GetPosition())
			self.BuildProgress = false
			if self.LBeam then 
			self.LBeam:Destroy()
			end
			if self.RBeam then 
			self.RBeam:Destroy()
			end
			if self.CBeam and self.CBeam2 then 
			self.CBeam:Destroy()
			self.CBeam2:Destroy()
			elseif self.CBeam then
			self.CBeam:Destroy()
			elseif self.CBeam2 then
			self.CBeam2:Destroy()
			end
			if self.LEffect then
			self.LEffect:Destroy()
			end
			if self.REffect then
			self.REffect:Destroy()
			end
			if self.CEffect and self.CEffect2 then
			self.CEffect:Destroy()
			self.CEffect2:Destroy()
			elseif self.CEffect then
			self.CEffect:Destroy()
			elseif self.CEffect2 then
			self.CEffect2:Destroy()
			end
			self.CCraneAnim:SetRate(0)
			self.CCraneSlideAnim:SetRate(0)
			self.LCraneAnim:SetRate(0)
			self.RCraneAnim:SetRate(0)
			if self.LeftUpgradeEntity then
			self.LeftUpgradeEntity:Destroy()
			end
			if self.RTurretUpgradeEntity then
			self.RTurretUpgradeEntity:Destroy()
			end
			if self.LTurretUpgradeEntity then
			self.LTurretUpgradeEntity:Destroy()
			end
			if self.RightUpgradeEntity then
			self.RightUpgradeEntity:Destroy()
			end
			unitBeingBuilt:CreateEnhancement(self.LeftUpgrade)
			unitBeingBuilt:CreateEnhancement(self.SubSystemsUpgrade)
			unitBeingBuilt:CreateEnhancement(self.LTurretUpgrade)
			unitBeingBuilt:CreateEnhancement(self.RTurretUpgrade)
			unitBeingBuilt:CreateEnhancement(self.RightUpgrade)
			break
			else
			if self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true then
			self:GetWeaponByLabel('Dummy'):SetTargetGround(self:GetPosition())
			WaitSeconds(0.1)
			number = number + 1
			else
			if self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false then
			self:GetWeaponByLabel('Dummy'):SetTargetGround(BothTurretsUpgradeEntityPos)
			elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == true and self:HasEnhancement( 'MMFacRTurretEmpty' ) == false then
			self:GetWeaponByLabel('Dummy'):SetTargetGround(RTurretUpgradeEntityPos)
			elseif self:HasEnhancement( 'MMFacLTurretEmpty' ) == false and self:HasEnhancement( 'MMFacRTurretEmpty' ) == true then
			self:GetWeaponByLabel('Dummy'):SetTargetGround(LTurretUpgradeEntityPos)
			end
			WaitSeconds(0.1)
			number = number + 1
			end
			end
        end
		WaitSeconds(5)
		
		
		
        if unitBeingBuilt and not unitBeingBuilt:IsDead() then
            unitBeingBuilt:DetachFrom(true)
        end
        self:DetachAll(bp.Display.BuildAttachBone or 0)
        self:DestroyBuildRotator()
        if order != 'Upgrade' then
            ChangeState(self, self.RollingOffState)
        else
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
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
			if self.CBeam and self.CBeam2 then 
			self.CBeam:Destroy()
			self.CBeam2:Destroy()
			elseif self.CBeam then
			self.CBeam:Destroy()
			elseif self.CBeam2 then
			self.CBeam2:Destroy()
			end
			if self.LEffect then
			self.LEffect:Destroy()
			end
			if self.REffect then
			self.REffect:Destroy()
			end
			if self.CEffect and self.CEffect2 then
			self.CEffect:Destroy()
			self.CEffect2:Destroy()
			elseif self.CEffect then
			self.CEffect:Destroy()
			elseif self.CEffect2 then
			self.CEffect2:Destroy()
			end
			self.CCraneAnim:SetRate(0)
			self.CCraneSlideAnim:SetRate(0)
			self.LCraneAnim:SetRate(0)
			self.RCraneAnim:SetRate(0)
			if self.LeftUpgradeEntity then
			self.LeftUpgradeEntity:Destroy()
			end
			if self.RTurretUpgradeEntity then
			self.RTurretUpgradeEntity:Destroy()
			end
			if self.LTurretUpgradeEntity then
			self.LTurretUpgradeEntity:Destroy()
			end
			if self.RightUpgradeEntity then
			self.RightUpgradeEntity:Destroy()
			end
		end
		local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

		if version < 3652 then
		local unitBeingBuilt = self.UnitBeingBuilt
        if unitBeingBuilt and not unitBeingBuilt.Dead and not unitBeingBuilt.isFinishedUnit then
            unitBeingBuilt:DetachFrom(true)
		else
			if unitBeingBuilt then
			unitBeingBuilt:Destroy()
			end
        end
		else
		local unitBeingBuilt = self.UnitBeingBuilt
        if unitBeingBuilt and not unitBeingBuilt.Dead and not unitBeingBuilt.isFinishedUnit then
            unitBeingBuilt:Destroy()
		else
			if unitBeingBuilt then
			unitBeingBuilt:DetachFrom(true)
			end
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
			if self.CBeam and self.CBeam2 then 
			self.CBeam:Destroy()
			self.CBeam2:Destroy()
			elseif self.CBeam then
			self.CBeam:Destroy()
			elseif self.CBeam2 then
			self.CBeam2:Destroy()
			end
			if self.LEffect then
			self.LEffect:Destroy()
			end
			if self.REffect then
			self.REffect:Destroy()
			end
			if self.CEffect and self.CEffect2 then
			self.CEffect:Destroy()
			self.CEffect2:Destroy()
			elseif self.CEffect then
			self.CEffect:Destroy()
			elseif self.CEffect2 then
			self.CEffect2:Destroy()
			end
			self.CCraneAnim:SetRate(0)
			self.CCraneSlideAnim:SetRate(0)
			self.LCraneAnim:SetRate(0)
			self.RCraneAnim:SetRate(0)
			if self.LeftUpgradeEntity then
			self.LeftUpgradeEntity:Destroy()
			end
			if self.RTurretUpgradeEntity then
			self.RTurretUpgradeEntity:Destroy()
			end
			if self.LTurretUpgradeEntity then
			self.LTurretUpgradeEntity:Destroy()
			end
			if self.RightUpgradeEntity then
			self.RightUpgradeEntity:Destroy()
			end
		end
		local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

		if version < 3652 then
		local unitBeingBuilt = self.UnitBeingBuilt
        if unitBeingBuilt and not unitBeingBuilt.Dead and not unitBeingBuilt.isFinishedUnit then
            unitBeingBuilt:DetachFrom(true)
		else
			if unitBeingBuilt then
			unitBeingBuilt:Destroy()
			end
        end
		else
		local unitBeingBuilt = self.UnitBeingBuilt
        if unitBeingBuilt and not unitBeingBuilt.Dead and not unitBeingBuilt.isFinishedUnit then
            unitBeingBuilt:Destroy()
		else
			if unitBeingBuilt then
			unitBeingBuilt:DetachFrom(true)
			end
        end
		end
        TStructureUnit.OnReclaimed(self, reclaimer)
    end,	
	
	

}

TypeClass = UEBMD00203