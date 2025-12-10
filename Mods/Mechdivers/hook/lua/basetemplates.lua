do
    local groups = {
        {
            --UEF
			'Landingpad',
        },
        {
            --Aeon
        },
        {
            --Cybran
            'T1AdvancedLightBotFactory',
        },
        {
            --Seraphim
        },
    }
    for i = 1, 4 do
        if BaseTemplates[i] then
            for platoonindex, platoon in groups[i] do
                table.insert(BaseTemplates[i][1][1], platoon)
            end
        end
    end
end
