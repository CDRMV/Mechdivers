#****************************************************************************
#**
#**  File     :  /cdimage/units/URL0106/URL0106_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  Cybran Light Infantry Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CWalkingLandUnit = import('/lua/defaultunits.lua').WalkingLandUnit
local ModWeaponsFile = import('/mods/Mechdivers/lua/CSKMDWeapons.lua')
local CDFLaserFusionWeapon = ModWeaponsFile.CDFLaserFusionWeapon

CSKMDCL0100 = Class(CWalkingLandUnit) {
    Weapons = {
        MainGun = Class(CDFLaserFusionWeapon) {},
    },
	
	OnCreate = function(self)
		CWalkingLandUnit.OnCreate(self)
		RifleMesh = '/mods/Mechdivers/Decorations/CybranBot_Rifle_mesh'
		self.Rifle = import('/lua/sim/Entity.lua').Entity()
        self.Rifle:AttachBoneTo( -1, self, 'Gun' )
        self.Rifle:SetMesh(RifleMesh)
        self.Rifle:SetDrawScale(0.020)
        self.Rifle:SetVizToAllies('Intel')
        self.Rifle:SetVizToNeutrals('Intel')
        self.Rifle:SetVizToEnemies('Intel')
		DropRifleMesh = '/mods/Mechdivers/Decorations/CybranBot_DropRifle_mesh'
		self.DropRifle = import('/lua/sim/Entity.lua').Entity()
        self.DropRifle:AttachBoneTo( -1, self, 'Gun' )
        self.DropRifle:SetMesh(DropRifleMesh)
        self.DropRifle:SetDrawScale(0.020)
        self.DropRifle:SetVizToAllies('Never')
        self.DropRifle:SetVizToNeutrals('Never')
        self.DropRifle:SetVizToEnemies('Never')
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(2)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(1)
        end
    end,
	
	HideRifle = function(self)
		CWalkingLandUnit.OnCreate(self)
        self.Rifle:SetVizToAllies('Never')
        self.Rifle:SetVizToNeutrals('Never')
        self.Rifle:SetVizToEnemies('Never')
    end,
	
	ShowRifle = function(self)
		CWalkingLandUnit.OnCreate(self)
        self.Rifle:SetVizToAllies('Intel')
        self.Rifle:SetVizToNeutrals('Intel')
        self.Rifle:SetVizToEnemies('Intel')
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		if self.Rifle then
		self.Rifle:Destroy()
		end
		
		if self.DeathAnimManip then 
            WaitFor(self.DeathAnimManip)
		end
		
        self:DestroyAllDamageEffects()
		local army = self:GetArmy()

		if self.PlayDestructionEffects then
            self:CreateDestructionEffects(overkillRatio)
        end

        if self.ShowUnitDestructionDebris and overkillRatio then
            self:CreateUnitDestructionDebris(true, true, overkillRatio > 2)
        end
		
		self:CreateWreckage(overkillRatio or self.overkillRatio)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
}

TypeClass = CSKMDCL0100