
local Explosion = import('/lua/defaultexplosions.lua')
local ModEffectTemplate = import('/mods/Mechdivers/lua/CSKMDEffectTemplates.lua')
local ModPath = '/mods/Mechdivers/effects/emitters/'
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat
local EffectUtil = import('/lua/EffectUtilities.lua')
local AdjacencyBuffs = import('/lua/sim/adjacencybuffs.lua')
local Buff = import('/lua/sim/Buff.lua')

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
        local curEnergy = aiBrain:GetEconomyStoredRatio('ENERGY')
        local curMass = aiBrain:GetEconomyStoredRatio('MASS')
        if curEnergy > 0.11 and curMass > 0.11 then

        else
        end
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
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
    MinConsumptionPerSecondEnergy = 1,
    MinWeaponRequiresEnergy = 0,
    
    FxDamage1 = { EffectTemplate.DamageStructureSmoke01, EffectTemplate.DamageStructureSparks01 },
    FxDamage2 = { EffectTemplate.DamageStructureFireSmoke01, EffectTemplate.DamageStructureSparks01 },
    FxDamage3 = { EffectTemplate.DamageStructureFire01, EffectTemplate.DamageStructureSparks01 },    

    OnCreate = function(self)
        Unit.OnCreate(self)
        self.WeaponMod = {}
        self.FxBlinkingLightsBag = {} 
        if self:GetCurrentLayer() == 'Land' and self:GetBlueprint().Physics.FlattenSkirt then
            self:FlattenSkirt()
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
				self:ForkThread( EffectUtil.CreateAeonBuildBaseThread, builder, self.OnBeingBuiltEffectsBag )
			end
		elseif FactionName == 'Cybran' then
		elseif FactionName == 'Seraphim' then
			if bp.General.UpgradesFrom != builder:GetUnitId() then
				self:ForkThread( EffectUtil.CreateSeraphimBuildBaseThread, builder, self.OnBeingBuiltEffectsBag )
			end		
		end
    end,
	
	HideLandBones = function(self)
        if self.LandBuiltHiddenBones and self.Layer == 'Land' then
            for _, v in self.LandBuiltHiddenBones do
                if self:IsValidBone(v) then
                    self:HideBone(v, true)
                end
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
    
    OnKilled = function(self, instigator, type, overkillRatio)
        Unit.OnKilled(self, instigator, type, overkillRatio)
        local orient = self.TarmacBag.Orientation
        local currentBP = self.TarmacBag.CurrentBP
        self:DestroyTarmac()
        self:CreateTarmac(true, true, true, orient, currentBP, currentBP.DeathLifetime or 300)
    end,
    
    
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

    
    CreateAdjacentEffect = function(self, adjacentUnit)
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
            if v.Unit:BeenDestroyed() or v.Unit:IsDead() then #or v.Unit:GetEntityId() == adjacentUnit:GetEntityId() then
                v.Trash:Destroy()
                self.AdjacencyBeamsBag[k] = nil
            end
        end
    end,
    
}



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
		local bp = self:GetBlueprint()
        local x0,z0,x1,z1 = self:GetSkirtRect(bp)
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


BugHole = Class(TerminideStructureUnit) {
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
        local curEnergy = aiBrain:GetEconomyStoredRatio('ENERGY')
        local curMass = aiBrain:GetEconomyStoredRatio('MASS')
        if curEnergy > 0.11 and curMass > 0.11 then
        else
        end
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
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
	
	CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateTerminideUnitBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )                 
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
        if self.UnitBeingBuilt then
            self.UnitBeingBuilt:Destroy()
        end
    end,
}

ShriekerNest = Class(TerminideStructureUnit) {
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
        local curEnergy = aiBrain:GetEconomyStoredRatio('ENERGY')
        local curMass = aiBrain:GetEconomyStoredRatio('MASS')
        if curEnergy > 0.11 and curMass > 0.11 then
        else
        end
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
    end,

    OnStartBuild = function(self, unitBeingBuilt, order )
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
	
	CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateTerminideUnitBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )                 
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
        if self.UnitBeingBuilt then
            self.UnitBeingBuilt:Destroy()
        end
    end,
}

