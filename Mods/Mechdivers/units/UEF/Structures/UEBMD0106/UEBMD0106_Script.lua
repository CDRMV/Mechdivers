#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB2101/UEB2101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Terran Light Gun Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TStructureUnit = import('/lua/defaultunits.lua').RadarUnit
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
local R, Ceil = Random, math.ceil
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local CSoothSayerAmbient = import('/lua/EffectTemplates.lua').CSoothSayerAmbient

UEBMD0106 = Class(TStructureUnit) {

	IntelEffects = {
		{
            Bones = { 'Turret', },
            Offset = { 0, 0, 0, },
            Type = 'Jammer01',
		},
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
		ClapDummy = '/mods/Mechdivers/projectiles/Null/Null_proj_mesh',
        self.ClapDummy:AttachBoneTo( -2, self, 'Main_Clap1' )
        self.ClapDummy:SetMesh(ClapDummy)
        self.ClapDummy:SetDrawScale(0.50)
        self.ClapDummy:SetVizToAllies('Intel')
        self.ClapDummy:SetVizToNeutrals('Intel')
        self.ClapDummy:SetVizToEnemies('Intel')
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
        self.AnimationManipulator3:PlayAnim(self:GetBlueprint().Display.AnimationBeaconUnpack, false):SetRate(0)	
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
		self.ClapDummy:Destroy()
		local x = math.random(-1, 1)
		local z = math.random(-1, 1)
		self.Clap = self:CreateProjectile('/Mods/Mechdivers/projectiles/Null/Null_proj.bp', 0, 0.5, 0, x, 7, z)
		WaitFor(self.AnimationManipulator2)
        self.AnimationManipulator3:PlayAnim(self:GetBlueprint().Display.AnimationBeaconUnpack, false):SetRate(2)	
		WaitFor(self.AnimationManipulator3)
        self.ExpandingVisionDisableCount = 1
		self:OnIntelEnabled()
		end
		)
    end,
    
    
    OnKilled = function(self, instigator, type, overkillRatio)
        local curRadius = self:GetIntelRadius('vision')
        local position = self:GetPosition()
        local army = self:GetAIBrain():GetArmyIndex()
        TStructureUnit.OnKilled(self, instigator, type, overkillRatio)
        local spec = {
            X = position[1],
            Z = position[3],
            Radius = curRadius,
            LifeTime = -1,
            Army = army,
        }
        local vizEnt = VizMarker(spec)
        vizEnt.DeathThread = ForkThread(self.VisibleEntityDeathThread, vizEnt, curRadius)
    end,
    
    VisibleEntityDeathThread = function(entity, curRadius)
        local lifetime = 0
        while lifetime < 30 do
            if curRadius > 1 then
                curRadius = curRadius - 1
                if curRadius < 1 then
                    curRadius = 1
                end
                entity:SetIntelRadius('vision', curRadius)
            end
            lifetime = lifetime + 2
            WaitSeconds(0.1)
        end
        entity:Destroy()
    end,

    OnIntelEnabled = function(self)
		if not self.Spinner then
		self.Spinner = CreateRotator(self, 'Turret', 'y', nil, 0, 30, 360)
		end
		self.Spinner:SetTargetSpeed(180)
		if not self.AnimationManipulator4 then
            self.AnimationManipulator4 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator4)
        end
	
		self.AnimationManipulator4:PlayAnim('/Mods/Mechdivers/units/UEF/Structures/UEBMD0106/UEBMD0106_Activate.sca', false):SetRate(1)	
        self.ExpandingVisionDisableCount = self.ExpandingVisionDisableCount - 1
        if self.ExpandingVisionDisableCount == 0 then 		            
            ChangeState( self, self.ExpandingVision )
        end
    end,

    OnIntelDisabled = function(self)
		if not self.Spinner then
		self.Spinner = CreateRotator(self, 'Turret', 'y', nil, 0, 30, 360)
		end
		self.Spinner:SetTargetSpeed(0)
		if not self.AnimationManipulator4 then
            self.AnimationManipulator4 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator4)
        end
	
		self.AnimationManipulator4:PlayAnim('/Mods/Mechdivers/units/UEF/Structures/UEBMD0106/UEBMD0106_Activate.sca', false):SetRate(-1)	
        self.ExpandingVisionDisableCount = self.ExpandingVisionDisableCount + 1
        if self.ExpandingVisionDisableCount == 1 then
            ChangeState( self, self.ContractingVision )
        end
    end,
    
    ExpandingVision = State {
        Main = function(self)
            WaitSeconds(0.1)
            while true do
                if self:GetResourceConsumed() ~= 1 then
                    self.ExpandingVisionEnergyCheck = true
                    self:OnIntelDisabled()
                end
                local curRadius = self:GetIntelRadius('vision')
                local targetRadius = self:GetBlueprint().Intel.MaxVisionRadius
                if curRadius < targetRadius then
                    curRadius = curRadius + 1
                    if curRadius >= targetRadius then
                        self:SetIntelRadius('vision', targetRadius)
                    else
                        self:SetIntelRadius('vision', curRadius)
                    end
                end
                WaitSeconds(0.2)
            end
        end,
    },
    
    ContractingVision = State {
        Main = function(self)
            while true do
                if self:GetResourceConsumed() == 1 then
                    if self.ExpandingVisionEnergyCheck then
                        self:OnIntelEnabled()
                    else
                        self:OnIntelDisabled()
                        self.ExpandingVisionEnergyCheck = true
                    end
                end
                local curRadius = self:GetIntelRadius('vision')
                local targetRadius = self:GetBlueprint().Intel.MinVisionRadius
                if curRadius > targetRadius then
                    curRadius = curRadius - 1
                    if curRadius <= targetRadius then
                        self:SetIntelRadius('vision', targetRadius)
                    else
                        self:SetIntelRadius('vision', curRadius)
                    end
                end
                WaitSeconds(0.2)
            end
        end,
    },
}

TypeClass = UEBMD0106