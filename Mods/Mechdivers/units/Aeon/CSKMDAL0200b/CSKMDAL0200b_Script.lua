#****************************************************************************
#**
#**  File     :  /data/units/XAL0203/XAL0203_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  Aeon Assault Tank Script
#**
#**  Copyright © 2007 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local AHoverLandUnit = import('/lua/defaultunits.lua').MobileUnit
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

CSKMDAL0200b = Class(AHoverLandUnit) {

GetNearestPlayablePoint = function(self,position) 

    local px, _, pz = unpack(position)
	
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then
	local playableArea = GetPlayableArea()

    -- keep track whether the point is actually outside the map
    local isOutside = false

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
    elseif px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
    elseif pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end

    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end

	elseif ScenarioInfo.type == 'skirmish' then
	local playableArea = GetPlayableArea()
	
	if playableArea[1] == 0 and playableArea[2] == 0 then
	
	
	LOG('position[1]', position[1])
	LOG('position[3]', position[3])
	
	local x, z
	
	if position[1] == 0 then
	x = position[1] + 1
	end
	
	if position[3] == 0 then
	z = position[3] + 1
	end
	
	if position[1] > 0 then
	x = position[1] - 1
	end
	
	if position[3] > 0 then
	z = position[3] - 1
	end
	
		    return {
            x, 
            GetSurfaceHeight(position[1], position[3]),
            z
        }
	
	
	else
    -- keep track whether the point is actually outside the map
    local isOutside = false
	

    if px < playableArea[1] then
        isOutside = true
        px = playableArea[1] + 1
	end	
    if px > playableArea[3] then
        isOutside = true
        px = playableArea[3] - 1
    end

    if pz < playableArea[2] then
        isOutside = true
        pz = playableArea[2] + 1
	end	
    if pz > playableArea[4] then
        isOutside = true
        pz = playableArea[4] - 1
    end
	
    -- if it really is outside the map then we allocate a new vector
    if isOutside then
        return {
            px, 
            GetTerrainHeight(px, pz),
            pz
        }

    end
	end
	else
	return position
	end
end,	



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
                    beacon:Destroy()
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
                    self:Destroy()
                end
                coroutine.yield(100)
            end
    end,

	OnStopBeingBuilt = function(self,builder,layer)
		ForkThread(function()
		self.Sphere1 = CreateSlider(self, 'Sphere1')
		self.Sphere1:SetGoal(0, 68, 0)
		self.Sphere1:SetSpeed(30)
		self.Sphere2 = CreateSlider(self, 'Sphere2')
		self.Sphere2:SetGoal(0, 52, 0)
		self.Sphere2:SetSpeed(30)
		self.Sphere3 = CreateSlider(self, 'Sphere3')
		self.Sphere3:SetGoal(0, 46, 0)
		self.Sphere3:SetSpeed(30)
		self.Sphere4 = CreateSlider(self, 'Sphere4')
		self.Sphere4:SetGoal(0, 35, 0)
		self.Sphere4:SetSpeed(30)
		self.Effect1 = CreateAttachedEmitter(self, 'Sphere1', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect01_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(0.3)
		self.Effect2 = CreateAttachedEmitter(self, 'Sphere2', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect01_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(0.3)
		self.Effect3 = CreateAttachedEmitter(self, 'Sphere3', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect01_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(0.3)
		self.Effect4 = CreateAttachedEmitter(self, 'Sphere4', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect01_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(0.3)
		WaitSeconds(2)
		local Targetposition = self:GetPosition()
		local Random = math.random(1,2)
		local unitID = nil
		if Random == 1 then
		unitID = 'UAA0107c'
		else
		unitID = 'UAA0104c'
		end
        local quantity = 1

        --Get positions
        local pos = self.CachePosition or self:GetPosition()
        local BorderPos, OppBorPos

        local x, z = pos[1] / ScenarioInfo.size[1] - 0.5, pos[3] / ScenarioInfo.size[2] - 0.6

        if math.abs(x) <= math.abs(z) then
            BorderPos = {pos[1], nil, math.ceil(z) * ScenarioInfo.size[2]}
            OppBorPos = {pos[1], nil, BorderPos[3]==0 and ScenarioInfo.size[2] or 0}
            x, z = 1, 0
        else
            BorderPos = {math.ceil(x) * ScenarioInfo.size[1], nil, pos[3]}
            OppBorPos = {BorderPos[1]==0 and ScenarioInfo.size[1] or 0, nil, pos[3]}
            x, z = 0, 1
        end

        BorderPos[2] = GetTerrainHeight(BorderPos[1], BorderPos[3])
        OppBorPos[2] = GetTerrainHeight(OppBorPos[1], OppBorPos[3])

		local position = self.GetNearestPlayablePoint(self,BorderPos)
		local oppoposition = self.GetNearestPlayablePoint(self,OppBorPos)

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
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
			RotateTowardsMid(self.AirUnits[tpn])
            --table.insert(self.AirUnits, AirUnits[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, unit in self.AirUnits do
           IssueTransportUnload({unit}, {Targetposition[1], Targetposition[2], Targetposition[3]})
            unit.DeliveryThread = self.DeliveryThread
            unit:ForkThread(unit.DeliveryThread, self)
		end	
			
            self:ForkThread(self.AirUnitSurvivalCheckThread)
		self.Effect5 = CreateAttachedEmitter(self, 'Sphere1', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect02_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(0.3)
		self.Effect6 = CreateAttachedEmitter(self, 'Sphere2', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect02_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(0.3)
		self.Effect7 = CreateAttachedEmitter(self, 'Sphere3', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect02_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(0.3)
		self.Effect8 = CreateAttachedEmitter(self, 'Sphere4', self:GetArmy(), '/mods/Mechdivers/effects/emitters/watcher_effect02_emit.bp'):SetEmitterParam('LIFETIME', -1):ScaleEmitter(0.3)
		WaitSeconds(10)
		self.Effect5:Destroy()
		self.Effect6:Destroy()
		self.Effect7:Destroy()
		self.Effect8:Destroy()
		end)
        AHoverLandUnit.OnStopBeingBuilt(self,builder,layer)
    end,
}


function GetPlayableArea()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end





	

TypeClass = CSKMDAL0200b