AirStagingPlatformUnit = Class(TerminideStructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,
}


TerminideConcreteStructureUnit = Class(TerminideStructureUnit) {
    OnCreate = function(self)
        StructureUnit.OnCreate(self)
        self:Destroy()
    end
}



TerminideEnergyCreationUnit = Class(TerminideStructureUnit) {
}



TerminideEnergyStorageUnit = Class(TerminideStructureUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        StructureUnit.OnStopBeingBuilt(self,builder,layer)
        local aiBrain = GetArmyBrain(self:GetArmy())
        local curEnergy = aiBrain:GetEconomyStoredRatio('ENERGY')
        if curEnergy > 0.11 then
        else
        end
    end,

    OnEnergyStorageStateChange = function(self, newState)
        if newState == 'EconLowEnergyStore' then
        elseif newState == 'EconMidEnergyStore' then
        elseif newState == 'EconFullEnergyStore' then
        end
    end,

}



TerminideMassCollectionUnit = Class(TerminideStructureUnit) {

    OnCreate = function(self)
        TerminideStructureUnit.OnCreate(self)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TerminideStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,


    OnStartBuild = function(self, unitbuilding, order)
        TerminideStructureUnit.OnStartBuild(self, unitbuilding, order)
        self:AddCommandCap('RULEUCC_Stop')
        local massConsumption = self:GetConsumptionPerSecondMass()
        local massProduction = self:GetProductionPerSecondMass()
        self.UpgradeWatcher = self:ForkThread(self.WatchUpgradeConsumption, massConsumption, massProduction)
    end,

    OnStopBuild = function(self, unitbuilding, order)
        TerminideStructureUnit.OnStopBuild(self, unitbuilding, order)
        self:RemoveCommandCap('RULEUCC_Stop')
        if self.UpgradeWatcher then
            KillThread(self.UpgradeWatcher)
            self:SetConsumptionPerSecondMass(0)
            self:SetProductionPerSecondMass(self:GetBlueprint().Economy.ProductionPerSecondMass or 0)                  
        end  
    end,

    WatchUpgradeConsumption = function(self, massConsumption, massProduction) 
        while true do 
            if not self:IsPaused() then 
                if self:GetResourceConsumed() != 1 then 
                    local aiBrain = self:GetAIBrain() 
                    if aiBrain and aiBrain:GetEconomyStored('ENERGY') <= 1 then 
                        self:SetProductionPerSecondMass(massProduction) 
                        self:SetConsumptionPerSecondMass(massConsumption) 
                    else 
                        if self:GetResourceConsumed() != 0 then 
                            self:SetConsumptionPerSecondMass(massConsumption) 
                            self:SetProductionPerSecondMass(massProduction / self:GetResourceConsumed()) 
                        else 
                            self:SetProductionPerSecondMass(0) 
                        end 
                    end                
                else 
                    self:SetConsumptionPerSecondMass(massConsumption) 
                    self:SetProductionPerSecondMass(massProduction) 
                end 
            else 
                self:SetProductionPerSecondMass(massProduction) 
            end 
            WaitSeconds(0.2) 
        end 
    end,  	
    
    OnPaused = function(self)
        TerminideStructureUnit.OnPaused(self)
	end,

	OnUnpaused = function(self)
	    TerminideStructureUnit.OnUnpaused(self)
	end,
	
    OnProductionPaused = function(self)
        TerminideStructureUnit.OnProductionPaused(self)
        self:StopUnitAmbientSound( 'ActiveLoop' )
    end,

    OnProductionUnpaused = function(self)
        TerminideStructureUnit.OnProductionUnpaused(self)
        self:PlayUnitAmbientSound( 'ActiveLoop' )
    end,	
}


