#****************************************************************************
#**
#**  File     :  /cdimage/units/UEA0203/UEA0203_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  UEF Gunship Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/defaultunits.lua').AirUnit
local SDFUnstablePhasonBeam = import('/lua/seraphimweapons.lua').SDFUnstablePhasonBeam
local R, Ceil = Random, math.ceil
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local ModEffectpath = '/mods/Commander Survival Kit/effects/emitters/'

UABMD0400c = Class(TAirUnit) {

    Weapons = {
		Lightning = Class(SDFUnstablePhasonBeam) {
			IdleState = State (SDFUnstablePhasonBeam.IdleState) {
                OnGotTarget = function(self)
                    SDFUnstablePhasonBeam.IdleState.OnGotTarget(self)
					Warp(self.unit, self:GetCurrentTargetPos(), self.unit:GetOrientation())
                end,
            },
		},
    },


    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
	end,	
}

TypeClass = UABMD0400c