#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB1102/UEB1102_script.lua
#**  Author(s):  Jessica St. Croix
#**
#**  Summary  :  UEF Hydrocarbon Power Plant Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TEnergyCreationUnit = import('/lua/defaultunits.lua').EnergyCreationUnit
TEB1102 = Class(TEnergyCreationUnit) {
    DestructionPartsHighToss = {'Exhaust01',},
    DestructionPartsLowToss = {'Exhaust01','Exhaust02','Exhaust03','Exhaust04','Exhaust05',},
    DestructionPartsChassisToss = {'UEB1102'},
    AirEffects = {'/effects/emitters/hydrocarbon_smoke_01_emit.bp',},
    AirEffectsBones = {'Exhaust01'},
    WaterEffects = {'/effects/emitters/underwater_idle_bubbles_01_emit.bp',},
    WaterEffectsBones = {'Exhaust01'},

    OnStopBeingBuilt = function(self,builder,layer)
        TEnergyCreationUnit.OnStopBeingBuilt(self,builder,layer)
    end,

#   Commenting out the unit closing when damaged since it will probably be an Aeon only ability.
#
#
#    OnDamage = function(self)
#        if self.Active and not self.Damaged then
#            ChangeState(self, self.InActiveState)
#        end
#        self.Damaged = true
#    end,

    ActiveState = State {
        Main = function(self)
            # Play the "activate" sound
            local myBlueprint = self:GetBlueprint()
            if myBlueprint.Audio.Activate then
                self:PlaySound(myBlueprint.Audio.Activate)
            end

#            self.Active = true


            local effects = {}
            local bones = {}
            local scale = 1
            if self:GetCurrentLayer() == 'Land' then
                effects = self.AirEffects
                bones = self.AirEffectsBones
            elseif self:GetCurrentLayer() == 'Seabed' then
                effects = self.WaterEffects
                bones = self.WaterEffectsBones
                scale = 3
            end

            for keys,values in effects do
                for keysbones,valuesbones in bones do
                    --table.insert(self.EffectsBag, CreateAttachedEmitter(self,valuesbones,self:GetArmy(), values):ScaleEmitter(scale):OffsetEmitter(0,-.1,0))
                end
            end
        end,

        OnInActive = function(self)
            ChangeState(self, self.InActiveState)
        end,
    },

    InActiveState = State {
        Main = function(self)
#            self.Active = false
            if self.EffectsBag then
                for keys,values in self.EffectsBag do
                    values:Destroy()
                end
                self.EffectsBag = {}
            end

#            if self.Damaged then
#                ChangeState(self, self.WatchState)
#            end
        end,

        OnActive = function(self)
            ChangeState(self, self.ActiveState)
        end,
    },

#    WatchState = State {
#        Main = function(self)
#            while true do
#                WaitSeconds(10)
#                if not self.Active and not self.Damaged then
#                    #LOG('*DEBUG: SAFE TO REOPEN')
#                    ChangeState(self, self.ActiveState)
#                end
#                self.Damaged = false
#            end
#        end,
#    },
}

TypeClass = TEB1102