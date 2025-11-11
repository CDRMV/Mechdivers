#****************************************************************************
#**
#**  File     :  /cdimage/units/URB1201/URB1201_script.lua
#**  Author(s):  John Comes, Dave Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Tier 2 Power Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CStructureUnit = import('/lua/defaultunits.lua').StructureUnit
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CDFLaserFusionWeapon = ModWeaponsFile.CDFLaserFusionWeapon

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


URBMD0100 = Class(CStructureUnit) {

   Weapons = {
		MainGun = Class(CDFLaserFusionWeapon) {
		IdleState = State (CDFLaserFusionWeapon.IdleState) {
        Main = function(self)
           CDFLaserFusionWeapon.IdleState.Main(self)
        end,
                
        OnGotTarget = function(self)
		self.unit:AddToggleCap('RULEUTC_WeaponToggle')
		self.unit.Spinner2:SetTargetSpeed(0)
		self.unit.Spinner2:SetGoal(self.unit.Spinner2:GetCurrentAngle() - self.unit.Spinner2:GetCurrentAngle())
               CDFLaserFusionWeapon.OnGotTarget(self)
        end,                
            },
        
        OnGotTarget = function(self)
		self.unit.Spinner2:SetTargetSpeed(0)
		self.unit:AddToggleCap('RULEUTC_WeaponToggle')
		self.unit.Spinner2:SetGoal(self.unit.Spinner2:GetCurrentAngle() - self.unit.Spinner2:GetCurrentAngle())
               CDFLaserFusionWeapon.OnGotTarget(self)
        end,
        
        OnLostTarget = function(self)
		local turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax()
		self.unit.Spinner2:SetTargetSpeed(5)
		self.unit:RemoveToggleCap('RULEUTC_WeaponToggle')
		self.unit.Spinner2:SetGoal(-20)
		self:SetTurretPitch(turretpitchmin, turretpitchmax)
            CDFLaserFusionWeapon.OnLostTarget(self)
        end,  			
		},
	},
	
	
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
	
    OnStopBeingBuilt = function(self,builder,layer)
        CStructureUnit.OnStopBeingBuilt(self,builder,layer)
				ForkThread(function()
				self:RemoveToggleCap('RULEUTC_WeaponToggle')
			ScanMesh = '/mods/Mechdivers/Decorations/CybranScan_mesh'
			self.Scan = import('/lua/sim/Entity.lua').Entity()
			self.Scan:AttachBoneTo( -2, self, 'Detector_Effect' )
			self.Scan:SetMesh(ScanMesh)
			self.Scan:SetDrawScale(0.90)
			self.Scan:SetVizToAllies('Intel')
			self.Scan:SetVizToNeutrals('Intel')
			self.Scan:SetVizToEnemies('Intel')
						CreateAttachedEmitter(self, 'Detector_Effect2', self:GetArmy(), '/mods/Mechdivers/effects/emitters/heavyfusion_flash_02_emit.bp'):SetEmitterParam('LIFETIME', -1):SetEmitterParam('ALIGN_TO_BONE', 1):SetEmitterParam('USE_LOCAL_VELOCITY', 1):SetEmitterParam('USE_LOCAL_ACCELERATION', 1)
			CreateAttachedEmitter(self, 'Detector_Effect2', self:GetArmy(), '/mods/Mechdivers/effects/emitters/heavyfusion_flash_01_emit.bp'):SetEmitterParam('LIFETIME', -1):SetEmitterParam('ALIGN_TO_BONE', 1):SetEmitterParam('USE_LOCAL_VELOCITY', 1):SetEmitterParam('USE_LOCAL_ACCELERATION', 1)
		self.Spinner1 = CreateRotator(self, 'Spinner', 'y', nil, 0, 60, 360):SetTargetSpeed(5)
		self.Spinner2 = CreateRotator(self, 'Detector', 'x', 10, 10, 0, 10):SetTargetSpeed(5)
		self:ForkThread(self.CreateIntelEntity,'Detector_Effect', 'Vision')
		while not self.Dead do
		if self.Spinner2 then
		local wep = self:GetWeaponByLabel('MainGun')
		if wep:WeaponHasTarget() then
		self.Spinner2:SetGoal(0)
		else
		self.Spinner2:SetGoal(math.random(-10,20))
		end
		else
		end
		WaitSeconds(1)
		end
		end)
    end,
	
	CreateIntelEntity = function(self, bone, intel)
	local radius = 60
    if not self.IntelEntity then
        self.IntelEntity = {}
    end
    if not self:BeenDestroyed() and radius > 0 then
        local counter = 1
		local anglevalue = 1
        while counter <= radius do
		anglevalue = anglevalue + 1
            local angle = math.ceil((anglevalue) / 3.14)
            if counter + angle < radius then
                ent = import('/lua/sim/Entity.lua').Entity({Owner = self,})
                table.insert(self.IntelEntity, ent)
                self.Trash:Add(ent)					
                ent:AttachBoneTo( -1, self, bone or 0 )
                local pos = self:CalculateWorldPositionFromRelative({0, 0, counter})
                ent:SetParentOffset(Vector(0,0, counter))
                ent:SetVizToFocusPlayer('Always')
                ent:SetVizToAllies('Always')
                ent:SetVizToNeutrals('Never')
                ent:SetVizToEnemies('Never')
				LOG(angle)
                ent:InitIntel(self:GetArmy(), intel, angle)
                ent:EnableIntel(intel)
            end
            counter = counter + 1
        end	
    end
end,
	
		OnScriptBitSet = function(self, bit)
        CStructureUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		ForkThread(function()
		local Targetposition = self:GetPosition()
		local Random = math.random(1,2)
		local unitID = nil
		if Random == 1 then
		unitID = 'URA0107c'
		else
		unitID = 'URA0104c'
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
        local AirUnits = {} -- Temporary, for this cycle
        local created = 0
        local tpn = 0
        local army = self:GetArmy()
		
		SetIgnoreArmyUnitCap(self:GetArmy(), true)
        while created < quantity do
            tpn = tpn + 1
			AirUnits[tpn] = CreateUnitHPR(
                unitID,
                army,
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
			RotateTowardsMid(AirUnits[tpn])
            --table.insert(self.AirUnits, AirUnits[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end
		SetIgnoreArmyUnitCap(self:GetArmy(), false)

        for i, unit in AirUnits do
           IssueTransportUnload({unit}, {Targetposition[1]+ math.random(-12,12), Targetposition[2], Targetposition[3] + math.random(-12,12)})
            unit.DeliveryThread = self.DeliveryThread
            unit:ForkThread(unit.DeliveryThread, self)
		end	
			
        if self.SingleUse then
            self:ForkThread(self.AirUnitSurvivalCheckThread)
        end
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		WaitSeconds(100)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		end)
		end
    end,

    OnScriptBitClear = function(self, bit)
        CStructureUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		ForkThread(function()
		local Targetposition = self:GetPosition()
		local Random = math.random(1,2)
		local unitID = nil
		if Random == 1 then
		unitID = 'URA0107c'
		else
		unitID = 'URA0104c'
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
        local AirUnits = {} -- Temporary, for this cycle
        local created = 0
        local tpn = 0
        local army = self:GetArmy()
		

        while created < quantity do
            tpn = tpn + 1
			AirUnits[tpn] = CreateUnitHPR(
                unitID,
                army,
                position[1] + (math.random(-quantity,quantity) * x), position[2], position[3] + (math.random(-quantity,quantity) * z),
                0, 0, 0
            )
			AirUnits[tpn]:RotateTowardsMid()
            --table.insert(self.AirUnits, AirUnits[tpn])
			created = created + 1
            if created >= quantity then
                break
            end
        end

        for i, unit in AirUnits do
           IssueTransportUnload({unit}, {Targetposition[1]+ math.random(-12,12), Targetposition[2], Targetposition[3] + math.random(-12,12)})
            unit.DeliveryThread = self.DeliveryThread
            unit:ForkThread(unit.DeliveryThread, self)
		end	
			
        if self.SingleUse then
            self:ForkThread(self.AirUnitSurvivalCheckThread)
        end
		self:RemoveToggleCap('RULEUTC_WeaponToggle')
		WaitSeconds(100)
		self:AddToggleCap('RULEUTC_WeaponToggle')
		end)
		end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.Scan then
		self.Scan:Destroy()
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
	
function GetPlayableArea()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end




    function DeliveryThread(self, beacon)
	local number = 0
	local pos = beacon:GetPosition()
        while not self.Dead do
            local orders = table.getn(self:GetCommandQueue())
            if orders > 1 then
                --Air Unit on the way
                coroutine.yield(50)
            elseif orders == 1 then
                coroutine.yield(100) 
				if beacon and beacon.SingleUse and not beacon.Dead then
                    beacon:Destroy()
                end
            elseif orders == 0 then
				if number == 0 then
				
				end
                coroutine.yield(100) --shouldn't matter, but just in case
            end
        end
    end

    function AirUnitSurvivalCheckThread(self)
        if self.SingleUse then --  double check just in case something called this and shouldn't have
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
        end
    end
	

TypeClass = URBMD0100