do
    local inserts = {
        {
            'T1AdvancedLightBotFactory',
            --UEF       AEON      CYBRAN    SERAPHIM
            {false,false,'URBMD0103',false},
        },
    }
    for group, data in inserts do
        for i, id in data[2] do
            if BuildingTemplates[i] and id then-- and __blueprints[id] then
                table.insert(BuildingTemplates[i], {data[1], id})
            end
        end
    end
end
