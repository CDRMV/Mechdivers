local Unit = import('/lua/sim/Unit.lua').Unit
local Shield = import('/lua/shield.lua').Shield
local explosion = import('/lua/defaultexplosions.lua')
local Util = import('/lua/utilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Entity = import('/lua/sim/Entity.lua').Entity
local Buff = import('/lua/sim/Buff.lua')
local AdjacencyBuffs = import('/lua/sim/AdjacencyBuffs.lua')

TerminideStructureUnit = Class(Unit) {
     LandBuiltHiddenBones = {'Floatation'},
    MinConsumptionPerSecondEnergy = 1,
    MinWeaponRequiresEnergy = 0,
    
    # Stucture unit specific damage effects and smoke
    FxDamage1 = { EffectTemplate.DamageStructureSmoke01, EffectTemplate.DamageStructureSparks01 },
    FxDamage2 = { EffectTemplate.DamageStructureFireSmoke01, EffectTemplate.DamageStructureSparks01 },
    FxDamage3 = { EffectTemplate.DamageStructureFire01, EffectTemplate.DamageStructureSparks01 },    

    OnCreate = function(self)
        Unit.OnCreate(self)
        self.WeaponMod = {}
        self.FxBlinkingLightsBag = {} 
        if self:GetCurrentLayer() == 'Land' and self:GetBlueprint().Physics.FlattenSkirt then
            self:FlattenSkirt()
            # Units creating structure units tell unit to create the tarmac.
            # This left here to help with F2 unit creation and testing.
            #self:CreateTarmac(true, true, true, false, false)
        end        
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        Unit.OnStopBeingBuilt(self,builder,layer)
        self:PlayActiveAnimation()
    end,

    OnFailedToBeBuilt = function(self)
        Unit.OnFailedToBeBuilt(self)
        self:DestroyTarmac()
    end,

    FlattenSkirt = function(self)
        local x, y, z = unpack(self:GetPosition())
        local x0,z0,x1,z1 = self:GetSkirtRect()
        x0,z0,x1,z1 = math.floor(x0),math.floor(z0),math.ceil(x1),math.ceil(z1)
        FlattenMapRect(x0, z0, x1-x0, z1-z0, y)
    end,

    CreateTarmac = function(self, albedo, normal, glow, orientation, specTarmac, lifeTime)
        if self:GetCurrentLayer() != 'Land' then return end
        local tarmac
        local bp = self:GetBlueprint().Display.Tarmacs
        if not specTarmac then
            if bp and table.getn(bp) > 0 then
                local num = Random(1, table.getn(bp))
                #LOG('*DEBUG: NUM + ', repr(num))
                tarmac = bp[num]
            else
                return false
            end
        else
            tarmac = specTarmac
        end
        
        local army = self:GetArmy()
        local w = tarmac.Width
        local l = tarmac.Length
        local fadeout = tarmac.FadeOut

        local x, y, z = unpack(self:GetPosition())
        
        #I'm disabling this for now since there are so many things wrong with it.
        #SetTerrainTypeRect(self.tarmacRect, {TypeCode= (aiBrain:GetFactionIndex() + 189) } )
        local orient = orientation
        if not orientation then
            if tarmac.Orientations and table.getn(tarmac.Orientations) > 0 then
                orient = tarmac.Orientations[Random(1, table.getn(tarmac.Orientations))]
                orient = (0.01745 * orient)
            else
                orient = 0
            end
        end

        if not self.TarmacBag then
            self.TarmacBag = {
                Decals = {},
                Orientation = orient,
                CurrentBP = tarmac,
            }
        end
        
        local GetTarmac = import('/lua/tarmacs.lua').GetTarmacType
        
        local terrain = GetTerrainType(x, z)
        local terrainName
        if terrain then
            terrainName = terrain.Name
        end
        #Players and AI can build buildings outside of their faction. Get the *building's* faction to determine the correct tarrain-specific tarmac
        local factionTable = {e=1, a=2, r=3, s=4}
        local faction  = factionTable[string.sub(self:GetUnitId(),2,2)]

        if albedo and tarmac.Albedo then
            local albedo2 = tarmac.Albedo2
            if albedo2 then 
                albedo2 = albedo2 .. GetTarmac(faction, terrain)
            end
            
            local tarmacHndl = CreateDecal(self:GetPosition(), orient, tarmac.Albedo .. GetTarmac(faction, terrainName) , albedo2 or '', 'Albedo', w, l, fadeout, lifeTime or 0, army, 0)
            table.insert(self.TarmacBag.Decals, tarmacHndl)
            if tarmac.RemoveWhenDead then
                self.Trash:Add(tarmacHndl)
            end
        end
        if normal and tarmac.Normal then
            local tarmacHndl = CreateDecal(self:GetPosition(), orient, tarmac.Normal .. GetTarmac(faction, terrainName), '', 'Alpha Normals', w, l, fadeout, lifeTime or 0, army, 0)
            
            table.insert(self.TarmacBag.Decals, tarmacHndl)
            if tarmac.RemoveWhenDead then
                self.Trash:Add(tarmacHndl)
            end
        end
        if glow and tarmac.Glow then
            local tarmacHndl = CreateDecal(self:GetPosition(), orient, tarmac.Glow .. GetTarmac(faction, terrainName), '', 'Glow', w, l, fadeout, lifeTime or 0, army, 0)
            
            table.insert(self.TarmacBag.Decals, tarmacHndl)
            if tarmac.RemoveWhenDead then
                self.Trash:Add(tarmacHndl)
            end
        end
    end,

    DestroyTarmac = function(self)
        if not self.TarmacBag then return end
        for k, v in self.TarmacBag.Decals do
            v:Destroy()
        end

        self.TarmacBag.Orientation = nil
        self.TarmacBag.CurrentBP = nil
    end,
    
    HasTarmac = function(self)
        if not self.TarmacBag then return false end
        return (table.getn(self.TarmacBag.Decals) != 0)
    end,

    OnMassStorageStateChange = function(self, state)
    end,

    OnEnergyStorageStateChange = function(self, state)
    end,

    CreateBlinkingLights = function(self, color)
        self:DestroyBlinkingLights()
        local bp = self:GetBlueprint().Display.BlinkingLights
        local bpEmitters = self:GetBlueprint().Display.BlinkingLightsFx
        if bp then
            local fxbp = bpEmitters[color]
            for k, v in bp do
                if type(v) == 'table' then
                    local fx = CreateAttachedEmitter(self, v.BLBone, self:GetArmy(), fxbp)
                    fx:OffsetEmitter(v.BLOffsetX or 0, v.BLOffsetY or 0, v.BLOffsetZ or 0)
                    fx:ScaleEmitter(v.BLScale or 1)
                    table.insert(self.FxBlinkingLightsBag, fx)
                    self.Trash:Add(fx)
                end
            end
        end
    end,

    DestroyBlinkingLights = function(self)
        for k, v in self.FxBlinkingLightsBag do
            v:Destroy()
        end
        self.FxBlinkingLightsBag = {}
    end,

    CreateDestructionEffects = function( self, overKillRatio )
        #LOG( bp.General.FactionName, ' ', bp.General.UnitType,' avg. bounding radius = ', explosion.GetAverageBoundingXZRadius( self ) )
        #LOG( 'CurrentLayer ', self:GetCurrentLayer())

        if( explosion.GetAverageBoundingXZRadius( self ) < 1.0 ) then
            explosion.CreateScalableUnitExplosion( self, overKillRatio )
        else
            explosion.CreateTimedStuctureUnitExplosion( self )
            WaitSeconds( 0.5 )
            explosion.CreateScalableUnitExplosion( self, overKillRatio )
        end
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
        Unit.OnStartBuild(self,unitBeingBuilt, order)
        #Fix up info on the unit id from the blueprint and see if it matches the 'UpgradeTo' field in the BP.
        local unitid = self:GetBlueprint().General.UpgradesTo
        self.UnitBeingBuilt = unitBeingBuilt
        if unitBeingBuilt:GetUnitId() == unitid and order == 'Upgrade' then
            ChangeState(self, self.UpgradingState)
        end
    end,
    
    IdleState = State {
        Main = function(self)
        end,
    },

    UpgradingState = State {
        Main = function(self)
            self:StopRocking()
            local bp = self:GetBlueprint().Display
            self:DestroyTarmac()
            self:PlayUnitSound('UpgradeStart')
            self:DisableDefaultToggleCaps()
            if bp.AnimationUpgrade then
                local unitBuilding = self.UnitBeingBuilt
                self.AnimatorUpgradeManip = CreateAnimator(self)
                self.Trash:Add(self.AnimatorUpgradeManip)
                local fractionOfComplete = 0
                self:StartUpgradeEffects(unitBuilding)
                self.AnimatorUpgradeManip:PlayAnim(bp.AnimationUpgrade, false):SetRate(0)

                while fractionOfComplete < 1 and not self:IsDead() do
                    fractionOfComplete = unitBuilding:GetFractionComplete()
                    self.AnimatorUpgradeManip:SetAnimationFraction(fractionOfComplete)
                    WaitTicks(1)
                end
                if not self:IsDead() then
                    self.AnimatorUpgradeManip:SetRate(1)
                end
            end
        end,

        OnStopBuild = function(self, unitBuilding)
            Unit.OnStopBuild(self, unitBuilding)
            self:EnableDefaultToggleCaps()
            
            if unitBuilding:GetFractionComplete() == 1 then
                NotifyUpgrade(self, unitBuilding)
                self:StopUpgradeEffects(unitBuilding)
                self:PlayUnitSound('UpgradeEnd')
                self:Destroy()
            end
        end,

        OnFailedToBuild = function(self)
            Unit.OnFailedToBuild(self)
            self:EnableDefaultToggleCaps()
            
            if self.AnimatorUpgradeManip then self.AnimatorUpgradeManip:Destroy() end
            
            if self:GetCurrentLayer() == 'Water' then
                self:StartRocking()
            end
            self:PlayUnitSound('UpgradeFailed')
            self:PlayActiveAnimation()
            self:CreateTarmac(true, true, true, self.TarmacBag.Orientation, self.TarmacBag.CurrentBP)
            ChangeState(self, self.IdleState)
        end,
        
    },
    
    StartBeingBuiltEffects = function(self, builder, layer)
		Unit.StartBeingBuiltEffects(self, builder, layer)
		local bp = self:GetBlueprint()
		local FactionName = bp.General.FactionName
		
		if FactionName == 'UEF' then
			self:HideBone(0, true)
			self.BeingBuiltShowBoneTriggered = false
			if bp.General.UpgradesFrom != builder:GetUnitId() then
				self:ForkThread( EffectUtil.CreateBuildCubeThread, builder, self.OnBeingBuiltEffectsBag )	
			end					
		elseif FactionName == 'Aeon' then
			if bp.General.UpgradesFrom != builder:GetUnitId() then
				self:ForkThread( EffectUtil.CreateAeonBuildBaseThread, builder, self.OnBeingBuiltEffectsBag )
			end
		elseif FactionName == 'Terminids' then
			if bp.General.UpgradesFrom != builder:GetUnitId() then
				self:ForkThread( EffectUtil.CreateTerminideBuildBaseThread, builder, self.OnBeingBuiltEffectsBag )
			end
		elseif FactionName == 'Cybran' then
		elseif FactionName == 'Seraphim' then
			if bp.General.UpgradesFrom != builder:GetUnitId() then
				self:ForkThread( EffectUtil.CreateSeraphimBuildBaseThread, builder, self.OnBeingBuiltEffectsBag )
			end		
		end
    end,
    
    StopBeingBuiltEffects = function(self, builder, layer)
        local FactionName = self:GetBlueprint().General.FactionName
        if FactionName == 'Aeon' then
            WaitSeconds( 2.0 )
        elseif FactionName == 'UEF' and not self.BeingBuiltShowBoneTriggered then 
            self:ShowBone(0, true)
            self:HideLandBones()            
        end
		Unit.StopBeingBuiltEffects(self, builder, layer)    
    end,
    
    StartBuildingEffects = function(self, unitBeingBuilt, order)
        Unit.StartBuildingEffects(self, unitBeingBuilt, order)
    end,
    
    StopBuildingEffects = function(self, unitBeingBuilt)
        Unit.StopBuildingEffects(self, unitBeingBuilt)
    end,
    
    StartUpgradeEffects = function(self, unitBeingBuilt)
        unitBeingBuilt:HideBone(0, true)
    end,
    
    StopUpgradeEffects = function(self, unitBeingBuilt)
        unitBeingBuilt:ShowBone(0, true)
    end,
    
    PlayActiveAnimation = function(self)
        
    end,
    
    #Adding into OnKilled the ability to destroy the tarmac but put a new one down that looks exactly like it but
    #will time out over the time spec'd or 300 seconds.
    OnKilled = function(self, instigator, type, overkillRatio)
        Unit.OnKilled(self, instigator, type, overkillRatio)
        local orient = self.TarmacBag.Orientation
        local currentBP = self.TarmacBag.CurrentBP
        self:DestroyTarmac()
        self:CreateTarmac(true, true, true, orient, currentBP, currentBP.DeathLifetime or 300)
    end,
    
    #---------------------------------------------------------------------------------------------
    #  Adjacency
    #---------------------------------------------------------------------------------------------
    
    #When we're adjacent, try to all all the possible bonuses.
    OnAdjacentTo = function(self, adjacentUnit, triggerUnit)
        if self:IsBeingBuilt() then return end
        if adjacentUnit:IsBeingBuilt() then return end
        
        local adjBuffs = self:GetBlueprint().Adjacency
        if not adjBuffs then return end
        
        for k,v in AdjacencyBuffs[adjBuffs] do
            Buff.ApplyBuff(adjacentUnit, v, self)
        end
        self:RequestRefreshUI()
        adjacentUnit:RequestRefreshUI()
    end,
    
    #When we're not adjacent, try to remove all the possible bonuses.
    OnNotAdjacentTo = function(self, adjacentUnit)
        local adjBuffs = self:GetBlueprint().Adjacency
        if adjBuffs and AdjacencyBuffs[adjBuffs] then 
            for k,v in AdjacencyBuffs[adjBuffs] do
                if Buff.HasBuff(adjacentUnit, v) then
                    Buff.RemoveBuff(adjacentUnit, v)
                end
            end
        end
        self:DestroyAdjacentEffects()
        
        self:RequestRefreshUI()
        adjacentUnit:RequestRefreshUI()
    end,

    #---------
    # Add/Remove Adjacency Effects
    #---------
    
    CreateAdjacentEffect = function(self, adjacentUnit)
        #Create trashbag to hold all these entities and beams
        if not self.AdjacencyBeamsBag then
            self.AdjacencyBeamsBag = {}
        end
        
        for k,v in self.AdjacencyBeamsBag do
            if v.Unit:GetEntityId() == adjacentUnit:GetEntityId() then
                return
            end
        end
            
		self:ForkThread( EffectUtil.CreateAdjacencyBeams, adjacentUnit, self.AdjacencyBeamsBag )
    end,

    DestroyAdjacentEffects = function(self, adjacentUnit)
        if not self.AdjacencyBeamsBag then return end
        for k, v in self.AdjacencyBeamsBag do
            # if any of the adjacent units are destroyed or the passed in unit is found: Kill the effect
            if v.Unit:BeenDestroyed() or v.Unit:IsDead() then #or v.Unit:GetEntityId() == adjacentUnit:GetEntityId() then
                v.Trash:Destroy()
                self.AdjacencyBeamsBag[k] = nil
            end
        end
    end,   
}


FAFBugHole = Class(TerminideStructureUnit) {
RollOffAnimationRate = 10,

    ---------------------------------------------------------------------------
    --#region Engine events

    ---@param self FactoryUnit
    OnCreate = function(self)
        TerminideStructureUnit.OnCreate(self)

        local blueprint = self.Blueprint

        -- if we're a support factory, make sure our build restrictions are correct
        if blueprint.CategoriesHash["SUPPORTFACTORY"] then
            self:UpdateBuildRestrictions()
        end

        -- store build bone rotator to prevent trashing the memory
        local buildBoneRotator = CreateRotator(self, blueprint.Display.BuildAttachBone or 0, 'y', 0, 10000)
        buildBoneRotator:SetPrecedence(1000)
        self.BuildBoneRotator = self.Trash:Add(buildBoneRotator)

        -- store build effect bones for quick access
        self.BuildEffectBones = blueprint.General.BuildBones.BuildEffectBones

        -- save for quick access later
        self.RollOffPoint = { 0, 0, 0 }
    end,

    ---@param self FactoryUnit
    OnDestroy = function(self)
        TerminideStructureUnit.OnDestroy(self)
        local brain = self.Brain
        local blueprint = self.Blueprint

        if blueprint.CategoriesHash["RESEARCH"] and self:GetFractionComplete() == 1.0 then
            -- update internal state
            brain:RemoveHQ(blueprint.FactionCategory, blueprint.LayerCategory, blueprint.TechCategory)
            brain:SetHQSupportFactoryRestrictions(blueprint.FactionCategory, blueprint.LayerCategory)

            -- update all units affected by this
            local affected = brain:GetListOfUnits(categories.SUPPORTFACTORY - categories.EXPERIMENTAL, false)
            for _, unit in affected do
                unit:UpdateBuildRestrictions()
            end
        end

        self:DestroyUnitBeingBuilt()
    end,

    ---@param self FactoryUnit
    OnPaused = function(self)
        TerminideStructureUnit.OnPaused(self)

        -- remove the build effects
        if self:IsUnitState('Building') then
            self:StopBuildingEffects(self.UnitBeingBuilt)
        end
    end,

    ---@param self FactoryUnit
    OnUnpaused = function(self)
        TerminideStructureUnit.OnUnpaused(self)

        -- re-introduce the build effects
        local unitBeingBuilt = self.UnitBeingBuilt --[[@as Unit]]
        local unitBuildOrder = self.UnitBuildOrder
        if self:IsUnitState('Building') and (not IsDestroyed(unitBeingBuilt)) then
            self:StartBuildingEffects(unitBeingBuilt, unitBuildOrder)
        end
    end,

    ---@param self FactoryUnit
    ---@param unitBeingBuilt Unit
    ---@param order string
    OnStartBuild = function(self, unitBeingBuilt, order)
        TerminideStructureUnit.OnStartBuild(self, unitBeingBuilt, order)

        self.FactoryBuildFailed = nil
        self.BuildingUnit = true
        if order ~= 'Upgrade' then
            ChangeState(self, self.BuildingState)
            self.BuildingUnit = nil
        elseif unitBeingBuilt.Blueprint.CategoriesHash["RESEARCH"] then
            -- temporarily remove the ability to assist to prevent cancelling the upgrade
            self:RemoveCommandCap('RULEUCC_Guard')
            self.DisabledAssist = true
        end
    end,

    --- Introduce a rolloff delay, where defined.
    ---@param self FactoryUnit
    ---@param unitBeingBuilt Unit
    ---@param order string
    OnStopBuild = function(self, unitBeingBuilt, order)
        TerminideStructureUnit.OnStopBuild(self, unitBeingBuilt, order)

        self.BuildingUnit = false

        -- re-introduce the ability to assist
        if self.DisabledAssist then
            self:AddCommandCap('RULEUCC_Guard')
            self.DisabledAssist = nil
        end

        -- Factory can stop building but still have an unbuilt unit if a mobile build order is issued and the order is cancelled
        if not IsDestroyed(unitBeingBuilt) and unitBeingBuilt:GetFractionComplete() < 1 then
            unitBeingBuilt:Destroy()
        end

        if not (self.FactoryBuildFailed or IsDestroyed(self)) then
            self:StopBuildFx()

            -- Moving off factory has to be issued this tick so that rally points are issued after it
            -- Air units don't need the move order since they fly off the factory by themselves
            -- Pass the spin up so that engineers can be rotated towards the rolloff point after the "build finished" animation

            local spin = nil
            if not EntityCategoryContains(categories.AIR, unitBeingBuilt) then
                local rollOffPoint = self.RollOffPoint
                local x, y, z
                spin, x, y, z = self:CalculateRollOffPoint()
                rollOffPoint[1], rollOffPoint[2], rollOffPoint[3] = x, y, z
                IssueToUnitMoveOffFactory(unitBeingBuilt, rollOffPoint)
            end

            self:ForkThread(self.FinishBuildThread, unitBeingBuilt, order, spin)
        end

    end,

    ---@param self FactoryUnit
    ---@param builder Unit
    ---@param layer Layer
    OnStopBeingBuilt = function(self, builder, layer)
        TerminideStructureUnit.OnStopBeingBuilt(self, builder, layer)

        local brain = self.Brain
        local blueprint = self.Blueprint

        if blueprint.CategoriesHash["RESEARCH"] then
            -- update internal state
            brain:AddHQ(blueprint.FactionCategory, blueprint.LayerCategory, blueprint.TechCategory)
            brain:SetHQSupportFactoryRestrictions(blueprint.FactionCategory, blueprint.LayerCategory)

            -- update all units affected by this
            local affected = brain:GetListOfUnits(categories.SUPPORTFACTORY - categories.EXPERIMENTAL, false)
            for _, unit in affected do
                unit:UpdateBuildRestrictions()
            end
        end

        -- Blinking lights functionality
        brain:RegisterUnitEnergyStorage(self)
        brain:RegisterUnitMassStorage(self)

        if brain.MassStorageState == 'EconLowMassStore' or brain.EnergyStorageState == 'EconLowEnergyStore' then
            self.BlinkingLightsState = 'Red'
        else
           self.BlinkingLightsState = 'Green'
        end
        self:CreateBlinkingLights()
    end,

    ---@param self FactoryUnit
    OnFailedToBuild = function(self)
        local unitBeingBuilt = self.UnitBeingBuilt
        if unitBeingBuilt and not unitBeingBuilt.Dead then
            -- Instantly clear the build area so the next build can start, since unit `Destroy` doesn't do so.
            unitBeingBuilt:SetCollisionShape("None")
        end
        TerminideStructureUnit.OnFailedToBuild(self)
        self.FactoryBuildFailed = true
        self:StopBuildFx()
        ChangeState(self, self.IdleState)
    end,

    --- When the factory is killed, kills the unit being built, with veterancy dispersal and credit to the instigator.
    ---@param self FactoryUnit
    ---@param instigator Unit | Projectile
    ---@param type string
    ---@param overkillRatio number
    OnKilled = function(self, instigator, type, overkillRatio)
        self:KillUnitBeingBuilt(instigator, type, overkillRatio)
        TerminideStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    --#endregion

    ---------------------------------------------------------------------------
    --#region Lua functionality

    --- Kills the unit being built, with veterancy dispersal and credit to the instigator.
    ---@param self FactoryUnit
    ---@param instigator Unit | Projectile
    ---@param type string
    ---@param overkillRatio number
    KillUnitBeingBuilt = function(self, instigator, type, overkillRatio)
        local unitBeingBuilt = self.UnitBeingBuilt
        if unitBeingBuilt and not unitBeingBuilt.Dead and not unitBeingBuilt.isFinishedUnit then
            -- Detach the unit to allow things like sinking
            unitBeingBuilt:DetachFrom(true)
            -- Disperse the unit's veterancy to our killers
            -- only take remaining HP so we don't double count
            -- Identical logic is used for cargo of transports, so this vet behavior is consistent.
            self:VeterancyDispersal(unitBeingBuilt:GetTotalMassCost() * unitBeingBuilt:GetHealth() / unitBeingBuilt:GetMaxHealth())
            if instigator then
                unitBeingBuilt:Kill(instigator, type, 0)
            else
                unitBeingBuilt:Kill()
            end
        end
    end,

    --- Destroys the unit being built if it isn't already dead/destroyed, this fixes cases
    --- where the factory is reclaimed or transferred and the unit being built still exists.
    ---@param self FactoryUnit
    DestroyUnitBeingBuilt = function(self)
        local unitBeingBuilt = self.UnitBeingBuilt --[[@as Unit]]
        -- unit is dead, so it should destroy itself
        if not unitBeingBuilt.Dead and not IsDestroyed(unitBeingBuilt)
            and not unitBeingBuilt.isFinishedUnit
        then
            unitBeingBuilt:Destroy()
        end
    end,

    ---@param self FactoryUnit
    ---@param unitBeingBuilt Unit
    ---@param order boolean
    ---@param rollOffPointSpin number?
    FinishBuildThread = function(self, unitBeingBuilt, order, rollOffPointSpin)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        local bp = self.Blueprint
        local bpAnim = bp.Display.AnimationFinishBuildLand
        if bpAnim and EntityCategoryContains(categories.LAND, unitBeingBuilt) then
            self.RollOffAnim = CreateAnimator(self):PlayAnim(bpAnim):SetRate(self.RollOffAnimationRate)
            self.Trash:Add(self.RollOffAnim)
            WaitTicks(1)
            WaitFor(self.RollOffAnim)
        end

        -- engineers can only be rotated during rolloff after the "build finished" animation ends
        if rollOffPointSpin and unitBeingBuilt and EntityCategoryContains(categories.ENGINEER, unitBeingBuilt) then
            unitBeingBuilt:SetRotation(rollOffPointSpin)
        end

        if unitBeingBuilt and not unitBeingBuilt.Dead then
            unitBeingBuilt:DetachFrom(true)
        end
        self:DetachAll(bp.Display.BuildAttachBone or 0)
        self:DestroyBuildRotator()
        if order ~= 'Upgrade' then
            ChangeState(self, self.RollingOffState)
        else
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
        end
    end,

    ---@param self FactoryUnit
    ---@param target_bp any
    ---@return boolean
    CheckBuildRestriction = function(self, target_bp)
        -- Check basic build restrictions first (Unit.CheckBuildRestriction but we only go up one inheritance level)
        if not TerminideStructureUnit.CheckBuildRestriction(self, target_bp) then
            return false
        end
        -- Factories never build factories (this does not break Upgrades since CheckBuildRestriction is never called for Upgrades)
        -- Note: We check for the primary category, since e.g. AircraftCarriers have the FACTORY category.
        -- TODO: This is a hotfix for --1043, remove when engymod design is properly fixed
        return target_bp.General.Category ~= 'Factory'
    end,

    ---@param self FactoryUnit
    CalculateRollOffPoint = function(self)
        local px, py, pz = self:GetPositionXYZ()

        -- check if we have roll of points set
        local rollOffPoints = self.Blueprint.Physics.RollOffPoints
        if not rollOffPoints then
            return 0, px, py, pz
        end

        -- find our rally point, or of the factory that we're assisting
        local rally = self:GetRallyPoint()
        local focus = self:GetGuardedUnit()
        while focus and focus != self do
            local next = focus:GetGuardedUnit()
            if next then
                focus = next
            else
                break
            end
        end

        if focus then
            rally = focus:GetRallyPoint()
        end

        -- check if we have a rally point set
        if not rally then
            return 0, px, py, pz
        end

        -- find nearest roll off point for rally point
        local nearestRollOffPoint = nil
        local d, dx, dz, lowest = 0, 0, 0, nil
        for k, rollOffPoint in rollOffPoints do
            dx = rally[1] - (px + rollOffPoint.X)
            dz = rally[3] - (pz + rollOffPoint.Z)
            d = dx * dx + dz * dz

            if not lowest or d < lowest then
                nearestRollOffPoint = rollOffPoint
                lowest = d
            end
        end

        -- determine return parameters
        local spin = self.UnitBeingBuilt.Blueprint.Display.ForcedBuildSpin or nearestRollOffPoint.UnitSpin
        local fx = nearestRollOffPoint.X + px
        local fy = nearestRollOffPoint.Y + py
        local fz = nearestRollOffPoint.Z + pz

        return spin, fx, fy, fz
    end,
	
	CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateTerminideUnitBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )                 
    end,

    ---@param self FactoryUnit
    ---@param unitBeingBuilt Unit
    StartBuildFx = function(self, unitBeingBuilt)
    end,

    ---@param self FactoryUnit
    StopBuildFx = function(self)
    end,

    ---@param self FactoryUnit
    PlayFxRollOff = function(self)
    end,

    ---@param self FactoryUnit
    PlayFxRollOffEnd = function(self)
        local rollOffAnim = self.RollOffAnim
        if rollOffAnim then
            rollOffAnim:SetRate(-1 * self.RollOffAnimationRate)
            WaitFor(rollOffAnim)
            rollOffAnim:Destroy()
            self.RollOffAnim = nil
        end
    end,

    ---@param self FactoryUnit
    RolloffBody = function(self)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self:PlayFxRollOff()

        local unitBeingBuilt = self.UnitBeingBuilt --[[@as Unit]]

        -- find out when build pad is free again
        local size = unitBeingBuilt.Blueprint.SizeX
        if size < unitBeingBuilt.Blueprint.SizeZ then
            size = unitBeingBuilt.Blueprint.SizeZ
        end

        size = (0.5 * size) * (0.5 * size)
        local unitPosition, dx, dz, d
        local buildPosition = self:GetPosition(self.Blueprint.Display.BuildAttachBone or 0)
        repeat
            unitPosition = unitBeingBuilt:GetPosition()
            dx = buildPosition[1] - unitPosition[1]
            dz = buildPosition[3] - unitPosition[3]
            d = dx * dx + dz * dz
            WaitTicks(2)
        until IsDestroyed(unitBeingBuilt) or d > size

        self:PlayFxRollOffEnd()
        self:SetBusy(false)
        self:SetBlockCommandQueue(false)

        ChangeState(self, self.IdleState)
    end,

    --#endregion

    ---------------------------------------------------------------------------
    --#region States

    IdleState = State {
        ---@param self FactoryUnit
        Main = function(self)
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
        end,
    },

    BuildingState = State {
        ---@param self FactoryUnit
        Main = function(self)

            local unitBeingBuilt = self.UnitBeingBuilt --[[@as Unit]]

            -- to help prevent a 1-tick rotation on most units
            local hasEnhancements = unitBeingBuilt.Blueprint.Enhancements
            if not hasEnhancements then
                unitBeingBuilt:HideBone(0, true)
            end

            -- determine and preserve the roll off point
            local spin, x, y, z = self:CalculateRollOffPoint()
            local rollOffPoint = self.RollOffPoint
            rollOffPoint[1] = x
            rollOffPoint[2] = y
            rollOffPoint[3] = z

            self.BuildBoneRotator:SetGoal(spin)
            unitBeingBuilt:AttachBoneTo(-2, self, self.Blueprint.Display.BuildAttachBone or 0)
            self:StartBuildFx(unitBeingBuilt)

            -- prevents a 1-tick rotating visual 'glitch' of unit
            -- as it is being attached and the rotator is applied
            WaitTicks(3)
            if not hasEnhancements then
                unitBeingBuilt:ShowBone(0, true)
            end
        end,
    },

    RollingOffState = State {
        ---@param self FactoryUnit
        Main = function(self)
            self:RolloffBody()
        end,
    },

    UpgradingState = State(TerminideStructureUnit.UpgradingState) {
        --- Copied from `StructureUnit.UpgradingState.OnStopBuild` and modified
        --- to unblock the build area when the factory upgrade finishes.
        ---@see StructureUnit.UpgradingState.OnStopBuild
        ---@param self FactoryUnit
        ---@param unitBuilding Unit
        ---@param order string
        OnStopBuild = function(self, unitBuilding, order)
            UnitOnStopBuild(self, unitBuilding, order)
            self:EnableDefaultToggleCaps()

            if unitBuilding:GetFractionComplete() == 1 then
                NotifyUpgrade(self, unitBuilding)
                self:StopUpgradeEffects(unitBuilding)
                self:PlayUnitSound('UpgradeEnd')

                -- Since `Destroy` wouldn't do so, immediately unblock the build area
                -- of the new factory by setting collision shape to none. This allows
                -- the new factory to immediately start working on its queue.
                self:SetCollisionShape("None")

                self:Destroy()
            end
        end,
    },

    --#endregion

    ---------------------------------------------------------------------------
    --#region Utility functions

    ---@param self FactoryUnit
    ---@return string?
    ToSupportFactoryIdentifier = function(self)
        local blueprint = self.Blueprint
        local hashedCategories = blueprint.CategoriesHash
        local identifier = blueprint.BlueprintId
        local faction = identifier:sub(2, 2)
        local layer = identifier:sub(7, 7)

        -- HQs can not upgrade to support factories
        if hashedCategories["RESEARCH"] then
            return nil
        end

        -- tech 1 factories can go tech 2 support factories if we have a tech 2 hq
        if  hashedCategories["TECH1"] and
            self.Brain:CountHQs(blueprint.FactionCategory, blueprint.LayerCategory, 'TECH2') > 0
        then
            return 'z' .. faction .. 'b950' .. layer
        end

        -- tech 2 support factories can go tech 3 support factories if we have a tech 3 hq
        if  hashedCategories["TECH2"] and
            hashedCategories["SUPPORTFACTORY"] and
            self.Brain:CountHQs(blueprint.FactionCategory, blueprint.LayerCategory, 'TECH3') > 0
        then
            return 'z' .. faction .. 'b960' .. layer
        end

        -- anything else can not upgrade
        return nil
    end,

    ---@param self FactoryUnit
    ToHQFactoryIdentifier = function(self)
        local blueprint = self.Blueprint
        local hashedCategories = blueprint.CategoriesHash
        local identifier = blueprint.BlueprintId
        local faction = identifier:sub(1, 3)
        local layer = identifier:sub(7, 7)

        -- support factories can not upgrade to HQs
        if hashedCategories["SUPPORTFACTORY"] then
            return nil
        end

        -- tech 1 factories can always upgrade
        if hashedCategories["TECH1"] then
            return faction .. '020' .. layer
        end

        -- tech 2 factories can always upgrade
        if hashedCategories["TECH2"] and hashedCategories["RESEARCH"] then
            return faction .. '030'  .. layer
        end

        -- anything else can not upgrade
        return nil
    end,

    --#endregion


    ---------------------------------------------------------------------------
    --#region Blinking lights functionality

    ---@param self FactoryUnit
    ---@param state AIBrainMassStorageState
    OnMassStorageStateChange = function(self, state)
        if state == 'EconLowMassStore' then
            self:ChangeBlinkingLights('Red')
        else
            self:ChangeBlinkingLights('Green')
        end
    end,

    ---@param self FactoryUnit
    ---@param state AIBrainEnergyStorageState
    OnEnergyStorageStateChange = function(self, state)
        if state == 'EconLowEnergyStore' then
            self:ChangeBlinkingLights('Red')
        else
            self:ChangeBlinkingLights('Green')
        end
    end,

    --#endregion

    ---------------------------------------------------------------------------
    --#region Deprecated functionality

    ---@deprecated
    ---@param self FactoryUnit
    ---@param unitBeingBuilt Unit
    ---@param order string
    DoStopBuild = function(self, unitBeingBuilt, order)
        -- StructureUnitOnStopBuild(self, unitBeingBuilt, order)

        -- if not self.FactoryBuildFailed and not self.Dead then
        --     if not EntityCategoryContains(categories.AIR, unitBeingBuilt) then
        --         self:RollOffUnit()
        --     end
        --     self:StopBuildFx()
        --     self:ForkThread(self.FinishBuildThread, unitBeingBuilt, order)
        -- end
        -- self.BuildingUnit = false
    end,

    --- Adds a pause between unit productions
    ---@deprecated
    ---@param self FactoryUnit
    ---@param productionpause number
    ---@param unitBeingBuilt Unit
    ---@param order string
    PauseThread = function(self, productionpause, unitBeingBuilt, order)
        -- self:StopBuildFx()
        -- self:SetBusy(true)
        -- self:SetBlockCommandQueue(true)

        -- WaitSeconds(productionpause)

        -- self:SetBusy(false)
        -- self:SetBlockCommandQueue(false)
        -- self:DoStopBuild(unitBeingBuilt, order)
    end,

    ---@deprecated
    ---@param self FactoryUnit
    CreateBuildRotator = function(self)
    end,

    ---@deprecated
    ---@param self FactoryUnit
    DestroyBuildRotator = function(self)
    end,
}

