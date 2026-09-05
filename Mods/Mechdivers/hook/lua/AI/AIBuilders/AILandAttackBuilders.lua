BuilderGroup {
    BuilderGroupName = 'T1AdvancedLightBotFactoryBuilders',
	BuildersType = 'FactoryBuilder',

    Builder {
        BuilderName = 'T1 Trooper - Tech 1',
        PlatoonTemplate = 'T1TrooperInfantry',
        Priority = 1500,
        --Priority = 950,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.INFANTRY } },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Land',
    },
	Builder {
        BuilderName = 'T1 Sturn - Tech 1',
        PlatoonTemplate = 'T1SturmInfantry',
        Priority = 1500,
        --Priority = 950,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.INFANTRY2 } },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Land',
    },
	Builder {
        BuilderName = 'T1 Command - Tech 1',
        PlatoonTemplate = 'T1CommandInfantry',
        Priority = 1500,
        --Priority = 950,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.MOBILE * categories.INFANTRY3 } },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Land',
    },
	Builder {
        BuilderName = 'T1 Assasin - Tech 1',
        PlatoonTemplate = 'T1AssasinInfantry',
        Priority = 1500,
        --Priority = 950,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.INFANTRY4 } },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Land',
    },
	Builder {
        BuilderName = 'T1 AntiTank - Tech 1',
        PlatoonTemplate = 'T1AntiTankInfantry',
        Priority = 1500,
        --Priority = 950,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.INFANTRY5 } },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Land',
    },
	Builder {
        BuilderName = 'T1 Ambush - Tech 1',
        PlatoonTemplate = 'T1AmbushInfantry',
        Priority = 1500,
        --Priority = 950,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.INFANTRY6 } },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Land',
    },
	Builder {
        BuilderName = 'T1 Jetpack - Tech 1',
        PlatoonTemplate = 'T1JetpackInfantry',
        Priority = 1500,
        --Priority = 950,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.INFANTRY7 } },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Land',
    },
	Builder {
        BuilderName = 'T1 Flame - Tech 1',
        PlatoonTemplate = 'T1FlameInfantry',
        Priority = 1500,
        --Priority = 950,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.INFANTRY8 } },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Land',
    },
}	
BuilderGroup {
    BuilderGroupName = 'T1WarpshipBuilders',	
	BuildersType = 'FactoryBuilder',
	Builder {
        BuilderName = 'T1 Voteless - Tech 1',
        PlatoonTemplate = 'T1Voteless',
        Priority = 1500,
        --Priority = 950,
        BuilderConditions = {
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.MELEEANDROID } },
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Land',
    },
}	
BuilderGroup {
    BuilderGroupName = 'T2AdvancedHeavyFactoryBuilders',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'T2 Devastator - Tech 2',
        PlatoonTemplate = 'T2Devastator',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDINFANTRY } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T2 Devastator Heavy - Tech 2',
        PlatoonTemplate = 'T2DevastatorHeavy',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDINFANTRY2 } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T2 Devastator Missile - Tech 2',
        PlatoonTemplate = 'T2DevastatorMissile',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDINFANTRY3 } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T2 Devastator Shotgun- Tech 2',
        PlatoonTemplate = 'T2DevastatorShotgun',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDINFANTRY4 } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T2 DevastatorJetpack - Tech 2',
        PlatoonTemplate = 'T2DevastatorJetPack',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDINFANTRY5 } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T2 Berserker - Tech 2',
        PlatoonTemplate = 'T2Berserker',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDINFANTRY6 } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T2 ScoutStrider - Tech 2',
        PlatoonTemplate = 'T2ScoutStrider',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.SCOUTSTRIDER } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
}

BuilderGroup {
    BuilderGroupName = 'T2CyborgFactoryBuilders',	
	BuildersType = 'FactoryBuilder',
	Builder {
        BuilderName = 'T2 AssaultCyborg - Tech 2',
        PlatoonTemplate = 'T2AssaultCyborg',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.CYBORG } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T2 ShotgunCyborg - Tech 2',
        PlatoonTemplate = 'T2ShotgunCyborg',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.CYBORG2 } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
}	
	
