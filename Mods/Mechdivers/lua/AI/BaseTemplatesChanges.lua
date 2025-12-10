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
				'LandingpadCommanderConstruction',
                'LandingpadConstruction',
				'LandingpadSupport',
            },
        },
        ChallengeExpansion = {Builders = {'AdvancedLightBotFactorySupport', 'LandingpadSupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4, Landingpad = 2,}}},
        ChallengeMain = {
            Builders = {
                'AdvancedLightBotFactorySupport',
				'LandingpadSupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2, Landingpad = 2}}
        },
        ChallengeNaval = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4, Landingpad = 2}}},
        NavalExpansionLarge = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4, Landingpad = 2}}},
        NavalExpansionSmall = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2, Landingpad = 1}}},
        NormalMain = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        NormalNaval = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4}}},
        RushExpansionAirFull = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4, Landingpad = 2}}},
        RushExpansionAirSmall = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2, Landingpad = 1}}},
        RushExpansionBalancedFull = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4, Landingpad = 2}}},
        RushExpansionBalancedSmall = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2, Landingpad = 1}}},
        RushExpansionLandFull = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4, Landingpad = 2}}},
        RushExpansionLandSmall = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2, Landingpad = 1}}},
        RushExpansionNaval = {Builders = {'AdvancedLightBotFactorySupport'}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 0}}},
        RushMainAir = {
            Builders = {
                'AdvancedLightBotFactorySupport',
				'LandingpadSupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 5, Landingpad = 3}}
        },
        RushMainBalanced = {
            Builders = {
                'AdvancedLightBotFactorySupport',
				'LandingpadSupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4, Landingpad = 2}}
        },
        RushMainLand = {
            Builders = {
                'AdvancedLightBotFactorySupport',
				'LandingpadSupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 5, Landingpad = 3}}
        },
        RushMainNaval = {
            Builders = {
                'AdvancedLightBotFactorySupport',
				'LandingpadSupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 3, Landingpad = 2}}
        },
        SorianExpansionAirFull = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4, Landingpad = 2}}},
        SorianExpansionBalancedFull = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2, Landingpad = 2}}},
        SorianExpansionBalancedSmall = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 1, Landingpad = 1}}},
        SorianExpansionTurtleFull = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 1, Landingpad = 1}}},
        SorianExpansionWaterFull = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 3, Landingpad = 2}}},
        SorianMainAir = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 5, Landingpad = 3}}},
        SorianMainBalanced = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 5, Landingpad = 3}}},
        SorianMainRush = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4, Landingpad = 1}}},
        SorianMainTurtle = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2, Landingpad = 1}}},
        SorianMainWater = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4, Landingpad = 2}}},
        SorianNavalExpansionLarge = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 3, Landingpad = 2}}},
        SorianNavalExpansionSmall = {BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2, Landingpad = 1}}},
        TechExpansion = {Builders = {'AdvancedLightBotFactorySupport', 'LandingpadSupport',}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 3, Landingpad = 2}}},
        TechExpansionSmall = {Builders = {'AdvancedLightBotFactorySupport', 'LandingpadSupport',}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2, Landingpad = 1}}},
        TechMain = {
            Builders = {
                'AdvancedLightBotFactorySupport',
				'LandingpadSupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 3, Landingpad = 2}}
        },
        TurtleExpansion = {Builders = {'AdvancedLightBotFactorySupport', 'LandingpadSupport',}, BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 1, Landingpad = 1}}},
        TurtleMain = {
            Builders = {
                'AdvancedLightBotFactorySupport',
				'LandingpadSupport',
            },
            NonCheatBuilders = {
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 1, Landingpad = 1}}
        },
        --FAF specific things:
        SetonsCustom = {
            Builders = {
                'AdvancedLightBotFactorySupport',
				'LandingpadSupport',
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 4, Landingpad = 2}}
        },
        TechSmallMap = {
            Builders = {
                'AdvancedLightBotFactorySupport',
				'LandingpadSupport',
            },
            BaseSettings = {FactoryCount = {AdvancedLightBotFactory = 2, Landingpad = 1}}
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