TerminideMassFabricationUnit = Class(TerminideStructureUnit) {
    OnStopBeingBuilt = function(self,builder,layer)
        TerminideStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        self:SetProductionActive(true)
    end,

    OnConsumptionActive = function(self)
        TerminideStructureUnit.OnConsumptionActive(self)
        self:SetMaintenanceConsumptionActive()
        self:SetProductionActive(true)
    end,

    OnConsumptionInActive = function(self)
        TerminideStructureUnit.OnConsumptionInActive(self)
        self:SetMaintenanceConsumptionInactive()
        self:SetProductionActive(false)
    end,
    
    OnPaused = function(self)
        TerminideStructureUnit.OnPaused(self)
	end,

	OnUnpaused = function(self)
	    TerminideStructureUnit.OnUnpaused(self)
	end,
	
    OnProductionPaused = function(self)
        TerminideStructureUnit.OnProductionPaused(self)
        self:StopUnitAmbientSound( 'ActiveLoop' )
    end,

    OnProductionUnpaused = function(self)
        TerminideStructureUnit.OnProductionUnpaused(self)
        self:PlayUnitAmbientSound( 'ActiveLoop' )
    end,
	
}


TerminideMassStorageUnit = Class(TerminideStructureUnit) {


    OnStopBeingBuilt = function(self,builder,layer)
        TerminideStructureUnit.OnStopBeingBuilt(self,builder,layer)
        local aiBrain = GetArmyBrain(self:GetArmy())
        local curMass = aiBrain:GetEconomyStoredRatio('MASS')
        if curMass > 0.11 then
        else
        end
    end,


    OnMassStorageStateChange = function(self, newState)
        if newState == 'EconLowMassStore' then
        elseif newState == 'EconMidMassStore' then
        elseif newState == 'EconFullMassStore' then
        end
    end,

}


TerminideRadarUnit = Class(TerminideStructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        TerminideStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,
    
    OnIntelDisabled = function(self)
        TerminideStructureUnit.OnIntelDisabled(self)
        self:DestroyIdleEffects()
    end,

    OnIntelEnabled = function(self)
        TerminideStructureUnit.OnIntelEnabled(self)
        self:CreateIdleEffects()
    end,
}



TerminideSporeSpewerStructureUnit = Class(TerminideStructureUnit) {

    OnStartBuild = function(self, unitbuilding, order)
        TerminideStructureUnit.OnStartBuild(self, unitbuilding, order)
        self:SetMaintenanceConsumptionInactive()
        self:DisableIntel('Jammer')
        self:DisableIntel('RadarStealthField')
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        TerminideStructureUnit.OnStopBuild(self, unitBeingBuilt)
        self:SetMaintenanceConsumptionActive()
        self:EnableIntel('Jammer')
        self:EnableIntel('RadarStealthField')
    end,

    OnFailedToBuild = function(self)
        TerminideStructureUnit.OnFailedToBuild(self)
        self:SetMaintenanceConsumptionActive()
        self:EnableIntel('Jammer')
        self:EnableIntel('RadarStealthField')
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TerminideStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,
    
    OnIntelEnabled = function(self)
        TerminideStructureUnit.OnIntelEnabled(self)
        if self.IntelEffects and not self.IntelFxOn then
			self.IntelEffectsBag = {}
			self.CreateTerrainTypeEffects( self, self.IntelEffects, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
			self.IntelFxOn = true
		end
    end,

    OnIntelDisabled = function(self)
        TerminideStructureUnit.OnIntelDisabled(self)
        EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
        self.IntelFxOn = false
    end,       
}


TerminideSonarUnit = Class(TerminideStructureUnit) {

    OnStopBeingBuilt = function(self,builder,layer)
        TerminideStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,
    
    CreateIdleEffects = function(self)
        TerminideStructureUnit.CreateIdleEffects(self)
        self.TimedSonarEffectsThread = self:ForkThread( self.TimedIdleSonarEffects )
    end,
    
    TimedIdleSonarEffects = function( self )
        local layer = self:GetCurrentLayer()
        local army = self:GetArmy()
        local pos = self:GetPosition()
        
        if self.TimedSonarTTIdleEffects then
            while not self:IsDead() do
                for kTypeGroup, vTypeGroup in self.TimedSonarTTIdleEffects do
                    local effects = self.GetTerrainTypeEffects( 'FXIdle', layer, pos, vTypeGroup.Type, nil )
                    
                    for kb, vBone in vTypeGroup.Bones do
                        for ke, vEffect in effects do
                            emit = CreateAttachedEmitter(self,vBone,army,vEffect):ScaleEmitter(vTypeGroup.Scale or 1)
                            if vTypeGroup.Offset then
                                emit:OffsetEmitter(vTypeGroup.Offset[1] or 0, vTypeGroup.Offset[2] or 0,vTypeGroup.Offset[3] or 0)
                            end
                        end
                    end                    
                end
                self:PlayUnitSound('Sonar')
                WaitSeconds( 6.0 )                
            end
        end
    end,
    
    DestroyIdleEffects = function(self)
        self.TimedSonarEffectsThread:Destroy()
        TerminideStructureUnit.DestroyIdleEffects(self)
    end,    
    
    OnIntelDisabled = function(self)
        TerminideStructureUnit.OnIntelDisabled(self)
    end,

    OnIntelEnabled = function(self)
        TerminideStructureUnit.OnIntelEnabled(self)
    end,
}


TerminideSeaFactoryUnit = Class(BugHole) {
    StartRocking = function(self)
    end,

    StopRocking = function(self)
    end,
	
	CreateBuildEffects = function( self, unitBeingBuilt, order )
        EffectUtil.CreateTerminideUnitBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )      
		EffectUtil.CreateTerminideConstructionUnitBuildingEffects2( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )		
    end,
}


