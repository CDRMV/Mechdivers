
local Explosion = import('/lua/defaultexplosions.lua')

function GetPlayableArea()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end

function SetRotation(unit, angle)
        local qx, qy, qz, qw = Explosion.QuatFromRotation(angle, 0, 1, 0)
        unit:SetOrientation({qx, qy, qz, qw}, true)
end

    ---@param self Unit
    ---@param angle number
function Rotate(unit, angle)
        local qx, qy, qz, qw = unpack(unit:GetOrientation())
        local a = math.atan2(2.0 * (qx * qz + qw * qy), qw * qw + qx * qx - qz * qz - qy * qy)
        local current_yaw = math.floor(math.abs(a) * (180 / math.pi) + 0.5)

        SetRotation(angle + current_yaw)
end

    ---@param self Unit
    ---@param tpos number
function RotateTowards(unit, tpos)
        local pos = unit:GetPosition()
        local rad = math.atan2(tpos[1] - pos[1], tpos[3] - pos[3])
        SetRotation(unit, rad * (180 / math.pi))
end

    ---@param self Unit
function RotateTowardsMid(unit)
        local x, y = GetMapSize()
        RotateTowards(unit, {x / 2, 0, y / 2})
end


ModularFactoryUnit = Class(StructureUnit) {
    OnCreate = function(self)
        StructureUnit.OnCreate(self)
        self.BuildingUnit = false
    end,
    
    OnPaused = function(self)
        #When factory is paused take some action
        self:StopUnitAmbientSound( 'ConstructLoop' )
        StructureUnit.OnPaused(self)
    end,
    
    OnUnpaused = function(self)
        if self.BuildingUnit then
            self:PlayUnitAmbientSound( 'ConstructLoop' )
        end
        StructureUnit.OnUnpaused(self)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        local aiBrain = GetArmyBrain(self:GetArmy())
        aiBrain:ESRegisterUnitMassStorage(self)
        aiBrain:ESRegisterUnitEnergyStorage(self)
        local curEnergy = aiBrain:GetEconomyStoredRatio('ENERGY')
        local curMass = aiBrain:GetEconomyStoredRatio('MASS')
        if curEnergy > 0.11 and curMass > 0.11 then
            self:CreateBlinkingLights('Green')
            self.BlinkingLightsState = 'Green'
        else
            self:CreateBlinkingLights('Red')
            self.BlinkingLightsState = 'Red'
        end
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
    end,

    ChangeBlinkingLights = function(self, state)
        local bls = self.BlinkingLightsState
        if state == 'Yellow' then
            if bls == 'Green' then
                self:CreateBlinkingLights('Yellow')
                self.BlinkingLightsState = state
            end
        elseif state == 'Green' then
            if bls == 'Yellow' then
                self:CreateBlinkingLights('Green')
                self.BlinkingLightsState = state
            elseif bls == 'Red' then
                local aiBrain = GetArmyBrain(self:GetArmy())
                local curEnergy = aiBrain:GetEconomyStoredRatio('ENERGY')
                local curMass = aiBrain:GetEconomyStoredRatio('MASS')
                if curEnergy > 0.11 and curMass > 0.11 then
                    if self:GetNumBuildOrders(categories.ALLUNITS) == 0 then
                        self:CreateBlinkingLights('Green')
                        self.BlinkingLightsState = state
                    else
                        self:CreateBlinkingLights('Yellow')
                        self.BlinkingLightsState = 'Yellow'
                    end
                end
            end
        elseif state == 'Red' then
            self:CreateBlinkingLights('Red')
            self.BlinkingLightsState = state
        end
    end,

    OnMassStorageStateChange = function(self, newState)
        if newState == 'EconLowMassStore' then
            self:ChangeBlinkingLights('Red')
        else
            self:ChangeBlinkingLights('Green')
        end
    end,

    OnEnergyStorageStateChange = function(self, newState)
        if newState == 'EconLowEnergyStore' then
            self:ChangeBlinkingLights('Red')
        else
            self:ChangeBlinkingLights('Green')
        end
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
        self:ChangeBlinkingLights('Yellow')
        StructureUnit.OnStartBuild(self, unitBeingBuilt, order )
        self.BuildingUnit = true
        if order != 'Upgrade' then
            ChangeState(self, self.BuildingState)
            self.BuildingUnit = false
        end
        self.FactoryBuildFailed = false
    end,

    OnStopBuild = function(self, unitBeingBuilt, order )
        StructureUnit.OnStopBuild(self, unitBeingBuilt, order )
        
        if not self.FactoryBuildFailed then
            if not EntityCategoryContains(categories.AIR, unitBeingBuilt) then
                self:RollOffUnit()
            end
            self:StopBuildFx()
            self:ForkThread(self.FinishBuildThread, unitBeingBuilt, order )
        end
        self.BuildingUnit = false
    end,

    FinishBuildThread = function(self, unitBeingBuilt, order )
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationFinishBuildLand
        if bpAnim and EntityCategoryContains(categories.LAND, unitBeingBuilt) then
            self.RollOffAnim = CreateAnimator(self):PlayAnim(bpAnim)
            self.Trash:Add(self.RollOffAnim)
            WaitTicks(1)
            WaitFor(self.RollOffAnim)
        end
        if unitBeingBuilt and not unitBeingBuilt:IsDead() then
            unitBeingBuilt:DetachFrom(true)
        end
        self:DetachAll(bp.Display.BuildAttachBone or 0)
        self:DestroyBuildRotator()
        if order != 'Upgrade' then
            ChangeState(self, self.RollingOffState)
        else
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
        end
    end,

    CheckBuildRestriction = function(self, target_bp)
        if self:CanBuild(target_bp.BlueprintId) then
            return true
        else
            return false
        end
    end,
    
    OnFailedToBuild = function(self)
        self.FactoryBuildFailed = true        
        StructureUnit.OnFailedToBuild(self)
        self:DestroyBuildRotator()
        self:StopBuildFx()
        ChangeState(self, self.IdleState)
    end,

    RollOffUnit = function(self)
        local spin, x, y, z = self:CalculateRollOffPoint()
        local units = { self.UnitBeingBuilt }
        self.MoveCommand = IssueMove(units, Vector(x, y, z))
    end,
    
    CalculateRollOffPoint = function(self)
        local bp = self:GetBlueprint().Physics.RollOffPoints
        local px, py, pz = unpack(self:GetPosition())
        if not bp then return 0, px, py, pz end
        local vectorObj = self:GetRallyPoint()
        local bpKey = 1
        local distance, lowest = nil
        for k, v in bp do
            distance = VDist2(vectorObj[1], vectorObj[3], v.X + px, v.Z + pz)
            if not lowest or distance < lowest then
                bpKey = k
                lowest = distance
            end
        end
        local fx, fy, fz, spin
        local bpP = bp[bpKey]
        local unitBP = self.UnitBeingBuilt:GetBlueprint().Display.ForcedBuildSpin
        if unitBP then
            spin = unitBP
        else
            spin = bpP.UnitSpin
        end
        fx = bpP.X + px
        fy = bpP.Y + py
        fz = bpP.Z + pz
        return spin, fx, fy, fz
    end,
    
    StartBuildFx = function(self, unitBeingBuilt)
        
    end,
    
    StopBuildFx = function(self)
        
    end,

    PlayFxRollOff = function(self)
    end,
    
    PlayFxRollOffEnd = function(self)
        if self.RollOffAnim then        
            self.RollOffAnim:SetRate(-1)
            WaitFor(self.RollOffAnim)
            self.RollOffAnim:Destroy()
            self.RollOffAnim = nil
        end
    end,
    
    CreateBuildRotator = function(self)
        if not self.BuildBoneRotator then
            local spin = self:CalculateRollOffPoint()
            local bp = self:GetBlueprint().Display
            self.BuildBoneRotator = CreateRotator(self, bp.BuildAttachBone or 0, 'y', spin, 10000)
            self.Trash:Add(self.BuildBoneRotator)
        end
    end,
    
    DestroyBuildRotator = function(self)
        if self.BuildBoneRotator then
            self.BuildBoneRotator:Destroy()
            self.BuildBoneRotator = nil
        end
    end,
    
    RolloffBody = function(self)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self:PlayFxRollOff()
        # Wait until unit has left the factory
        while not self.UnitBeingBuilt:IsDead() and self.MoveCommand and not IsCommandDone(self.MoveCommand) do
            WaitSeconds(0.5)
        end
        self.MoveCommand = nil
        self:PlayFxRollOffEnd()
        self:SetBusy(false)
        self:SetBlockCommandQueue(false)
        ChangeState(self, self.IdleState)
    end,
            
    IdleState = State {

        Main = function(self)
            self:ChangeBlinkingLights('Green')
            self:SetBusy(false)
            self:SetBlockCommandQueue(false)
            self:DestroyBuildRotator()
        end,
    },

    BuildingState = State {

        Main = function(self)
            local unitBuilding = self.UnitBeingBuilt
            local bp = self:GetBlueprint()
            local bone = bp.Display.BuildAttachBone or 0
            self:DetachAll(bone)
            unitBuilding:AttachBoneTo(-2, self, bone)
            self:CreateBuildRotator()
            self:StartBuildFx(unitBuilding)
        end,
    },


    RollingOffState = State {
        Main = function(self)
            self:RolloffBody()
        end,
    },

    OnKilled = function(self, instigator, type, overkillRatio)
        StructureUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
}

StructureUnit2 = Class(Unit) {
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
            self:CreateTarmac(true, true, true, false, false)
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
		if EntityCategoryContains(categories.MECHDIVERSCIVILIANSTRUCTURE, self) then
		local x, y, z = unpack(self:GetPosition())
		local bp = self:GetBlueprint()
        local x0,z0,x1,z1 = self:GetSkirtRect(bp)
        x0,z0,x1,z1 = math.floor(x0),math.floor(z0),math.ceil(x1),math.ceil(z1)
        FlattenMapRect(x0, z0, x1-x0, z1-z0, y)
		else
            if not (__blueprints[self.BpId] or self:GetBlueprint()).Physics.ConditionalFlattenSkirt then
                oldStructureUnit.FlattenSkirt(self)
            else
                self:ForkThread(function(self)
                    coroutine.yield(1) -- Delay because this triggers before it gets attached to anything.
                    local pos = self.CachePosition or self:GetPosition()
                    local terrain = GetTerrainHeight(pos[1], pos[3])
                    if pos[2] == terrain then
                        oldStructureUnit.FlattenSkirt(self)
                    end
                end)
            end
		end	
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

