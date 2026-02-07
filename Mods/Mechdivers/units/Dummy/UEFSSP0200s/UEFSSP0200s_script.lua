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
local ModEffectpath = '/mods/Mechdivers/effects/emitters/'

UEFSSP0200r= Class(StructureUnit) {
    Weapons = {
        Nanites = Class(DefaultProjectileWeapon) {},
    },
	
	StunThread = function(self)
        while not self:IsDead() do
            local units = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE - categories.AIR, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius,
			'Enemy'
			
			)
			
			local allyunits = self:GetAIBrain():GetUnitsAroundPoint(
			
			categories.BUILTBYTIER3FACTORY + categories.BUILTBYQUANTUMGATE + categories.NEEDMOBILEBUILD + categories.STRUCTURE - categories.AIR, 
			self:GetPosition(), 
			self:GetBlueprint().Intel.VisionRadius,
			'Ally'
			
			)
            for _,allyunit in allyunits do
				allyunit:SetStunned(1)
            end
			
			for _,unit in units do
				unit:SetStunned(1)
            end
            
            WaitSeconds(1)
        end
    end,
	
	
	
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
			self:ForkThread(function()
			self:HideBone('UEFSSP0100b', true)
			self.Effect1 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'emp_shell_empeffect_01_emit.bp'):ScaleEmitter(1.0):SetEmitterParam('LIFETIME', -1)
			self.Effect2 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'emp_shell_empeffect_02_emit.bp'):ScaleEmitter(1.0):SetEmitterParam('LIFETIME', -1)
			self.Effect3 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'emp_shell_smoke_01_emit.bp'):ScaleEmitter(1.0):SetEmitterParam('LIFETIME', -1)
			self.Effect4 = CreateAttachedEmitter(self,0,self:GetArmy(), ModEffectpath .. 'emp_shell_smoke_01_emit.bp'):ScaleEmitter(1.0):SetEmitterParam('LIFETIME', -1)
				local interval = 0
                while (interval < 6) do
				LOG(interval)
					if interval < 5 then 
						self.StunThreadHandle = self:ForkThread(self.StunThread)
						WaitSeconds(1)
						interval = interval + 1
					elseif interval == 5 then
						self.Effect1:Destroy()
						self.Effect2:Destroy()
						self.Effect3:Destroy()
						self.Effect4:Destroy()
						self:Destroy()
						break
					end
                end		
			end)
    end,

}

TypeClass = UEFSSP0200r