TerminideWallStructureUnit = Class(TerminideStructureUnit) {
}

TerminideWalkingLandUnit = Class(MobileUnit) {

	FxDamage1 = { ModEffectTemplate.TerminideBlood },
    FxDamage2 = { ModEffectTemplate.TerminideBlood },
    FxDamage3 = { ModEffectTemplate.TerminideBlood },
	
	
	TerminideBloodExplosion = {
	ModPath .. 'terminide_unit_explosion_01_emit.bp',
	ModPath .. 'terminide_unit_explosion_02_emit.bp',
	ModPath .. 'terminide_unit_explosion_03_emit.bp',
	ModPath .. 'terminide_unit_explosion_04_emit.bp',
	ModPath .. 'terminide_unit_explosion_05_emit.bp',
	},

    WalkingAnim = nil,
    WalkingAnimRate = 1,
    IdleAnim = false,
    IdleAnimRate = 1,
    DeathAnim = false,
    DisabledBones = {},

    OnMotionHorzEventChange = function( self, new, old )
        MobileUnit.OnMotionHorzEventChange(self, new, old)
        
        if ( old == 'Stopped' ) then
            if (not self.Animator) then
                self.Animator = CreateAnimator(self, true)
            end
            local bpDisplay = self:GetBlueprint().Display
            if bpDisplay.AnimationWalk then
                self.Animator:PlayAnim(bpDisplay.AnimationWalk, true)
                self.Animator:SetRate(bpDisplay.AnimationWalkRate or 1)
            end
        elseif ( new == 'Stopped' ) then
            # only keep the animator around if we are dying and playing a death anim
            # or if we have an idle anim
            if(self.IdleAnim and not self:IsDead()) then
                self.Animator:PlayAnim(self.IdleAnim, true)
            elseif(not self.DeathAnim or not self:IsDead()) then
                self.Animator:Destroy()
                self.Animator = false
            end
        end
    end,
	
    PlayDamageEffect = function(self, fxTable, fxBag)
        local army = self:GetArmy()
        local effects = fxTable[Random(1,table.getn(fxTable))]
        if not effects then return end
        local totalBones = self:GetBoneCount()
        local bone = Random(1, totalBones) - 1
        local bpDE = self:GetBlueprint().Display.DamageEffects
        for k, v in effects do
            local fx
            if bpDE then
                local num = Random(1, table.getsize(bpDE))
                local bpFx = bpDE[num]
                fx = CreateAttachedEmitter(self, bpFx.Bone,army, v):ScaleEmitter(self.FxDamageScale):OffsetEmitter(bpFx.OffsetX or 0, bpFx.OffsetY or 0, bpFx.OffsetZ or 0)
            else
                fx = CreateAttachedEmitter(self, bone, army, v):ScaleEmitter(self.FxDamageScale)
            end
            table.insert(fxBag, fx)
        end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		local army = self:GetArmy()
		local bp = self:GetBlueprint()
						for e, effect in self.TerminideBloodExplosion do 
				CreateAttachedEmitter(self, 'Body', army, effect):ScaleEmitter(bp.BloodExplosionSize or 1)
				end
		local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
		CreateDecal(position, orientation, '/mods/Mechdivers/decals/acid_splash.dds', '', 'Albedo', bp.DecalSizeX or 1, bp.DecalSizeX or 1, 150, 55, self:GetArmy())
		if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
        end
						for e, effect in self.TerminideBloodExplosion do 
				CreateEmitterAtEntity(self, army, effect):ScaleEmitter(bp.BloodExplosionSize or 1)
				end
        self:DestroyAllDamageEffects()
        self:CreateWreckage( overkillRatio )
		
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
}

