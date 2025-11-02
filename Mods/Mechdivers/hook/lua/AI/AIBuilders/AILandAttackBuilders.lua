BuilderGroup {
    BuilderGroupName = 'T1LandFactoryBuilders - Rush',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'T1 Bot - Late Game Rush',
        PlatoonTemplate = 'T1LandDFBot',
        Priority = 1500,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1000, 'TECH1 BOT'} },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 100, 'TECH1 BOT'} },
        },
        BuilderType = 'Land',
    },
}