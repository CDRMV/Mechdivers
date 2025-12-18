do 

function SpawnCivilianSlatter(UnitID, MarkerName, Amount)
--[[

MarkerNames

- Expansion Area 
- Large Expansion Area
- Defensive Point
- Protected Experimental Construction
- Combat Zone
- Transport Marker

]]--



					ForkThread(function()
					local number = 0
					while number <= Amount do
					local Locations = import('/lua/AI/aiutilities.lua').AIGetMarkerLocations('NEUTRAL_CIVILIAN', MarkerName) --Expansion Area, Large Expansion Area
					local MarkerAmount = table.getsize(Locations)
					local SetRandomLocation = math.random(1, MarkerAmount)
					local MarkerPosition = Locations[SetRandomLocation].Position
					local terrain  = GetTerrainType(MarkerPosition[1], MarkerPosition[3])
					if string.find(terrain.Name, 'Water') then

					else
					local unit = CreateUnitHPR(UnitID, 'NEUTRAL_CIVILIAN', MarkerPosition[1], MarkerPosition[2], MarkerPosition[3], 0, 0, 0)
					unit:AddCommandCap('RULEUCC_Reclaim')
							    local reclaim = GetEntitiesInRect(unit:GetSkirtRect())
					for _, r in reclaim do
					if IsProp(r)then
						IssueReclaim({unit},r)
					end
					end
					unit:RemoveCommandCap('RULEUCC_Reclaim')
					---------------------------------------------------------------------------------------------
					-- Spawn Props (Fences and Lights)
					---------------------------------------------------------------------------------------------
					local pos = unit:GetPosition()
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2, pos[2], pos[3]-2.5, 0, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-1, pos[2], pos[3]-2.5, 0, 0, 0 )
					--CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1], pos[2], pos[3]-2.5, 0, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+1, pos[2], pos[3]-2.5, 0, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2, pos[2], pos[3]-2.5, 0, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2, pos[2], pos[3]+2.5, 0, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-1, pos[2], pos[3]+2.5, 0, 0, 0 )
					--CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1], pos[2], pos[3]+2.5, 0, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+1, pos[2], pos[3]+2.5, 0, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2, pos[2], pos[3]+2.5, 0, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2.5, pos[2], pos[3]-2, 90, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2.5, pos[2], pos[3]-1, 90, 0, 0 )
					--CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2.5, pos[2], pos[3], 90, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2.5, pos[2], pos[3]+1, 90, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2.5, pos[2], pos[3]+2, 90, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2.5, pos[2], pos[3]-2, -90, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2.5, pos[2], pos[3]-1, -90, 0, 0 )
					--CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2.5, pos[2], pos[3], -90, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2.5, pos[2], pos[3]+1, -90, 0, 0 )
					CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2.5, pos[2], pos[3]+2, -90, 0, 0 )
					
					CreatePropHPR( '/env/UEF/Props/UEF_Streetlight_01_prop.bp', pos[1]-2.4, pos[2], pos[3]-2.39, 0, 0, 0 )
					CreatePropHPR( '/env/UEF/Props/UEF_Streetlight_01_prop.bp', pos[1]-2.4, pos[2], pos[3]+2.39, 0, 0, 0 )
					CreatePropHPR( '/env/UEF/Props/UEF_Streetlight_01_prop.bp', pos[1]+2.4, pos[2], pos[3]-2.39, 0, 0, 0 )
					CreatePropHPR( '/env/UEF/Props/UEF_Streetlight_01_prop.bp', pos[1]+2.4, pos[2], pos[3]+2.39, 0, 0, 0 )
					number = number + 1
					end
					end
					end)
end


OldInitializeArmies = InitializeArmies

function InitializeArmies()
OldInitializeArmies()

SpawnCivilianSlatter('UEBMD00300b', 'Combat Zone', 2)
SpawnCivilianSlatter('UEBMD00300b', 'Transport Marker', 2)
SpawnCivilianSlatter('UEBMD00300b', 'Protected Experimental Construction', 2)
end


end