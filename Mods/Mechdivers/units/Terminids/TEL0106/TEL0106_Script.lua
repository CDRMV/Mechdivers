#****************************************************************************
#**
#**  File     :  /cdimage/units/UEL0106/UEL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Light Assault Bot Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local TerminideWalkingLandUnit = import('/lua/Defaultunits.lua').TerminideWalkingLandUnit
local TDFMachineGunWeapon = import('/lua/terranweapons.lua').TDFMachineGunWeapon
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local CARRIER = '/mods/Mechdivers/projectiles/Jump/Jump_proj.bp'
local GRAVITY, JUMP_SPEED = 9.8, 20

TEL0106 = Class(TerminideWalkingLandUnit) {
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
				self:ChangeMaxRadius(1.0)
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
		self:ChangeMaxRadius(15)
            DummyTurretWeapon.OnLostTarget(self)
        end, 
			},
		Melee = Class(DummyTurretWeapon) {
		
		OnWeaponFired = function(self)
			ForkThread( function()
			local animator = CreateAnimator(self.unit)
            animator:PlayAnim('/Mods/Mechdivers/units/Terminids/TEL0106/TEL0106_AMelee01.sca', false):SetRate(2)
			WaitFor(animator)
			animator:Destroy()
			end)
		end,
			},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        TerminideWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.DoMeleeThreadHandle = self:ForkThread(self.DoMeleeThread)
		self.jump = false
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
    local attached = self:AttachBoneTo('Bone', carrier, -2)
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
TypeClass = TEL0106

