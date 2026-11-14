#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0106/URL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Light Infantry Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local ModTexPath = '/mods/Mechdivers/textures/particles/'
local ModEmPath = '/mods/Mechdivers/effects/emitters/'
local CARRIER = '/mods/Mechdivers/projectiles/Jump/Jump_proj.bp'
local GRAVITY, JUMP_SPEED = 9.8, 20

CSKMDCL0310 = Class(CWalkingLandUnit) {
    Weapons = {
		Dummy = Class(DummyTurretWeapon) {
		
		IdleState = State (DummyTurretWeapon.IdleState) {
        Main = function(self)
            DummyTurretWeapon.IdleState.Main(self)
        end,
                
        OnGotTarget = function(self)
			   local pos = self:GetCurrentTargetPos()
			   local dist = self.unit:GetDistanceToTarget(pos, self.unit:GetPosition())
			   	local number = math.random(1,2)
				if number == 1 then

				else
				if dist < 3.5 then
				elseif dist > 3.5 < 8.0 then
				self.unit:Jump(pos)
				pos = nil 
				end
				end
               DummyTurretWeapon.OnGotTarget(self)
        end,               
            },
		OnLostTarget = function(self)

            DummyTurretWeapon.OnLostTarget(self)
        end, 
			},
		Melee = Class(DummyTurretWeapon) {
		
		IdleState = State (DummyTurretWeapon.IdleState) {
        Main = function(self)
            DummyTurretWeapon.IdleState.Main(self)
        end,
                
        OnGotTarget = function(self)
			   local wep1 = self.unit:GetWeaponByLabel('Flamethrower')
			   wep1:SetEnabled(false)
               DummyTurretWeapon.OnGotTarget(self)
        end,                
            },
        
        OnGotTarget = function(self)
			   local wep1 = self.unit:GetWeaponByLabel('Flamethrower')
			   wep1:SetEnabled(false)
               DummyTurretWeapon.OnGotTarget(self)
        end,
        
        OnLostTarget = function(self)
			local wep1 = self.unit:GetWeaponByLabel('Flamethrower')
			wep1:SetEnabled(true)
            DummyTurretWeapon.OnLostTarget(self)
        end,  
		
		OnWeaponFired = function(self)
			ForkThread( function()
			self.unit.number = 0
			local animator = CreateAnimator(self.unit)
			local number = math.random(1,2)
			if number == 1 then
            animator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0307/CSKMDCL0307_ASaw01.sca', false):SetRate(2)
			else
			animator:PlayAnim('/Mods/Mechdivers/units/Cybran/CSKMDCL0307/CSKMDCL0307_ASaw02.sca', false):SetRate(2)
			end
			WaitFor(animator)
			animator:Destroy()
			end)
		end,
			},
        Flamethrower = Class(TDFMachineGunWeapon) {},
    },
	
	OnMotionHorzEventChange = function(self, new, old)
        CWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
		if old == 'Stopped' then
			self:AddToggleCap('RULEUTC_SpecialToggle')
			self:SetScriptBit('RULEUTC_SpecialToggle', false)
        elseif new == 'Stopped' then
			self:RemoveToggleCap('RULEUTC_SpecialToggle')
        end
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
        if bit == 7 then 
			KillThread(self.DoMeleeThread)
			local Oldlocation = self:GetPosition()
			local MovePos = self:GetCurrentMoveLocation()
			local LandUnit = {} 
			local bp = self:GetBlueprint()
			local AirDummyUnit = bp.Display.AirDummyUnit
			LOG('ScriptBit: ',self:GetScriptBit(2))
			LOG('MovePos: ',MovePos)
			ForkThread( function()
			local aiBrain = self:GetAIBrain()
			local qx, qy, qz, qw = unpack(self:GetOrientation())
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			LandUnit[1] = CreateUnit(AirDummyUnit,self:GetArmy(),Oldlocation[1], Oldlocation[2], Oldlocation[3],qx, qy, qz, qw, 0)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			self:AttachBoneTo(-2, LandUnit[1], 0)
			for i, Unit in LandUnit do
			EffectBones = self:GetBlueprint().Display.JetPackEffectBones
			self.Effect1 = CreateAttachedEmitter(self,EffectBones[1],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
            self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedEmitter(self,EffectBones[2],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
            self.Trash:Add(self.Effect2)
			self.Effect3 = CreateAttachedBeam(self,EffectBones[1],self:GetArmy(),  0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect3)
			self.Effect4 = CreateAttachedBeam(self,EffectBones[2],self:GetArmy(), 0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect4)
			LandUnit[1]:SetElevation(10)
            IssueTransportUnload({Unit}, MovePos)
            end
			end
			)
        end
		end)
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 7 then 
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
			self.DoMeleeThreadHandle = self:ForkThread(self.DoMeleeThread)
        end
    end,
	
	OnCreate = function(self)
		CWalkingLandUnit.OnCreate(self)
		self.FireEffect = CreateAttachedEmitter(self,'L_Arm_Fire',self:GetArmy(), '/effects/emitters/op_ambient_fire_01_emit.bp'):ScaleEmitter(0.05)
		self.SawEffect = CreateAttachedEmitter(self,'R_Arm_Saw',self:GetArmy(), '/effects/emitters/destruction_damaged_sparks_01_emit.bp'):ScaleEmitter(0.8)
		self.Saw = CreateRotator(self, 'R_Arm_Saw', 'x', nil, 0, 60, 360):SetTargetSpeed(270)
		self.JetPackEffectsBag = {}
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		self.jump = false
		self.DoMeleeThreadHandle = self:ForkThread(self.DoMeleeThread)
    end,
	
	DoMeleeThread = function(self)
			local unitPos = self:GetPosition()
			local radius = self:GetBlueprint().Intel.VisionRadius
			while not self:IsDead() do
			if self:GetFireState() == 1 then
			
			else
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.MOBILE + categories.LAND, unitPos, radius, 'Enemy')
            for _,unit in units do
			IssueAttack({self}, unit)
            end
			end
			WaitSeconds(0.1)
			end
    end,
	
	
	jump_target = function(self, location)
    local pos = self:GetPosition()
    local range = 40
    local dx, dz = location[1] - pos[1], location[3] - pos[3]
    local dist = math.sqrt(dx * dx + dz * dz)
    if dist > range then
        dx, dz = dx * range / dist, dz * range / dist
        dist = range
    end
    return pos, dx, dz, dist
end,

jump_thread = function(self, location)
    local pos, dx, dz, dist = self:jump_target(location)
    local land = { pos[1] + dx, 0, pos[3] + dz }
    land[2] = GetSurfaceHeight(land[1], land[3])
    local face = (dist > 0.1) and OrientFromDir(Vector(dx, 0, dz)) or self:GetOrientation()
    self:SetImmobile(true)
    local T = math.max(1.2, dist / JUMP_SPEED)
    local dy = land[2] - pos[2]
    local carrier = self:CreateProjectile(CARRIER, 0, 0, 0, nil, nil, nil)
    carrier:SetOrientation(face, true)
    carrier:SetBallisticAcceleration(-GRAVITY)
    carrier:SetVelocity(dx / T, dy / T + GRAVITY * T / 2, dz / T)
	EffectBones = self:GetBlueprint().Display.JetPackEffectBones
	self.Effect1 = CreateAttachedEmitter(self,EffectBones[1],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
    self.Trash:Add(self.Effect1)
	self.Effect2 = CreateAttachedEmitter(self,EffectBones[2],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
    self.Trash:Add(self.Effect2)
	self.Effect3 = CreateAttachedBeam(self,EffectBones[1],self:GetArmy(),  0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
    self.Trash:Add(self.Effect3)
	self.Effect4 = CreateAttachedBeam(self,EffectBones[2],self:GetArmy(), 0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
    self.Trash:Add(self.Effect4)
    local attached = self:AttachBoneTo('CSKMDCL0306', carrier, -2)
    local t = 0
    while t < T - 0.05 and not self.Dead and not carrier:BeenDestroyed() do
        WaitTicks(1)
        t = t + 0.1
    end
    if attached and not self.Dead then self:DetachFrom(true) end
    if not carrier:BeenDestroyed() then carrier:Destroy() end
    if self.Dead then return end
    if self:IsUnitState('Attached') then
	self:DetachFrom(true) 
	self.Effect1:Destroy()
	self.Effect2:Destroy()
	self.Effect3:Destroy()
	self.Effect4:Destroy()
    land[2] = GetSurfaceHeight(land[1], land[3])
	Warp(self, land, face)
	self:SetImmobile(false)
    IssueClearCommands(self)
	self.jump = false
	end
end,

--- the Unit hook's OnTeleportUnit: the Teleport order is SC2's jump on units with jump jets. True when handled
Jump = function(self, location)
self.jump = true
    local layer = self:GetCurrentLayer()
    local ok = layer
    local area = ScenarioInfo and ScenarioInfo.PlayableArea
	if ok and area and (location[1] < (area[1] or 0) + 1 or location[1] > area[3] - 1
        or location[3] < (area[2] or 0) + 1 or location[3] > area[4] - 1) then
        ok = false
    end
    if self:GetCurrentLayer() == 'Land' then
        local pos, dx, dz = self:jump_target(location)
        local x, z = pos[1] + dx, pos[3] + dz
        local depth = GetSurfaceHeight(x, z) - GetTerrainHeight(x, z)
            ok = depth <= 0.1
    end
    if not self:GetCurrentLayer() == 'Land' then
        IssueClearCommands(self)
        return true
    end
    self:ForkThread(self.jump_thread, location)
    return true
end,

    GetDistanceToTarget = function(self, tpos, spos)
        local dist = VDist2(spos[1], spos[3], tpos[1], tpos[3])
        return dist
    end,
}

TypeClass = CSKMDCL0310