do    
	local oldModBlueprints = ModBlueprints
    function ModBlueprints(all_bps)
	    oldModBlueprints(all_bps)
        for id, bp in all_bps.Unit do
            if bp.Weapon then
                for ik, wep in bp.Weapon do
					if wep.RangeCategory == 'UWRC_AntiAir' then
						if not wep.AntiOrbital == true then
							wep.TargetRestrictDisallow = wep.TargetRestrictDisallow .. ', SATELLITE, ORBITAL'
							LOG('*ADDING RESTRICTION : ' .. bp.BlueprintId .. " : " .. wep.DisplayName)
						end
					end
				end
			end
		end
    end
end	