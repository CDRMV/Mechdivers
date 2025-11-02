BuilderGroup {
    BuilderGroupName = 'AdvancedLightBotFactoryCommanderConstruction',
    BuildersType = 'CommanderBuilder',

    Builder {
        BuilderName = 'AdvancedLightBotFactory Commander Priority Builder',
        PlatoonTemplate = 'CommanderBuilder',
        Priority = 800,
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'FactoryLessAtLocation', { 'LocationType', 1, 'Land' } },
			{ UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 6, categories.ADVANCEDLIGHTBOTFACTORY } },
			{ UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
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
    BuilderGroupName = 'AdvancedLightBotFactoryConstruction',
    BuildersType = 'EngineerBuilder',

    Builder {
        BuilderName = 'Sorian Advanced Light Bot Factory Priority Builder',
        PlatoonTemplate = 'EngineerBuilder',
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
        PlatoonTemplate = 'EngineerBuilder',
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
    BuilderGroupName = 'AdvancedLightBotFactorySupport',
    BuildersType = 'EngineerBuilder',

    Builder {
        BuilderName = 'Advanced Light Bot Factory Engineer Builder',
        PlatoonTemplate = 'EngineerBuilder',
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
