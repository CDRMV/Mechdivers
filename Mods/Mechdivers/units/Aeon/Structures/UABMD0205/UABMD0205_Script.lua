#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB2101/UAB2101_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Light Laser Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local DummyTurretWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local GetDistanceBetweenTwoEntities = import("/lua/utilities.lua").GetDistanceBetweenTwoEntities
local Explosion = import('/lua/defaultexplosions.lua')

function SetRotation(unit, angle)
        local qx, qy, qz, qw = Explosion.QuatFromRotation(angle, 0, 1, 0)
        unit:SetOrientation({qx, qy, qz, qw}, true)
end

    ---@param self Unit
    ---@param angle number
function Rotate(unit, angle)
        local qx, qy, qz, qw = unpack(unit:GetOrientation())
        local a = math.atan2(2.0 * (qx * qz + qw * qy), qw * qw + qx * qx - qz * qz - qy * qy)
        local current_yaw = math.floor(math.abs(a) * (180 / math.pi) + 0.5)

        SetRotation(angle + current_yaw)
end

    ---@param self Unit
    ---@param tpos number
function RotateTowards(unit, tpos)
        local pos = unit:GetPosition()
        local rad = math.atan2(tpos[1] - pos[1], tpos[3] - pos[3])
        SetRotation(unit, rad * (180 / math.pi))
end

    ---@param self Unit
function RotateTowardsMid(unit)
        local x, y = GetMapSize()
        RotateTowards(unit, {x / 2, 0, y / 2})
end

	
function GetPlayableArea()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end

