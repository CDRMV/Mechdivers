do
function IssueToUnitUpgrade(unit, blueprintID)
    UnitsCache[1] = unit
    return IssueUpgrade(UnitsCache, blueprintID)
end
end