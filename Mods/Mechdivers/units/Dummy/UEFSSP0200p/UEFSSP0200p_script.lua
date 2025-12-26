#****************************************************************************
#**
#**  UEF Medium Artillery Strike
#**  Author(s):  CDRMV
#**
#**  Summary  :  A Dummy Unit which fires Artillery Strikes below it. 
#**				 It is Selectable and Untargetable by enemy Units.				
#**				 It attacks enemy Units automatically in Range and will be destroyed after 10 Seconds.
#**              
#**  Copyright © 2022 Fire Support Manager by CDRMV
#****************************************************************************

local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local DefaultProjectileWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local Effectpath = '/effects/emitters/'


UEFSSP0200p = Class(StructureUnit) {
    Weapons = {
        Nanites = Class(DefaultProjectileWeapon) {},
    },
	
	DamageThread = function(self)
        while not self:IsDead() do
            #Get friendly units in the area (including self)
			DamageArea(self, self:GetPosition(), 1, 5, 'Fire', true, false)
            WaitSeconds(0.1)
        end
    end,
	
	
	
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
			self:ForkThread(function()
			self:HideBone('UEFSSP0100b', true)
			self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), Effectpath .. 'napalm_hvy_01_emit.bp'):ScaleEmitter(0.5):SetEmitterParam('LIFETIME', -1)
			self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), Effectpath .. 'napalm_hvy_thin_smoke_emit.bp'):ScaleEmitter(0.5):SetEmitterParam('LIFETIME', -1)
				local interval = 0
                while (interval < 6) do
				LOG(interval)
					if interval < 5 then 
						self.DamageThreadHandle = self:ForkThread(self.DamageThread)
						WaitSeconds(1)
						interval = interval + 1
					elseif interval == 5 then
						self.Effect1:Destroy()
						self.Effect2:Destroy()
						self:Destroy()
						break
					end
                end		
			end)
    end,

}

TypeClass = UEFSSP0200p