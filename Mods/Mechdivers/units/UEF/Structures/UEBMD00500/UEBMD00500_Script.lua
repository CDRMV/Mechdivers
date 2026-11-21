#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB3101/UEB3101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Light Radar Installation Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local StructureUnit = import('/lua/defaultunits.lua').StructureUnit

UEBMD00500 = Class(StructureUnit) {

	OnCreate = function(self)
		StructureUnit.OnCreate(self)
		if not self.AnimationManipulator1 then
         self.AnimationManipulator1 = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator1)
        end
		self.AnimationManipulator1:PlayAnim('/mods/Mechdivers/units/UEF/Structures/UEBMD00500/UEBMD00500_Unpack.sca', false):SetRate(0)
		self.Effect01 = nil
		self.Effect02 = nil
		self.Effect03 = nil
		self.Effect04 = nil
		self.Effect05 = nil
		self.Effect06 = nil
    end,

	OnScriptBitSet = function(self, bit)
        StructureUnit.OnScriptBitSet(self, bit)
		ForkThread(function()
        if bit == 7 then 
			self.AnimationManipulator1:SetRate(1)
			WaitFor(self.AnimationManipulator1)
			self.Effect01 = CreateAttachedEmitter(self, 'Smoke1', self:GetArmy(), '/effects/emitters/dirty_exhaust_smoke_02_emit.bp' ):SetEmitterParam('LIFETIME', -1)
			self.Effect02 = CreateAttachedEmitter(self, 'Smoke2', self:GetArmy(), '/effects/emitters/dirty_exhaust_smoke_02_emit.bp' ):SetEmitterParam('LIFETIME', -1)
			self.Effect03 = CreateAttachedEmitter(self, 'Smoke3', self:GetArmy(), '/effects/emitters/dirty_exhaust_smoke_02_emit.bp' ):SetEmitterParam('LIFETIME', -1)
			self.Effect04 = CreateAttachedEmitter(self, 'Smoke4', self:GetArmy(), '/effects/emitters/dirty_exhaust_smoke_02_emit.bp' ):SetEmitterParam('LIFETIME', -1)
			self.Effect05 = CreateAttachedEmitter(self, 'Smoke5', self:GetArmy(), '/effects/emitters/dirty_exhaust_smoke_02_emit.bp' ):SetEmitterParam('LIFETIME', -1)
			self.Effect06 = CreateAttachedEmitter(self, 'Smoke6', self:GetArmy(), '/effects/emitters/dirty_exhaust_smoke_02_emit.bp' ):SetEmitterParam('LIFETIME', -1)
        end
		end)
    end,

    OnScriptBitClear = function(self, bit)
        StructureUnit.OnScriptBitClear(self, bit)
		ForkThread(function()
        if bit == 7 then 
			self.Effect01:Destroy()
			self.Effect02:Destroy()
			self.Effect03:Destroy()
			self.Effect04:Destroy()
			self.Effect05:Destroy()
			self.Effect06:Destroy()
			self.AnimationManipulator1:SetRate(-1)
        end
		end)
    end,
}

TypeClass = UEBMD00500