TerminideAnimatedAirUnit = Class(MobileUnit) {
	ShowUnitDestructionDebris = false,
	DestroyNoFallRandomChance = 0.5,

	FxDamage1 = { ModEffectTemplate.TerminideBlood },
    FxDamage2 = { ModEffectTemplate.TerminideBlood },
    FxDamage3 = { ModEffectTemplate.TerminideBlood },
	
	TerminideBloodExplosion = {
	ModPath .. 'terminide_unit_explosion_01_emit.bp',
	ModPath .. 'terminide_unit_explosion_02_emit.bp',
	ModPath .. 'terminide_unit_explosion_03_emit.bp',
	ModPath .. 'terminide_unit_explosion_04_emit.bp',
	ModPath .. 'terminide_unit_explosion_05_emit.bp',
	},

    WalkingAnim = nil,
    WalkingAnimRate = 1,
    IdleAnim = false,
    IdleAnimRate = 1,
    DeathAnim = false,
	
    OnStopBeingBuilt = function(self,builder,layer)
        MobileUnit.OnStopBeingBuilt(self,builder,layer)
		ForkThread(function()
        local bp = self:GetBlueprint()
        if bp.SizeSphere then
            self:SetCollisionShape(
                'Sphere', 
                bp.CollisionSphereOffsetX or 0, 
                bp.CollisionSphereOffsetY or 0, 
                bp.CollisionSphereOffsetZ or 0, 
                bp.SizeSphere
            )
        end  
		while not self.Dead do
		local RandomElevation = math.random(8,11)
		if not self.Dead then
		self:SetElevation(RandomElevation)
		end
		WaitSeconds(1)
		end
		end)		
    end,
	
    DisabledBones = {}, 

    OnMotionHorzEventChange = function( self, new, old )
        MobileUnit.OnMotionHorzEventChange(self, new, old)
        if ( old == 'Stopped' ) then
            if not self.Animator and not self.Dead then
                self.Animator = CreateAnimator(self, true)
            end
            local bpDisplay = self:GetBlueprint().Display
            if bpDisplay.AnimationWalk then
                self.Animator:PlayAnim(bpDisplay.AnimationWalk, true)
                self.Animator:SetRate(bpDisplay.AnimationWalkRate or 1)
            end
        elseif ( new == 'Stopped' ) then
            # only keep the animator around if we are dying and playing a death anim
            # or if we have an idle anim
            if self.IdleAnim and not self.Dead then
                self.Animator:PlayAnim(self.IdleAnim, true)
            elseif not self.DeathAnim or not self.Dead then
                self.Animator:Destroy()
                self.Animator = false
            end
        end
    end,
	
	PlayDamageEffect = function(self, fxTable, fxBag)
        local army = self:GetArmy()
        local effects = fxTable[Random(1,table.getn(fxTable))]
        if not effects then return end
        local totalBones = self:GetBoneCount()
        local bone = Random(1, totalBones) - 1
        local bpDE = self:GetBlueprint().Display.DamageEffects
        for k, v in effects do
            local fx
            if bpDE then
                local num = Random(1, table.getsize(bpDE))
                local bpFx = bpDE[num]
                fx = CreateAttachedEmitter(self, bpFx.Bone,army, v):ScaleEmitter(self.FxDamageScale):OffsetEmitter(bpFx.OffsetX or 0, bpFx.OffsetY or 0, bpFx.OffsetZ or 0)
            else
                fx = CreateAttachedEmitter(self, bone, army, v):ScaleEmitter(self.FxDamageScale)
            end
            table.insert(fxBag, fx)
        end
    end,
	
	
    OnImpact = function(self, with, other)
        # Damage the area we have impacted with.
        local bp = self:GetBlueprint()
        local i = 1
        local numWeapons = table.getn(bp.Weapon)

        for i, numWeapons in bp.Weapon do
            if(bp.Weapon[i].Label == 'DeathImpact') then
                DamageArea(self, self:GetPosition(), bp.Weapon[i].DamageRadius, bp.Weapon[i].Damage, bp.Weapon[i].DamageType, bp.Weapon[i].DamageFriendly)
                break
            end
        end

        if with == 'Water' then
            self:PlayUnitSound('AirUnitWaterImpact')
            EffectUtil.CreateEffects( self, self:GetArmy(), EffectTemplate.DefaultProjectileWaterImpact )
            self:Destroy()
        else
            # This is a bit of safety to keep us from calling the death thread twice in case we bounce twice quickly
            if not self.DeathBounce then
                self:ForkThread(self.DeathThread, self.OverKillRatio )
                self.DeathBounce = 1
            end
        end
    end,
	
	CreateUnitAirDestructionEffects = function( self, scale )
	local army = self:GetArmy()
	local bp = self:GetBlueprint()
						for e, effect in self.TerminideBloodExplosion do 
				CreateAttachedEmitter(self, 'Bone' or 'Sack', army, effect):ScaleEmitter(bp.BloodExplosionSize or 1)
				end
						local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
		CreateDecal(position, orientation, '/mods/Mechdivers/decals/acid_splash.dds', '', 'Albedo', bp.DecalSizeX or 1, bp.DecalSizeX or 1, 150, 55, self:GetArmy())

    end,
	
    OnKilled = function(self, instigator, type, overkillRatio)
		local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

		if version < 3652 then
        local bp = self:GetBlueprint()
        if (self:GetCurrentLayer() == 'Air' and Random() < self.DestroyNoFallRandomChance) then
            
            self.CreateUnitAirDestructionEffects( self, 1.0 )
            self:DestroyTopSpeedEffects()
            self:DestroyBeamExhaust()
            self.OverKillRatio = overkillRatio
            self:PlayUnitSound('Killed')
            self:DoUnitCallbacks('OnKilled')
            self:OnKilledVO()
            if instigator and IsUnit(instigator) then
                instigator:OnKilledUnit(self)
            end
        else
            self.DeathBounce = 1
            if instigator and IsUnit(instigator) then
                instigator:OnKilledUnit(self)
            end
            MobileUnit.OnKilled(self, instigator, type, overkillRatio)
        end
		else
		if self:GetFractionComplete() == 1 and
            (self.Layer == 'Air' or EntityCategoryContains(categories.TRANSPORTATION, self))
        then
            local army = self.Army

            self.Dead = true
            -- We want to skip all the visual/audio/shield bounce/death weapon stuff if we're in internal storage
            if type ~= "TransportDamage" then
                self:CreateUnitAirDestructionEffects(1.0)
                self:DestroyTopSpeedEffects()
                self:DestroyBeamExhaust()
                self.OverKillRatio = overkillRatio
                self:PlayUnitSound('Killed')
                self:DoUnitCallbacks('OnKilled')
                self:DisableShield()

                -- The unit falling is a death animation, so it needs collision turned off
                self.DisallowCollisions = true

                -- Store our death weapon's damage on the unit so it can be edited remotely by the shield bouncer projectile
                local bp = self.Blueprint
                for i, _ in bp.Weapon do
                    if bp.Weapon[i].Label == 'DeathImpact' then
                        self.deathWep = bp.Weapon[i]
                        break
                    end
                end

                if not self.deathWep or self.deathWep == {} then
                    WARN(string.format('(%s) has no death weapon or the death weapon has an incorrect label!',
                        tostring(bp.BlueprintId)))
                else
                    self.DeathCrashDamage = self.deathWep.Damage
                end

                -- Create a projectile we'll use to interact with Shields
                local proj = self:CreateProjectileAtBone('/projectiles/ShieldCollider/ShieldCollider_proj.bp', 0) --[[@as ShiledCollider]]
                self.colliderProj = proj
                proj:Start(self, 0)
                self.Trash:Add(proj)

                self:DisableUnitIntel('Killed')

                if not self.Blueprint.Air.EnableVisionWhileFalling then
                    self:DisableIntel('Vision') -- Disable vision seperately, it's not handled in DisableUnitIntel
                else
                    -- Create a vision entity so vision shading is visible

                    local x, y, z = self:GetPositionXYZ(0)
                    ---@type VisionMarkerOpti
                    local vizEnt = self.Trash:Add(VisionMarkerOpti({ Army = army }))
                    vizEnt:UpdateIntel(army, self:GetIntelRadius("Vision"), "Vision", true)
                    vizEnt:UpdatePosition(x, z)
                    vizEnt:AttachTo(self, 0)
                end
            end

            self:VeterancyDispersal()

            -- awareness for traitor game mode and game statistics
            ArmyBrains[army].LastUnitKilledBy = (instigator or self).Army
            ArmyBrains[army]:AddUnitStat(self.UnitId, "lost", 1)

            -- awareness of instigator that it killed a unit, but it can also be a projectile or nil
            if instigator and instigator.OnKilledUnit then
                instigator:OnKilledUnit(self)
            end

            self.Brain:OnUnitKilled(self, instigator, type, overkillRatio)

            -- If we're in internal storage, we're done, destroy the unit to avoid OnImpact errors
            if type == "TransportDamage" then
                self:Destroy()
            end
        else
            MobileUnitOnKilled(self, instigator, type, overkillRatio)
        end
		end
    end,
	
	DeathThread = function( self, overkillRatio , instigator)  
		local army = self:GetArmy()
		local bp = self:GetBlueprint()

		local position = self:GetPosition()
		local orientation = RandomFloat(0,2*math.pi)
		CreateDecal(position, orientation, '/mods/Mechdivers/decals/acid_splash.dds', '', 'Albedo', bp.DecalSizeX or 1, bp.DecalSizeX or 1, 150, 55, self:GetArmy())
						for e, effect in self.TerminideBloodExplosion do 
				CreateEmitterAtEntity(self, army, effect):ScaleEmitter(bp.BloodExplosionSize or 1)
				end
        self:DestroyAllDamageEffects()
        self:CreateWreckage( overkillRatio )
		
		
        self:PlayUnitSound('Destroyed')
        self:Destroy()
    end,
	
}

