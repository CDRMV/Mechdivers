do
    local groups = {
        {
            --UEF
			'Landingpad',
			'T3MDAntiOrbitalCannon',
			'T3MDDeimos',
			'T3MDDeimosStorage',
			'MDExMissileLauncher',
        },
        {
            --Aeon
			'T1AdvancedLightBotFactory',
			'T2AdvancedHeavyFactory',
			'T1MDGroundDefense',
			'T1MDGroundDefense2',
			'T3MDAntiOrbitalCannon',
        },
        {
            --Cybran
            'T1AdvancedLightBotFactory',
			'T2AdvancedHeavyFactory',
			'T1MDGroundDefense',
			'T2MDGroundDefense',
			'T3MDGroundDefense',
			'T3MDGroundDefense2',
			'T2MDDronestation',
			'T3MDMortar',
			'T3MDAADefense',
			'T3MDAntiOrbitalCannon',
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
