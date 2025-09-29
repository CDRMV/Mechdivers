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
local ModTexPath = '/mods/Mechdivers/textures/particles/'
local ModEmPath = '/mods/Mechdivers/effects/emitters/'

CSKMDCL0205 = Class(CWalkingLandUnit) {
    Weapons = {
        MainGun = Class(CDFLaserFusionWeapon) {},
    },
	
	OnCreate = function(self)
		CWalkingLandUnit.OnCreate(self)
		self:HideBone('R_Arm_B04', true)
		self:HideBone('L_Arm_Shield', true)
		self:HideBone('L_Arm_Shield2', true)
		self:HideBone('B01', true)
		self:HideBone('B02', true)
		self.JetPackEffectsBag = {}
		self:RemoveToggleCap('RULEUTC_SpecialToggle')
    end,
	
	OnMotionHorzEventChange = function(self, new, old)
        CWalkingLandUnit.OnMotionHorzEventChange(self, new, old)
		if old == 'Stopped' then
			self:AddToggleCap('RULEUTC_SpecialToggle')
			self:SetScriptBit('RULEUTC_SpecialToggle', false)
        elseif new == 'Stopped' then
			self:RemoveToggleCap('RULEUTC_SpecialToggle')
        end
    end,
	
	OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
        if bit == 1 then 
		self:SetSpeedMult(1.2)
        elseif bit == 7 then 
			local Oldlocation = self:GetPosition()
			local MovePos = self:GetCurrentMoveLocation()
			local LandUnit = {} 
			local bp = self:GetBlueprint()
			local AirDummyUnit = bp.Display.AirDummyUnit
			LOG('ScriptBit: ',self:GetScriptBit(2))
			LOG('MovePos: ',MovePos)
			ForkThread( function()
			local aiBrain = self:GetAIBrain()
			local qx, qy, qz, qw = unpack(self:GetOrientation())
			SetIgnoreArmyUnitCap(self:GetArmy(), true)
			LandUnit[1] = CreateUnit(AirDummyUnit,self:GetArmy(),Oldlocation[1], Oldlocation[2], Oldlocation[3],qx, qy, qz, qw, 0)
			SetIgnoreArmyUnitCap(self:GetArmy(), false)
			self:AttachBoneTo(-2, LandUnit[1], 0)
			for i, Unit in LandUnit do
			EffectBones = self:GetBlueprint().Display.JetPackEffectBones
			self.Effect1 = CreateAttachedEmitter(self,EffectBones[1],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
            self.Trash:Add(self.Effect1)
			self.Effect2 = CreateAttachedEmitter(self,EffectBones[2],self:GetArmy(), ModEmPath .. 'jetpack_trail_01_emit.bp'):OffsetEmitter(0 ,0, -0.4):ScaleEmitter(0.5)
            self.Trash:Add(self.Effect2)
			self.Effect3 = CreateAttachedBeam(self,EffectBones[1],self:GetArmy(),  0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect3)
			self.Effect4 = CreateAttachedBeam(self,EffectBones[2],self:GetArmy(), 0.2, 0.05, ModTexPath .. 'beam_jetpack_exhaust.dds')
            self.Trash:Add(self.Effect4)
			LandUnit[1]:SetElevation(10)
            IssueTransportUnload({Unit}, MovePos)
            end
			end
			)
        end
		end)
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
		self:SetSpeedMult(1)
        elseif bit == 7 then 
			self.Effect1:Destroy()
			self.Effect2:Destroy()
			self.Effect3:Destroy()
			self.Effect4:Destroy()
        end
    end,
}

TypeClass = CSKMDCL0205