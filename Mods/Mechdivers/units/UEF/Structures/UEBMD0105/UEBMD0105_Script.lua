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

UEBMD0105 = Class(TStructureUnit) {

	
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
		ClapDummy = '/Mods/Mechdivers/projectiles/DropClap/DropClap_proj_mesh',
        self.ClapDummy:AttachBoneTo( -2, self, 'Main_Clap1' )
        self.ClapDummy:SetMesh(ClapDummy)
        self.ClapDummy:SetDrawScale(0.50)
        self.ClapDummy:SetVizToAllies('Intel')
        self.ClapDummy:SetVizToNeutrals('Intel')
        self.ClapDummy:SetVizToEnemies('Intel')
		self.Enabled = false	
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
        self.AnimationManipulator3:PlayAnim(self:GetBlueprint().Display.AnimationBombUnpack, false):SetRate(0)	
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
		local x = math.random(-1, 1)
		local z = math.random(-1, 1)
		self.Clap = self:CreateProjectile('/Mods/Mechdivers/projectiles/DropClap/DropClap_proj.bp', 0, 0.5, 0, x, 7, z)
		self.ClapDummy:DetachFrom(true)
		self.ClapDummy:AttachBoneTo( -2, self.Clap, -2 )
		WaitFor(self.AnimationManipulator2)
        self.AnimationManipulator3:PlayAnim(self:GetBlueprint().Display.AnimationBombUnpack, false):SetRate(2)	
		WaitFor(self.AnimationManipulator3)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:AddToggleCap('RULEUTC_SpecialToggle')
		
		if not self.AnimationManipulator4 then
            self.AnimationManipulator4 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator4)
        end
		
		end
		)
    end,
	
	OnScriptBitSet = function(self, bit)
        TStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
			ForkThread( function()
			self.Enabled = true
			self:RemoveToggleCap('RULEUTC_WeaponToggle')
			self:RemoveToggleCap('RULEUTC_SpecialToggle')
			self.AnimationManipulator4:PlayAnim('/Mods/Mechdivers/units/UEF/Structures/UEBMD0105/UEBMD0105_Activate.sca', false):SetRate(1)	
			WaitFor(self.AnimationManipulator4)
			WaitSeconds(20)
			if not self.Dead then
			self:Kill()
			end
			end)
        end
		if bit == 7 then 
			self.AutomaticDetonationThreadHandle = self:ForkThread(self.AutomaticDetonationThread)
        end
    end,

    OnScriptBitClear = function(self, bit)
        TStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 

        end
		if bit == 7 then 
			KillThread(self.AutomaticDetonationThreadHandle)
        end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		if self.Enabled == true then
		local position = self:GetPosition()
        DamageArea(self, position, 15, 25000, 'Nuke', true)
		local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
		local rotation = RandomFloat(0,2*math.pi)
		local size = RandomFloat(45.75,45.0)
		CreateDecal(self:GetPosition(), rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 150, self:GetArmy())
		nukeProjectile = self:CreateProjectile('/mods/Mechdivers/effects/Entities/Blu4000/Blu4000EffectController01/Blu4000EffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
        nukeProjectile:PassDamageData(self.DamageData)
        nukeProjectile:PassData(self.Data)
		
		else
		self:CreateWreckage(overkillRatio or self.overkillRatio)
		end

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
	AutomaticDetonationThread = function(self)
 		while not self:IsDead() do
			local unitPos = self:GetPosition()
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, 20, 'Enemy')
            for _,unit in units do
				self:SetScriptBit('RULEUTC_WeaponToggle', true)
            end
            WaitSeconds(0.1)
		end	
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

TypeClass = UEBMD0105