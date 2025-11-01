BuilderGroup {
    BuilderGroupName = 'SorianAdvancedLightBotFactoryCommanderConstruction',
    BuildersType = 'EngineerBuilder',

    Builder {
        BuilderName = 'Sorian AdvancedLightBotFactory Commander Priority Builder',
        PlatoonTemplate = 'CommanderBuilderSorian',
        Priority = 505,
        BuilderConditions = {                        
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
			#{ UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.ADVANCEDLIGHTBOTFACTORY}},
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 3, 'FACTORY LAND' }},
			{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.ADVANCEDLIGHTBOTFACTORY, 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1AdvancedLightBotFactory',
                },
            }
        }
    },
	
	    Builder {
        BuilderName = 'SorianCDR T1 AdvancedLightBotFactory Higher Pri',
        PlatoonTemplate = 'CommanderBuilderSorian',
        Priority = 505,
        BuilderConditions = {                        
            { SIBC, 'GreaterThanEconEfficiencyOverTime', { 0.8, 1.1} },
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { EBC, 'MassToFactoryRatioBaseCheck', { 'LocationType' } },
			#{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 3, 'LAND FACTORY'}},
			#{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, 'AIR FACTORY'}},
			{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 2, 'FACTORY LAND' }},
			{ UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 0, 'FACTORY AIR' }},
			{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, 'LAND FACTORY', 'LocationType', }},
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1AdvancedLightBotFactory',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianAdvancedLightBotFactoryConstruction',
    BuildersType = 'EngineerBuilder',

    Builder {
        BuilderName = 'Sorian Advanced Light Bot Factory Priority Builder',
        PlatoonTemplate = 'EngineerBuilderSorian',
        Priority = 880,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ADVANCEDLIGHTBOTFACTORY } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.ADVANCEDLIGHTBOTFACTORY } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION',
                AdjacencyDistance = 100,
                BuildClose = false,
                Location = 'LocationType',
                BuildStructures = {
                    'T1AdvancedLightBotFactory',
                },
            }
        }
    },
    Builder {
        BuilderName = 'Sorian AdvancedLightBotFactory Builder',
        PlatoonTemplate = 'EngineerBuilderSorian',
        Priority = 725,
        BuilderConditions = {
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2} },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
            { UCBC, 'AdvancedLightBotFactoryCapCheck', { 'LocationType', 'AdvancedLightBotFactory' } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION',
                AdjacencyDistance = 100,
                BuildClose = false,
                Location = 'LocationType',
                BuildStructures = {
                    'T1AdvancedLightBotFactory',
                },
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'SorianAdvancedLightBotFactorySupport',
    BuildersType = 'EngineerBuilder',

    Builder {
        BuilderName = 'Sorian Advanced Light Bot Factory Engineer Builder',
        PlatoonTemplate = 'EngineerBuilderSorian',
        Priority = 850,
        BuilderConditions = {
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 0, categories.ADVANCEDLIGHTBOTFACTORY }},
            { MIBC, 'FactionIndex', {1, 3, 4}},
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 1.2} },
            { IBC, 'BrainNotLowPowerMode', {} },
            { UCBC, 'UnitCapCheckLess', { .8 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 1,
            Construction = {
                AdjacencyCategory = 'ENERGYPRODUCTION',
                AdjacencyDistance = 100,
                BuildClose = false,
                Location = 'LocationType',
                BuildStructures = {
                    'T1EngineerSupport',
                    'T1EngineerSupport',
                    'T1EngineerSupport',
                    'T1EngineerSupport',
                    'T1EngineerSupport',
                },
            }
        }
    },
}
