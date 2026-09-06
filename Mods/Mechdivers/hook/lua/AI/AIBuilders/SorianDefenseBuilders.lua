
BuilderGroup {
    BuilderGroupName = 'T1MDBaseDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T1 MDDefenses PD',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 8, categories.DEFENSE * categories.TECH1 } },
			{ UCBC, 'HaveGreaterThanUnitsWithCategory', { 1, 'ENERGYPRODUCTION TECH1' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerRadius = 20,
                LocationRadius = 75,
				 ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T1MDGroundDefense',
					'T1MDGroundDefense2',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'T2MDBaseDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T2 MDDefenses PD',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 8, categories.DEFENSE * categories.TECH2 } },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, 'DEFENSE TECH2 DIRECTFIRE' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerRadius = 20,
                LocationRadius = 75,
				 ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2MDGroundDefense',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'T2MDDronestationDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T2 MDDronestation',
        PlatoonTemplate = 'EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.DEFENSE * categories.ASSAULTDRONESTATION } },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, 'DEFENSE TECH2 DIRECTFIRE' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
                NearMarkerType = 'Start Location',
				MarkerUnitCount = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T2MDDronestation',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'T3MDBaseDefenses',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T3 T3MDDefenses AA',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 16, categories.DEFENSE * categories.TECH3 } },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, 'DEFENSE TECH3 ANTIAIR' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerRadius = 20,
                LocationRadius = 75,
				 ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3MDAADefense',
                },
                Location = 'LocationType',
            }
        }
    },
	Builder {
        BuilderName = 'T3 T3MDDefenses AA2',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.DEFENSE * categories.TECH3 * categories.ANTIAIR * categories.SILO} },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, 'DEFENSE TECH3 ANTIAIR SILO' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerRadius = 20,
                LocationRadius = 75,
				 ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3MDAADefense2',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'T3 T3MDDefenses PD',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 16, categories.DEFENSE * categories.TECH3 } },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, 'DEFENSE TECH3 DIRECTFIRE' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerRadius = 20,
                LocationRadius = 75,
				 ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3MDGroundDefense',
					'T3MDGroundDefense2',
                },
                Location = 'LocationType',
            }
        }
    },
	Builder {
        BuilderName = 'T3 T3MDDefenses Mortar',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 16, categories.DEFENSE * categories.TECH3 } },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, 'DEFENSE TECH3 INIRECTFIRE' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerRadius = 20,
                LocationRadius = 75,
				 ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 1,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3MDMortar',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'T3AntiOrbitalCannons',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T3 MDAntiOrbitalCannon',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.STRATEGIC * categories.ANTIORBITALCANNON } },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, 'STRATEGIC TECH3 ANTIORBITALCANNON' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerRadius = 20,
                LocationRadius = 35,
				 ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3MDAntiOrbitalCannon',
                },
                Location = 'LocationType',
            }
        }
    },
}


BuilderGroup {
    BuilderGroupName = 'T3DeimosArtillery',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'T3 T3MDDeimos',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.DEFENSE * categories.TECH3 * categories.DEIMOSARTILLERY} },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, 'DEFENSE TECH3 DEIMOSARTILLERY' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
                NearMarkerType = 'Start Location',
				MarkerUnitCount = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3MDDeimos',
                },
                Location = 'LocationType',
            }
        }
    },
	Builder {
        BuilderName = 'T3 T3MDDeimos Storage',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.DEFENSE * categories.TECH3 * categories.DEIMOSAMMOSTORAGE} },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, 'DEFENSE TECH3 DEIMOSAMMOSTORAGE' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
                NearMarkerType = 'Start Location',
				MarkerUnitCount = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'T3MDDeimosStorage',
                },
                Location = 'LocationType',
            }
        }
    },
}

BuilderGroup {
    BuilderGroupName = 'ExMissileLauncher',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'MDExNukeMissileLauncher',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 1500,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.STRATEGIC * categories.EXPERIMENTAL * categories.SILO} },
			{ UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, 'STRATEGIC EXPERIMENTAL SILO' }},
            { IBC, 'BrainNotLowPowerMode', {} },
        },
        BuilderType = 'Any',
        BuilderData = {
            NumAssistees = 2,
                NearMarkerType = 'Start Location',
                MarkerRadius = 20,
                LocationRadius = 35,
				 ThreatMin = 0,
                ThreatMax = 1,
                ThreatRings = 2,
                ThreatType = 'AntiSurface',
                MarkerUnitCount = 2,
            Construction = {
                BuildClose = false,
                BuildStructures = {
                    'MDExMissileLauncher',
                },
                Location = 'LocationType',
            }
        }
    },
}


