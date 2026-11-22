do
PlatoonTemplate {
    Name = 'T1LandFactoryUpgrade',
    Plan = 'UnitUpgradeAI',
    GlobalSquads = {
        { categories.TECH1 * categories.FACTORY * categories.LAND - categories.CUSTOMFACTORY, 1, 1, 'support', 'none' }
    }
}

PlatoonTemplate {
    Name = 'T2LandFactoryUpgrade',
    Plan = 'UnitUpgradeAI',
    GlobalSquads = {
        { categories.TECH2 * categories.FACTORY * categories.LAND - categories.CUSTOMFACTORY, 1, 1, 'support', 'none' }
    }
}
PlatoonTemplate {
    Name = 'T1AirFactoryUpgrade',
    Plan = 'UnitUpgradeAI',
    GlobalSquads = {
        { categories.TECH1 * categories.FACTORY * categories.AIR - categories.CUSTOMFACTORY, 1, 1, 'support', 'none' }
    }
}

PlatoonTemplate {
    Name = 'T2AirFactoryUpgrade',
    Plan = 'UnitUpgradeAI',
    GlobalSquads = {
        { categories.TECH2 * categories.FACTORY * categories.AIR - categories.CUSTOMFACTORY, 1, 1, 'support', 'none' }
    }
}

PlatoonTemplate {
    Name = 'T1SeaFactoryUpgrade',
    Plan = 'UnitUpgradeAI',
    GlobalSquads = {
        { categories.TECH1 * categories.FACTORY * categories.NAVAL - categories.CUSTOMFACTORY, 1, 1, 'support', 'none' }
    }
}

PlatoonTemplate {
    Name = 'T2SeaFactoryUpgrade',
    Plan = 'UnitUpgradeAI',
    GlobalSquads = {
        { categories.TECH2 * categories.FACTORY * categories.NAVAL - categories.CUSTOMFACTORY, 1, 1, 'support', 'none' }
    }
}
end