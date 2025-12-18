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
					local Fence1 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2, GetTerrainHeight(pos[1]-2, pos[3]-2.5), pos[3]-2.5, 0, 0, 0 )
					local Fence2 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-1, GetTerrainHeight(pos[1]-1, pos[3]-2.5), pos[3]-2.5, 0, 0, 0 )
					--local Fence3 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1], GetTerrainHeight(pos[1], pos[3]-2.5), pos[3]-2.5, 0, 0, 0 )
					local Fence4 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+1, GetTerrainHeight(pos[1]+1, pos[3]-2.5), pos[3]-2.5, 0, 0, 0 )
					local Fence5 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2, GetTerrainHeight(pos[1]+2, pos[3]-2.5), pos[3]-2.5, 0, 0, 0 )
					local Fence6 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2, GetTerrainHeight(pos[1]-2, pos[3]+2.5), pos[3]+2.5, 0, 0, 0 )
					local Fence7 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-1, GetTerrainHeight(pos[1]-1, pos[3]+2.5), pos[3]+2.5, 0, 0, 0 )
					--local Fence8 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1], GetTerrainHeight(pos[1], pos[3]+2.5), pos[3]+2.5, 0, 0, 0 )
					local Fence9 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+1, GetTerrainHeight(pos[1]+1, pos[3]+2.5), pos[3]+2.5, 0, 0, 0 )
					local Fence10 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2, GetTerrainHeight(pos[1]+2, pos[3]+2.5), pos[3]+2.5, 0, 0, 0 )
					local Fence11 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2.5, GetTerrainHeight(pos[1]+2.5, pos[3]-2), pos[3]-2, 90, 0, 0 )
					local Fence12 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2.5, GetTerrainHeight(pos[1]+2.5, pos[3]-1), pos[3]-1, 90, 0, 0 )
					--local Fence13 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2.5, GetTerrainHeight(pos[1]+2.5, pos[3]), pos[3], 90, 0, 0 )
					local Fence14 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2.5, GetTerrainHeight(pos[1]+2.5, pos[3]+1), pos[3]+1, 90, 0, 0 )
					local Fence15 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]+2.5, GetTerrainHeight(pos[1]+2.5, pos[3]+2), pos[3]+2, 90, 0, 0 )
					local Fence16 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2.5, GetTerrainHeight(pos[1]-2.5, pos[3]-2), pos[3]-2, -90, 0, 0 )
					local Fence17 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2.5, GetTerrainHeight(pos[1]-2.5, pos[3]-1), pos[3]-1, -90, 0, 0 )
					--local Fence18 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2.5, GetTerrainHeight(pos[1]-2.5, pos[3]), pos[3], -90, 0, 0 )
					local Fence19 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2.5, GetTerrainHeight(pos[1]-2.5, pos[3]+1), pos[3]+1, -90, 0, 0 )
					local Fence20 = CreatePropHPR( '/env/uef/props/uef_fence_prop.bp', pos[1]-2.5, GetTerrainHeight(pos[1]-2.5, pos[3]+2), pos[3]+2, -90, 0, 0 )
					
					local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
					if version < 3652 then
					
					else 
					roll, pitch = import('/lua/sim/TerrainUtils.lua').GetTerrainSlopeAngles(pos, 2,2)
					
					Fence1:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence1:GetOrientation(), true) 
					Fence2:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence2:GetOrientation(), true) 
					--Fence3:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence3:GetOrientation(), true) 
					Fence4:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence4:GetOrientation(), true) 
					Fence5:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence5:GetOrientation(), true) 
					Fence6:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence6:GetOrientation(), true) 
					Fence7:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence7:GetOrientation(), true) 
					--Fence8:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence8:GetOrientation(), true) 
					Fence9:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence9:GetOrientation(), true) 
					Fence10:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence10:GetOrientation(), true) 
					Fence11:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence11:GetOrientation(), true) 
					Fence12:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence12:GetOrientation(), true) 
					--Fence13:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence13:GetOrientation(), true) 
					Fence14:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence14:GetOrientation(), true) 
					Fence15:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence15:GetOrientation(), true) 
					Fence16:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence16:GetOrientation(), true) 
					Fence17:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence17:GetOrientation(), true) 
					--Fence18:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence18:GetOrientation(), true) 
					Fence19:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence19:GetOrientation(), true)					
					Fence20:SetOrientation(EulerToQuaternion(roll, pitch, 0) * Fence20:GetOrientation(), true)						
					end
					
					CreatePropHPR( '/env/UEF/Props/UEF_Streetlight_01_prop.bp', pos[1]-2.4, GetTerrainHeight(pos[1]-2.4, pos[3]-2.39), pos[3]-2.39, 0, 0, 0 )
					CreatePropHPR( '/env/UEF/Props/UEF_Streetlight_01_prop.bp', pos[1]-2.4, GetTerrainHeight(pos[1]-2.4, pos[3]+2.39), pos[3]+2.39, 0, 0, 0 )
					CreatePropHPR( '/env/UEF/Props/UEF_Streetlight_01_prop.bp', pos[1]+2.4, GetTerrainHeight(pos[1]+2.4, pos[3]-2.39), pos[3]-2.39, 0, 0, 0 )
					CreatePropHPR( '/env/UEF/Props/UEF_Streetlight_01_prop.bp', pos[1]+2.4, GetTerrainHeight(pos[1]+2.4, pos[3]+2.39), pos[3]+2.39, 0, 0, 0 )
					
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