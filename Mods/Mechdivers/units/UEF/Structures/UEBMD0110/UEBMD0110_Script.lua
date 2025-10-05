#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2101/UEB2101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Light Gun Tower Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFRiotWeapon = import('/lua/terranweapons.lua').TDFRiotWeapon
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local EffectTemplate = import('/lua/EffectTemplates.lua')
local utilities = import('/lua/utilities.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local ModeffectPath = '/mods/Commander Survival Kit/effects/emitters/'
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
local TIFHighBallisticMortarWeapon = import('/lua/terranweapons.lua').TIFHighBallisticMortarWeapon

UEBMD0110 = Class(TStructureUnit) {
    Weapons = {
		MG = Class(TDFGaussCannonWeapon) {
	--[[
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'Turret_Muzzle01' then
		CreateAttachedEmitter(self.unit, 'R_Cannon_Shell01', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		if muzzle == 'R_Cannon_Muzzle02' then
		CreateAttachedEmitter(self.unit, 'R_Cannon_Shell02', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
	]]--	
		},
    },
	OnCreate = function(self)
		self:HideBone( 'Pod', true )
		self:ShowBone( 'CallBeacon', true )
		self:SetDoNotTarget(true)
		self:SetWeaponEnabledByLabel('WallMG', false)
		self:SetWeaponEnabledByLabel('MG', true)
        TStructureUnit.OnCreate(self)
    end,
	
	CreateEnhancement = function(self, enh)
        TStructureUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'PODWall' then
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:AddToggleCap('RULEUTC_SpecialToggle')
		self:SetWeaponEnabledByLabel('WallMG', true)
		self:SetWeaponEnabledByLabel('MG', false)	
		self:SetMaxHealth(4000)
		self:SetHealth(self, 4000)
		self.WallUpgrade = true
        elseif enh == 'PODWallRemove' then
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self:SetWeaponEnabledByLabel('WallMG', false)
		self:SetWeaponEnabledByLabel('MG', true)
		self:SetMaxHealth(1000)
		self:SetHealth(self, 1000)
		self.WallUpgrade = false
		elseif enh == 'WallTurretArmor' then
		self:SetWeaponEnabledByLabel('WallMG', true)
		self:SetWeaponEnabledByLabel('MG', false)	
		self:SetMaxHealth(4500)
		self:SetHealth(self, 4500)
        elseif enh == 'WallTurretArmorRemove' then
		self:SetWeaponEnabledByLabel('WallMG', false)
		self:SetWeaponEnabledByLabel('MG', true)
		self:SetMaxHealth(1000)
		self:SetHealth(self, 1000)
		elseif enh == 'TurretArmor' then
		self:SetMaxHealth(1500)
		self:SetHealth(self, 1500)
        elseif enh == 'TurretArmorRemove' then
		self:SetMaxHealth(1000)
		self:SetHealth(self, 1000)
        end
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
			ForkThread( function()
			self:RemoveCommandCap('RULEUCC_Transport')
			self.Rotate = CreateRotator(self, 'Wall01', 'y', nil, 0, 0, 0)
			self.RotateValue = 0
			self.TurretRotate = CreateRotator(self, 'Turret', 'y', nil, 0, 0, 0)
			self.TurretRotateValue = 0
		local army = self:GetArmy()
        local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
		self.Beam = AttachBeamEntityToEntity(self, 'CallBeacon_Muzzle', self, 'Pod', army, '/mods/Mechdivers/effects/emitters/beacon_beam_01_emit.bp' )
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
		if not self.AnimationManipulator3 then
            self.AnimationManipulator3 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator3)
        end
        self.AnimationManipulator3:PlayAnim(self:GetBlueprint().Display.AnimationUnpack2, false):SetRate(0)	
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationArrival, false):SetRate(2)	
		self.ArmSlider1 = CreateSlider(self, 'Pod')
        self.Trash:Add(self.ArmSlider1)
		self.ArmSlider1:SetGoal(0, 1000, 0)
		self.ArmSlider1:SetSpeed(1000)
		self:HideBone( 'Pod', true )
        self:SetUnSelectable(true)	
		WaitSeconds(1)			
		self.ArmSlider1 = CreateSlider(self, 'Pod')
		self.Trash:Add(self.ArmSlider1)        
		self.ArmSlider1:SetGoal(0, -1000, 0)
		self.ArmSlider1:SetSpeed(100)
		self.Dummy = import('/lua/sim/Entity.lua').Entity()
		Dummy = '/mods/Mechdivers/projectiles/Asteroid/Mesh/Asteroid_mesh',
        self.Dummy:AttachBoneTo( -1, self, 'Effect' )
        self.Dummy:SetMesh(Dummy)
        self.Dummy:SetDrawScale(0.000)
        self.Dummy:SetVizToAllies('Intel')
        self.Dummy:SetVizToNeutrals('Intel')
        self.Dummy:SetVizToEnemies('Intel')
		self.ArrivalEffect1 = CreateAttachedEmitter(self.Dummy,0,self:GetArmy(), '/effects/emitters/nuke_munition_launch_trail_04_emit.bp'):ScaleEmitter(4):OffsetEmitter(0,-1,0)
		self.ArrivalEffect2 = CreateAttachedEmitter(self.Dummy,0,self:GetArmy(), '/effects/emitters/nuke_munition_launch_trail_06_emit.bp'):ScaleEmitter(4):OffsetEmitter(0,-1,0)
		self.ArrivalEffect3 = CreateAttachedEmitter(self.Dummy,0,self:GetArmy(), '/mods/Mechdivers/effects/emitters/fire_trail_08_emit.bp'):ScaleEmitter(4):OffsetEmitter(0,-1,0)
		self.ArrivalEffect4 = CreateBeamEmitterOnEntity(self, 'Pod_Exhaust01', self:GetArmy(), '/effects/emitters/missile_exhaust_fire_beam_06_emit.bp')
		self.ArrivalEffect5 = CreateBeamEmitterOnEntity(self, 'Pod_Exhaust02', self:GetArmy(), '/effects/emitters/missile_exhaust_fire_beam_06_emit.bp')
		self.ArrivalEffect6 = CreateBeamEmitterOnEntity(self, 'Pod_Exhaust03', self:GetArmy(), '/effects/emitters/missile_exhaust_fire_beam_06_emit.bp')
		self.ArrivalEffect7 = CreateBeamEmitterOnEntity(self, 'Pod_Exhaust04', self:GetArmy(), '/effects/emitters/missile_exhaust_fire_beam_06_emit.bp')
		self.ArrivalEffect8 = CreateBeamEmitterOnEntity(self, 'Pod_Exhaust05', self:GetArmy(), '/effects/emitters/missile_exhaust_fire_beam_06_emit.bp')
		self.ArrivalEffect9 = CreateBeamEmitterOnEntity(self, 'Pod_Exhaust06', self:GetArmy(), '/effects/emitters/missile_exhaust_fire_beam_06_emit.bp')
		self:ShowBone( 0, true )
		self:HideBone( 'Wall01', true )
		self:HideBone( 'Turret', true )
		WaitSeconds(10)
		CreateEmitterOnEntity(self,self:GetArmy(), '/effects/emitters/destruction_explosion_flash_04_emit.bp')
		CreateEmitterOnEntity(self,self:GetArmy(), '/effects/emitters/destruction_explosion_flash_05_emit.bp')
        DamageArea(self, position, 4, 10, 'Force', false, false)
        DamageArea(self, position, 4, 10, 'Fire', false, false)
        CreateDecal(position, orientation, 'Scorch_010_albedo', '', 'Albedo', 2, 2, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 2, 2, 500, 600, army)
        CreateDecal(position, orientation, 'Crater05_normals', '', 'Normals', 2, 2, 500, 600, army)
	    self.ArrivalEffect1:Destroy()
		self.ArrivalEffect2:Destroy()
		self.ArrivalEffect3:Destroy()
		self.ArrivalEffect4:Destroy()
		self.ArrivalEffect5:Destroy()
		self.ArrivalEffect6:Destroy()
		self.ArrivalEffect7:Destroy()
		self.ArrivalEffect8:Destroy()
		self.ArrivalEffect9:Destroy()
		self:HideBone( 'CallBeacon', true )
		self.Beam:Destroy()
		if not self.AnimationManipulator2 then
            self.AnimationManipulator2 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator2)
        end
        self.AnimationManipulator2:PlayAnim(self:GetBlueprint().Display.AnimationUnpack, false):SetRate(1)	
		self:SetUnSelectable(false)	
		self:SetDoNotTarget(false)
		self:ShowBone( 'Turret', true )
		self:HideBone( 'Turret_Armor01', true )
		WaitFor(self.AnimationManipulator2)
		self.AnimationManipulator3:PlayAnim(self:GetBlueprint().Display.AnimationUnpack2, false):SetRate(2)	
		WaitFor(self.AnimationManipulator3)
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		BotMesh = '/mods/Mechdivers/Decorations/T1Bot_mesh3'
		self.Bot = import('/lua/sim/Entity.lua').Entity()
        self.Bot:AttachBoneTo( -1, self, 'AttachPoint' )
        self.Bot:SetMesh(BotMesh)
        self.Bot:SetDrawScale(0.500)
        self.Bot:SetVizToAllies('Never')
        self.Bot:SetVizToNeutrals('Never')
        self.Bot:SetVizToEnemies('Never')	
		self.load = false
		self.WallUpgrade = false
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		local position = self:GetPosition()
		self.Beacon = CreateUnitHPR('UEB5102', self:GetArmy(), position[1], position[2], position[3], 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:AddToggleCap('RULEUTC_IntelToggle')
		self:AddToggleCap('RULEUTC_ProductionToggle')
		self:SetScriptBit('RULEUTC_ProductionToggle', true)
		self:SetWeaponEnabledByLabel('WallMG', false)
		self:SetWeaponEnabledByLabel('MG', false)
		end
		)
    end,
	
	OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self.Blocker:Destroy()
		self.Blocker2:Destroy()
		if self.RotateValue == 0 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -90 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -180 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -270 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -360 then
		self.RotateValue = 0
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 0 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 90 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 180 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 270 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 360 then
		self.RotateValue = 0
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		local position = self:GetPosition()
		self.RotateValue = self.RotateValue - 90
		self.Rotate:SetGoal(self.RotateValue)
		self.Rotate:SetSpeed(90)
		self.Rotate:SetTargetSpeed(90)
		self.TurretRotateValue = self.TurretRotateValue - 90
		self.TurretRotate:SetGoal(self.TurretRotateValue)
		self.TurretRotate:SetSpeed(90)
		self.TurretRotate:SetTargetSpeed(90)
		LOG(self.RotateValue)
		if self.RotateValue == 0 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -90 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -180 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -270 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -360 then
		self.RotateValue = 0
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 90 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 180 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 270 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 360 then
		self.RotateValue = 0
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		elseif bit == 4 then
		self.load = false
		local units = self:GetCargo()
		local position = self:GetPosition()
		self.Bot:SetVizToAllies('Never')
		self.Bot:SetVizToNeutrals('Never')
		self.Bot:SetVizToEnemies('Never')
        for _, unit in units do
			Warp(unit, {position[1] + math.random(-1,1), GetTerrainHeight(position[1], position[3]), position[3] + math.random(-1,1)}, self:GetOrientation())
			unit:ShowBone(0, true)
			unit:SetDoNotTarget(false)
			unit:SetUnSelectable(false)
			unit:SetWeaponEnabledByLabel('ArmCannonTurret', true)
			unit:SetCollisionShape('Box', 0, 0,0, 0.45, 0.55, 0.35)
			unit:DetachFrom(true)
			unit:AddCommandCap('RULEUCC_Attack')
			unit:AddCommandCap('RULEUCC_RetaliateToggle')
			unit:AddCommandCap('RULEUCC_Stop')
			if self.WallUpgrade == true then
			self:SetWeaponEnabledByLabel('WallMG', false)
			elseif self.WallUpgrade == false then
			self:SetWeaponEnabledByLabel('MG', false)
			end
			self:RemoveCommandCap('RULEUCC_Attack')
			self:RemoveCommandCap('RULEUCC_RetaliateToggle')
			self:RemoveCommandCap('RULEUCC_Stop')
        end	
		elseif bit == 7 then 
		self.Blocker:Destroy()
		self.Blocker2:Destroy()
		if self.RotateValue == 0 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 90 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 180 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 270 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 360 then
		self.RotateValue = 0
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 0 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -90 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -180 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -270 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -360 then
		self.RotateValue = 0
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		local position = self:GetPosition()
		self.RotateValue = self.RotateValue + 90
		self.Rotate:SetGoal(self.RotateValue)
		self.Rotate:SetSpeed(90)
		self.Rotate:SetTargetSpeed(90)
		self.TurretRotateValue = self.TurretRotateValue + 90
		self.TurretRotate:SetGoal(self.TurretRotateValue)
		self.TurretRotate:SetSpeed(90)
		self.TurretRotate:SetTargetSpeed(90)
		LOG(self.RotateValue)
		if self.RotateValue == 0 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -90 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -180 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -270 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -360 then
		self.RotateValue = 0
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 90 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 180 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 270 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 360 then
		self.RotateValue = 0
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		elseif bit == 3 then
		self.Beacon:HideBone(0, true)
        end	
    end,

    OnScriptBitClear = function(self, bit)
        TStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self.Blocker:Destroy()
		self.Blocker2:Destroy()
		if self.RotateValue == 0 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 90 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 180 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 270 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 360 then
		self.RotateValue = 0
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 0 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -90 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -180 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -270 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -360 then
		self.RotateValue = 0
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		local position = self:GetPosition()
		self.RotateValue = self.RotateValue - 90
		self.Rotate:SetGoal(self.RotateValue)
		self.Rotate:SetSpeed(90)
		self.Rotate:SetTargetSpeed(90)
		self.TurretRotateValue = self.TurretRotateValue - 90
		self.TurretRotate:SetGoal(self.TurretRotateValue)
		self.TurretRotate:SetSpeed(90)
		self.TurretRotate:SetTargetSpeed(90)
		LOG(self.RotateValue)
		if self.RotateValue == 0 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -90 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -180 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -270 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -360 then
		self.RotateValue = 0
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 90 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 180 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 270 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 360 then
		self.RotateValue = 0
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		elseif bit == 4 then
				LOG('Test')
		self.load = true
		local position = self.Beacon:GetPosition()
			local units = self.Beacon:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND + categories.TECH1, position, 10, 'Ally')
			local number = 0
        for _,unit in units do
			if unit:IsUnitState('WaitForFerry') and unit:GetBlueprint().General.UnitName == '<LOC uel0106_name>Mech Marine' then
			if number < 1 then
			unit:AttachBoneTo(-2, self, 'AttachPoint')
			unit:SetDoNotTarget(true)
			unit:SetWeaponEnabledByLabel('ArmCannonTurret', false)
			unit:SetUnSelectable(true)
			unit:HideBone(0, true)
			unit:SetCollisionShape('Box', 0, 0, 0, 0, 0, 0)
			unit:RemoveCommandCap('RULEUCC_Attack')
			unit:RemoveCommandCap('RULEUCC_RetaliateToggle')
			unit:RemoveCommandCap('RULEUCC_Stop')
			IssueClearCommands({unit})
			self.Bot:SetVizToAllies('Intel')
			self.Bot:SetVizToNeutrals('Intel')
			self.Bot:SetVizToEnemies('Intel')
			if self.WallUpgrade == true then
			self:SetWeaponEnabledByLabel('WallMG', true)
			elseif self.WallUpgrade == false then
			self:SetWeaponEnabledByLabel('MG', true)
			end
			self:AddCommandCap('RULEUCC_Attack')
			self:AddCommandCap('RULEUCC_RetaliateToggle')
			self:AddCommandCap('RULEUCC_Stop')
			number = number + 1
			else
			end
			else
            end
		end	
		elseif bit == 7 then 
		self.Blocker:Destroy()
		self.Blocker2:Destroy()
		if self.RotateValue == 0 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 90 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 180 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 270 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 360 then
		self.RotateValue = 0
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 0 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -90 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -180 then
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -270 then
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -360 then
		self.RotateValue = 0
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		local position = self:GetPosition()
		self.RotateValue = self.RotateValue + 90
		self.Rotate:SetGoal(self.RotateValue)
		self.Rotate:SetSpeed(90)
		self.Rotate:SetTargetSpeed(90)
		self.TurretRotateValue = self.TurretRotateValue + 90
		self.TurretRotate:SetGoal(self.TurretRotateValue)
		self.TurretRotate:SetSpeed(90)
		self.TurretRotate:SetTargetSpeed(90)
		LOG(self.RotateValue)
		if self.RotateValue == 0 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -90 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -180 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == -270 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == -360 then
		self.RotateValue = 0
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 90 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 180 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		if self.RotateValue == 270 then
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z+1, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x, position.y, position.z-1, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 0.1, 0.6, 1)
		end
		if self.RotateValue == 360 then
		self.RotateValue = 0
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
		self.Blocker = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x+1, position.y, position.z, 0, 0, 0)
		self.Blocker2 = CreateUnitHPR('UEBMD0001', self:GetArmy(), position.x-1, position.y, position.z, 0, 0, 0)
		SetIgnoreArmyUnitCap(self:GetArmy(), false)
		self:SetCollisionShape('Box', 0, 0, 0, 1, 0.6, 0.1)
		end
		elseif bit == 3 then
		self.Beacon:ShowBone(0, true)
		end
    end,
	
	OnKilled = function(self, instigator, type, overkillRatio)
	if self.Blocker and self.Blocker2 then
		self.Blocker:Destroy()
		self.Blocker2:Destroy()
	end
	TStructureUnit.OnKilled(self, instigator, type, overkillRatio)	
	end,
	
	OnReclaimed = function(self, reclaimer)
	if self.Blocker and self.Blocker2 then
		self.Blocker:Destroy()
		self.Blocker2:Destroy()
	end
    end,
}

TypeClass = UEBMD0110