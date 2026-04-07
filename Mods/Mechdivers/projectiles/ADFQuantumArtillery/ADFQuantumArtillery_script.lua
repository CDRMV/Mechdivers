#
# Aeon quantum 'bolt'
#
local AQuantumCannonProjectile = import('/lua/aeonprojectiles.lua').AQuantumCannonProjectile
ADFQuantumArtillery = Class(AQuantumCannonProjectile) {
    FxTrails = {
        '/effects/emitters/quantum_cannon_munition_05_emit.bp',
        '/effects/emitters/quantum_cannon_munition_06_emit.bp',  
    },
}

TypeClass = ADFQuantumArtillery

