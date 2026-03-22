do 
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')

function AIVanillaGetMarkerLocations(aiBrain, markerType)
    #LOG('*AI DEBUG: ARMY 2: Getting Marker Locations of Type ', markerType)
    local markerList = {}
    
    if markerType == 'Start Location' then
        local tempMarkers = AIGetMarkerLocations( aiBrain, 'Blank Marker') 
        for k,v in tempMarkers do
            if string.sub(v.Name,1,5) == 'ARMY_' then 
                table.insert(markerList, { Position = v.Position, Name = v.Name})
            end
        end   
    else
        local markers = ScenarioUtils.GetMarkers()
        if markers then
            for k, v in markers do
                if v.type == markerType then
                    table.insert(markerList, { Position = v.position, Name = k } )
                end
            end
        end
    end
    
    return markerList
end

end