UABMD0205 = Class(AStructureUnit) {
    Weapons = {
        Dummy = Class(DummyTurretWeapon) {},
		Dummy2 = Class(DummyTurretWeapon) {
		IdleState = State (DummyTurretWeapon.IdleState) {
        Main = function(self)
           DummyTurretWeapon.IdleState.Main(self)
        end,
                
        OnGotTarget = function(self)
		self.unit:AddToggleCap('RULEUTC_SpecialToggle')
               DummyTurretWeapon.OnGotTarget(self)
        end,                
            },
        
        OnGotTarget = function(self)
		self.unit:AddToggleCap('RULEUTC_SpecialToggle')
               DummyTurretWeapon.OnGotTarget(self)
        end,
        
        OnLostTarget = function(self)
		self.unit:RemoveToggleCap('RULEUTC_SpecialToggle')
            DummyTurretWeapon.OnLostTarget(self)
        end,  			
		},
	},
	
	DeliveryThread = function(self, beacon)
	local number = 0

	local pos = beacon:GetPosition()
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Air Unit on the way
                coroutine.yield(50)
            elseif orders == 1 then
                coroutine.yield(100) 
				if beacon and not beacon.Dead then
				    WaitSeconds(5)
                end
            elseif orders == 0 then
				if number == 0 then

				end
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end,

    AirUnitSurvivalCheckThread = function(self)
            while not self.Dead do
                local KYS = true
                for i, tran in self.AirUnits do
                    if tran and not tran.Dead then
                        KYS = false
                        break
                    end
                end
                if KYS then

                end
                coroutine.yield(100)
            end
    end,
	
	OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim('/mods/Mechdivers/units/Aeon/Structures/UABMD0205/UABMD0205_AOpen.sca', false):SetRate(0)
		self.Effect1 = nil
		self.Effect2 = nil
		self:SetScriptBit('RULEUTC_IntelToggle', true)
		self:SetScriptBit('RULEUTC_IntelToggle', false)
	end,
	
	OnScriptBitSet = function(self, bit)
        AStructureUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
		if bit == 3 then 
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', true)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self.wep2 = self:GetWeaponByLabel('Dummy2')	
		self.wep2:SetEnabled(false)
		self.wep2:ResetTarget()
		elseif bit == 1 then 
		if self:GetScriptBit('RULEUTC_IntelToggle') == true then
		KillThread(self.SearchOvershipThreadHandle)
		end
		self.wep = self:GetWeaponByLabel('Dummy')	
		self.wep:ResetTarget()
		if self.Effect1 then
		self.Effect1:Destroy()
		end
		if self.Effect2 then
		self.Effect2:Destroy()
		end
		self.AnimationManipulator:SetRate(-2)
		WaitFor(self.AnimationManipulator)
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		elseif bit == 7 then
		local Targetposition = self:GetPosition()
		local unitID = 'CSKMDAA0100'
        local quantity = 1

        --Get positions

		local position = self:GetPosition()
			local RandomPos1 = math.random(-40, 40)
	local RandomPos2 = math.random(-40, 40)
	local RandomUnloadPos1 = math.random(-10, 10)
	local RandomUnloadPos2 = math.random(-10, 10)


        --Get blueprints
        local unitBP = __blueprints[unitID]


        --Entity data
        self.AirUnits = {} -- Temporary, for this cycle
        local created = 0
        local tpn = 0
        local army = self:GetArmy()

        while created < quantity do
            tpn = tpn + 1
			self.AirUnits[tpn] = CreateUnitHPR(
                unitID,
                army,
                position[1] + RandomPos1, position[2], position[3] + RandomPos2,
                0, 0, 0
            )
			RotateTowards(self.AirUnits[tpn],position)
            --table.insert(self.AirUnits, AirUnits[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, unit in self.AirUnits do
           IssueTransportUnload({unit}, {Targetposition[1] + RandomUnloadPos1, Targetposition[2], Targetposition[3] + RandomUnloadPos2})
            unit.DeliveryThread = self.DeliveryThread
            unit:ForkThread(unit.DeliveryThread, self)
		end	
			
        self:ForkThread(self.AirUnitSurvivalCheckThread)
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
		WaitSeconds(100)
		self:AddToggleCap('RULEUTC_SpecialToggle')
        end	
		end)
    end,

    OnScriptBitClear = function(self, bit)
        AStructureUnit.OnScriptBitClear(self, bit)
		ForkThread(function()
		if bit == 3 then 
		self:AddToggleCap('RULEUTC_WeaponToggle')
		self:SetScriptBit('RULEUTC_WeaponToggle', false)
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		self.wep2 = self:GetWeaponByLabel('Dummy2')	
		self.wep2:SetEnabled(true)
		self.wep2:ResetTarget()
		elseif bit == 1 then 
		self.AnimationManipulator:SetRate(2)
		WaitFor(self.AnimationManipulator)
		self.Effect1 = CreateAttachedEmitter( self, 'Effect', self:GetArmy(), '/mods/Mechdivers/effects/emitters/aeon_gateeffect01_emit.bp' ):ScaleEmitter(0.3)
		self.Effect2 = CreateAttachedEmitter( self, 'Effect', self:GetArmy(), '/mods/Mechdivers/effects/emitters/aeon_gateeffect02_emit.bp' ):ScaleEmitter(0.3)
		self.SearchOvershipThreadHandle = self:ForkThread(self.SearchOvershipThread)
		elseif bit == 7 then

		end
		end)
    end,
	
	SearchOvershipThread = function(self)
		local number = 0
		while not self.Dead do
			local units = self:GetAIBrain():GetUnitsAroundPoint(categories.OVERSHIP, self:GetPosition(), 80, 'Ally')
			if units[1] then
			    if GetDistanceBetweenTwoEntities(units[1], self) < 142 then
					if self:GetScriptBit('RULEUTC_IntelToggle') == false then
					if number == 0 then
					self:AddToggleCap('RULEUTC_WeaponToggle')
					self:SetScriptBit('RULEUTC_WeaponToggle', false)
					self:RemoveToggleCap('RULEUTC_WeaponToggle')
					number = 1
					end
					self.wep = self:GetWeaponByLabel('Dummy')	
					self.wep:SetTargetEntity(units[1])
					end
				end
				if GetDistanceBetweenTwoEntities(units[1], self) > 144 then
					if self:GetScriptBit('RULEUTC_IntelToggle') == false then
					if number == 1 then
					self:AddToggleCap('RULEUTC_WeaponToggle')
					self:SetScriptBit('RULEUTC_WeaponToggle', true)
					self:RemoveToggleCap('RULEUTC_WeaponToggle')
					self:RemoveToggleCap('RULEUTC_SpecialToggle')
					number = 0
					end
					end
				end  
			end
            WaitSeconds(0.01)
		end
    end,
}

TypeClass = UABMD0205