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
local ADFDustSwirl = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').ADFDustSwirl
local EffectTemplate = import('/lua/EffectTemplates.lua')
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

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
		DustSwirl = Class(ADFDustSwirl) {},    
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

    BuildAttachBone = 'Build',

    OnStopBeingBuilt = function(self,builder,layer)
        AAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.OpenAnimManip = CreateAnimator(self)
		self.Trash:Add(self.OpenAnimManip)
		self.OpenAnimManip:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAA0400/CSKMDAA0400_Fly.sca', true):SetRate(0.1)
        ChangeState(self, self.IdleState)
		self:HideBone('Center_Beam',false)
		self.DustSwirl = self:GetWeaponByLabel('DustSwirl')
		self.DustSwirl:SetEnabled(false)
		self.QuantumBeam = self:GetWeaponByLabel('QuantumBeamGeneratorWeapon')
		self.QuantumBeam:SetEnabled(false)
		self.QuantumGun01 = self:GetWeaponByLabel('QuantumGun01')
		self.QuantumGun01:SetEnabled(false)
		self.QuantumGun02 = self:GetWeaponByLabel('QuantumGun02')
		self.QuantumGun02:SetEnabled(false)
		self.QuantumGun03 = self:GetWeaponByLabel('QuantumGun03')
		self.QuantumGun03:SetEnabled(false)
		self.QuantumGun04 = self:GetWeaponByLabel('QuantumGun04')
		self.QuantumGun04:SetEnabled(false)
		self.QuantumBeam1 = self:GetWeaponByLabel('QuantumBeam1')
		self.QuantumBeam1:SetEnabled(false)
		self.QuantumBeam2 = self:GetWeaponByLabel('QuantumBeam2')
		self.QuantumBeam2:SetEnabled(false)
		self.QuantumBeam3 = self:GetWeaponByLabel('QuantumBeam3')
		self.QuantumBeam3:SetEnabled(false)
		self.QuantumBeam4 = self:GetWeaponByLabel('QuantumBeam4')
		self.QuantumBeam4:SetEnabled(false)
		ChangeState(self, self.IdleState)
		self:RemoveCommandCap('RULEUCC_Transport')
		self:CreateEnhancement('HangarbayRemove')
		ForkThread(function()
			local elevation = nil
			while not self.Dead do 
				local targets = self:GetAIBrain():GetUnitsAroundPoint( categories.LAND, self:GetPosition(), 10, 'Enemy' )
				local amount = table.getn(targets)
                for i, target in targets do
				if self:GetScriptBit('RULEUTC_WeaponToggle') == false then
				if target:IsUnitState('attached') == true then
				local Dummys = self:GetAIBrain():GetUnitsAroundPoint( categories.DUSTSWIRLDUMMY, self:GetPosition(), 10, 'Enemy' )
				target:DetachFrom()
				 local projectile = target:CreateProjectileAtBone('/Mods/Mechdivers/projectiles/ADFTractorFall01/ADFTractorFall01_proj.bp'
                , 0)
				            local vx, vy, vz = target:GetVelocity()
            projectile:SetVelocity(10 * vx, 10 * vy, 10 * vz)
			target:AttachBoneTo(-2, projectile, 0)
            -- is not defined when the projectile is created underwater
            if not projectile.Blueprint then
                explosion.CreateScalableUnitExplosion(target, 0, true)
                target:Kill()
            end

            projectile.OnImpact = function(projectile)
                if not IsDestroyed(target) then
                    target:Kill()

                    CreateLightParticle(target, 0, self.Army, 4, 2, 'glow_02', 'ramp_blue_16')

                    local position = target:GetPosition()
                    DamageArea(target, position, 3, 1, 'TreeFire', false, false)
                    DamageArea(target, position, 2, 1, 'TreeForce', false, false)
                end

                projectile:Destroy()
            end
				for i, Dummy in Dummys do
				if Dummy and not Dummy.Dead then
				Dummy:Destroy()
				end
				end
				end
				else
                    if target and not target.Dead and target ~= self then		
			local targetpos = target:GetPosition()
			local Health = target:GetHealth()
			local qx, qy, qz, qw = unpack(target:GetOrientation())
			if i > amount then
			
			elseif i < amount or i == amount then
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			elevation = 0
			self.DummyUnit = CreateUnit('CSKMDJP01002',target:GetArmy(),targetpos[1], targetpos[2], targetpos[3],qx, qy, qz, qw, 0)
			self.DummyUnit:SetElevation(0)
			self.DummyUnit:SetSpeedMult(1.0)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			if target:IsUnitState('attached') == false then
			target:AttachBoneTo(-2, self.DummyUnit, 0)
			else
			self.DummyUnit:Destroy()
			end
			else
			
			end
				elevation = elevation + 20
				self.DummyUnit:SetElevation(elevation)
				target:SetDoNotTarget(true)
				target:SetImmobile(true)
				Damage(self, target:GetPosition(), target, 50, 'Fire')
                    end
									end
                end
				WaitSeconds(1)
			end	
		end)
    end,

    OnFailedToBuild = function(self)
        AAirUnit.OnFailedToBuild(self)
        ChangeState(self, self.IdleState)
    end,

    IdleState = State {
        Main = function(self)
            self:DetachAll(self.BuildAttachBone)
            self:SetBusy(false)
			self:SetImmobile(false)
        end,

        OnStartBuild = function(self, unitBuilding, order)
            AAirUnit.OnStartBuild(self, unitBuilding, order)
            self.UnitBeingBuilt = unitBuilding
			self:SetImmobile(true)
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
	
	OnScriptBitSet = function(self, bit)
        AAirUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self:ForkThread(
            function()
		self.OpenAnimManip:Destroy()
		self.OpenAnimManip1 = CreateAnimator(self)
		self.Trash:Add(self.OpenAnimManip1)
		self.OpenAnimManip1:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAA0400/CSKMDAA0400_Unpack.sca', false):SetRate(0.1)
                self.AimingNode = CreateRotator(self, 0, 'x', 0, 10000, 10000, 1000)
                WaitFor(self.AimingNode)
				local interval = 0
                while (interval < 26) do
					if interval == 25 then 
					self:SetScriptBit('RULEUTC_WeaponToggle', false)
					end
                    self:GetWeaponByLabel'DustSwirl':SetEnabled(true):FireWeapon()
					WaitSeconds(1)
					interval = interval + 1
                end
            end
        )
        end	
    end,

    OnScriptBitClear = function(self, bit)
        AAirUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self.OpenAnimManip1:Destroy()
		self.OpenAnimManip = CreateAnimator(self)
		self.OpenAnimManip:PlayAnim('/Mods/Mechdivers/units/Aeon/CSKMDAA0400/CSKMDAA0400_Fly.sca', true):SetRate(0.1)
		end
    end,
	
	CreateEnhancement = function(self, enh)
        AAirUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		local wep = self:GetWeaponByLabel('MainGun')
		if enh == 'Hangarbay' then
		self:RemoveBuildRestriction(categories.STINGRAY)
		self:AddCommandCap('RULEUCC_Transport')
		elseif enh == 'HangarbayRemove' then
		self:AddBuildRestriction(categories.STINGRAY)
		self:RemoveCommandCap('RULEUCC_Transport')
        elseif enh == 'OrbitalPlasmaCannonBarrage' then
		self.QuantumBeam:SetEnabled(false)
		self.QuantumGun01:SetEnabled(true)
		self.QuantumGun02:SetEnabled(true)
		self.QuantumGun03:SetEnabled(true)
		self.QuantumGun04:SetEnabled(true)
		self.QuantumBeam1:SetEnabled(false)
		self.QuantumBeam2:SetEnabled(false)
		self.QuantumBeam3:SetEnabled(false)
		self.QuantumBeam4:SetEnabled(false)
        elseif enh == 'OrbitalSecondaryLasers' then
		self.QuantumBeam:SetEnabled(false)
		self.QuantumGun01:SetEnabled(false)
		self.QuantumGun02:SetEnabled(false)
		self.QuantumGun03:SetEnabled(false)
		self.QuantumGun04:SetEnabled(false)
		self.QuantumBeam1:SetEnabled(true)
		self.QuantumBeam2:SetEnabled(true)
		self.QuantumBeam3:SetEnabled(true)
		self.QuantumBeam4:SetEnabled(true)
		elseif enh == 'OrbitalLaser' then
		self.QuantumBeam:SetEnabled(true)
		self.QuantumGun01:SetEnabled(false)
		self.QuantumGun02:SetEnabled(false)
		self.QuantumGun03:SetEnabled(false)
		self.QuantumGun04:SetEnabled(false)
		self.QuantumBeam1:SetEnabled(false)
		self.QuantumBeam2:SetEnabled(false)
		self.QuantumBeam3:SetEnabled(false)
		self.QuantumBeam4:SetEnabled(false)
        end
    end,
}

TypeClass = CSKMDAA0400