BuilderGroup {
    BuilderGroupName = 'SorianT1LandFactoryBuilders - Rush',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'Sorian T1 Bot - Late Game Rush',
        PlatoonTemplate = 'T1LandDFBot',
        Priority = 999999,
        BuilderConditions = {
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 100, categories.TECH1 * categories.BOT} },
        },
        BuilderType = 'Land',
    },
}

