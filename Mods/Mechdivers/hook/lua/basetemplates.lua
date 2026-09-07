do
    local groups = {
        {
            --UEF
			'Landingpad',
			'T3MDSlatterSAM',
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
			'T2MDTacticalJammer',
			'T2MDMonolith',
			'T2MDOvershipComArray',
			'T3MDAntiOrbitalCannon',
			'MDExWeatherManipulator',
        },
        {
            --Cybran
            'T1AdvancedLightBotFactory',
			'T2AdvancedHeavyFactory',
			'T1MDGroundDefense',
			'T2MDGroundDefense',
			'T3MDGroundDefense',
			'T3MDGroundDefense2',
			'T3MDGroundDefense3',
			'T3MDGroundDefense4',
			'T2MDDronestation',
			'T2MDDetectorTower',
			'T2MDTacticalJammer',
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