FAFShriekerNest = Class(TerminideStructureUnit) {
 RollOffAnimationRate = 10,

    ---------------------------------------------------------------------------
    --#region Engine events

    ---@param self FactoryUnit
    OnCreate = function(self)
        TerminideStructureUnit.OnCreate(self)

        local blueprint = self.Blueprint

        -- if we're a support factory, make sure our build restrictions are correct
        if blueprint.CategoriesHash["SUPPORTFACTORY"] then
            self:UpdateBuildRestrictions()
        end

        -- store build bone rotator to prevent trashing the memory
        local buildBoneRotator = CreateRotator(self, blueprint.Display.BuildAttachBone or 0, 'y', 0, 10000)
        buildBoneRotator:SetPrecedence(1000)
        self.BuildBoneRotator = self.Trash:Add(buildBoneRotator)

        -- store build effect bones for quick access
        self.BuildEffectBones = blueprint.General.BuildBones.BuildEffectBones

        -- save for quick access later
        self.RollOffPoint = { 0, 0, 0 }
    end,

    ---@param self FactoryUnit
    OnDestroy = function(self)
        TerminideStructureUnit.OnDestroy(self)
        local brain = self.Brain
        local blueprint = self.Blueprint

        if blueprint.CategoriesHash["RESEARCH"] and self:GetFractionComplete() == 1.0 then
            -- update internal state
            brain:RemoveHQ(blueprint.FactionCategory, blueprint.LayerCategory, blueprint.TechCategory)
            brain:SetHQSupportFactoryRestrictions(blueprint.FactionCategory, blueprint.LayerCategory)

            -- update all units affected by this
            local affected = brain:GetListOfUnits(categories.SUPPORTFACTORY - categories.EXPERIMENTAL, false)
            for _, unit in affected do
                unit:UpdateBuildRestrictions()
            end
        end

        self:DestroyUnitBeingBuilt()
    end,

    ---@param self FactoryUnit
    OnPaused = function(self)
        TerminideStructureUnit.OnPaused(self)

        -- remove the build effects
        if self:IsUnitState('Building') then
            self:StopBuildingEffects(self.UnitBeingBuilt)
        end
    end,

    ---@param self FactoryUnit
    OnUnpaused = function(self)
        TerminideStructureUnit.OnUnpaused(self)

        -- re-introduce the build effects
        local unitBeingBuilt = self.UnitBeingBuilt --[[@as Unit]]
        local unitBuildOrder = self.UnitBuildOrder
        if self:IsUnitState('Building') and (not IsDestroyed(unitBeingBuilt)) then
            self:StartBuildingEffects(unitBeingBuilt, unitBuildOrder)
        end
    end,

    ---@param self FactoryUnit
    ---@param unitBeingBuilt Unit
    ---@param order string
    OnStartBuild = function(self, unitBeingBuilt, order)
        TerminideStructureUnit.OnStartBuild(self, unitBeingBuilt, order)

        self.FactoryBuildFailed = nil
        self.BuildingUnit = true
        if order ~= 'Upgrade' then
            ChangeState(self, self.BuildingState)
            self.BuildingUnit = nil
        elseif unitBeingBuilt.Blueprint.CategoriesHash["RESEARCH"] then
            -- temporarily remove the ability to assist to prevent cancelling the upgrade
            self:RemoveCommandCap('RULEUCC_Guard')
            self.DisabledAssist = true
        end
    end,

    --- Introduce a rolloff delay, where defined.
    ---@param self FactoryUnit
    ---@param unitBeingBuilt Unit
    ---@param order string
    OnStopBuild = function(self, unitBeingBuilt, order)
        TerminideStructureUnit.OnStopBuild(self, unitBeingBuilt, order)

        self.BuildingUnit = false

        -- re-introduce the ability to assist
        if self.DisabledAssist then
            self:AddCommandCap('RULEUCC_Guard')
            self.DisabledAssist = nil
        end

        -- Factory can stop building but still have an unbuilt unit if a mobile build order is issued and the order is cancelled
        if not IsDestroyed(unitBeingBuilt) and unitBeingBuilt:GetFractionComplete() < 1 then
            unitBeingBuilt:Destroy()
        end

        if not (self.FactoryBuildFailed or IsDestroyed(self)) then
            self:StopBuildFx()

            -- Moving off factory has to be issued this tick so that rally points are issued after it
            -- Air units don't need the move order since they fly off the factory by themselves
            -- Pass the spin up so that engineers can be rotated towards the rolloff point after the "build finished" animation

            local spin = nil
            if not EntityCategoryContains(categories.AIR, unitBeingBuilt) then
                local rollOffPoint = self.RollOffPoint
                local x, y, z
                spin, x, y, z = self:CalculateRollOffPoint()
                rollOffPoint[1], rollOffPoint[2], rollOffPoint[3] = x, y, z
                IssueToUnitMoveOffFactory(unitBeingBuilt, rollOffPoint)
            end

            self:ForkThread(self.FinishBuildThread, unitBeingBuilt, order, spin)
        end

    end,

    ---@param self FactoryUnit
    ---@param builder Unit
    ---@param layer Layer
    OnStopBeingBuilt = function(self, builder, layer)
        TerminideStructureUnit.OnStopBeingBuilt(self, builder, layer)

        local brain = self.Brain
        local blueprint = self.Blueprint

        if blueprint.CategoriesHash["RESEARCH"] then
            -- update internal state
            brain:AddHQ(blueprint.FactionCategory, blueprint.LayerCategory, blueprint.TechCategory)
            brain:SetHQSupportFactoryRestrictions(blueprint.FactionCategory, blueprint.LayerCategory)

            -- update all units affected by this
            local affected = brain:GetListOfUnits(categories.SUPPORTFACTORY - categories.EXPERIMENTAL, false)
            for _, unit in affected do
                unit:UpdateBuildRestrictions()
            end
        end

        -- Blinking lights functionality
        brain:RegisterUnitEnergyStorage(self)
        brain:RegisterUnitMassStorage(self)

        if brain.MassStorageState == 'EconLowMassStore' or brain.EnergyStorageState == 'EconLowEnergyStore' then
            self.BlinkingLightsState = 'Red'
        else
           self.BlinkingLightsState = 'Green'
        end
        self:CreateBlinkingLights()
    end,

    ---@param self FactoryUnit
    OnFailedToBuild = function(self)
        local unitBeingBuilt = self.UnitBeingBuilt
        if unitBeingBuilt and not unitBeingBuilt.Dead then
            -- Instantly clear the build area so the next build can start, since unit `Destroy` doesn't do so.
            unitBeingBuilt:SetCollisionShape("None")
        end
        TerminideStructureUnit.OnFailedToBuild(self)
        self.FactoryBuildFailed = true
        self:StopBuildFx()
        ChangeState(self, self.IdleState)
    end,

    --- When the factory is killed, kills the unit being built, with veterancy dispersal and credit to the instigator.
    ---@param self FactoryUnit
    ---@param instigator Unit | Projectile
    ---@param type string
    ---@param overkillRatio number
    OnKilled = function(self, instigator, type, overkillRatio)
        self:KillUnitBeingBuilt(instigator, type, overkillRatio)
        TerminideStructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    --#endregion

    ---------------------------------------------------------------------------
    --#region Lua functionality

    --- Kills the unit being built, with veterancy dispersal and credit to the instigator.
    ---@param self FactoryUnit
    ---@param instigator Unit | Projectile
    ---@param type string
    ---@param overkillRatio number
    KillUnitBeingBuilt = function(self, instigator, type, overkillRatio)
        local unitBeingBuilt = self.UnitBeingBuilt
        if unitBeingBuilt and not unitBeingBuilt.Dead and not unitBeingBuilt.isFinishedUnit then
            -- Detach the unit to allow things like sinking
            unitBeingBuilt:DetachFrom(true)
            -- Disperse the unit's veterancy to our killers
            -- only take remaining HP so we don't double count
            -- Identical logic is used for cargo of transports, so this vet behavior is consistent.
            self:VeterancyDispersal(unitBeingBuilt:GetTotalMassCost() * unitBeingBuilt:GetHealth() / unitBeingBuilt:GetMaxHealth())
            if instigator then
                unitBeingBuilt:Kill(instigator, type, 0)
            else
                unitBeingBuilt:Kill()
            end
        end
    end,

    --- Destroys the unit being built if it isn't already dead/destroyed, this fixes cases
    --- where the factory is reclaimed or transferred and the unit being built still exists.
    ---@param self FactoryUnit
    DestroyUnitBeingBuilt = function(self)
        local unitBeingBuilt = self.UnitBeingBuilt --[[@as Unit]]
        -- unit is dead, so it should destroy itself
        if not unitBeingBuilt.Dead and not IsDestroyed(unitBeingBuilt)
            and not unitBeingBuilt.isFinishedUnit
        then
            unitBeingBuilt:Destroy()
        end
    end,

    ---@param self FactoryUnit
    ---@param unitBeingBuilt Unit
    ---@param order boolean
    ---@param rollOffPointSpin number?
    FinishBuildThread = function(self, unitBeingBuilt, order, rollOffPointSpin)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        local bp = self.Blueprint
        local bpAnim = bp.Display.AnimationFinishBuildLand
        if bpAnim and EntityCategoryContains(categories.LAND, unitBeingBuilt) then
            self.RollOffAnim = CreateAnimator(self):PlayAnim(bpAnim):SetRate(self.RollOffAnimationRate)
            self.Trash:Add(self.RollOffAnim)
            WaitTicks(1)
            WaitFor(self.RollOffAnim)
        end

        -- engineers can only be rotated during rolloff after the "build finished" animation ends
        if rollOffPointSpin and unitBeingBuilt and EntityCategoryContains(categories.ENGINEER, unitBeingBuilt) then
            unitBeingBuilt:SetRotation(rollOffPointSpin)
        end

        if unitBeingBuilt and not unitBeingBuilt.Dead then
            unitBeingBuilt:DetachFrom(true)
        end
        self:DetachAll(bp.Display.BuildAttachBone or 0)
        self:DestroyBuildRotator()
        if order ~= 'Upgrade' then
            ChangeState(self, self.RollingOffState)
        else
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
        end
    end,

    ---@param self FactoryUnit
    ---@param target_bp any
    ---@return boolean
    CheckBuildRestriction = function(self, target_bp)
        -- Check basic build restrictions first (Unit.CheckBuildRestriction but we only go up one inheritance level)
        if not TerminideStructureUnit.CheckBuildRestriction(self, target_bp) then
            return false
        end
        -- Factories never build factories (this does not break Upgrades since CheckBuildRestriction is never called for Upgrades)
        -- Note: We check for the primary category, since e.g. AircraftCarriers have the FACTORY category.
        -- TODO: This is a hotfix for --1043, remove when engymod design is properly fixed
        return target_bp.General.Category ~= 'Factory'
    end,

    ---@param self FactoryUnit
    CalculateRollOffPoint = function(self)
        local px, py, pz = self:GetPositionXYZ()

        -- check if we have roll of points set
        local rollOffPoints = self.Blueprint.Physics.RollOffPoints
        if not rollOffPoints then
            return 0, px, py, pz
        end

        -- find our rally point, or of the factory that we're assisting
        local rally = self:GetRallyPoint()
        local focus = self:GetGuardedUnit()
        while focus and focus != self do
            local next = focus:GetGuardedUnit()
            if next then
                focus = next
            else
                break
            end
        end

        if focus then
            rally = focus:GetRallyPoint()
        end

        -- check if we have a rally point set
        if not rally then
            return 0, px, py, pz
        end

        -- find nearest roll off point for rally point
        local nearestRollOffPoint = nil
        local d, dx, dz, lowest = 0, 0, 0, nil
        for k, rollOffPoint in rollOffPoints do
            dx = rally[1] - (px + rollOffPoint.X)
            dz = rally[3] - (pz + rollOffPoint.Z)
            d = dx * dx + dz * dz

            if not lowest or d < lowest then
                nearestRollOffPoint = rollOffPoint
                lowest = d
            end
        end

        -- determine return parameters
        local spin = self.UnitBeingBuilt.Blueprint.Display.ForcedBuildSpin or nearestRollOffPoint.UnitSpin
        local fx = nearestRollOffPoint.X + px
        local fy = nearestRollOffPoint.Y + py
        local fz = nearestRollOffPoint.Z + pz

        return spin, fx, fy, fz
    end,
	
	CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateTerminideUnitBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )                 
    end,

    ---@param self FactoryUnit
    ---@param unitBeingBuilt Unit
    StartBuildFx = function(self, unitBeingBuilt)
    end,

    ---@param self FactoryUnit
    StopBuildFx = function(self)
    end,

    ---@param self FactoryUnit
    PlayFxRollOff = function(self)
    end,

    ---@param self FactoryUnit
    PlayFxRollOffEnd = function(self)
        local rollOffAnim = self.RollOffAnim
        if rollOffAnim then
            rollOffAnim:SetRate(-1 * self.RollOffAnimationRate)
            WaitFor(rollOffAnim)
            rollOffAnim:Destroy()
            self.RollOffAnim = nil
        end
    end,

    ---@param self FactoryUnit
    RolloffBody = function(self)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self:PlayFxRollOff()

        local unitBeingBuilt = self.UnitBeingBuilt --[[@as Unit]]

        -- find out when build pad is free again
        local size = unitBeingBuilt.Blueprint.SizeX
        if size < unitBeingBuilt.Blueprint.SizeZ then
            size = unitBeingBuilt.Blueprint.SizeZ
        end

        size = (0.5 * size) * (0.5 * size)
        local unitPosition, dx, dz, d
        local buildPosition = self:GetPosition(self.Blueprint.Display.BuildAttachBone or 0)
        repeat
            unitPosition = unitBeingBuilt:GetPosition()
            dx = buildPosition[1] - unitPosition[1]
            dz = buildPosition[3] - unitPosition[3]
            d = dx * dx + dz * dz
            WaitTicks(2)
        until IsDestroyed(unitBeingBuilt) or d > size

        self:PlayFxRollOffEnd()
        self:SetBusy(false)
        self:SetBlockCommandQueue(false)

        ChangeState(self, self.IdleState)
    end,

    --#endregion

    ---------------------------------------------------------------------------
    --#region States

    IdleState = State {
        ---@param self FactoryUnit
        Main = function(self)
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
        end,
    },

    BuildingState = State {
        ---@param self FactoryUnit
        Main = function(self)

            local unitBeingBuilt = self.UnitBeingBuilt --[[@as Unit]]

            -- to help prevent a 1-tick rotation on most units
            local hasEnhancements = unitBeingBuilt.Blueprint.Enhancements
            if not hasEnhancements then
                unitBeingBuilt:HideBone(0, true)
            end

            -- determine and preserve the roll off point
            local spin, x, y, z = self:CalculateRollOffPoint()
            local rollOffPoint = self.RollOffPoint
            rollOffPoint[1] = x
            rollOffPoint[2] = y
            rollOffPoint[3] = z

            self.BuildBoneRotator:SetGoal(spin)
            unitBeingBuilt:AttachBoneTo(-2, self, self.Blueprint.Display.BuildAttachBone or 0)
            self:StartBuildFx(unitBeingBuilt)

            -- prevents a 1-tick rotating visual 'glitch' of unit
            -- as it is being attached and the rotator is applied
            WaitTicks(3)
            if not hasEnhancements then
                unitBeingBuilt:ShowBone(0, true)
            end
        end,
    },

    RollingOffState = State {
        ---@param self FactoryUnit
        Main = function(self)
            self:RolloffBody()
        end,
    },

    UpgradingState = State(TerminideStructureUnit.UpgradingState) {
        --- Copied from `StructureUnit.UpgradingState.OnStopBuild` and modified
        --- to unblock the build area when the factory upgrade finishes.
        ---@see StructureUnit.UpgradingState.OnStopBuild
        ---@param self FactoryUnit
        ---@param unitBuilding Unit
        ---@param order string
        OnStopBuild = function(self, unitBuilding, order)
            UnitOnStopBuild(self, unitBuilding, order)
            self:EnableDefaultToggleCaps()

            if unitBuilding:GetFractionComplete() == 1 then
                NotifyUpgrade(self, unitBuilding)
                self:StopUpgradeEffects(unitBuilding)
                self:PlayUnitSound('UpgradeEnd')

                -- Since `Destroy` wouldn't do so, immediately unblock the build area
                -- of the new factory by setting collision shape to none. This allows
                -- the new factory to immediately start working on its queue.
                self:SetCollisionShape("None")

                self:Destroy()
            end
        end,
    },

    --#endregion

    ---------------------------------------------------------------------------
    --#region Utility functions

    ---@param self FactoryUnit
    ---@return string?
    ToSupportFactoryIdentifier = function(self)
        local blueprint = self.Blueprint
        local hashedCategories = blueprint.CategoriesHash
        local identifier = blueprint.BlueprintId
        local faction = identifier:sub(2, 2)
        local layer = identifier:sub(7, 7)

        -- HQs can not upgrade to support factories
        if hashedCategories["RESEARCH"] then
            return nil
        end

        -- tech 1 factories can go tech 2 support factories if we have a tech 2 hq
        if  hashedCategories["TECH1"] and
            self.Brain:CountHQs(blueprint.FactionCategory, blueprint.LayerCategory, 'TECH2') > 0
        then
            return 'z' .. faction .. 'b950' .. layer
        end

        -- tech 2 support factories can go tech 3 support factories if we have a tech 3 hq
        if  hashedCategories["TECH2"] and
            hashedCategories["SUPPORTFACTORY"] and
            self.Brain:CountHQs(blueprint.FactionCategory, blueprint.LayerCategory, 'TECH3') > 0
        then
            return 'z' .. faction .. 'b960' .. layer
        end

        -- anything else can not upgrade
        return nil
    end,

    ---@param self FactoryUnit
    ToHQFactoryIdentifier = function(self)
        local blueprint = self.Blueprint
        local hashedCategories = blueprint.CategoriesHash
        local identifier = blueprint.BlueprintId
        local faction = identifier:sub(1, 3)
        local layer = identifier:sub(7, 7)

        -- support factories can not upgrade to HQs
        if hashedCategories["SUPPORTFACTORY"] then
            return nil
        end

        -- tech 1 factories can always upgrade
        if hashedCategories["TECH1"] then
            return faction .. '020' .. layer
        end

        -- tech 2 factories can always upgrade
        if hashedCategories["TECH2"] and hashedCategories["RESEARCH"] then
            return faction .. '030'  .. layer
        end

        -- anything else can not upgrade
        return nil
    end,

    --#endregion


    ---------------------------------------------------------------------------
    --#region Blinking lights functionality

    ---@param self FactoryUnit
    ---@param state AIBrainMassStorageState
    OnMassStorageStateChange = function(self, state)
        if state == 'EconLowMassStore' then
            self:ChangeBlinkingLights('Red')
        else
            self:ChangeBlinkingLights('Green')
        end
    end,

    ---@param self FactoryUnit
    ---@param state AIBrainEnergyStorageState
    OnEnergyStorageStateChange = function(self, state)
        if state == 'EconLowEnergyStore' then
            self:ChangeBlinkingLights('Red')
        else
            self:ChangeBlinkingLights('Green')
        end
    end,

    --#endregion

    ---------------------------------------------------------------------------
    --#region Deprecated functionality

    ---@deprecated
    ---@param self FactoryUnit
    ---@param unitBeingBuilt Unit
    ---@param order string
    DoStopBuild = function(self, unitBeingBuilt, order)
        -- StructureUnitOnStopBuild(self, unitBeingBuilt, order)

        -- if not self.FactoryBuildFailed and not self.Dead then
        --     if not EntityCategoryContains(categories.AIR, unitBeingBuilt) then
        --         self:RollOffUnit()
        --     end
        --     self:StopBuildFx()
        --     self:ForkThread(self.FinishBuildThread, unitBeingBuilt, order)
        -- end
        -- self.BuildingUnit = false
    end,

    --- Adds a pause between unit productions
    ---@deprecated
    ---@param self FactoryUnit
    ---@param productionpause number
    ---@param unitBeingBuilt Unit
    ---@param order string
    PauseThread = function(self, productionpause, unitBeingBuilt, order)
        -- self:StopBuildFx()
        -- self:SetBusy(true)
        -- self:SetBlockCommandQueue(true)

        -- WaitSeconds(productionpause)

        -- self:SetBusy(false)
        -- self:SetBlockCommandQueue(false)
        -- self:DoStopBuild(unitBeingBuilt, order)
    end,

    ---@deprecated
    ---@param self FactoryUnit
    CreateBuildRotator = function(self)
    end,

    ---@deprecated
    ---@param self FactoryUnit
    DestroyBuildRotator = function(self)
    end,
}


