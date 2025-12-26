#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2101/UEB2101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Light Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
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
local EffectUtils = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
local TIFHighBallisticMortarWeapon = import('/lua/terranweapons.lua').TIFHighBallisticMortarWeapon
local R, Ceil = Random, math.ceil

UEBMD0102 = Class(TStructureUnit) {
    Weapons = {
        MainGun = Class(TDFGaussCannonWeapon) {
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'L1_Mine01' then
		self.unit.Mine:Destroy()
		end
		if muzzle == 'L1_Mine02' then
		self.unit.Mine2:Destroy()
		end
		if muzzle == 'L1_Mine03' then
		self.unit.Mine3:Destroy()
		end
		if muzzle == 'L1_Mine04' then
		self.unit.Mine4:Destroy()
		end
		if muzzle == 'L1_Mine05' then
		self.unit.Mine5:Destroy()
		end
		if muzzle == 'L1_Mine06' then
		self.unit.Mine6:Destroy()
		end
		if muzzle == 'L1_Mine07' then
		self.unit.Mine7:Destroy()
		end
		if muzzle == 'L1_Mine08' then
		self.unit.Mine8:Destroy()
		end
		if muzzle == 'L2_Mine01' then
		self.unit.Mine9:Destroy()
		end
		if muzzle == 'L2_Mine02' then
		self.unit.Mine10:Destroy()
		end
		if muzzle == 'L2_Mine03' then
		self.unit.Mine11:Destroy()
		end
		if muzzle == 'L2_Mine04' then
		self.unit.Mine12:Destroy()
		end
		if muzzle == 'L2_Mine05' then
		self.unit.Mine13:Destroy()
		end
		if muzzle == 'L2_Mine06' then
		self.unit.Mine14:Destroy()
		end
		if muzzle == 'L2_Mine07' then
		self.unit.Mine15:Destroy()
		end
		if muzzle == 'L2_Mine08' then
		self.unit.Mine16:Destroy()
		end
		if muzzle == 'L3_Mine01' then
		self.unit.Mine17:Destroy()
		end
		if muzzle == 'L3_Mine02' then
		self.unit.Mine18:Destroy()
		end
		if muzzle == 'L3_Mine03' then
		self.unit.Mine19:Destroy()
		end
		if muzzle == 'L3_Mine04' then
		self.unit.Mine20:Destroy()
		end
		if muzzle == 'L3_Mine05' then
		self.unit.Mine21:Destroy()
		end
		if muzzle == 'L3_Mine06' then
		self.unit.Mine22:Destroy()
		end
		if muzzle == 'L3_Mine07' then
		self.unit.Mine23:Destroy()
		end
		if muzzle == 'L3_Mine08' then
		self.unit.Mine24:Destroy()
		end
		if muzzle == 'L4_Mine01' then
		self.unit.Mine25:Destroy()
		end
		if muzzle == 'L4_Mine02' then
		self.unit.Mine26:Destroy()
		end
		if muzzle == 'L4_Mine03' then
		self.unit.Mine27:Destroy()
		end
		if muzzle == 'L4_Mine04' then
		self.unit.Mine28:Destroy()
		end
		if muzzle == 'L4_Mine05' then
		self.unit.Mine29:Destroy()
		end
		if muzzle == 'L4_Mine06' then
		self.unit.Mine30:Destroy()
		end
		if muzzle == 'L4_Mine07' then
		self.unit.Mine31:Destroy()
		end
		if muzzle == 'L4_Mine08' then
		self.unit.Mine32:Destroy()
		end
		if muzzle == 'L5_Mine01' then
		self.unit.Mine33:Destroy()
		end
		if muzzle == 'L5_Mine02' then
		self.unit.Mine34:Destroy()
		end
		if muzzle == 'L5_Mine03' then
		self.unit.Mine35:Destroy()
		end
		if muzzle == 'L5_Mine04' then
		self.unit.Mine36:Destroy()
		end
		if muzzle == 'L5_Mine05' then
		self.unit.Mine37:Destroy()
		end
		if muzzle == 'L5_Mine06' then
		self.unit.Mine38:Destroy()
		end
		if muzzle == 'L5_Mine07' then
		self.unit.Mine39:Destroy()
		end
		if muzzle == 'L5_Mine08' then
		self.unit.Mine40:Destroy()
		end
		if muzzle == 'L6_Mine01' then
		self.unit.Mine41:Destroy()
		end
		if muzzle == 'L6_Mine02' then
		self.unit.Mine42:Destroy()
		end
		if muzzle == 'L6_Mine03' then
		self.unit.Mine43:Destroy()
		end
		if muzzle == 'L6_Mine04' then
		self.unit.Mine44:Destroy()
		end
		if muzzle == 'L6_Mine05' then
		self.unit.Mine45:Destroy()
		end
		if muzzle == 'L6_Mine06' then
		self.unit.Mine46:Destroy()
		end
		if muzzle == 'L6_Mine07' then
		self.unit.Mine47:Destroy()
		end
		if muzzle == 'L6_Mine08' then
		self.unit.Mine48:Destroy()
		end
		end,
		}
    },
	
	OnCreate = function(self)
		self:HideBone( 'Pod', true )
		self:ShowBone( 'CallBeacon', true )
		self:SetDoNotTarget(true)
        TStructureUnit.OnCreate(self)
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        TStructureUnit.OnStopBeingBuilt(self,builder,layer)
			ForkThread( function()
		self.ClapDummy = import('/lua/sim/Entity.lua').Entity()
		ClapDummy = '/mods/Mechdivers/projectiles/DropClap/DropClap_proj_mesh',
        self.ClapDummy:AttachBoneTo( -2, self, 'Main_Clap1' )
        self.ClapDummy:SetMesh(ClapDummy)
        self.ClapDummy:SetDrawScale(0.50)
        self.ClapDummy:SetVizToAllies('Intel')
        self.ClapDummy:SetVizToNeutrals('Intel')
        self.ClapDummy:SetVizToEnemies('Intel')
		local army = self:GetArmy()
        local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
		self.Spinner1 = CreateRotator(self, 'Turret', 'y', nil, 0, 60, 360):SetTargetSpeed(0)
		self.Beam = AttachBeamEntityToEntity(self, 'CallBeacon_Muzzle', self, 'Pod', army, '/mods/Mechdivers/effects/emitters/beacon_beam_01_emit.bp' )
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
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
		self:SpawnMines()
		local x = math.random(-1, 1)
		local z = math.random(-1, 1)
		self.Clap = self:CreateProjectile('/Mods/Mechdivers/projectiles/DropClap/DropClap_proj.bp', 0, 0.5, 0, x, 7, z)
		self.ClapDummy:DetachFrom(true)
		self.ClapDummy:AttachBoneTo( -2, self.Clap, -2 )
		WaitFor(self.AnimationManipulator2)
		if not self.AnimationManipulator3 then
            self.AnimationManipulator3 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator3)
        end
        self.AnimationManipulator3:PlayAnim(self:GetBlueprint().Display.AnimationTurretUnpack, false):SetRate(2)	
		WaitFor(self.AnimationManipulator3)
		local interval = 0
        while (interval < 3) do
				LOG(interval)
					if interval == 0 then
					self.Spinner1:SetTargetSpeed(360)
					end
					if interval == 2 then 
						local wep1 = self:GetWeaponByLabel('MainGun')
						wep1:SetEnabled(false)	
						self.Spinner1:SetTargetSpeed(0)
						self:SetDoNotTarget(true)
						break
					end
                    local num = Ceil((R()+R()+R()+R()+R()+R()+R()+R()+R()+R()+R())*R(1,10))
                    coroutine.yield(num)
                    self:GetWeaponByLabel'MainGun':FireWeapon()
					WaitSeconds(1)
					interval = interval + 1
        end
		end
		)
    end,
	
	SpawnMines = function(self)
		MineMesh = '/Mods/Mechdivers/units/UEF/Structures/UEBMD0102d/Mine_mesh'
		self.Mine = import('/lua/sim/Entity.lua').Entity()
        self.Mine:AttachBoneTo( -1, self, 'L1_Mine01' )
        self.Mine:SetMesh(MineMesh)
        self.Mine:SetDrawScale(0.50)
        self.Mine:SetVizToAllies('Intel')
        self.Mine:SetVizToNeutrals('Intel')
        self.Mine:SetVizToEnemies('Intel')
		self.Mine2 = import('/lua/sim/Entity.lua').Entity()
        self.Mine2:AttachBoneTo( -1, self, 'L1_Mine02' )
        self.Mine2:SetMesh(MineMesh)
        self.Mine2:SetDrawScale(0.50)
        self.Mine2:SetVizToAllies('Intel')
        self.Mine2:SetVizToNeutrals('Intel')
        self.Mine2:SetVizToEnemies('Intel')
		self.Mine3 = import('/lua/sim/Entity.lua').Entity()
        self.Mine3:AttachBoneTo( -1, self, 'L1_Mine03' )
        self.Mine3:SetMesh(MineMesh)
        self.Mine3:SetDrawScale(0.50)
        self.Mine3:SetVizToAllies('Intel')
        self.Mine3:SetVizToNeutrals('Intel')
        self.Mine3:SetVizToEnemies('Intel')
		self.Mine4 = import('/lua/sim/Entity.lua').Entity()
        self.Mine4:AttachBoneTo( -1, self, 'L1_Mine04' )
        self.Mine4:SetMesh(MineMesh)
        self.Mine4:SetDrawScale(0.50)
        self.Mine4:SetVizToAllies('Intel')
        self.Mine4:SetVizToNeutrals('Intel')
        self.Mine4:SetVizToEnemies('Intel')
		self.Mine5 = import('/lua/sim/Entity.lua').Entity()
        self.Mine5:AttachBoneTo( -1, self, 'L1_Mine05' )
        self.Mine5:SetMesh(MineMesh)
        self.Mine5:SetDrawScale(0.50)
        self.Mine5:SetVizToAllies('Intel')
        self.Mine5:SetVizToNeutrals('Intel')
        self.Mine5:SetVizToEnemies('Intel')
		self.Mine6 = import('/lua/sim/Entity.lua').Entity()
        self.Mine6:AttachBoneTo( -1, self, 'L1_Mine06' )
        self.Mine6:SetMesh(MineMesh)
        self.Mine6:SetDrawScale(0.50)
        self.Mine6:SetVizToAllies('Intel')
        self.Mine6:SetVizToNeutrals('Intel')
        self.Mine6:SetVizToEnemies('Intel')
		self.Mine7 = import('/lua/sim/Entity.lua').Entity()
        self.Mine7:AttachBoneTo( -1, self, 'L1_Mine07' )
        self.Mine7:SetMesh(MineMesh)
        self.Mine7:SetDrawScale(0.50)
        self.Mine7:SetVizToAllies('Intel')
        self.Mine7:SetVizToNeutrals('Intel')
        self.Mine7:SetVizToEnemies('Intel')
		self.Mine8 = import('/lua/sim/Entity.lua').Entity()
        self.Mine8:AttachBoneTo( -1, self, 'L1_Mine08' )
        self.Mine8:SetMesh(MineMesh)
        self.Mine8:SetDrawScale(0.50)
        self.Mine8:SetVizToAllies('Intel')
        self.Mine8:SetVizToNeutrals('Intel')
        self.Mine8:SetVizToEnemies('Intel')
		self.Mine9 = import('/lua/sim/Entity.lua').Entity()
        self.Mine9:AttachBoneTo( -1, self, 'L2_Mine01' )
        self.Mine9:SetMesh(MineMesh)
        self.Mine9:SetDrawScale(0.50)
        self.Mine9:SetVizToAllies('Intel')
        self.Mine9:SetVizToNeutrals('Intel')
        self.Mine9:SetVizToEnemies('Intel')
		self.Mine10 = import('/lua/sim/Entity.lua').Entity()
        self.Mine10:AttachBoneTo( -1, self, 'L2_Mine02' )
        self.Mine10:SetMesh(MineMesh)
        self.Mine10:SetDrawScale(0.50)
        self.Mine10:SetVizToAllies('Intel')
        self.Mine10:SetVizToNeutrals('Intel')
        self.Mine10:SetVizToEnemies('Intel')
		self.Mine11 = import('/lua/sim/Entity.lua').Entity()
        self.Mine11:AttachBoneTo( -1, self, 'L2_Mine03' )
        self.Mine11:SetMesh(MineMesh)
        self.Mine11:SetDrawScale(0.50)
        self.Mine11:SetVizToAllies('Intel')
        self.Mine11:SetVizToNeutrals('Intel')
        self.Mine11:SetVizToEnemies('Intel')
		self.Mine12 = import('/lua/sim/Entity.lua').Entity()
        self.Mine12:AttachBoneTo( -1, self, 'L2_Mine04' )
        self.Mine12:SetMesh(MineMesh)
        self.Mine12:SetDrawScale(0.50)
        self.Mine12:SetVizToAllies('Intel')
        self.Mine12:SetVizToNeutrals('Intel')
        self.Mine12:SetVizToEnemies('Intel')
		self.Mine13 = import('/lua/sim/Entity.lua').Entity()
        self.Mine13:AttachBoneTo( -1, self, 'L2_Mine05' )
        self.Mine13:SetMesh(MineMesh)
        self.Mine13:SetDrawScale(0.50)
        self.Mine13:SetVizToAllies('Intel')
        self.Mine13:SetVizToNeutrals('Intel')
        self.Mine13:SetVizToEnemies('Intel')
		self.Mine14 = import('/lua/sim/Entity.lua').Entity()
        self.Mine14:AttachBoneTo( -1, self, 'L2_Mine06' )
        self.Mine14:SetMesh(MineMesh)
        self.Mine14:SetDrawScale(0.50)
        self.Mine14:SetVizToAllies('Intel')
        self.Mine14:SetVizToNeutrals('Intel')
        self.Mine14:SetVizToEnemies('Intel')
		self.Mine15 = import('/lua/sim/Entity.lua').Entity()
        self.Mine15:AttachBoneTo( -1, self, 'L2_Mine07' )
        self.Mine15:SetMesh(MineMesh)
        self.Mine15:SetDrawScale(0.50)
        self.Mine15:SetVizToAllies('Intel')
        self.Mine15:SetVizToNeutrals('Intel')
        self.Mine15:SetVizToEnemies('Intel')
		self.Mine16 = import('/lua/sim/Entity.lua').Entity()
        self.Mine16:AttachBoneTo( -1, self, 'L2_Mine08' )
        self.Mine16:SetMesh(MineMesh)
        self.Mine16:SetDrawScale(0.50)
        self.Mine16:SetVizToAllies('Intel')
        self.Mine16:SetVizToNeutrals('Intel')
        self.Mine16:SetVizToEnemies('Intel')
		self.Mine17 = import('/lua/sim/Entity.lua').Entity()
        self.Mine17:AttachBoneTo( -1, self, 'L3_Mine01' )
        self.Mine17:SetMesh(MineMesh)
        self.Mine17:SetDrawScale(0.50)
        self.Mine17:SetVizToAllies('Intel')
        self.Mine17:SetVizToNeutrals('Intel')
        self.Mine17:SetVizToEnemies('Intel')
		self.Mine18 = import('/lua/sim/Entity.lua').Entity()
        self.Mine18:AttachBoneTo( -1, self, 'L3_Mine02' )
        self.Mine18:SetMesh(MineMesh)
        self.Mine18:SetDrawScale(0.50)
        self.Mine18:SetVizToAllies('Intel')
        self.Mine18:SetVizToNeutrals('Intel')
        self.Mine18:SetVizToEnemies('Intel')
		self.Mine19 = import('/lua/sim/Entity.lua').Entity()
        self.Mine19:AttachBoneTo( -1, self, 'L3_Mine03' )
        self.Mine19:SetMesh(MineMesh)
        self.Mine19:SetDrawScale(0.50)
        self.Mine19:SetVizToAllies('Intel')
        self.Mine19:SetVizToNeutrals('Intel')
        self.Mine19:SetVizToEnemies('Intel')
		self.Mine20 = import('/lua/sim/Entity.lua').Entity()
        self.Mine20:AttachBoneTo( -1, self, 'L3_Mine04' )
        self.Mine20:SetMesh(MineMesh)
        self.Mine20:SetDrawScale(0.50)
        self.Mine20:SetVizToAllies('Intel')
        self.Mine20:SetVizToNeutrals('Intel')
        self.Mine20:SetVizToEnemies('Intel')
		self.Mine21 = import('/lua/sim/Entity.lua').Entity()
        self.Mine21:AttachBoneTo( -1, self, 'L3_Mine05' )
        self.Mine21:SetMesh(MineMesh)
        self.Mine21:SetDrawScale(0.50)
        self.Mine21:SetVizToAllies('Intel')
        self.Mine21:SetVizToNeutrals('Intel')
        self.Mine21:SetVizToEnemies('Intel')
		self.Mine22 = import('/lua/sim/Entity.lua').Entity()
        self.Mine22:AttachBoneTo( -1, self, 'L3_Mine06' )
        self.Mine22:SetMesh(MineMesh)
        self.Mine22:SetDrawScale(0.50)
        self.Mine22:SetVizToAllies('Intel')
        self.Mine22:SetVizToNeutrals('Intel')
        self.Mine22:SetVizToEnemies('Intel')
		self.Mine23 = import('/lua/sim/Entity.lua').Entity()
        self.Mine23:AttachBoneTo( -1, self, 'L3_Mine07' )
        self.Mine23:SetMesh(MineMesh)
        self.Mine23:SetDrawScale(0.50)
        self.Mine23:SetVizToAllies('Intel')
        self.Mine23:SetVizToNeutrals('Intel')
        self.Mine23:SetVizToEnemies('Intel')
		self.Mine24 = import('/lua/sim/Entity.lua').Entity()
        self.Mine24:AttachBoneTo( -1, self, 'L3_Mine08' )
        self.Mine24:SetMesh(MineMesh)
        self.Mine24:SetDrawScale(0.50)
        self.Mine24:SetVizToAllies('Intel')
        self.Mine24:SetVizToNeutrals('Intel')
        self.Mine24:SetVizToEnemies('Intel')
		self.Mine25 = import('/lua/sim/Entity.lua').Entity()
        self.Mine25:AttachBoneTo( -1, self, 'L4_Mine01' )
        self.Mine25:SetMesh(MineMesh)
        self.Mine25:SetDrawScale(0.50)
        self.Mine25:SetVizToAllies('Intel')
        self.Mine25:SetVizToNeutrals('Intel')
        self.Mine25:SetVizToEnemies('Intel')
		self.Mine26 = import('/lua/sim/Entity.lua').Entity()
        self.Mine26:AttachBoneTo( -1, self, 'L4_Mine02' )
        self.Mine26:SetMesh(MineMesh)
        self.Mine26:SetDrawScale(0.50)
        self.Mine26:SetVizToAllies('Intel')
        self.Mine26:SetVizToNeutrals('Intel')
        self.Mine26:SetVizToEnemies('Intel')
		self.Mine27 = import('/lua/sim/Entity.lua').Entity()
        self.Mine27:AttachBoneTo( -1, self, 'L4_Mine03' )
        self.Mine27:SetMesh(MineMesh)
        self.Mine27:SetDrawScale(0.50)
        self.Mine27:SetVizToAllies('Intel')
        self.Mine27:SetVizToNeutrals('Intel')
        self.Mine27:SetVizToEnemies('Intel')
		self.Mine28 = import('/lua/sim/Entity.lua').Entity()
        self.Mine28:AttachBoneTo( -1, self, 'L4_Mine04' )
        self.Mine28:SetMesh(MineMesh)
        self.Mine28:SetDrawScale(0.50)
        self.Mine28:SetVizToAllies('Intel')
        self.Mine28:SetVizToNeutrals('Intel')
        self.Mine28:SetVizToEnemies('Intel')
		self.Mine29 = import('/lua/sim/Entity.lua').Entity()
        self.Mine29:AttachBoneTo( -1, self, 'L4_Mine05' )
        self.Mine29:SetMesh(MineMesh)
        self.Mine29:SetDrawScale(0.50)
        self.Mine29:SetVizToAllies('Intel')
        self.Mine29:SetVizToNeutrals('Intel')
        self.Mine29:SetVizToEnemies('Intel')
		self.Mine30 = import('/lua/sim/Entity.lua').Entity()
        self.Mine30:AttachBoneTo( -1, self, 'L4_Mine06' )
        self.Mine30:SetMesh(MineMesh)
        self.Mine30:SetDrawScale(0.50)
        self.Mine30:SetVizToAllies('Intel')
        self.Mine30:SetVizToNeutrals('Intel')
        self.Mine30:SetVizToEnemies('Intel')
		self.Mine31 = import('/lua/sim/Entity.lua').Entity()
        self.Mine31:AttachBoneTo( -1, self, 'L4_Mine07' )
        self.Mine31:SetMesh(MineMesh)
        self.Mine31:SetDrawScale(0.50)
        self.Mine31:SetVizToAllies('Intel')
        self.Mine31:SetVizToNeutrals('Intel')
        self.Mine31:SetVizToEnemies('Intel')
		self.Mine32 = import('/lua/sim/Entity.lua').Entity()
        self.Mine32:AttachBoneTo( -1, self, 'L4_Mine08' )
        self.Mine32:SetMesh(MineMesh)
        self.Mine32:SetDrawScale(0.50)
        self.Mine32:SetVizToAllies('Intel')
        self.Mine32:SetVizToNeutrals('Intel')
        self.Mine32:SetVizToEnemies('Intel')
		self.Mine33 = import('/lua/sim/Entity.lua').Entity()
        self.Mine33:AttachBoneTo( -1, self, 'L5_Mine01' )
        self.Mine33:SetMesh(MineMesh)
        self.Mine33:SetDrawScale(0.50)
        self.Mine33:SetVizToAllies('Intel')
        self.Mine33:SetVizToNeutrals('Intel')
        self.Mine33:SetVizToEnemies('Intel')
		self.Mine34 = import('/lua/sim/Entity.lua').Entity()
        self.Mine34:AttachBoneTo( -1, self, 'L5_Mine02' )
        self.Mine34:SetMesh(MineMesh)
        self.Mine34:SetDrawScale(0.50)
        self.Mine34:SetVizToAllies('Intel')
        self.Mine34:SetVizToNeutrals('Intel')
        self.Mine34:SetVizToEnemies('Intel')
		self.Mine35 = import('/lua/sim/Entity.lua').Entity()
        self.Mine35:AttachBoneTo( -1, self, 'L5_Mine03' )
        self.Mine35:SetMesh(MineMesh)
        self.Mine35:SetDrawScale(0.50)
        self.Mine35:SetVizToAllies('Intel')
        self.Mine35:SetVizToNeutrals('Intel')
        self.Mine35:SetVizToEnemies('Intel')
		self.Mine36 = import('/lua/sim/Entity.lua').Entity()
        self.Mine36:AttachBoneTo( -1, self, 'L5_Mine04' )
        self.Mine36:SetMesh(MineMesh)
        self.Mine36:SetDrawScale(0.50)
        self.Mine36:SetVizToAllies('Intel')
        self.Mine36:SetVizToNeutrals('Intel')
        self.Mine36:SetVizToEnemies('Intel')
		self.Mine37 = import('/lua/sim/Entity.lua').Entity()
        self.Mine37:AttachBoneTo( -1, self, 'L5_Mine05' )
        self.Mine37:SetMesh(MineMesh)
        self.Mine37:SetDrawScale(0.50)
        self.Mine37:SetVizToAllies('Intel')
        self.Mine37:SetVizToNeutrals('Intel')
        self.Mine37:SetVizToEnemies('Intel')
		self.Mine38 = import('/lua/sim/Entity.lua').Entity()
        self.Mine38:AttachBoneTo( -1, self, 'L5_Mine06' )
        self.Mine38:SetMesh(MineMesh)
        self.Mine38:SetDrawScale(0.50)
        self.Mine38:SetVizToAllies('Intel')
        self.Mine38:SetVizToNeutrals('Intel')
        self.Mine38:SetVizToEnemies('Intel')
		self.Mine39 = import('/lua/sim/Entity.lua').Entity()
        self.Mine39:AttachBoneTo( -1, self, 'L5_Mine07' )
        self.Mine39:SetMesh(MineMesh)
        self.Mine39:SetDrawScale(0.50)
        self.Mine39:SetVizToAllies('Intel')
        self.Mine39:SetVizToNeutrals('Intel')
        self.Mine39:SetVizToEnemies('Intel')
		self.Mine40 = import('/lua/sim/Entity.lua').Entity()
        self.Mine40:AttachBoneTo( -1, self, 'L5_Mine08' )
        self.Mine40:SetMesh(MineMesh)
        self.Mine40:SetDrawScale(0.50)
        self.Mine40:SetVizToAllies('Intel')
        self.Mine40:SetVizToNeutrals('Intel')
        self.Mine40:SetVizToEnemies('Intel')
		self.Mine41 = import('/lua/sim/Entity.lua').Entity()
        self.Mine41:AttachBoneTo( -1, self, 'L6_Mine01' )
        self.Mine41:SetMesh(MineMesh)
        self.Mine41:SetDrawScale(0.50)
        self.Mine41:SetVizToAllies('Intel')
        self.Mine41:SetVizToNeutrals('Intel')
        self.Mine41:SetVizToEnemies('Intel')
		self.Mine42 = import('/lua/sim/Entity.lua').Entity()
        self.Mine42:AttachBoneTo( -1, self, 'L6_Mine02' )
        self.Mine42:SetMesh(MineMesh)
        self.Mine42:SetDrawScale(0.50)
        self.Mine42:SetVizToAllies('Intel')
        self.Mine42:SetVizToNeutrals('Intel')
        self.Mine42:SetVizToEnemies('Intel')
		self.Mine43 = import('/lua/sim/Entity.lua').Entity()
        self.Mine43:AttachBoneTo( -1, self, 'L6_Mine03' )
        self.Mine43:SetMesh(MineMesh)
        self.Mine43:SetDrawScale(0.50)
        self.Mine43:SetVizToAllies('Intel')
        self.Mine43:SetVizToNeutrals('Intel')
        self.Mine43:SetVizToEnemies('Intel')
		self.Mine44 = import('/lua/sim/Entity.lua').Entity()
        self.Mine44:AttachBoneTo( -1, self, 'L6_Mine04' )
        self.Mine44:SetMesh(MineMesh)
        self.Mine44:SetDrawScale(0.50)
        self.Mine44:SetVizToAllies('Intel')
        self.Mine44:SetVizToNeutrals('Intel')
        self.Mine44:SetVizToEnemies('Intel')
		self.Mine45 = import('/lua/sim/Entity.lua').Entity()
        self.Mine45:AttachBoneTo( -1, self, 'L6_Mine05' )
        self.Mine45:SetMesh(MineMesh)
        self.Mine45:SetDrawScale(0.50)
        self.Mine45:SetVizToAllies('Intel')
        self.Mine45:SetVizToNeutrals('Intel')
        self.Mine45:SetVizToEnemies('Intel')
		self.Mine46 = import('/lua/sim/Entity.lua').Entity()
        self.Mine46:AttachBoneTo( -1, self, 'L6_Mine06' )
        self.Mine46:SetMesh(MineMesh)
        self.Mine46:SetDrawScale(0.50)
        self.Mine46:SetVizToAllies('Intel')
        self.Mine46:SetVizToNeutrals('Intel')
        self.Mine46:SetVizToEnemies('Intel')
		self.Mine47 = import('/lua/sim/Entity.lua').Entity()
        self.Mine47:AttachBoneTo( -1, self, 'L6_Mine07' )
        self.Mine47:SetMesh(MineMesh)
        self.Mine47:SetDrawScale(0.50)
        self.Mine47:SetVizToAllies('Intel')
        self.Mine47:SetVizToNeutrals('Intel')
        self.Mine47:SetVizToEnemies('Intel')
		self.Mine48 = import('/lua/sim/Entity.lua').Entity()
        self.Mine48:AttachBoneTo( -1, self, 'L6_Mine08' )
        self.Mine48:SetMesh(MineMesh)
        self.Mine48:SetDrawScale(0.50)
        self.Mine48:SetVizToAllies('Intel')
        self.Mine48:SetVizToNeutrals('Intel')
        self.Mine48:SetVizToEnemies('Intel')
	end,
	
	OnReclaimed = function(self, reclaimer)
		if self.ClapDummy then
		self.ClapDummy:Destroy()
		end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		
		if self.ClapDummy then
		self.ClapDummy:Destroy()
		end
		
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
		self:CreateWreckage(overkillRatio or self.overkillRatio)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
}

TypeClass = UEBMD0102