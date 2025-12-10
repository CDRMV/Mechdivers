

BuilderGroup {
    BuilderGroupName = 'Land Rush Initial ACU Builders',
    BuildersType = 'EngineerBuilder',

    -- Initial builder
    Builder {
        BuilderName = 'CDR Initial Land Rush',
        PlatoonTemplate = 'CommanderInitialBuilder',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'NotPreBuilt', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BaseTemplateFile = '/mods/Mechdivers/hook/lua/AI/AIBaseTemplates/ACUBaseTemplate.lua',
                BaseTemplate = 'ACUBaseTemplate',
            }
        }
    },
    Builder {
        BuilderName = 'CDR Initial PreBuilt Land Rush',
        PlatoonTemplate = 'CommanderBuilder',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'PreBuiltBase', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BuildStructures = {
				'T1AdvancedLightBotFactory',
                    'T1LandFactory',
                    'T1AirFactory',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1AirFactory',
					'T1AdvancedLightBotFactory',
					'T1AdvancedLightBotFactory',
					'T1AdvancedLightBotFactory',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'Balanced Rush Initial ACU Builders',
    BuildersType = 'EngineerBuilder',

    -- Initial builder
    Builder {
        BuilderName = 'CDR Initial Balanced',
        PlatoonTemplate = 'CommanderBuilder',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'NotPreBuilt', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BaseTemplateFile = '/mods/Mechdivers/hook/lua/AI/AIBaseTemplates/ACUBaseTemplate.lua',
                BaseTemplate = 'ACUBaseTemplate',
            }
        }
    },
    Builder {
        BuilderName = 'CDR Initial PreBuilt Balanced',
        PlatoonTemplate = 'CommanderBuilder',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'PreBuiltBase', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BuildStructures = {
				'T1AdvancedLightBotFactory',
                    'T1LandFactory',
                    'T1AirFactory',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1AirFactory',
					'T1AdvancedLightBotFactory',
					'T1AdvancedLightBotFactory',
					'T1AdvancedLightBotFactory',
                }
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'Air Rush Initial ACU Builders',
    BuildersType = 'EngineerBuilder',

    -- Initial builder
    Builder {
        BuilderName = 'CDR Initial Air Rush',
        PlatoonTemplate = 'CommanderBuilder',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'NotPreBuilt', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BaseTemplateFile = '/mods/Mechdivers/hook/lua/AI/AIBaseTemplates/ACUBaseTemplate.lua',
                BaseTemplate = 'ACUBaseTemplate',
            }
        }
    },
    Builder {
        BuilderName = 'CDR Initial PreBuilt Air Rush',
        PlatoonTemplate = 'CommanderBuilder',
        Priority = 1000,
        BuilderConditions = {
                { IBC, 'PreBuiltBase', {}},
            },
        InstantCheck = true,
        BuilderType = 'Any',
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, },
        BuilderData = {
            Construction = {
                BuildStructures = {
				'T1AdvancedLightBotFactory',
                    'T1LandFactory',
                    'T1AirFactory',
                    'T1EnergyProduction',
                    'T1EnergyProduction',
                    'T1AirFactory',
					'T1AdvancedLightBotFactory',
					'T1AdvancedLightBotFactory',
					'T1AdvancedLightBotFactory',
                }
            }
        }
    },
}