FAFTerminideSeaFactoryUnit = ClassUnit(FAFBugHole) {

	CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateTerminideUnitBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )      
		EffectUtil.CreateTerminideConstructionUnitBuildingEffects2( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )		
    end,

    ---@param self SeaFactoryUnit
    DestroyUnitBeingBuilt = function(self)
        local unitBeingBuilt = self.UnitBeingBuilt
        if unitBeingBuilt and not unitBeingBuilt.Dead and unitBeingBuilt:GetFractionComplete() < 1 then
            unitBeingBuilt:Destroy()
        end
    end,

    ---@param self SeaFactoryUnit
    CalculateRollOffPoint = function(self)
        -- backwards compatible, don't try and fix mods that rely on the old logic
        if not self.Blueprint.Physics.ComputeRollOffPoint then
            return FAFBugHole.CalculateRollOffPoint(self)
        end

        -- retrieve our position
        local px, py, pz = self:GetPositionXYZ()

        -- retrieve roll off points
        local bp = self.Blueprint.Physics.RollOffPoints
        if not bp then
            return 0, px, py, pz
        end

        -- retrieve rally point
        local rallyPoint = self:GetRallyPoint()
        if not rallyPoint then
            return 0, px, py, pz
        end

        -- find the attachpoint for the build location
        local bone = (self:IsValidBone('Attachpoint') and 'Attachpoint') or (self:IsValidBone('Attachpoint01') and 'Attachpoint01')
        local bx, by, bz = self:GetPositionXYZ(bone)
        local ropx = bx - px
        local modz = 1.0 + 0.1 * self.UnitBeingBuilt.Blueprint.SizeZ

        -- find the nearest roll off point
        local bpKey = 1
        local distance, lowest = nil, nil
        for k, rolloffPoint in bp do

            local ropz = modz * rolloffPoint.Z
            distance = VDist2(rallyPoint[1], rallyPoint[3], ropx + px, ropz + pz)
            if not lowest or distance < lowest then
                bpKey = k
                lowest = distance
            end
        end

        -- finalize the computation
        local fx, fy, fz, spin
        local bpP = bp[bpKey]
        local unitBP = self.UnitBeingBuilt.Blueprint.Display.ForcedBuildSpin
        if unitBP then
            spin = unitBP
        else
            spin = bpP.UnitSpin
        end

        fx = ropx + px
        fy = bpP.Y + py
        fz = modz * bpP.Z + pz

        return spin, fx, fy, fz
    end,

}


