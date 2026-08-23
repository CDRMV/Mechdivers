#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0111/UEL0111_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Mobile Missile Launcher Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TLandUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local EffectUtil = import('/lua/EffectUtilities.lua')
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon

CSKMDTL0311 = Class(TLandUnit) {

    Weapons = {
	    Dummy = Class(DummyTurretWeapon) {},
		AADummy = Class(DummyTurretWeapon) {
		IdleState = State (DummyTurretWeapon.IdleState) {
        Main = function(self)
                    DummyTurretWeapon.IdleState.Main(self)
                end,
                
        OnGotTarget = function(self)
		LOG(self.unit:GetFireState())
			if self.unit:GetFireState() == 0 then
			local target = self.unit:GetTargetEntity()
			if target then
			if self.unit.Module and not self.unit.Module.Dead then
			IssueClearCommands({self.unit.Module})
			self.unit.Module:GetWeapon(1):SetTargetEntity(target)
			IssueAttack({self.unit.Module}, target)
			end
			end
			elseif self.unit:GetFireState() == 1 then
			if self.unit.Module and not self.unit.Module.Dead then
			IssueClearCommands({self.unit.Module})
			end
			end
               DummyTurretWeapon.OnGotTarget(self)
        end,                
            },
			
		OnGotTarget = function(self)
			if self.unit:GetFireState() == 0 then
			local target = self.unit:GetTargetEntity()
			if target then
			if self.unit.Module and not self.unit.Module.Dead then
			IssueClearCommands({self.unit.Module})
			self.unit.Module:GetWeapon(1):SetTargetEntity(target)
			IssueAttack({self.unit.Module}, target)
			end
			end
			elseif self.unit:GetFireState() == 1 then
			if self.unit.Module and not self.unit.Module.Dead then
			IssueClearCommands({self.unit.Module})
			end
			end
               DummyTurretWeapon.OnGotTarget(self)
        end, 
        
        OnLostTarget = function(self)
			if self.unit.Module and not self.unit.Module.Dead then
			IssueClearCommands({self.unit.Module})
			end
            DummyTurretWeapon.OnLostTarget(self)
        end,  	
		
		},
		GroundDummy = Class(DummyTurretWeapon) {
		IdleState = State (DummyTurretWeapon.IdleState) {
        Main = function(self)
                    DummyTurretWeapon.IdleState.Main(self)
                end,
                
        OnGotTarget = function(self)
			self.unit:SetScriptBit('RULEUTC_SpecialToggle',true)
			if self.unit:GetFireState() == 2 then
			local target = self.unit:GetTargetEntity()
			if target then
			
			else
			local targetposition = self:GetCurrentTargetPos()
			if targetposition then
			if self.unit.Module and not self.unit.Module.Dead then
			IssueClearCommands({self.unit.Module})
			self.unit.Module:GetWeapon(1):SetTargetGround(targetposition)
			IssueAttack({self.unit.Module}, targetposition)
			end
			end
			end
			elseif self.unit:GetFireState() == 0 then
			if self.unit.Module and not self.unit.Module.Dead then
			IssueClearCommands({self.unit.Module})
			end
			end
               DummyTurretWeapon.OnGotTarget(self)
        end,                
            },
			
		OnGotTarget = function(self)
			self.unit:SetScriptBit('RULEUTC_SpecialToggle',true)
			if self.unit:GetFireState() == 2 then
			local target = self.unit:GetTargetEntity()
			if target then
			
			else
			local targetposition = self:GetCurrentTargetPos()
			if targetposition then
			if self.unit.Module and not self.unit.Module.Dead then
			IssueClearCommands({self.unit.Module})
			self.unit.Module:GetWeapon(1):SetTargetGround(targetposition)
			IssueAttack({self.unit.Module}, targetposition)
			end
			end
			end
			elseif self.unit:GetFireState() == 0 then
			if self.unit.Module and not self.unit.Module.Dead then
			IssueClearCommands({self.unit.Module})
			end
			end
               DummyTurretWeapon.OnGotTarget(self)
        end, 
        
        OnLostTarget = function(self)
			self.unit:SetScriptBit('RULEUTC_SpecialToggle',false)
			if self.unit.Module and not self.unit.Module.Dead then
			IssueClearCommands({self.unit.Module})
			end
            DummyTurretWeapon.OnLostTarget(self)
        end,  	
		
		},
		LACGun = Class(TDFGaussCannonWeapon) {
		--[[
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'L_Turret_Muzzle' then
		CreateAttachedEmitter(self.unit, 'L_Turret_Shell', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		]]--
		},
		RACGun = Class(TDFGaussCannonWeapon) {
		--[[
		PlayFxMuzzleSequence = function(self, muzzle)
		TDFGaussCannonWeapon.PlayFxMuzzleSequence(self, muzzle)
		if muzzle == 'R_Turret_Muzzle' then
		CreateAttachedEmitter(self.unit, 'R_Turret_Shell', self.unit:GetArmy(), '/mods/Mechdivers/effects/emitters/autocannon_shell_01_emit.bp')
		end
		end,
		]]--
		},
		Gun = Class(TDFGaussCannonWeapon) {},
    },

	OnStopBeingBuilt = function(self,builder,layer)
		TLandUnit.OnStopBeingBuilt(self,builder,layer)
		if not self.AnimationManipulator1 then
            self.AnimationManipulator1 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator1)
        end
		self.AnimationManipulator1:PlayAnim('/Mods/Mechdivers/units/UEF/CSKMDTL0311/CSKMDTL0311_ADeploy.sca', false):SetRate(0)
		 ChangeState(self, self.IdleState)
		self.Module = nil
		self.wep = self:GetWeaponByLabel('AADummy')
		self.wep:SetEnabled(false)
		self.wep2 = self:GetWeaponByLabel('GroundDummy')
		self.wep2:SetEnabled(false)
		self.wep3 = self:GetWeaponByLabel('Dummy')
		self.wep3:ChangeMaxRadius(35)
		ForkThread(function()
		while self and not self.Dead do
		if self:GetFireState() == 0 then
		if self.Module and not self.Module.Dead then
		self.Module:SetFireState(0)
		end
		elseif self:GetFireState() == 1 then
		if self.Module and not self.Module.Dead then
		self.Module:SetFireState(1)
		end
		elseif self:GetFireState() == 2 then
		if self.Module and not self.Module.Dead then
		self.Module:SetFireState(2)
		end
		end
		WaitSeconds(1)
		end
		end)
    end,
	
	BuildAttachBone = 'AttachPoint',

    OnFailedToBuild = function(self)
        TLandUnit.OnFailedToBuild(self)
        ChangeState(self, self.IdleState)
    end,

    IdleState = State {
        OnStartBuild = function(self, unitBuilding, order)
            self:SetBusy(true)
            TLandUnit.OnStartBuild(self, unitBuilding, order)
            self.UnitBeingBuilt = unitBuilding
            ChangeState(self, self.BuildingState)
        end,

        Main = function(self)
            self:SetBusy(false)
        end,
    },

    BuildingState = State {

        Main = function(self)
            local unitBuilding = self.UnitBeingBuilt
            local bone = self.BuildAttachBone
            if not self.UnitBeingBuilt:IsDead() then
                unitBuilding:AttachBoneTo( -2, self, bone )
            end
			for k, v in self:GetBlueprint().General.BuildBones.BuildEffectBones do
            self.BuildEffectsBag:Add( CreateAttachedEmitter( self, v, self:GetArmy(), '/effects/emitters/flashing_blue_glow_01_emit.bp' ) )         
            self.BuildEffectsBag:Add(self:CreateDefaultBuildBeams(unitBuilding, {v}, self.BuildEffectsBag ))
			end
            WaitSeconds(3)
            unitBuilding:ShowBone(0,true)
            local unitBuilding = self.UnitBeingBuilt
            self.UnitDoneBeingBuilt = false
        end,

        OnStopBuild = function(self, unitBeingBuilt)
            TLandUnit.OnStopBuild(self, unitBeingBuilt)

            ChangeState(self, self.FinishedBuildingState)
        end,

    },

    FinishedBuildingState = State {
        Main = function(self)
            self:SetBusy(true)
            local unitBuilding = self.UnitBeingBuilt
			self:AddBuildRestriction(categories.BUILTBYTIER3MODULARTRUCK)
			self:AddToggleCap('RULEUTC_WeaponToggle')
            self:SetBusy(false)
            self:RequestRefreshUI()
			self.Module = unitBuilding
			if self.Module:GetBlueprint().General.UnitName == 'Slatter' or self.Module:GetBlueprint().General.UnitName == 'L/64 Air Guard' then
			self.wep:ChangeMaxRadius(100)
			self.wep:SetEnabled(true)
			else
			self.wep:ChangeMaxRadius(0.01)
			self.wep:SetEnabled(false)
			end
			if self.Module:GetBlueprint().General.UnitName == 'HIMARS 3000' then
			self:AddToggleCap('RULEUTC_IntelToggle')
			self:GiveTacticalSiloAmmo(4)
			end
			if self.Module:GetBlueprint().General.UnitName == 'Pak 150' or 
			self.Module:GetBlueprint().General.UnitName == 'HIMARS 3000' or 
			self.Module:GetBlueprint().General.UnitName == 'Karl Mark II' then
			self:AddToggleCap('RULEUTC_SpecialToggle')
			self.wep2:SetEnabled(true)
			self.wep2:ChangeMaxRadius(150)
			self.wep3:ChangeMaxRadius(150)
			else
			self.wep2:SetEnabled(false)
			self.wep2:ChangeMaxRadius(35)
			self.wep3:ChangeMaxRadius(35)
			end
            ChangeState(self, self.IdleState)
        end,
    },
	
	OnScriptBitSet = function(self, bit)
        TLandUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
		if bit == 1 then 
		if self.Module and not self.Module.Dead then
		self.Module:Destroy()
		self:RemoveBuildRestriction(categories.BUILTBYTIER3MODULARTRUCK)
		self:RequestRefreshUI()
		self:SetScriptBit('RULEUTC_WeaponToggle',false)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self:RemoveToggleCap('RULEUTC_IntelToggle')
		self:AddToggleCap('RULEUTC_SpecialToggle')
		end
		elseif bit == 7 then 
		self:SetImmobile(true)
		self.AnimationManipulator1:SetRate(1)
		WaitFor(self.AnimationManipulator1)
		elseif bit == 3 then
		self:SetScriptBit('RULEUTC_SpecialToggle',true)
		if self.Module:GetTacticalSiloAmmoCount() == 0 then
		
		else
		self.Module:GetWeaponByLabel('MissileRack01'):SetTargetGround(self:GetPosition())
		self.Module:GetWeaponByLabel('MissileRack01'):FireWeapon()
		end
		self:SetScriptBit('RULEUTC_IntelToggle',false)
		end
		end)
    end,

    OnScriptBitClear = function(self, bit)
        TLandUnit.OnScriptBitClear(self, bit)
		ForkThread(function()
		if bit == 1 then 

		elseif bit == 7 then 
		self.AnimationManipulator1:SetRate(-1)
		WaitFor(self.AnimationManipulator1)
		self:SetImmobile(false)
		end
		end)
    end,
	
	
	OnKilled = function(self, instigator, type, overkillRatio)
	if self.Module and not self.Module.Dead then
	self.Module:Kill()
	end
    TLandUnit.OnKilled(self, instigator, type, overkillRatio)	
    end,
	
	CreateDefaultBuildBeams = function(builder, unitBeingBuilt, BuildEffectBones, BuildEffectsBag )
	ForkThread( function()
    local BeamBuildEmtBp = '/effects/emitters/build_beam_01_emit.bp'
    local ox, oy, oz = unpack(builder:GetPosition('AttachPoint'))
	local Entity = import('/lua/sim/Entity.lua').Entity
    local BeamEndEntity = Entity()
    local army = builder:GetArmy()
    BuildEffectsBag:Add( BeamEndEntity )
    Warp( BeamEndEntity, Vector(ox, oy, oz))   
   
    local BuildBeams = {}

    # Create build beams
    if BuildEffectBones != nil then
        local beamEffect = nil
        for i, BuildBone in BuildEffectBones do
            local beamEffect = AttachBeamEntityToEntity(builder, BuildBone, BeamEndEntity, -2, army, BeamBuildEmtBp )
            table.insert( BuildBeams, beamEffect )
            BuildEffectsBag:Add(beamEffect)
        end
    end    

    CreateEmitterOnEntity( BeamEndEntity, builder:GetArmy(),'/effects/emitters/sparks_08_emit.bp')
    local waitTime = RandomFloat( 0.3, 1.5 )

    while true do
	if BeamEndEntity:BeenDestroyed() then
	break
	else
        local x, y, z = builder.GetRandomOffset(unitBeingBuilt, 1 )
        Warp( BeamEndEntity, Vector(ox + x, oy + y, oz + z))
	end
        WaitSeconds(waitTime)
    end
	end)
	end,
}

TypeClass = CSKMDTL0311