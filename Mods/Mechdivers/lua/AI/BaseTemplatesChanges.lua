function ChangeBaseTemplate(group)
    local BaseTemplates = {
        All = {
            --[[Builders = {},
            NonCheatBuilders = {},
            BaseSettings = {
                EngineerCount = {
                    Tech1 = 0,
                    Tech2 = 0,
                    Tech3 = 0,
                    SCU = 0,
                },
                FactoryCount = {
                    Land = 0,
                    Air = 0,
                    Sea = 0,
                    Gate = 0,
                    Gantry = 3,
                },
            },]]
        },
        AllSorian = {
            Builders = {
				'SorianAdvancedLightBotFactoryCommanderConstruction',
                'SorianAdvancedLightBotFactoryConstruction',
                'SorianAdvancedLightBotFactorySupport',
            },
        },
        AllVanilla = {
            Builders = {
			    'AdvancedLightBotFactoryCommanderConstruction',
                'AdvancedLightBotFactoryConstruction',
				'AdvancedLightBotFactorySupport',
            },
        },
        ChallengeExpansion = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        ChallengeMain = {
            Builders = {
                'AdvancedLightBotFactorySupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2}}
        },
        ChallengeNaval = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        NavalExpansionLarge = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        NavalExpansionSmall = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2}}},
        NormalMain = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        NormalNaval = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        RushExpansionAirFull = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        RushExpansionAirSmall = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2}}},
        RushExpansionBalancedFull = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        RushExpansionBalancedSmall = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2}}},
        RushExpansionLandFull = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        RushExpansionLandSmall = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2}}},
        RushExpansionNaval = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 0}}},
        RushMainAir = {
            Builders = {
                'AdvancedLightBotFactorySupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 5}}
        },
        RushMainBalanced = {
            Builders = {
                'AdvancedLightBotFactorySupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}
        },
        RushMainLand = {
            Builders = {
                'AdvancedLightBotFactorySupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 5}}
        },
        RushMainNaval = {
            Builders = {
                'AdvancedLightBotFactorySupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 3}}
        },
        SorianExpansionAirFull = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        SorianExpansionBalancedFull = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2}}},
        SorianExpansionBalancedSmall = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 1}}},
        SorianExpansionTurtleFull = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 1}}},
        SorianExpansionWaterFull = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 3}}},
        SorianMainAir = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 5}}},
        SorianMainBalanced = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 5}}},
        SorianMainRush = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        SorianMainTurtle = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2}}},
        SorianMainWater = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        SorianNavalExpansionLarge = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 3}}},
        SorianNavalExpansionSmall = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2}}},
        TechExpansion = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 3}}},
        TechExpansionSmall = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2}}},
        TechMain = {
            Builders = {
                'AdvancedLightBotFactorySupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 3}}
        },
        TurtleExpansion = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 1}}},
        TurtleMain = {
            Builders = {
                'AdvancedLightBotFactorySupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 1}}
        },
        --FAF specific things:
        SetonsCustom = {
            Builders = {
                'AdvancedLightBotFactorySupport',
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}
        },
        TechSmallMap = {
            Builders = {
                'AdvancedLightBotFactorySupport',
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2}}
        },
    }

    for base, data in BaseBuilderTemplates do
        for i, set in {'All', (group or 'AllVanilla'), data.BaseTemplateName} do
            if not BaseTemplates[set] then
                WARN("No Mechdivers mod data for AI base template " .. set)
            end
            if BaseTemplates[set].Builders then
                for i, builder in BaseTemplates[set].Builders do
                    if not table.find(data.Builders, builder) then
                        table.insert(data.Builders, builder)
                    end
                end
            end
            if BaseTemplates[set].NonCheatBuilders then
                for i, builder in BaseTemplates[set].NonCheatBuilders do
                    if not table.find(data.NonCheatBuilders, builder) then
                        table.insert(data.NonCheatBuilders, builder)
                    end
                end
            end
            if BaseTemplates[set].BaseSettings then
                for tablekey, table in BaseTemplates[set].BaseSettings do
                    for k, val in table do
                        data.BaseSettings[tablekey][k] = val
                    end
                end
            end
        end
    end
end