TerminideSeaUnit = Class(MobileUnit) {
	FxDamage1 = { ModEffectTemplate.TerminideBlood },
    FxDamage2 = { ModEffectTemplate.TerminideBlood },
    FxDamage3 = { ModEffectTemplate.TerminideBlood },
	
	TerminideBloodExplosion = {
	ModPath .. 'terminide_unit_explosion_01_emit.bp',
	ModPath .. 'terminide_unit_explosion_02_emit.bp',
	ModPath .. 'terminide_unit_explosion_03_emit.bp',
	ModPath .. 'terminide_unit_explosion_04_emit.bp',
	ModPath .. 'terminide_unit_explosion_05_emit.bp',
	},

    DeathThreadDestructionWaitTime = 5,
    ShowUnitDestructionDebris = false,
    PlayEndAnimDestructionEffects = false,


    OnStopBeingBuilt = function(self,builder,layer)
        MobileUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,

    # by default, just destroy us when we are killed.
    OnKilled = function(self, instigator, type, overkillRatio)
        local layer = self:GetCurrentLayer()
        self:DestroyIdleEffects()
        if(layer == 'Water' or layer == 'Seabed' or layer == 'Sub')then
            self.SinkExplosionThread = self:ForkThread(self.ExplosionThread)
            self.SinkThread = self:ForkThread(self.SinkingThread)
        end
        MobileUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

    ExplosionThread = function(self)
        local maxcount = Util.GetRandomInt(6,20) # max number of above surface explosions. timed to animation
        local i = maxcount # initializing the above surface counter
        local d = 0 # delay offset after surface explosions cease
        local sx, sy, sz = self:GetUnitSizes()
        local vol = sx * sy * sz
        local army = self:GetArmy()
        local numBones = self:GetBoneCount() - 1
		local bp = self:GetBlueprint()

        while true do
            if i > 0 then
                local rx, ry, rz = self:GetRandomOffset(1)
                local rs = Random(vol/2, vol*2) / (vol*2)
                for e, effect in self.TerminideBloodExplosion do 
				CreateEmitterAtEntity(self, army, effect):ScaleEmitter(bp.BloodExplosionSize or 2)
				end
            else
                d = d + 1 # if submerged, increase delay offset
                self:DestroyAllDamageEffects()
            end
            i = i - 1

            local rx, ry, rz = self:GetRandomOffset(0.25)
            local rs = Random(vol/2, vol*2) / (vol*2)
            local randBone = Util.GetRandomInt( 0, numBones)
            

            local rd = Util.GetRandomFloat( 0.4, 1.0)
            WaitSeconds(rd)
        end
    end,

    SinkingThread = function(self)
        local i = 8 # initializing the above surface counter
        local sx, sy, sz = self:GetUnitSizes()
        local vol = sx * sy * sz
        local army = self:GetArmy()

        while true do
            if i > 0 then
                local rx, ry, rz = self:GetRandomOffset(1)
                local rs = Random(vol/2, vol*2) / (vol*2) 
                CreateAttachedEmitter(self,-1,army,'/effects/emitters/destruction_water_sinking_ripples_01_emit.bp'):OffsetEmitter(rx, 0, rz):ScaleEmitter(rs)

                local rx, ry, rz = self:GetRandomOffset(1)
                CreateAttachedEmitter(self,self.LeftFrontWakeBone,army, '/effects/emitters/destruction_water_sinking_wash_01_emit.bp'):OffsetEmitter(rx, 0, rz):ScaleEmitter(rs)

                local rx, ry, rz = self:GetRandomOffset(1)
                CreateAttachedEmitter(self,self.RightFrontWakeBone,army, '/effects/emitters/destruction_water_sinking_wash_01_emit.bp'):OffsetEmitter(rx, 0, rz):ScaleEmitter(rs)
            end

            local rx, ry, rz = self:GetRandomOffset(1)
            local rs = Random(vol/2, vol*2) / (vol*2)
            CreateAttachedEmitter(self,-1,army,'/effects/emitters/destruction_underwater_sinking_wash_01_emit.bp'):OffsetEmitter(rx, 0, rz):ScaleEmitter(rs)

            i = i - 1
            WaitSeconds(1)
        end
    end,
	
	PlayDamageEffect = function(self, fxTable, fxBag)
        local army = self:GetArmy()
        local effects = fxTable[Random(1,table.getn(fxTable))]
        if not effects then return end
        local totalBones = self:GetBoneCount()
        local bone = Random(1, totalBones) - 1
        local bpDE = self:GetBlueprint().Display.DamageEffects
        for k, v in effects do
            local fx
            if bpDE then
                local num = Random(1, table.getsize(bpDE))
                local bpFx = bpDE[num]
                fx = CreateAttachedEmitter(self, bpFx.Bone,army, v):ScaleEmitter(self.FxDamageScale):OffsetEmitter(bpFx.OffsetX or 0, bpFx.OffsetY or 0, bpFx.OffsetZ or 0)
            else
                fx = CreateAttachedEmitter(self, bone, army, v):ScaleEmitter(self.FxDamageScale)
            end
            table.insert(fxBag, fx)
        end
    end,
}
