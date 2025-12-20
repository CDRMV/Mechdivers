----
----
----
----
----
----
----
----
----
----
--[[
Callbacks.SpawnReinforcements = function(data, units)
	local id = data.id
	
	if id == nil then 

	else
	local randomnumberx = math.random(1,10)
	local randomnumberz = math.random(1,10)
	local quantity = data.Quantity
	local x = data.X
	local z = data.Z
	local BorderPos = data.pos 
	local aiBrain = ArmyBrains[data.ArmyIndex] 
		LOG('X: ', BorderPos[1])
	LOG('Y: ', BorderPos[3])
	LOG('Unit ID: ', id)
	LOG('X: ', BorderPos[1])
	LOG('Y: ', BorderPos[3])
	LOG('GetFocusArmy: ', ArmyBrains[data.ArmyIndex])
	
	local spawnedUnit = aiBrain:CreateUnitNearSpot(id, BorderPos[1] + (randomnumberx * x), BorderPos[3] + (randomnumberz * z)) 
	end
	
end	
]]--
Callbacks.SpawnAirDropRef = function(data, units)
	local id = data.id
	LOG(id)
	
	if id == nil then 

	else
	local clicklocationtemp = data.pos 
	local ArmyIndex = ArmyBrains[data.ArmyIndex] 
	LOG('Unit ID: ', id)
	LOG('Klick Position: ', clicklocationtemp)
	LOG('GetFocusArmy: ', ArmyIndex)    
	if GetArmyUnitCostTotal(data.ArmyIndex) == GetArmyUnitCap(data.ArmyIndex) then
	else
	local RefUnit = nil
	local RandomPos1 = math.random(-120, 120)
	local RandomPos2 = math.random(-120, 120)
	local RandomUnloadPos1 = math.random(-20, 20)
	local RandomUnloadPos2 = math.random(-20, 20)
	RefUnit = ArmyIndex:CreateUnitNearSpot(id, clicklocationtemp[1] + RandomPos1, clicklocationtemp[3] + RandomPos2) 
	local RotateTowards = import('/lua/defaultunits.lua').RotateTowards
	RotateTowards(RefUnit,clicklocationtemp)
	IssueTransportUnload({RefUnit}, {clicklocationtemp[1] + RandomUnloadPos1, clicklocationtemp[2], clicklocationtemp[3]+ RandomUnloadPos2})
	end
	end
end	

Callbacks.SpawnDropPodRef = function(data, units)
	local id = data.id
	LOG(id)
	
	if id == nil then 

	else
	local clicklocationtemp = data.pos 
	local ArmyIndex = ArmyBrains[data.ArmyIndex] 
	LOG('Unit ID: ', id)
	LOG('Klick Position: ', clicklocationtemp)
	LOG('GetFocusArmy: ', ArmyIndex)    
	if GetArmyUnitCostTotal(data.ArmyIndex) == GetArmyUnitCap(data.ArmyIndex) then
	else
	local RefUnit = nil
	RefUnit = ArmyIndex:CreateUnitNearSpot(id, clicklocationtemp[1], clicklocationtemp[3]) 
	end
	end
end	









