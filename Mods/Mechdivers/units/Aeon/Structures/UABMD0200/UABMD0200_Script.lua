#****************************************************************************
#**
#**  File     :  /cdimage/units/UAB2101/UAB2101_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  Aeon Light Laser Tower Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local AStructureUnit = import('/lua/defaultunits.lua').FactoryUnit

UABMD0200 = Class(AStructureUnit) {

	OnStopBeingBuilt = function(self,builder,layer)
        AStructureUnit.OnStopBeingBuilt(self,builder,layer)
		if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationBuild, false):SetRate(0)
		Spinner1 = CreateRotator(self, 'Gate_Spinner', 'z', nil, 0, 60, 360):SetTargetSpeed(0)
        Spinner2 = CreateRotator(self, 'Gate_Spinner2', 'z', nil, 0, 60, -360):SetTargetSpeed(0)
		BuildEffectMesh = '/mods/Mechdivers/Decorations/AeonGateEffect_mesh'
		BuildEffectMesh4 = '/mods/Mechdivers/Decorations/AeonGateEffect2_mesh'
		self.BuildEffect = import('/lua/sim/Entity.lua').Entity()
		self.BuildEffect:AttachBoneTo( -2, self, 'Gate_Effect' )
		self.BuildEffect:SetMesh(BuildEffectMesh)
		self.BuildEffect:SetDrawScale(0.4)
		self.BuildEffect:SetVizToAllies('Never')
		self.BuildEffect:SetVizToNeutrals('Never')
		self.BuildEffect:SetVizToEnemies('Never')
		BuildEffectMesh2 = '/mods/Mechdivers/Decorations/AeonGateEffectDisk_mesh'
		self.BuildEffect2 = import('/lua/sim/Entity.lua').Entity()
		self.BuildEffect2:AttachBoneTo( -2, self, 'Gate_Effect1' )
		self.BuildEffect2:SetMesh(BuildEffectMesh2)
		self.BuildEffect2:SetDrawScale(0.5)
		self.BuildEffect2:SetVizToAllies('Never')
		self.BuildEffect2:SetVizToNeutrals('Never')
		self.BuildEffect2:SetVizToEnemies('Never')
		BuildEffectMesh3 = '/mods/Mechdivers/Decorations/AeonGateEffectDisk2_mesh'
		self.BuildEffect3 = import('/lua/sim/Entity.lua').Entity()
		self.BuildEffect3:AttachBoneTo( -2, self, 'Gate_Effect' )
		self.BuildEffect3:SetMesh(BuildEffectMesh3)
		self.BuildEffect3:SetDrawScale(1.9)
		self.BuildEffect3:SetVizToAllies('Never')
		self.BuildEffect3:SetVizToNeutrals('Never')
		self.BuildEffect3:SetVizToEnemies('Never')
		self.BuildEffect4 = import('/lua/sim/Entity.lua').Entity()
		self.BuildEffect4:AttachBoneTo( -2, self, 'Gate_Effect' )
		self.BuildEffect4:SetMesh(BuildEffectMesh4)
		self.BuildEffect4:SetDrawScale(0.4)
		self.BuildEffect4:SetVizToAllies('Never')
		self.BuildEffect4:SetVizToNeutrals('Never')
		self.BuildEffect4:SetVizToEnemies('Never')
	end,

    OnStartBuild = function(self, unitBeingBuilt, order )
		unitBeingBuilt:HideBone(0,true)
        self:ChangeBlinkingLights('Yellow')
        AStructureUnit.OnStartBuild(self, unitBeingBuilt, order )
        self.BuildingUnit = true
        if order != 'Upgrade' then
            ChangeState(self, self.BuildingState)
            self.BuildingUnit = false
        end
        self.FactoryBuildFailed = false
		self.AnimationManipulator:SetRate(1)
		Spinner1:SetTargetSpeed(180)
		Spinner2:SetTargetSpeed(-180)
		self.BuildEffect:SetVizToAllies('Intel')
		self.BuildEffect:SetVizToNeutrals('Intel')
		self.BuildEffect:SetVizToEnemies('Intel')
		self.BuildEffect2:SetVizToAllies('Intel')
		self.BuildEffect2:SetVizToNeutrals('Intel')
		self.BuildEffect2:SetVizToEnemies('Intel')
		self.BuildEffect3:SetVizToAllies('Intel')
		self.BuildEffect3:SetVizToNeutrals('Intel')
		self.BuildEffect3:SetVizToEnemies('Intel')
		self.BuildEffect4:SetVizToAllies('Intel')
		self.BuildEffect4:SetVizToNeutrals('Intel')
		self.BuildEffect4:SetVizToEnemies('Intel')
    end,

    OnStopBuild = function(self, unitBeingBuilt, order )
        AStructureUnit.OnStopBuild(self, unitBeingBuilt, order )
        
        if not self.FactoryBuildFailed then
            if not EntityCategoryContains(categories.AIR, unitBeingBuilt) then
                self:RollOffUnit()
            end
            self:StopBuildFx()
            self:ForkThread(self.FinishBuildThread, unitBeingBuilt, order )
        end
        self.BuildingUnit = false
		self.AnimationManipulator:SetRate(-1)
		Spinner1:SetTargetSpeed(0)
		Spinner2:SetTargetSpeed(0)
		self.BuildEffect:SetVizToAllies('Never')
		self.BuildEffect:SetVizToNeutrals('Never')
		self.BuildEffect:SetVizToEnemies('Never')
		self.BuildEffect2:SetVizToAllies('Never')
		self.BuildEffect2:SetVizToNeutrals('Never')
		self.BuildEffect2:SetVizToEnemies('Never')
		self.BuildEffect3:SetVizToAllies('Never')
		self.BuildEffect3:SetVizToNeutrals('Never')
		self.BuildEffect3:SetVizToEnemies('Never')
		self.BuildEffect4:SetVizToAllies('Never')
		self.BuildEffect4:SetVizToNeutrals('Never')
		self.BuildEffect4:SetVizToEnemies('Never')
    end,

    FinishBuildThread = function(self, unitBeingBuilt, order )
		CreateLightParticle( self, 'AttachPoint', self:GetArmy(), 6, 6, 'glow_03', 'ramp_white_01' ) 
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
		self.AnimationManipulator:SetRate(-1)
		Spinner1:SetTargetSpeed(0)
		Spinner2:SetTargetSpeed(0)
		self.BuildEffect:SetVizToAllies('Never')
		self.BuildEffect:SetVizToNeutrals('Never')
		self.BuildEffect:SetVizToEnemies('Never')
		self.BuildEffect2:SetVizToAllies('Never')
		self.BuildEffect2:SetVizToNeutrals('Never')
		self.BuildEffect2:SetVizToEnemies('Never')
		self.BuildEffect3:SetVizToAllies('Never')
		self.BuildEffect3:SetVizToNeutrals('Never')
		self.BuildEffect3:SetVizToEnemies('Never')
		self.BuildEffect4:SetVizToAllies('Never')
		self.BuildEffect4:SetVizToNeutrals('Never')
		self.BuildEffect4:SetVizToEnemies('Never')
        local bp = self:GetBlueprint()
        local bpAnim = bp.Display.AnimationFinishBuildLand
        if bpAnim and EntityCategoryContains(categories.LAND, unitBeingBuilt) then
            self.RollOffAnim = CreateAnimator(self):PlayAnim(bpAnim)
            self.Trash:Add(self.RollOffAnim)
            WaitTicks(1)
            WaitFor(self.RollOffAnim)
        end
        if unitBeingBuilt and not unitBeingBuilt:IsDead() then
			unitBeingBuilt:ShowBone(0,true)
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
        AStructureUnit.OnFailedToBuild(self)
        self:DestroyBuildRotator()
        self:StopBuildFx()
		self.AnimationManipulator:SetRate(-1)
		Spinner1:SetTargetSpeed(0)
		Spinner2:SetTargetSpeed(0)
		self.BuildEffect:SetVizToAllies('Never')
		self.BuildEffect:SetVizToNeutrals('Never')
		self.BuildEffect:SetVizToEnemies('Never')
		self.BuildEffect2:SetVizToAllies('Never')
		self.BuildEffect2:SetVizToNeutrals('Never')
		self.BuildEffect2:SetVizToEnemies('Never')
		self.BuildEffect3:SetVizToAllies('Never')
		self.BuildEffect3:SetVizToNeutrals('Never')
		self.BuildEffect3:SetVizToEnemies('Never')
		self.BuildEffect4:SetVizToAllies('Never')
		self.BuildEffect4:SetVizToNeutrals('Never')
		self.BuildEffect4:SetVizToEnemies('Never')
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
        AStructureUnit.OnKilled(self, instigator, type, overkillRatio)
        if self.UnitBeingBuilt then
            self.UnitBeingBuilt:Destroy()
        end
    end,

}

TypeClass = UABMD0200