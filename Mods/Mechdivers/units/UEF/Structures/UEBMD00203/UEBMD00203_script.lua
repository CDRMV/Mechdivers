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
		self:CreateEnhancement('MMFacRightEmpty')
		self:CreateEnhancement('MMDefaultSkin')
        TStructureUnit.OnCreate(self)
    end,
	
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
		if not self.ArmSlider then
            self.ArmSlider = CreateSlider(self, 'Center_Crane')
            self.Trash:Add(self.ArmSlider)
        end
		self.CenterUpgrade = nil
		self.RightUpgrade = nil
		self.LeftUpgrade = nil
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
			unitBeingBuilt:CreateEnhancement('DefaultSkin')
		end	
		
		if self:HasEnhancement( 'MMSkin1' ) then
			unitBeingBuilt:CreateEnhancement('Skin1')
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
		local number = 0
		local Modpath = '/mods/Mechdivers/Decorations/Modules/Turrets/'
		local LModpath = '/mods/Mechdivers/Decorations/Modules/Left Arm/'
		local RModpath = '/mods/Mechdivers/Decorations/Modules/Right Arm/'
		
		if self:HasEnhancement( 'MMFacEmpty' ) then
		self.CenterUpgrade = 'Empty'
		end
		if self:HasEnhancement( 'MMFacAutocannonTurret' ) then
		self.CenterUpgrade = 'AutocannonTurret'
		self.CenterUpgradeEntity:SetMesh(Modpath .. 'Autocannon_mesh')
		self.CenterUpgradeEntity:AttachBoneTo( 0, unitBeingBuilt, 'AttachSpecial01' )
		end
		if self:HasEnhancement( 'MMFacGatlingTurret' ) then
		self.CenterUpgrade = 'GatlingTurret'
		self.CenterUpgradeEntity:SetMesh(Modpath .. 'Gatling_mesh')
		self.CenterUpgradeEntity:AttachBoneTo( 0, unitBeingBuilt, 'AttachSpecial01' )
		end
		
		if self:HasEnhancement( 'MMFacRightEmpty' ) then
		self.RightUpgrade = 'RightEmpty'
		end
		if self:HasEnhancement( 'MMFacRightBalisticShield' ) then
		self.RightUpgrade = 'RightBalisticShield'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_BalisticShield_mesh')
		self.RightUpgradeEntity:AttachBoneTo('BalisticShield_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightAntiTankCannon' ) then
		self.RightUpgrade = 'RightAntiTankCannon'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_AntiTankCannon_mesh')
		self.RightUpgradeEntity:AttachBoneTo('AntiTankCannon_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightFlameThrower' ) then
		self.RightUpgrade = 'RightFlameThrower'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Flamethrower_mesh')
		self.RightUpgradeEntity:AttachBoneTo('FlameThrower_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightAutoCannon' ) then
		self.RightUpgrade = 'RightAutoCannon'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Autocannon_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Cannon_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightGatling' ) then
		self.RightUpgrade = 'RightGatling'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Gatling_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Gatling_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightMissileLauncher' ) then
		self.RightUpgrade = 'RightMissileLauncher'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_MissileLauncher_mesh')
		self.RightUpgradeEntity:AttachBoneTo('MissileLauncher_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		if self:HasEnhancement( 'MMFacRightScatterGun' ) then
		self.RightUpgrade = 'RightScatterGun'
		self.RightUpgradeEntity:SetMesh(RModpath .. 'R_Shotgun_mesh')
		self.RightUpgradeEntity:AttachBoneTo('Launcher_Attach', unitBeingBuilt, 'AttachSpecial03')
		end
		
		if self:HasEnhancement( 'MMFacLeftEmpty' ) then
		self.LeftUpgrade = 'LeftEmpty'
		end
		if self:HasEnhancement( 'MMFacLeftBalisticShield' ) then
		self.LeftUpgrade = 'LeftBalisticShield'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_BalisticShield_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('BalisticShield_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftAntiTankCannon' ) then
		self.LeftUpgrade = 'LeftAntiTankCannon'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_AntiTankCannon_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('AntiTankCannon_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftFlameThrower' ) then
		self.LeftUpgrade = 'LeftFlameThrower'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Flamethrower_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('FlameThrower_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftAutoCannon' ) then
		self.LeftUpgrade = 'LeftAutoCannon'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Autocannon_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Cannon_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftGatling' ) then
		self.LeftUpgrade = 'LeftGatling'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Gatling_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Gatling_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftMissileLauncher' ) then
		self.LeftUpgrade = 'LeftMissileLauncher'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_MissileLauncher_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('MissileLauncher_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		if self:HasEnhancement( 'MMFacLeftScatterGun' ) then
		self.LeftUpgrade = 'LeftScatterGun'
		self.LeftUpgradeEntity:SetMesh(LModpath .. 'L_Shotgun_mesh')
		self.LeftUpgradeEntity:AttachBoneTo('Launcher_Attach', unitBeingBuilt, 'AttachSpecial02')
		end
		

		     
		if self:HasEnhancement( 'MMFacLeftEmpty' ) == false then
		self.LCraneAnim:SetRate(0.5)
		self.LBeam = AttachBeamEntityToEntity(self, 'L_Crane_Muzzle', unitBeingBuilt, 'AttachSpecial03', self:GetArmy(), BeamBuildEmtBp)
		self.LEffect = CreateAttachedEmitter( unitBeingBuilt, 'AttachSpecial03', unitBeingBuilt:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		if self:HasEnhancement( 'MMFacEmpty' ) == false then
		self.CCraneAnim:SetRate(0.5)
		self.CCraneSlideAnim:SetRate(0.3)
		self.CBeam = AttachBeamEntityToEntity(self, 'Center_Crane_Muzzle', unitBeingBuilt, 'AttachSpecial01', self:GetArmy(), BeamBuildEmtBp)
		self.CEffect = CreateAttachedEmitter( unitBeingBuilt, 'AttachSpecial01', unitBeingBuilt:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		if self:HasEnhancement( 'MMFacRightEmpty' ) == false then
		self.RCraneAnim:SetRate(0.5)
		self.RBeam = AttachBeamEntityToEntity(self, 'R_Crane_Muzzle', unitBeingBuilt, 'AttachSpecial02', self:GetArmy(), BeamBuildEmtBp)
		self.REffect = CreateAttachedEmitter( unitBeingBuilt, 'AttachSpecial02', unitBeingBuilt:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
		end
		
		local CenterUpgradeEntityPos = unitBeingBuilt:GetPosition('AttachSpecial01')
		 
		 
        while true do
			if number == 150 then
			self:GetWeaponByLabel('Dummy'):SetTargetGround(self:GetPosition())
			self.BuildProgress = false
			self.LBeam:Destroy()
			self.RBeam:Destroy()
			self.CBeam:Destroy()
			self.LEffect:Destroy()
			self.REffect:Destroy()
			self.CEffect:Destroy()
			self.ArmSlider:SetGoal(0, 0, 0)
			self.CCraneAnim:SetRate(0)
			self.CCraneSlideAnim:SetRate(0)
			self.LCraneAnim:SetRate(0)
			self.RCraneAnim:SetRate(0)
			self.LeftUpgradeEntity:Destroy()
			self.CenterUpgradeEntity:Destroy()
			self.RightUpgradeEntity:Destroy()
			unitBeingBuilt:CreateEnhancement(self.LeftUpgrade)
			unitBeingBuilt:CreateEnhancement(self.CenterUpgrade)
			unitBeingBuilt:CreateEnhancement(self.RightUpgrade)
			break
			else
			if self:HasEnhancement( 'MMFacEmpty' ) == true then
			self.ArmSlider:SetGoal(0, 0, 0)
			WaitSeconds(5)
			number = number + 1
			else
			self:GetWeaponByLabel('Dummy'):SetTargetGround(CenterUpgradeEntityPos)
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
	
	MovingArmsThread = function(self)
        TStructureUnit.MovingArmsThread(self)
        while true do
			if not self.ArmSlider then return end
            self.ArmSlider:SetGoal(1, 0, 0)
            self.ArmSlider:SetSpeed(1)
            WaitFor(self.ArmSlider)
            self.ArmSlider:SetGoal(-1, 0, 0)
            WaitFor(self.ArmSlider)
        end
    end,
	
	
	OnKilled = function(self, instigator, type, overkillRatio)
		if self.BuildProgress == true then
			self.LBeam:Destroy()
			self.RBeam:Destroy()
			self.CBeam:Destroy()
			self.LEffect:Destroy()
			self.REffect:Destroy()
			self.CEffect:Destroy()
			self.ArmSlider:SetGoal(0, 0, 0)
			self.CCraneAnim:SetRate(0)
			self.LCraneAnim:SetRate(0)
			self.RCraneAnim:SetRate(0)
			self.LeftUpgradeEntity:Destroy()
			self.CenterUpgradeEntity:Destroy()
			self.RightUpgradeEntity:Destroy()
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
			self.LBeam:Destroy()
			self.RBeam:Destroy()
			self.CBeam:Destroy()
			self.LEffect:Destroy()
			self.REffect:Destroy()
			self.CEffect:Destroy()
			self.ArmSlider:SetGoal(0, 0, 0)
			self.CCraneAnim:SetRate(0)
			self.LCraneAnim:SetRate(0)
			self.RCraneAnim:SetRate(0)
			self.LeftUpgradeEntity:Destroy()
			self.CenterUpgradeEntity:Destroy()
			self.RightUpgradeEntity:Destroy()
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