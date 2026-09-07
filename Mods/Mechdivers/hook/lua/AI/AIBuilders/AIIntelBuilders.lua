BuilderGroup {
    BuilderGroupName = 'T2MDTacticalJammer',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T2 MDTacticalJammer',
        PlatoonTemplate = 'T2EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.TACTICALJAMMER * categories.TECH2}},
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
				NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerUnitCount = 3,
                BuildStructures = {
                    'T2MDTacticalJammer',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'T2MDDetectorTower',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T2 MDDetectorTower',
        PlatoonTemplate = 'T2EngineerBuilder',
        Priority = 2000,
        BuilderConditions = {
		    { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.DETECTORTOWER * categories.TECH2} },
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2' }},
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, 'DETECTORTOWER TECH2' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
				NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerUnitCount = 2,
                BuildStructures = {
                    'T2MDDetectorTower',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'T2MDMonolith',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T2 MDMonolith',
        PlatoonTemplate = 'T2EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.MONOLITH * categories.TECH2}},
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2' }},
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, 'MONOLITH TECH2' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
				NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerUnitCount = 3,
                BuildStructures = {
                    'T2MDMonolith',
                },
                Location = 'LocationType',
            }
        }
    },
}


BuilderGroup {
    BuilderGroupName = 'T2MDOvershipComArray',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T2 MDOvershipComArray',
        PlatoonTemplate = 'T2EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.SENSORFLOWER * categories.TECH2}},
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH2' }},
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, 'SENSORFLOWER TECH2' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                BuildClose = false,
				NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerUnitCount = 3,
                BuildStructures = {
                    'T2MDOvershipComArray',
                },
                Location = 'LocationType',
            }
        }
    },
}