BuilderGroup {
    BuilderGroupName = 'T3AdvancedHeavyFactoryBuilders',	
	BuildersType = 'FactoryBuilder',
	Builder {
        BuilderName = 'T3 AdvancedScoutStrider - Tech 3',
        PlatoonTemplate = 'T3AdvancedScoutStrider',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDSCOUTSTRIDER } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T2 AssaultCyborg - Tech 2',
        PlatoonTemplate = 'T2AssaultCyborg',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.CYBORG } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T2 ShotgunCyborg - Tech 2',
        PlatoonTemplate = 'T2ShotgunCyborg',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.CYBORG2 } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 HeavyTank - Tech 3',
        PlatoonTemplate = 'T3HeavyTank',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.HEAVYTANK } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 MissileBattery - Tech 3',
        PlatoonTemplate = 'T3MissileBattery',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.MISSILEBATTERY } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 AntiAirTank - Tech 3',
        PlatoonTemplate = 'T3AntiAirTank',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ANTIAIRTANK } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 HeavyMortarTank - Tech 3',
        PlatoonTemplate = 'T3HeavyMortarTank',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.HEAVYMORTARTANK } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 AutocannonTank - Tech 3',
        PlatoonTemplate = 'T3AutocannonTank',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.AUTOCANNONTANK } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 HeavyAssaultBot - Tech 3',
        PlatoonTemplate = 'T3HeavyAssaultBot',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.HEAVYASSAULTBOT } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 HeavyAmbushBot - Tech 3',
        PlatoonTemplate = 'T3HeavyAmbushBot',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.HEAVYAMBUSHBOT } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 HeavySiegeBot - Tech 3',
        PlatoonTemplate = 'T3HeavySiegeBot',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.HEAVYSIEGEBOT } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 HeavyArmoredAmbushBot - Tech 3',
        PlatoonTemplate = 'T3HeavyArmoredAmbushBot',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.HEAVYARMOREDAMBUSHBOT } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 HeavyJetpackAmbushBot - Tech 3',
        PlatoonTemplate = 'T3HeavyJetpackAmbushBot',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.HEAVYJETPACKAMBUSHBOT } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 HeavyJetpackAssaultBot - Tech 3',
        PlatoonTemplate = 'T3HeavyJetpackAssaultBot',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.HEAVYJETPACKASSAULTBOT } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T3 HeavyArmoredArtyBot - Tech 3',
        PlatoonTemplate = 'T3HeavyArmoredArtyBot',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.HEAVYARMOREDARTYBOT } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
}	
BuilderGroup {
    BuilderGroupName = 'T2WarpShipBuilders',
	BuildersType = 'FactoryBuilder',
	Builder {
        BuilderName = 'T2 Overseer - Tech 2',
        PlatoonTemplate = 'T2Overseer',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDANDROID } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	
	Builder {
        BuilderName = 'T2 Jetpack Overseer - Tech 2',
        PlatoonTemplate = 'T2JetpackOverseer',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDANDROID2 } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
}	
BuilderGroup {
    BuilderGroupName = 'T2WarpGateBuilders',
	BuildersType = 'FactoryBuilder',
	Builder {
        BuilderName = 'T2 WatcherDrone - Tech 2',
        PlatoonTemplate = 'T2WatcherDrone',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.MOBILE * categories.SCOUTDRONE } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	Builder {
        BuilderName = 'T2 ObtruderDrone - Tech 2',
        PlatoonTemplate = 'T2ObtruderDrone',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ASSAULTDRONE } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	
	Builder {
        BuilderName = 'T2 Overseer - Tech 2',
        PlatoonTemplate = 'T2Overseer',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDANDROID } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	
	Builder {
        BuilderName = 'T2 Jetpack Overseer - Tech 2',
        PlatoonTemplate = 'T2JetpackOverseer',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDANDROID2 } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	
	Builder {
        BuilderName = 'T2 Arty Overseer - Tech 2',
        PlatoonTemplate = 'T2ArtyOverseer',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDANDROID3 } },
           -- { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	
	Builder {
        BuilderName = 'T2 Neomob - Tech 2',
        PlatoonTemplate = 'T2Neomob',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDMELEEANDROID } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	
	Builder {
        BuilderName = 'T2 Crusher - Tech 2',
        PlatoonTemplate = 'T2Crusher',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDMELEEANDROID2 } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	
	Builder {
        BuilderName = 'T2 Wretch - Tech 2',
        PlatoonTemplate = 'T2Wretch',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ADVANCEDMELEEANDROID3 } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
}	
BuilderGroup {
    BuilderGroupName = 'T3WarpGateBuilders',
	BuildersType = 'FactoryBuilder',
	Builder {
        BuilderName = 'T3 AssaultTripod - Tech 3',
        PlatoonTemplate = 'T3AssaultTripod',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.ASSAULTTRIPOD } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
	
	Builder {
        BuilderName = 'T3 MeleeTripod - Tech 3',
        PlatoonTemplate = 'T3MeleeTripod',
        Priority = 1500,
        BuilderType = 'Land',
        BuilderConditions = {
            { IBC, 'BrainNotLowPowerMode', {} },
			{ UCBC, 'HaveLessThanUnitsWithCategory', { 20, categories.MOBILE * categories.MELEETRIPOD } },
            --{ EBC, 'GreaterThanEconEfficiencyOverTime', { 0.7, 1.05 }},
        },
    },
}



	