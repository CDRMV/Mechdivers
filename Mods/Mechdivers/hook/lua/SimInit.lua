
do
local SimFile = '/mods/Mechdivers/UI/RefWindowSim.lua'
ArmyBrains = {}
Area = {
	x0 = 0,
	y0 = 0,
	x1 = 0,
	y1 = 0,
}

local oldBeginSession = BeginSession
function BeginSession()
    oldBeginSession()
	ForkThread(import(SimFile).CheckEnableButton)
	LOG('ScenarioInfo.type', ScenarioInfo.type)
	LOG('x0: ', Area.x0)
	LOG('y0: ', Area.y0)
	LOG('x1: ', Area.x1)
	LOG('y1: ', Area.y1)
	if ScenarioInfo.type == 'campaign' or ScenarioInfo.type == 'campaign_coop' then

	elseif ScenarioInfo.type == 'skirmish' then
	import('/lua/ScenarioFramework.lua').SetPlayableArea(Area, true)
	end
end



end