local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then
if DiskGetFileInfo('/lua/AI/CustomAIs_v2/ExtrasAI.lua') then
if import('/lua/AI/CustomAIs_v2/ExtrasAI.lua').AI.Name == 'AI Patch LOUD' then
LOG('CSK Gameversion Analyzer: LOUD Detected')
LOG('CSK: Load modified LOUD Gamemain.lua')

---  /lua/sim/Weapon.lua
---  Summary  : The base weapon class for all weapons in the game.

local LOUDENTITY = EntityCategoryContains
local ParseEntityCategory = ParseEntityCategory

local LOUDCOPY = table.copy
local LOUDFLOOR = math.floor
local LOUDINSERT = table.insert
local LOUDPARSE = ParseEntityCategory
local LOUDREMOVE = table.remove

local LOUDCREATEPROJECTILE = moho.weapon_methods.CreateProjectile

local ForkThread = ForkThread
local ForkTo = ForkThread

local TrashBag = TrashBag
local TrashAdd = TrashBag.Add
local TrashDestroy = TrashBag.Destroy

local WaitSeconds = WaitSeconds
local WaitTicks = coroutine.yield

local BeenDestroyed = moho.entity_methods.BeenDestroyed
local GetBlueprint = moho.weapon_methods.GetBlueprint
local PlaySound = moho.weapon_methods.PlaySound

local SetBoneEnabled = moho.AnimationManipulator.SetBoneEnabled
local SetEnabled = moho.AimManipulator.SetEnabled
local SetFiringArc = moho.AimManipulator.SetFiringArc

local SetFireTargetLayerCaps = moho.weapon_methods.SetFireTargetLayerCaps
local SetResetPoseTime = moho.AimManipulator.SetResetPoseTime
local SetTargetingPriorities = moho.weapon_methods.SetTargetingPriorities

local PassDamageData = import('/lua/sim/Projectile.lua').Projectile.PassDamageData

local MISSILEOPTION = tonumber(ScenarioInfo.Options.MissileOption)
local STRUCTURE = categories.STRUCTURE

--LOG("*AI DEBUG Weapon Methods are "..repr(moho.weapon_methods))

Weapon = Class(moho.weapon_methods) {

    __init = function(self, unit)

        -- this captures the parent unit of the weapon
        self.unit = unit
        
    end,

    ForkThread = function(self, fn, ...)
    
        local thread = ForkThread(fn, self, unpack(arg))
        
		TrashAdd( self.Trash, thread )
        
        return thread
    end,

    OnCreate = function(self)
        
        local LOUDCOPY = LOUDCOPY
        local LOUDFLOOR = LOUDFLOOR
        local WaitTicks = WaitTicks

		-- use the trash on the parent unit
		--self.Trash = self.unit.Trash
        self.Trash = TrashBag()

        -- store the blueprint of the weapon 
        self.bp = GetBlueprint(self)
		
        local bp = self.bp

		if ScenarioInfo.WeaponDialog then
			LOG("*AI DEBUG Weapon OnCreate for "..repr(__blueprints[self.unit.BlueprintID].Description).." "..self.unit.EntityID.." -- "..repr(self.bp.Label) )
		end

        -- brought this function local since it's the only place it gets called
        if bp.Turreted == true then
		
            local CreateAimController = CreateAimController
            local SetPrecedence = moho.manipulator_methods.SetPrecedence
            
            local yawBone = bp.TurretBoneYaw
            local pitchBone = bp.TurretBonePitch
            local muzzleBone = bp.TurretBoneMuzzle
            local precedence = bp.AimControlPrecedence or 10
            local pitchBone2
            local muzzleBone2
		
            if bp.TurretBoneDualPitch and bp.TurretBoneDualPitch != '' then
                pitchBone2 = bp.TurretBoneDualPitch
            end
		
            if bp.TurretBoneDualMuzzle and bp.TurretBoneDualMuzzle != '' then
                muzzleBone2 = bp.TurretBoneDualMuzzle
            end

            if yawBone and pitchBone and muzzleBone then
		
                if bp.TurretDualManipulators then
			
                    if not bp.TurretBoneAimYaw then
                        self.AimControl = CreateAimController(self, 'Torso', yawBone)
                    else
                        self.AimControl = CreateAimController(self, 'Torso', bp.TurretBoneAimYaw)
                    end
				
                    self.AimRight = CreateAimController(self, 'Right', pitchBone, pitchBone, muzzleBone)
                    self.AimLeft = CreateAimController(self, 'Left', pitchBone2, pitchBone2, muzzleBone2)
				
                    SetPrecedence( self.AimControl, precedence )
                    SetPrecedence( self.AimRight, precedence)
                    SetPrecedence( self.AimLeft, precedence)
				
                    if LOUDENTITY(STRUCTURE, self.unit) then
                        SetResetPoseTime( self.AimControl, 9999999 )
                    end
				
                    self:SetFireControl('Right')
                    
                    TrashAdd( self.Trash, self.AimControl )
                    TrashAdd( self.Trash, self.AimRight )
                    TrashAdd( self.Trash, self.AimLeft )
				
                else
                
                    if not bp.TurretBoneAimYaw then
                        self.AimControl = CreateAimController(self, 'Default', yawBone, pitchBone, muzzleBone)
                    else
                        self.AimControl = CreateAimController(self, 'Default', bp.TurretBoneAimYaw, pitchBone, muzzleBone)
                    end
				
                    if LOUDENTITY(STRUCTURE, self.unit) then
                        SetResetPoseTime( self.AimControl,9999999 )
                    end
				
                    TrashAdd( self.unit.Trash, self.AimControl )
                    
                    SetPrecedence( self.AimControl, precedence)
				
                    if bp.RackSlavedToTurret and bp.RackBones[1] then
                    
                        for k, v in bp.RackBones do

                            if v.RackBone != pitchBone then
                            
                                local slaver = CreateSlaver(self.unit, v.RackBone, pitchBone)
                                
                                SetPrecedence( slaver, precedence-1 )
                                
                                TrashAdd( self.Trash, slaver )
                            end
                        end
                    end
                end

            end

            local numbersexist = true
		
            local turretyawmin, turretyawmax, turretyawspeed
            local turretpitchmin, turretpitchmax, turretpitchspeed
        
            if bp.TurretYaw and bp.TurretYawRange then
                turretyawmin = bp.TurretYaw - bp.TurretYawRange
                turretyawmax = bp.TurretYaw + bp.TurretYawRange
            else
                numbersexist = false
            end
        
            if bp.TurretYawSpeed then
                turretyawspeed = bp.TurretYawSpeed
            else
                numbersexist = false
            end
        
            if bp.TurretPitch and bp.TurretPitchRange then
                turretpitchmin = bp.TurretPitch - bp.TurretPitchRange
                turretpitchmax = bp.TurretPitch + bp.TurretPitchRange
            else
                numbersexist = false
            end
        
            if bp.TurretPitchSpeed then
                turretpitchspeed = bp.TurretPitchSpeed
            else
                numbersexist = false
            end
        
            if numbersexist then
		
                SetFiringArc( self.AimControl, turretyawmin, turretyawmax, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
                
                if self.AimRight then
                    SetFiringArc( self.AimRight, turretyawmin/12, turretyawmax/12, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
                end
			
                if self.AimLeft then
                    SetFiringArc( self.AimLeft, turretyawmin/12, turretyawmax/12, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
                end
            end
        end

		-- store weapon buffs on the weapon itself so 
		-- we can bypass GetBlueprint every time the weapon fires
		if bp.Buffs then
			self.Buffs = LOUDCOPY(bp.Buffs)
		end

		-- if a weapon fires a round with these parameters 
		-- flag it so we can avoid GetBlueprint when it is NOT
        if bp.NukeOuterRingDamage and bp.NukeOuterRingRadius and bp.NukeOuterRingTicks and bp.NukeOuterRingTotalTime and
            bp.NukeInnerRingDamage and bp.NukeInnerRingRadius and bp.NukeInnerRingTicks and bp.NukeInnerRingTotalTime then
			
			self.NukeWeapon = true
		end

        self:SetValidTargetsForCurrentLayer( self.unit.CacheLayer, bp)
		
		-- next 3 conditions are for adv missile track and retarget
        if bp.advancedTracking then
		
        	self.advancedTracking = bp.advancedTracking
 		
			-- calc a lifetime if one is not provided
			if bp.ProjectileLifetime then
				self.ProjectileLifetime = bp.ProjectileLifetime
			else
				self.ProjectileLifetime = (bp.MaxRadius / bp.MuzzleVelocity) * 1.15
			end
		
			-- calc tracking radius if not provided
            -- if not set, the default is one - that's no good
            -- we'll force it to the MaxRadius
			if bp.TrackingRadius > 1 then
				self.TrackingRadius = bp.TrackingRadius
			else
				self.TrackingRadius = bp.MaxRadius
			end
            
            if bp.TargetRestrictOnlyAllow then
                self.TargetRestrictOnlyAllow = bp.TargetRestrictOnlyAllow
            end
		
		end
		
        self:SetWeaponPriorities(bp.TargetPriorities)
		
        local initStore = MISSILEOPTION or bp.InitialProjectileStorage or 0
		
        if initStore > 0 then
		
			-- if the weapon cant hold that amount - set it to its max amount
            if bp.MaxProjectileStorage and bp.MaxProjectileStorage < initStore then
                initStore = bp.MaxProjectileStorage
            end
			
            local nuke = false
			
            if bp.NukeWeapon then
                nuke = true
            end

            local function AmmoThread(amount)
	
                if not BeenDestroyed(self.unit) then
		
                    if nuke then
                        self.unit:GiveNukeSiloAmmo(amount)
                    else
                        self.unit:GiveTacticalSiloAmmo(amount)
                    end
                end

                WaitTicks(2)

            end
			
            ForkThread( AmmoThread, LOUDFLOOR(initStore))
        end
		
		self:SetDamageTable(bp)

    end,

    OnDestroy = function(self)
		-- this only triggers when the unit itself is destroyed
		-- but I don't see it all the time
		--if ScenarioInfo.WeaponDialog then
			--LOG("*AI DEBUG Weapon OnDestroy ")
		--end

        TrashDestroy(self.Trash)
    end,

    AimManipulatorSetEnabled = function(self, enabled)
 	
        if self.AimControl then
       
            if self.WeaponAimEnabled != enabled then
   
                if ScenarioInfo.WeaponDialog or ScenarioInfo.WeaponStateDialog then
                    LOG("*AI DEBUG Weapon "..repr(self.bp.Label).." Aim Control is "..repr(self.WeaponAimEnabled).." at "..GetGameTick().." setting to "..repr(enabled) )
                end
                
                if self.unit.Dead then return end

                SetEnabled( self.AimControl, enabled )

                self.WeaponAimEnabled = enabled
                
            end
        end
		
    end,

    GetAimManipulator = function(self)
        return self.AimControl
    end,

    SetTurretYawSpeed = function(self, speed)
	
        local turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        local turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax()
        local turretpitchspeed = self:GetTurretPitchSpeed()
		
        if self.AimControl then
            SetFiringArc( self.AimControl, turretyawmin, turretyawmax, speed, turretpitchmin, turretpitchmax, turretpitchspeed)
        end
    end,

    SetTurretPitchSpeed = function(self, speed)
	
        local turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        local turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax()
        local turretpitchspeed = self:GetTurretYawSpeed()
		
        if self.AimControl then
            SetFiringArc( self.AimControl, turretyawmin, turretyawmax, turretyawspeed, turretpitchmin, turretpitchmax, speed)
        end
    end,
	
	SetTurretPitch = function(self, value, value2)
        local turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        local turretpitchmin, turretpitchmax = value, value2
        local turretyawspeed = self:GetTurretYawSpeed()
		local turretpitchspeed = self:GetTurretPitchSpeed()
        if self.AimControl then
            self.AimControl:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, value, value2, turretpitchspeed)
        end
    end,

    GetTurretYawMinMax = function(self,blueprint)
        return self.bp.TurretYaw - self.bp.TurretYawRange, self.bp.TurretYaw + self.bp.TurretYawRange
    end,

    GetTurretYawSpeed = function(self,blueprint)
        return self.bp.TurretYawSpeed
    end,

    GetTurretPitchMinMax = function(self,blueprint)
        return self.bp.TurretPitch - self.bp.TurretPitchRange, self.bp.TurretPitch + self.bp.TurretPitchRange
    end,

    GetTurretPitchSpeed = function(self,blueprint)
        return self.bp.TurretPitchSpeed
    end,

    Fire = function(self)
    
    end,
    
    OnFire = function(self)
	
		if ScenarioInfo.WeaponDialog then
			LOG("*AI DEBUG Weapon OnFire for "..repr(__blueprints[self.unit.BlueprintID].Description).." "..repr(self.bp.Label).." on tick "..GetGameTick() )
		end

		if self.Buffs then
			self:DoOnFireBuffs(self.Buffs)
		end
    end,

	OnWeaponFired = function(self, target)
	
		if ScenarioInfo.WeaponDialog then
			LOG("*AI DEBUG Weapon OnWeaponFired for "..repr(__blueprints[self.unit.BlueprintID].Description).." "..repr(self.bp.Label).." on tick "..GetGameTick() )
		end

	end,

    OnDisableWeapon = function(self)
	
        if ScenarioInfo.WeaponDialog then
            LOG("*AI DEBUG Weapon OnDisableWeapon for "..repr(__blueprints[self.unit.BlueprintID].Description).." "..repr(self.bp.Label).." on tick "..GetGameTick() )
        end

    end,
    
    OnEnableWeapon = function(self)
	
        if ScenarioInfo.WeaponDialog then
            LOG("*AI DEBUG Weapon OnEnableWeapon for "..repr(__blueprints[self.unit.BlueprintID].Description).." "..repr(self.bp.Label).." on tick "..GetGameTick() )
        end

        self:SetValidTargetsForCurrentLayer(self.unit.CacheLayer, self.bp)
    end,

    OnGotTarget = function(self)

        if self.WeaponIsEnabled then
	
            if ScenarioInfo.WeaponDialog then
                LOG("*AI DEBUG Weapon OnGotTarget for "..repr(__blueprints[self.unit.BlueprintID].Description).." "..repr(self.bp.Label).." on tick "..GetGameTick() )
            end
    
            if self.DisabledFiringBones and self.unit.Animator then
		
                for _, value in self.DisabledFiringBones do
                    SetBoneEnabled( self.unit.Animator, value, false )
                end
            end

            self.HadTarget = true
        
        end
		
    end,

    OnLostTarget = function(self)
   
        if self.HadTarget then
	
            if ScenarioInfo.WeaponDialog then
                LOG("*AI DEBUG Weapon OnLostTarget for "..repr(__blueprints[self.unit.BlueprintID].Description).." "..repr(self.bp.Label).." on tick "..GetGameTick() )
            end
 
            if self.DisabledFiringBones and self.unit.Animator then
		
                for _, value in self.DisabledFiringBones do
                    SetBoneEnabled( self.unit.Animator, value, true )
                end
            end

        end
        
        self.HadTarget = false

    end,

    OnStartTracking = function(self, label)
    
        if self.WeaponIsEnabled then
	
            if ScenarioInfo.WeaponDialog then
                LOG("*AI DEBUG Weapon OnStartTracking for "..repr(self.bp.Label).." on tick "..GetGameTick() )
            end
 
            self:PlayWeaponSound('BarrelStart')
        end
    end,

    OnStopTracking = function(self, label)
	
        if self.WeaponIsEnabled then
	
            if ScenarioInfo.WeaponDialog then
                LOG("*AI DEBUG Weapon OnStopTracking for "..repr(self.bp.Label).." on tick "..GetGameTick() )
            end

            self:PlayWeaponSound('BarrelStop')
		
            if LOUDENTITY(STRUCTURE, self.unit) then
                SetResetPoseTime( self.AimControl, 9999999 )
            else
                SetResetPoseTime( self.AimControl, 3 )
            end
        end
    end,

    PlayWeaponSound = function(self, sound)

        if not self.bp.Audio[sound] then return end
		
        PlaySound( self, self.bp.Audio[sound] )
		
    end,

	-- as opposed to creating this data every time the weapon is fired
	-- lets create it once, store it, and eliminate all the function calls
	-- to GetDamageTable -- imagine that
    SetDamageTable = function(self, weaponBlueprint)
	
		-- at minimum the weapons damage table will have 
			--	Damage Amount
			--	Damage Type	                (used for armor type calculations - usually 'Normal')
			--	Damage Radius               (only for AOE weapons)

			--	Collide & Damage Friendly   (for those weapons which do that)
			--	Damage Over Time & Pulses   (for those weapons which do that)

			--	Artillery Shield Blocks     

			--	advancedTracking	        (used by tracking projectiles)
			--		also add ProjectileLifetime, TrackingRadius and TargetRestrictOnlyAllow
            --  TrackingWeapon              (used by weapons thattrack projectiles rather than units)

			
        self.damageTable = {
			DamageAmount = weaponBlueprint.Damage + (self.DamageMod or 0),
			DamageType = weaponBlueprint.DamageType,
		}
		
		if weaponBlueprint.CollideFriendly then
			self.damageTable.CollideFriendly = weaponBlueprint.CollideFriendly
		end
		
		if weaponBlueprint.DamageFriendly then
			self.damageTable.DamageFriendly = weaponBlueprint.DamageFriendly
		end
		
		if weaponBlueprint.DamageRadius > 0 then
			self.damageTable.DamageRadius = weaponBlueprint.DamageRadius + (self.DamageRadiusMod or 0)
		end
		
		if weaponBlueprint.advancedTracking then

			self.damageTable.advancedTracking = weaponBlueprint.advancedTracking
			self.damageTable.ProjectileLifetime = self.ProjectileLifetime
			self.damageTable.TargetRestrictOnlyAllow = self.TargetRestrictOnlyAllow
            self.damageTable.TrackingRadius = self.TrackingRadius
            
            self.damageTable.TrackingWeapon = self
		end
		
		if weaponBlueprint.ArtilleryShieldBlocks then
			self.damageTable.ArtilleryShieldBlocks = weaponBlueprint.ArtilleryShieldBlocks
		end
		
		if weaponBlueprint.DoTTime then
			self.damageTable.DoTTime = weaponBlueprint.DoTTime
			self.damageTable.DoTPulses = weaponBlueprint.DoTPulses or nil
		end

        if weaponBlueprint.Buffs != nil then
		
			self.damageTable.Buffs = {}
			
            for k, v in weaponBlueprint.Buffs do
                
                if v.TargetAllow and type(v.TargetAllow) == 'string' then
                    v.TargetAllow = LOUDPARSE(v.TargetAllow)
                end
                
                if v.TargetDisallow and type(v.TargetDisallow) == 'string' then
                    v.TargetDisallow = LOUDPARSE(v.TargetDisallow)
                end
                
                self.damageTable.Buffs[k] = {}
                self.damageTable.Buffs[k] = v

            end   
			
        end     
		
        --remove disabled buff
        if (self.Disabledbf != nil) and (self.damageTable.Buffs != nil) then
		
            for k, v in self.damageTable.Buffs do
			
                for j, w in self.Disabledbf do
				
                    if v.BuffType == w then
                        --Removing buff
                        LOUDREMOVE( self.damageTable.Buffs, k )
						
                    end
					
                end
				
            end 
			
        end 
	
		if ScenarioInfo.WeaponDialog then
			LOG("*AI DEBUG Weapon SetDamageTable for "..repr(self.bp.Label).." is "..repr(self.damageTable))
		end

    end,

    ChangeDamage = function(self, new)
        self.damageTable.DamageAmount = new + (self.DamageMod or 0)
	
		if ScenarioInfo.WeaponDialog then
			LOG("*AI DEBUG Weapon SetDamageTable after ChangeDamage for "..repr(self.bp.Label).." is "..repr(self.damageTable))
		end

    end,

	-- this event is triggered at the moment that a weapon fires a shell
    CreateProjectileForWeapon = function(self, bone)

        local proj = LOUDCREATEPROJECTILE( self, bone )
        
        if not proj.BlueprintID then
        
            local target
        
            while self and proj and not proj.BlueprintID do
            
                target = self:GetCurrentTarget()

                if target and not target.Dead then
            
                    WaitTicks(1)

                    proj = LOUDCREATEPROJECTILE( self, bone )
                else

                    -- the weapon has lost its target during firing
                    --LOG("*AI DEBUG Projectile for Weapon "..repr(self.bp.Label).." "..repr(bone).." failed at "..GetGameTick().." Weapon has target is "..repr(self:WeaponHasTarget()).." Current target is "..repr(target.BlueprintID).." Dead "..repr(target.Dead) )                                

                    break
                end
            end
        end
		
        if proj and not BeenDestroyed(proj) then

            if ScenarioInfo.ProjectileDialog then
                LOG("*AI DEBUG Weapon CreateProjectileForWeapon "..repr(self.bp.Label).." at bone "..repr(bone).." on tick "..GetGameTick() )
            end
            
            PassDamageData( proj, self.damageTable )
			
            if self.NukeWeapon then
			
                local bp = self.bp

                proj.Data = {
				
                    NukeInnerRingDamage = bp.NukeInnerRingDamage or 2000,
                    NukeInnerRingRadius = bp.NukeInnerRingRadius or 30,
                    NukeInnerRingTicks = bp.NukeInnerRingTicks or 5,
                    NukeInnerRingTotalTime = bp.NukeInnerRingTotalTime or 2,
					
                    NukeOuterRingDamage = bp.NukeOuterRingDamage or 10,
                    NukeOuterRingRadius = bp.NukeOuterRingRadius or 45,
                    NukeOuterRingTicks = bp.NukeOuterRingTicks or 20,
                    NukeOuterRingTotalTime = bp.NukeOuterRingTotalTime or 20,

                }

            end

        end
		
        return proj
    end,

    SetValidTargetsForCurrentLayer = function(self, newLayer, bp)

        local weaponBlueprint = self.bp
        
        local SetFireTargetLayerCaps = SetFireTargetLayerCaps
		
        if weaponBlueprint.FireTargetLayerCapsTable then
		
            if weaponBlueprint.FireTargetLayerCapsTable[newLayer] then
			
                SetFireTargetLayerCaps( self, weaponBlueprint.FireTargetLayerCapsTable[newLayer] )
				
            else
			
                SetFireTargetLayerCaps( self,'None')
            end
        end
    end,

    SetWeaponPriorities = function(self, priTable)
	
		local LOUDPARSE = ParseEntityCategory
        local SetTargetingPriorities = SetTargetingPriorities 
		
        if not priTable then

            if self.bp.TargetPriorities then
			
                local priorityTable = {}
				local counter = 1
				
                for k, v in self.bp.TargetPriorities do
                
                    priorityTable[counter] = LOUDPARSE(v)
					counter = counter + 1
                end
				
                SetTargetingPriorities( self, priorityTable )
            end
			
        else
        
            if type(priTable[1]) == 'string' then
			
                local priorityTable = {}
				local counter = 1
				
                for k, v in priTable do
                
                    priorityTable[counter] = LOUDPARSE(v)
					counter = counter + 1
                end
				
                SetTargetingPriorities( self, priorityTable )
                
            else
            
                SetTargetingPriorities( self, priTable )
                
            end
        end
    end,

    WeaponUsesEnergy = function(self)

        if self.bp.EnergyRequired then
			return self.bp.EnergyRequired > 0
        end
		
		return false
    end,

    AddDamageMod = function(self, dmgMod)
        self.DamageMod = (self.DamageMod or 0) + (dmgMod or 0)
    end,

    AddDamageRadiusMod = function(self, dmgRadMod)
        self.DamageRadiusMod = (self.DamageRadiusMod or 0) + (dmgRadMod or 0)
    end,
    
    -- rewritten to have buff data passed in to save the GetBlueprint function call
    DoOnFireBuffs = function(self, buffs)

        for k, v in buffs do
			if v.Add.OnFire == true then
                self.unit:AddBuff(v)
            end
        end
    end,

    DisableBuff = function(self, buffname)
	
        if buffname then

			if not self.Disabledbf then
				self.Disabledbf = {}
			end
		
            for k, v in self.Disabledbf do
			
                if v == buffname then
                    -- buff already in the table
                    return
                end
            end
            
            --Add to disabled buff list
            LOUDINSERT(self.Disabledbf, buffname)
        end
    end,
    
    ReEnableBuff = function(self, buffname)
	
        if buffname then
		
			LOG("*AI DEBUG Weapon ReEnableBuff "..repr(buffname))
			
            for k, v in self.Disabledbf do
			
                if v == buffname then
                    --Remove from disabled buff list
                    LOUDREMOVE(self.Disabledbf, k)
                end
            end
        end
    end,
    
    --Method to mark weapon when parent unit gets loaded on to a transport unit
    SetOnTransport = function(self, transportstate)

        -- if not allowed to fire from transport - disable/renable weapon
        if not __blueprints[self.unit.BlueprintID].Transport.CanFireFromTransport then
        
            if transportstate then
                self:SetWeaponEnabled(false)
            else
                self:SetWeaponEnabled(true)
            end
        end      

        -- mark weapon with status
        self.WeaponOnTransport = transportstate
		
        if not self.WeaponOnTransport then
            -- tell weapon that it just got dropped and needs to restart aim
            self:OnLostTarget()
            -- remove mark on the weapon
            self.WeaponOnTransport = nil
        end

    end,

    -- Method to retreive if the parent unit has been loaded onto a transport unit
    GetOnTransport = function(self)
        return self.WeaponOnTransport
    end,
    
    --This is the function to set a weapon enabled. 
    --If the weapon is enhabled by an enhancement, this will check to see if the unit has the enhancement before
    --allowing it to try to be enabled or disabled.
    SetWeaponEnabled = function(self, enable)

        -- standard disable path
        if not enable then
 
            if self.WeaponIsEnabled != enable then
    
                if ScenarioInfo.WeaponDialog or ScenarioInfo.WeaponStateDialog then
                    LOG("*AI DEBUG Weapon SetWeaponEnabled "..repr(self.bp.Label).." to "..repr(enable).." at "..GetGameTick().." Enabled currently "..repr(self.WeaponIsEnabled) )
                end
            
                self.WeaponIsEnabled = false
    
                self:SetEnabled(enable)
               
                self:OnDisableWeapon()

            end

        end
        
        -- enabling path -- 
        
        local GetEntityId = moho.entity_methods.GetEntityId

        if enable and self.bp.EnabledByEnhancement then
		
            local id = GetEntityId(self.unit)
			
            if SimUnitEnhancements[id] then
 
                if ScenarioInfo.WeaponDialog or ScenarioInfo.WeaponStateDialog then
                    LOG("*AI DEBUG Weapon SetWeaponEnabled by Enhancement - unit enhancements are "..repr(SimUnitEnhancements[id]) )
                end
 			
                for k, v in SimUnitEnhancements[id] do
				
                    if v == self.bp.EnabledByEnhancement then
                    
                        if not self.WeaponIsEnabled then
    
                            if ScenarioInfo.WeaponDialog or ScenarioInfo.WeaponStateDialog then
                                LOG("*AI DEBUG Weapon SetWeaponEnabled by Enhancement "..repr(self.bp.Label).." to "..repr(enable).." at "..GetGameTick().." Enabled currently "..repr(self.WeaponIsEnabled) )
                            end
                        
                            self:SetEnabled(enable)
                            
                            self.WeaponIsEnabled = true
                            
                            self:OnEnableWeapon()
                            
                            ChangeState( self, self.IdleState )

                        end
                    end
                end
            end
			
            --Enhancement needed but doesn't have it, don't allow weapon to be enabled.
            return
        end
        
        -- standard enable path
        if self.WeaponIsEnabled != enable then
    
            if ScenarioInfo.WeaponDialog or ScenarioInfo.WeaponStateDialog then
                LOG("*AI DEBUG Weapon SetWeaponEnabled "..repr(self.bp.Label).." to "..repr(enable).." at "..GetGameTick().." Enabled currently "..repr(self.WeaponIsEnabled) )
            end
        
            self:SetEnabled(enable)
            
            self.WeaponIsEnabled = true
            
            self:OnEnableWeapon()
            
            ChangeState(self, self.IdleState)

        end
    end,    

}

else


local Entity = import('/lua/sim/Entity.lua').Entity

Weapon = Class(moho.weapon_methods) {
    __init = function(self, unit)
        self.unit = unit
    end,

    OnCreate = function(self)
        if not self.unit.Trash then
            self.unit.Trash = TrashBag()
        end
        self:SetValidTargetsForCurrentLayer(self.unit:GetCurrentLayer())
        if self:GetBlueprint().Turreted == true then
            self:SetupTurret()
        end
        self:SetWeaponPriorities()
        self.Disabledbf = {}
        self.DamageMod = 0
        self.DamageRadiusMod = 0
        local bp = self:GetBlueprint()
        local initStore = bp.InitialProjectileStorage
        if initStore and initStore > 0 then
            if bp.MaxProjectileStorage and bp.MaxProjectileStorage < initStore then
                initStore = bp.MaxProjectileStorage
            end
            local nuke = false
            if bp.NukeWeapon then
                nuke = true
            end
            self:ForkThread(self.AmmoThread, nuke, bp.InitialProjectileStorage)
        end
    end,

    AmmoThread = function(self, nuke, amount)
        WaitSeconds(0.1)
        if nuke then
            self.unit:GiveNukeSiloAmmo(amount)
        else
            self.unit:GiveTacticalSiloAmmo(amount)
        end
    end,

    SetupTurret = function(self)
        local bp = self:GetBlueprint()
        local yawBone = bp.TurretBoneYaw
        local pitchBone = bp.TurretBonePitch
        local muzzleBone = bp.TurretBoneMuzzle
        local precedence = bp.AimControlPrecedence or 10
        local pitchBone2
        local muzzleBone2
        if bp.TurretBoneDualPitch and bp.TurretBoneDualPitch != '' then
            pitchBone2 = bp.TurretBoneDualPitch
        end
        if bp.TurretBoneDualMuzzle and bp.TurretBoneDualMuzzle != '' then
            muzzleBone2 = bp.TurretBoneDualMuzzle
        end
        if not (self.unit:ValidateBone(yawBone) and self.unit:ValidateBone(pitchBone) and self.unit:ValidateBone(muzzleBone)) then
            error('*ERROR: Bone aborting turret setup due to bone issues.', 2)
            return
        elseif pitchBone2 and muzzleBone2 then
            if not (self.unit:ValidateBone(pitchBone2) and self.unit:ValidateBone(muzzleBone2)) then
                error('*ERROR: Bone aborting turret setup due to pitch/muzzle bone2 issues.', 2)
                return
            end
        end
        if yawBone and pitchBone and muzzleBone then
            if bp.TurretDualManipulators then
                self.AimControl = CreateAimController(self, 'Torso', yawBone)
                self.AimRight = CreateAimController(self, 'Right', pitchBone, pitchBone, muzzleBone)
                self.AimLeft = CreateAimController(self, 'Left', pitchBone2, pitchBone2, muzzleBone2)
                self.AimControl:SetPrecedence(precedence)
                self.AimRight:SetPrecedence(precedence)
                self.AimLeft:SetPrecedence(precedence)
                if EntityCategoryContains(categories.STRUCTURE, self.unit) then
                    self.AimControl:SetResetPoseTime(9999999)
                end
                self:SetFireControl('Right')
                self.unit.Trash:Add(self.AimControl)
                self.unit.Trash:Add(self.AimRight)
                self.unit.Trash:Add(self.AimLeft)
            else
                self.AimControl = CreateAimController(self, 'Default', yawBone, pitchBone, muzzleBone)
                if EntityCategoryContains(categories.STRUCTURE, self.unit) then
                    self.AimControl:SetResetPoseTime(9999999)
                end
                self.unit.Trash:Add(self.AimControl)
                self.AimControl:SetPrecedence(precedence)
                if bp.RackSlavedToTurret and table.getn(bp.RackBones) > 0 then
                    for k, v in bp.RackBones do
                        if v.RackBone != pitchBone then
                            local slaver = CreateSlaver(self.unit, v.RackBone, pitchBone)
                            slaver:SetPrecedence(precedence-1)
                            self.unit.Trash:Add(slaver)
                        end
                    end
                end
            end
        else
            error('*ERROR: Trying to setup a turreted weapon but there are yaw bones, pitch bones or muzzle bones missing from the blueprint.', 2)
        end


        local numbersexist = true
        local turretyawmin, turretyawmax, turretyawspeed
        local turretpitchmin, turretpitchmax, turretpitchspeed

        #SETUP MANIPULATORS AND SET TURRET YAW, PITCH AND SPEED
        if self:GetBlueprint().TurretYaw and self:GetBlueprint().TurretYawRange then
            turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        else
            numbersexist = false
        end
        if self:GetBlueprint().TurretYawSpeed then
            turretyawspeed = self:GetTurretYawSpeed()
        else
            numbersexist = false
        end
        if self:GetBlueprint().TurretPitch and self:GetBlueprint().TurretPitchRange then
            turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax()
        else
            numbersexist = false
        end
        if self:GetBlueprint().TurretPitchSpeed then
            turretpitchspeed = self:GetTurretPitchSpeed()
        else
            numbersexist = false
        end
        if numbersexist then
            self.AimControl:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
            if self.AimRight then
                self.AimRight:SetFiringArc(turretyawmin/12, turretyawmax/12, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
            end
            if self.AimLeft then
                self.AimLeft:SetFiringArc(turretyawmin/12, turretyawmax/12, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
            end
        else
            local strg = '*ERROR: TRYING TO SETUP A TURRET WITHOUT ALL TURRET NUMBERS IN BLUEPRINT, ABORTING TURRET SETUP. WEAPON: ' .. self:GetBlueprint().Label .. ' UNIT: '.. self.unit:GetUnitId()
            error(strg, 2)
        end
    end,

    AimManipulatorSetEnabled = function(self, enabled)
        if self.AimControl then
            self.AimControl:SetEnabled(enabled)
        end
    end,

    GetAimManipulator = function(self)
        return self.AimControl
    end,

    SetTurretYawSpeed = function(self, speed)
        local turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        local turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax()
        local turretpitchspeed = self:GetTurretPitchSpeed()
        if self.AimControl then
            self.AimControl:SetFiringArc(turretyawmin, turretyawmax, speed, turretpitchmin, turretpitchmax, turretpitchspeed)
        end
    end,

    SetTurretPitchSpeed = function(self, speed)
        local turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        local turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax()
        local turretyawspeed = self:GetTurretYawSpeed()
        if self.AimControl then
            self.AimControl:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, turretpitchmin, turretpitchmax, speed)
        end
    end,
	
	SetTurretPitch = function(self, value, value2)
        local turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        local turretpitchmin, turretpitchmax = value, value2
        local turretyawspeed = self:GetTurretYawSpeed()
		local turretpitchspeed = self:GetTurretPitchSpeed()
        if self.AimControl then
            self.AimControl:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, value, value2, turretpitchspeed)
        end
    end,

    GetTurretYawMinMax = function(self)
        local halfrange = self:GetBlueprint().TurretYawRange
        local yaw = self:GetBlueprint().TurretYaw
        turretyawmin = yaw - halfrange
        turretyawmax = yaw + halfrange
        return turretyawmin, turretyawmax
    end,

    GetTurretYawSpeed = function(self)
        return self:GetBlueprint().TurretYawSpeed
    end,

    GetTurretPitchMinMax = function(self)
        local halfrange = self:GetBlueprint().TurretPitchRange
        local pitch = self:GetBlueprint().TurretPitch
        turretpitchmin = pitch - halfrange
        turretpitchmax = pitch + halfrange
        return turretpitchmin, turretpitchmax
    end,

    GetTurretPitchSpeed = function(self)
        return self:GetBlueprint().TurretPitchSpeed
    end,

    OnFire = function(self)
        local bp = self:GetBlueprint()
        if bp.Audio.Fire then
            self:PlaySound(bp.Audio.Fire)
        end
        self:DoOnFireBuffs()
    end,

    OnEnableWeapon = function(self)
    end,

    OnGotTarget = function(self)
        #LOG('Got the target')
        if self.DisabledFiringBones and self.unit.Animator then
            for key, value in self.DisabledFiringBones do
                self.unit.Animator:SetBoneEnabled(value, false)
            end
        end
    end,

    OnLostTarget = function(self)
        if self.DisabledFiringBones and self.unit.Animator then
            for key, value in self.DisabledFiringBones do
                self.unit.Animator:SetBoneEnabled(value, true)
            end
        end
    end,

    OnStartTracking = function(self, label)
        self:PlayWeaponSound('BarrelStart')
        self:PlayWeaponAmbientSound('BarrelLoop')
    end,

    OnStopTracking = function(self, label)
        self:PlayWeaponSound('BarrelStop')
        self:StopWeaponAmbientSound('BarrelLoop')
        if EntityCategoryContains(categories.STRUCTURE, self.unit) then
            self.AimControl:SetResetPoseTime(9999999)
        end

    end,

    PlayWeaponSound = function(self, sound)
        local bp = self:GetBlueprint()
        if not bp.Audio[sound] then return end
        self:PlaySound(bp.Audio[sound])
    end,
    
    PlayWeaponAmbientSound = function(self, sound)
        local bp = self:GetBlueprint()
        if not bp.Audio[sound] then return end
        if not self.AmbientSounds then
            self.AmbientSounds = {}
        end
        if not self.AmbientSounds[sound] then
            local sndEnt = Entity {}
            self.AmbientSounds[sound] = sndEnt
            self.unit.Trash:Add(sndEnt)
            sndEnt:AttachTo(self.unit,-1)
        end
        self.AmbientSounds[sound]:SetAmbientSound( bp.Audio[sound], nil )
    end,
    
    StopWeaponAmbientSound = function(self, sound)
        if not self.AmbientSounds then return end
        if not self.AmbientSounds[sound] then return end
        local bp = self:GetBlueprint()
        if not bp.Audio[sound] then return end
        self.AmbientSounds[sound]:Destroy()
        self.AmbientSounds[sound] = nil
    end,

    OnEnableWeapon = function(self)
        
    end,

    OnMotionHorzEventChange = function(self, new, old)

    end,

    GetDamageTable = function(self)
        local weaponBlueprint = self:GetBlueprint()
        local damageTable = {}
        damageTable.DamageRadius = weaponBlueprint.DamageRadius + (self.DamageRadiusMod or 0)
        damageTable.DamageAmount = weaponBlueprint.Damage + (self.DamageMod or 0)
        damageTable.DamageType = weaponBlueprint.DamageType
        damageTable.DamageFriendly = weaponBlueprint.DamageFriendly
        if damageTable.DamageFriendly == nil then
            damageTable.DamageFriendly = true
        end
        damageTable.CollideFriendly = weaponBlueprint.CollideFriendly or false
        damageTable.DoTTime = weaponBlueprint.DoTTime
        damageTable.DoTPulses = weaponBlueprint.DoTPulses
        damageTable.MetaImpactAmount = weaponBlueprint.MetaImpactAmount
        damageTable.MetaImpactRadius = weaponBlueprint.MetaImpactRadius
        #Add buff
        damageTable.Buffs = {}
        if weaponBlueprint.Buffs != nil then
            for k, v in weaponBlueprint.Buffs do
                damageTable.Buffs[k] = {}
                damageTable.Buffs[k] = v
            end   
        end     
        #remove disabled buff
        if (self.Disabledbf != nil) and (damageTable.Buffs != nil) then
            for k, v in damageTable.Buffs do
                for j, w in self.Disabledbf do
                    if v.BuffType == w then
                        #Removing buff
                        table.remove( damageTable.Buffs, k )
                    end
                end
            end  
        end  
        return damageTable
    end,

    CreateProjectileForWeapon = function(self, bone)
        local proj = self:CreateProjectile(bone)
        local damageTable = self:GetDamageTable()
        if proj and not proj:BeenDestroyed() then
            proj:PassDamageData(damageTable)
            local bp = self:GetBlueprint()

            if bp.NukeOuterRingDamage and bp.NukeOuterRingRadius and bp.NukeOuterRingTicks and bp.NukeOuterRingTotalTime and
                bp.NukeInnerRingDamage and bp.NukeInnerRingRadius and bp.NukeInnerRingTicks and bp.NukeInnerRingTotalTime then
                local data = {
                    NukeOuterRingDamage = bp.NukeOuterRingDamage or 10,
                    NukeOuterRingRadius = bp.NukeOuterRingRadius or 40,
                    NukeOuterRingTicks = bp.NukeOuterRingTicks or 20,
                    NukeOuterRingTotalTime = bp.NukeOuterRingTotalTime or 10,
        
                    NukeInnerRingDamage = bp.NukeInnerRingDamage or 2000,
                    NukeInnerRingRadius = bp.NukeInnerRingRadius or 30,
                    NukeInnerRingTicks = bp.NukeInnerRingTicks or 24,
                    NukeInnerRingTotalTime = bp.NukeInnerRingTotalTime or 24,
                }
                proj:PassData(data)
            end
        end
        return proj
    end,

    SetValidTargetsForCurrentLayer = function(self, newLayer)
        #LOG( 'SetValidTargetsForCurrentLayer, layer = ', newLayer )
        local weaponBlueprint = self:GetBlueprint()
        if weaponBlueprint.FireTargetLayerCapsTable then
            if weaponBlueprint.FireTargetLayerCapsTable[newLayer] then
                #LOG( 'Setting Target Layer Caps to ', weaponBlueprint.FireTargetLayerCapsTable[newLayer] )
                self:SetFireTargetLayerCaps( weaponBlueprint.FireTargetLayerCapsTable[newLayer] )
            else
                #LOG( 'Setting Target Layer Caps to None' )
                self:SetFireTargetLayerCaps('None')
            end
        end
    end,

    OnDestroy = function(self)
    end,

    SetWeaponPriorities = function(self, priTable)
        if not priTable then
            local bp = self:GetBlueprint().TargetPriorities
            if bp then
                local priorityTable = {}
                for k, v in bp do
                    table.insert(priorityTable, ParseEntityCategory(v))
                end
                self:SetTargetingPriorities(priorityTable)
            end
        else
            if type(priTable[1]) == 'string' then
                local priorityTable = {}
                for k, v in priTable do
                    table.insert(priorityTable, ParseEntityCategory(v))
                end
                self:SetTargetingPriorities(priorityTable)
            else
                self:SetTargetingPriorities(priTable)
            end
        end
    end,

    WeaponUsesEnergy = function(self)
        local bp = self:GetBlueprint()
        if bp.EnergyRequired and bp.EnergyRequired > 0 then
            return true
        end
        return false
    end,

    ForkThread = function(self, fn, ...)
        if fn then
            local thread = ForkThread(fn, self, unpack(arg))
            self.unit.Trash:Add(thread)
            return thread
        else
            return nil
        end
    end,

    OnVeteranLevel = function(self, old, new)
        local bp = self:GetBlueprint().Buffs
        if not bp then return end

        local lvlkey = 'VeteranLevel' .. new
        for k, v in bp do
            if v.Add[lvlkey] == true then
                self:AddBuff(v)
            end
        end
    end,

    AddBuff = function(self, buffTbl)
        self.unit:AddWeaponBuff(buffTbl, self)
    end,

    AddDamageMod = function(self, dmgMod)
        self.DamageMod = self.DamageMod + dmgMod
    end,
    
    AddDamageRadiusMod = function(self, dmgRadMod)
        self.DamageRadiusMod = self.DamageRadiusMod + (dmgRadMod or 0)
    end,
    
    DoOnFireBuffs = function(self)
        local data = self:GetBlueprint()
        if data.Buffs then
            for k, v in data.Buffs do
                if v.Add.OnFire == true then
                    self.unit:AddBuff(v)
                end
            end
        end
    end,

    DisableBuff = function(self, buffname)
        if buffname then
            for k, v in self.Disabledbf do
                if v == buffname then
                    #this buff is already in the table
                    return
                end
            end
            
            #Add to disabled list
            table.insert(self.Disabledbf, buffname)
        else
            #Error
            error('ERROR: DisableBuff in weapon.lua does not have a buffname') 
        end
    end,
    
    ReEnableBuff = function(self, buffname)
        if buffname then
            for k, v in self.Disabledbf do
                if v == buffname then
                    #Remove from disabled list
                    table.remove(self.Disabledbf, k)
                end
            end
        else
            #Error 
            error('ERROR: ReEnableBuff in weapon.lua does not have a buffname') 
        end
    end,
    
    #Method to mark weapon when parent unit gets loaded on to a transport unit
    SetOnTransport = function(self, transportstate)
        self.onTransport = transportstate
        if not transportstate then
            #send a message to tell the weapon that the unit just got dropped and needs to restart aim
            self:OnLostTarget()
        end
        #Disable weapon if on transport and not allowed to fire from it
        if not self.unit:GetBlueprint().Transport.CanFireFromTransport then
            if transportstate then
                self.WeaponDisabledOnTransport = true
                self:SetWeaponEnabled(false)
            else
                self:SetWeaponEnabled(true)
                self.WeaponDisabledOnTransport = false
            end
        end        
    end,

    #Method to retreive onTransport information. True if the parent unit has been loaded on to a transport unit
    GetOnTransport = function(self)
        return self.onTransport
    end,
    
    #This is the function to set a weapon enabled. 
    #If the weapon is enhabled by an enhancement, this will check to see if the unit has the enhancement before
    #allowing it to try to be enabled or disabled.
    SetWeaponEnabled = function(self, enable)
        if not enable then
            self:SetEnabled(enable)
            return
        end
        local bp = self:GetBlueprint().EnabledByEnhancement
        if bp then
            local id = self.unit:GetEntityId()
            if SimUnitEnhancements[id] then
                for k, v in SimUnitEnhancements[id] do
                    if v == bp then
                        self:SetEnabled(enable)
                        return
                    end
                end
            end
            #Enhancement needed but doesn't have it, don't allow weapon to be enabled.
            return
        end
        self:SetEnabled(enable)
    end,
}

end

else

local Entity = import('/lua/sim/Entity.lua').Entity

Weapon = Class(moho.weapon_methods) {
    __init = function(self, unit)
        self.unit = unit
    end,

    OnCreate = function(self)
        if not self.unit.Trash then
            self.unit.Trash = TrashBag()
        end
        self:SetValidTargetsForCurrentLayer(self.unit:GetCurrentLayer())
        if self:GetBlueprint().Turreted == true then
            self:SetupTurret()
        end
        self:SetWeaponPriorities()
        self.Disabledbf = {}
        self.DamageMod = 0
        self.DamageRadiusMod = 0
        local bp = self:GetBlueprint()
        local initStore = bp.InitialProjectileStorage
        if initStore and initStore > 0 then
            if bp.MaxProjectileStorage and bp.MaxProjectileStorage < initStore then
                initStore = bp.MaxProjectileStorage
            end
            local nuke = false
            if bp.NukeWeapon then
                nuke = true
            end
            self:ForkThread(self.AmmoThread, nuke, bp.InitialProjectileStorage)
        end
    end,

    AmmoThread = function(self, nuke, amount)
        WaitSeconds(0.1)
        if nuke then
            self.unit:GiveNukeSiloAmmo(amount)
        else
            self.unit:GiveTacticalSiloAmmo(amount)
        end
    end,

    SetupTurret = function(self)
        local bp = self:GetBlueprint()
        local yawBone = bp.TurretBoneYaw
        local pitchBone = bp.TurretBonePitch
        local muzzleBone = bp.TurretBoneMuzzle
        local precedence = bp.AimControlPrecedence or 10
        local pitchBone2
        local muzzleBone2
        if bp.TurretBoneDualPitch and bp.TurretBoneDualPitch != '' then
            pitchBone2 = bp.TurretBoneDualPitch
        end
        if bp.TurretBoneDualMuzzle and bp.TurretBoneDualMuzzle != '' then
            muzzleBone2 = bp.TurretBoneDualMuzzle
        end
        if not (self.unit:ValidateBone(yawBone) and self.unit:ValidateBone(pitchBone) and self.unit:ValidateBone(muzzleBone)) then
            error('*ERROR: Bone aborting turret setup due to bone issues.', 2)
            return
        elseif pitchBone2 and muzzleBone2 then
            if not (self.unit:ValidateBone(pitchBone2) and self.unit:ValidateBone(muzzleBone2)) then
                error('*ERROR: Bone aborting turret setup due to pitch/muzzle bone2 issues.', 2)
                return
            end
        end
        if yawBone and pitchBone and muzzleBone then
            if bp.TurretDualManipulators then
                self.AimControl = CreateAimController(self, 'Torso', yawBone)
                self.AimRight = CreateAimController(self, 'Right', pitchBone, pitchBone, muzzleBone)
                self.AimLeft = CreateAimController(self, 'Left', pitchBone2, pitchBone2, muzzleBone2)
                self.AimControl:SetPrecedence(precedence)
                self.AimRight:SetPrecedence(precedence)
                self.AimLeft:SetPrecedence(precedence)
                if EntityCategoryContains(categories.STRUCTURE, self.unit) then
                    self.AimControl:SetResetPoseTime(9999999)
                end
                self:SetFireControl('Right')
                self.unit.Trash:Add(self.AimControl)
                self.unit.Trash:Add(self.AimRight)
                self.unit.Trash:Add(self.AimLeft)
            else
                self.AimControl = CreateAimController(self, 'Default', yawBone, pitchBone, muzzleBone)
                if EntityCategoryContains(categories.STRUCTURE, self.unit) then
                    self.AimControl:SetResetPoseTime(9999999)
                end
                self.unit.Trash:Add(self.AimControl)
                self.AimControl:SetPrecedence(precedence)
                if bp.RackSlavedToTurret and table.getn(bp.RackBones) > 0 then
                    for k, v in bp.RackBones do
                        if v.RackBone != pitchBone then
                            local slaver = CreateSlaver(self.unit, v.RackBone, pitchBone)
                            slaver:SetPrecedence(precedence-1)
                            self.unit.Trash:Add(slaver)
                        end
                    end
                end
            end
        else
            error('*ERROR: Trying to setup a turreted weapon but there are yaw bones, pitch bones or muzzle bones missing from the blueprint.', 2)
        end


        local numbersexist = true
        local turretyawmin, turretyawmax, turretyawspeed
        local turretpitchmin, turretpitchmax, turretpitchspeed

        #SETUP MANIPULATORS AND SET TURRET YAW, PITCH AND SPEED
        if self:GetBlueprint().TurretYaw and self:GetBlueprint().TurretYawRange then
            turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        else
            numbersexist = false
        end
        if self:GetBlueprint().TurretYawSpeed then
            turretyawspeed = self:GetTurretYawSpeed()
        else
            numbersexist = false
        end
        if self:GetBlueprint().TurretPitch and self:GetBlueprint().TurretPitchRange then
            turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax()
        else
            numbersexist = false
        end
        if self:GetBlueprint().TurretPitchSpeed then
            turretpitchspeed = self:GetTurretPitchSpeed()
        else
            numbersexist = false
        end
        if numbersexist then
            self.AimControl:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
            if self.AimRight then
                self.AimRight:SetFiringArc(turretyawmin/12, turretyawmax/12, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
            end
            if self.AimLeft then
                self.AimLeft:SetFiringArc(turretyawmin/12, turretyawmax/12, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
            end
        else
            local strg = '*ERROR: TRYING TO SETUP A TURRET WITHOUT ALL TURRET NUMBERS IN BLUEPRINT, ABORTING TURRET SETUP. WEAPON: ' .. self:GetBlueprint().Label .. ' UNIT: '.. self.unit:GetUnitId()
            error(strg, 2)
        end
    end,

    AimManipulatorSetEnabled = function(self, enabled)
        if self.AimControl then
            self.AimControl:SetEnabled(enabled)
        end
    end,

    GetAimManipulator = function(self)
        return self.AimControl
    end,

    SetTurretYawSpeed = function(self, speed)
        local turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        local turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax()
        local turretpitchspeed = self:GetTurretPitchSpeed()
        if self.AimControl then
            self.AimControl:SetFiringArc(turretyawmin, turretyawmax, speed, turretpitchmin, turretpitchmax, turretpitchspeed)
        end
    end,

    SetTurretPitchSpeed = function(self, speed)
        local turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        local turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax()
        local turretyawspeed = self:GetTurretYawSpeed()
        if self.AimControl then
            self.AimControl:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, turretpitchmin, turretpitchmax, speed)
        end
    end,
	
	SetTurretPitch = function(self, value, value2)
        local turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        local turretpitchmin, turretpitchmax = value, value2
        local turretyawspeed = self:GetTurretYawSpeed()
		local turretpitchspeed = self:GetTurretPitchSpeed()
        if self.AimControl then
            self.AimControl:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, value, value2, turretpitchspeed)
        end
    end,

    GetTurretYawMinMax = function(self)
        local halfrange = self:GetBlueprint().TurretYawRange
        local yaw = self:GetBlueprint().TurretYaw
        turretyawmin = yaw - halfrange
        turretyawmax = yaw + halfrange
        return turretyawmin, turretyawmax
    end,

    GetTurretYawSpeed = function(self)
        return self:GetBlueprint().TurretYawSpeed
    end,

    GetTurretPitchMinMax = function(self)
        local halfrange = self:GetBlueprint().TurretPitchRange
        local pitch = self:GetBlueprint().TurretPitch
        turretpitchmin = pitch - halfrange
        turretpitchmax = pitch + halfrange
        return turretpitchmin, turretpitchmax
    end,

    GetTurretPitchSpeed = function(self)
        return self:GetBlueprint().TurretPitchSpeed
    end,

    OnFire = function(self)
        local bp = self:GetBlueprint()
        if bp.Audio.Fire then
            self:PlaySound(bp.Audio.Fire)
        end
        self:DoOnFireBuffs()
    end,

    OnEnableWeapon = function(self)
    end,

    OnGotTarget = function(self)
        #LOG('Got the target')
        if self.DisabledFiringBones and self.unit.Animator then
            for key, value in self.DisabledFiringBones do
                self.unit.Animator:SetBoneEnabled(value, false)
            end
        end
    end,

    OnLostTarget = function(self)
        if self.DisabledFiringBones and self.unit.Animator then
            for key, value in self.DisabledFiringBones do
                self.unit.Animator:SetBoneEnabled(value, true)
            end
        end
    end,

    OnStartTracking = function(self, label)
        self:PlayWeaponSound('BarrelStart')
        self:PlayWeaponAmbientSound('BarrelLoop')
    end,

    OnStopTracking = function(self, label)
        self:PlayWeaponSound('BarrelStop')
        self:StopWeaponAmbientSound('BarrelLoop')
        if EntityCategoryContains(categories.STRUCTURE, self.unit) then
            self.AimControl:SetResetPoseTime(9999999)
        end

    end,

    PlayWeaponSound = function(self, sound)
        local bp = self:GetBlueprint()
        if not bp.Audio[sound] then return end
        self:PlaySound(bp.Audio[sound])
    end,
    
    PlayWeaponAmbientSound = function(self, sound)
        local bp = self:GetBlueprint()
        if not bp.Audio[sound] then return end
        if not self.AmbientSounds then
            self.AmbientSounds = {}
        end
        if not self.AmbientSounds[sound] then
            local sndEnt = Entity {}
            self.AmbientSounds[sound] = sndEnt
            self.unit.Trash:Add(sndEnt)
            sndEnt:AttachTo(self.unit,-1)
        end
        self.AmbientSounds[sound]:SetAmbientSound( bp.Audio[sound], nil )
    end,
    
    StopWeaponAmbientSound = function(self, sound)
        if not self.AmbientSounds then return end
        if not self.AmbientSounds[sound] then return end
        local bp = self:GetBlueprint()
        if not bp.Audio[sound] then return end
        self.AmbientSounds[sound]:Destroy()
        self.AmbientSounds[sound] = nil
    end,

    OnEnableWeapon = function(self)
        
    end,

    OnMotionHorzEventChange = function(self, new, old)

    end,

    GetDamageTable = function(self)
        local weaponBlueprint = self:GetBlueprint()
        local damageTable = {}
        damageTable.DamageRadius = weaponBlueprint.DamageRadius + (self.DamageRadiusMod or 0)
        damageTable.DamageAmount = weaponBlueprint.Damage + (self.DamageMod or 0)
        damageTable.DamageType = weaponBlueprint.DamageType
        damageTable.DamageFriendly = weaponBlueprint.DamageFriendly
        if damageTable.DamageFriendly == nil then
            damageTable.DamageFriendly = true
        end
        damageTable.CollideFriendly = weaponBlueprint.CollideFriendly or false
        damageTable.DoTTime = weaponBlueprint.DoTTime
        damageTable.DoTPulses = weaponBlueprint.DoTPulses
        damageTable.MetaImpactAmount = weaponBlueprint.MetaImpactAmount
        damageTable.MetaImpactRadius = weaponBlueprint.MetaImpactRadius
        #Add buff
        damageTable.Buffs = {}
        if weaponBlueprint.Buffs != nil then
            for k, v in weaponBlueprint.Buffs do
                damageTable.Buffs[k] = {}
                damageTable.Buffs[k] = v
            end   
        end     
        #remove disabled buff
        if (self.Disabledbf != nil) and (damageTable.Buffs != nil) then
            for k, v in damageTable.Buffs do
                for j, w in self.Disabledbf do
                    if v.BuffType == w then
                        #Removing buff
                        table.remove( damageTable.Buffs, k )
                    end
                end
            end  
        end  
        return damageTable
    end,

    CreateProjectileForWeapon = function(self, bone)
        local proj = self:CreateProjectile(bone)
        local damageTable = self:GetDamageTable()
        if proj and not proj:BeenDestroyed() then
            proj:PassDamageData(damageTable)
            local bp = self:GetBlueprint()

            if bp.NukeOuterRingDamage and bp.NukeOuterRingRadius and bp.NukeOuterRingTicks and bp.NukeOuterRingTotalTime and
                bp.NukeInnerRingDamage and bp.NukeInnerRingRadius and bp.NukeInnerRingTicks and bp.NukeInnerRingTotalTime then
                local data = {
                    NukeOuterRingDamage = bp.NukeOuterRingDamage or 10,
                    NukeOuterRingRadius = bp.NukeOuterRingRadius or 40,
                    NukeOuterRingTicks = bp.NukeOuterRingTicks or 20,
                    NukeOuterRingTotalTime = bp.NukeOuterRingTotalTime or 10,
        
                    NukeInnerRingDamage = bp.NukeInnerRingDamage or 2000,
                    NukeInnerRingRadius = bp.NukeInnerRingRadius or 30,
                    NukeInnerRingTicks = bp.NukeInnerRingTicks or 24,
                    NukeInnerRingTotalTime = bp.NukeInnerRingTotalTime or 24,
                }
                proj:PassData(data)
            end
        end
        return proj
    end,

    SetValidTargetsForCurrentLayer = function(self, newLayer)
        #LOG( 'SetValidTargetsForCurrentLayer, layer = ', newLayer )
        local weaponBlueprint = self:GetBlueprint()
        if weaponBlueprint.FireTargetLayerCapsTable then
            if weaponBlueprint.FireTargetLayerCapsTable[newLayer] then
                #LOG( 'Setting Target Layer Caps to ', weaponBlueprint.FireTargetLayerCapsTable[newLayer] )
                self:SetFireTargetLayerCaps( weaponBlueprint.FireTargetLayerCapsTable[newLayer] )
            else
                #LOG( 'Setting Target Layer Caps to None' )
                self:SetFireTargetLayerCaps('None')
            end
        end
    end,

    OnDestroy = function(self)
    end,

    SetWeaponPriorities = function(self, priTable)
        if not priTable then
            local bp = self:GetBlueprint().TargetPriorities
            if bp then
                local priorityTable = {}
                for k, v in bp do
                    table.insert(priorityTable, ParseEntityCategory(v))
                end
                self:SetTargetingPriorities(priorityTable)
            end
        else
            if type(priTable[1]) == 'string' then
                local priorityTable = {}
                for k, v in priTable do
                    table.insert(priorityTable, ParseEntityCategory(v))
                end
                self:SetTargetingPriorities(priorityTable)
            else
                self:SetTargetingPriorities(priTable)
            end
        end
    end,

    WeaponUsesEnergy = function(self)
        local bp = self:GetBlueprint()
        if bp.EnergyRequired and bp.EnergyRequired > 0 then
            return true
        end
        return false
    end,

    ForkThread = function(self, fn, ...)
        if fn then
            local thread = ForkThread(fn, self, unpack(arg))
            self.unit.Trash:Add(thread)
            return thread
        else
            return nil
        end
    end,

    OnVeteranLevel = function(self, old, new)
        local bp = self:GetBlueprint().Buffs
        if not bp then return end

        local lvlkey = 'VeteranLevel' .. new
        for k, v in bp do
            if v.Add[lvlkey] == true then
                self:AddBuff(v)
            end
        end
    end,

    AddBuff = function(self, buffTbl)
        self.unit:AddWeaponBuff(buffTbl, self)
    end,

    AddDamageMod = function(self, dmgMod)
        self.DamageMod = self.DamageMod + dmgMod
    end,
    
    AddDamageRadiusMod = function(self, dmgRadMod)
        self.DamageRadiusMod = self.DamageRadiusMod + (dmgRadMod or 0)
    end,
    
    DoOnFireBuffs = function(self)
        local data = self:GetBlueprint()
        if data.Buffs then
            for k, v in data.Buffs do
                if v.Add.OnFire == true then
                    self.unit:AddBuff(v)
                end
            end
        end
    end,

    DisableBuff = function(self, buffname)
        if buffname then
            for k, v in self.Disabledbf do
                if v == buffname then
                    #this buff is already in the table
                    return
                end
            end
            
            #Add to disabled list
            table.insert(self.Disabledbf, buffname)
        else
            #Error
            error('ERROR: DisableBuff in weapon.lua does not have a buffname') 
        end
    end,
    
    ReEnableBuff = function(self, buffname)
        if buffname then
            for k, v in self.Disabledbf do
                if v == buffname then
                    #Remove from disabled list
                    table.remove(self.Disabledbf, k)
                end
            end
        else
            #Error 
            error('ERROR: ReEnableBuff in weapon.lua does not have a buffname') 
        end
    end,
    
    #Method to mark weapon when parent unit gets loaded on to a transport unit
    SetOnTransport = function(self, transportstate)
        self.onTransport = transportstate
        if not transportstate then
            #send a message to tell the weapon that the unit just got dropped and needs to restart aim
            self:OnLostTarget()
        end
        #Disable weapon if on transport and not allowed to fire from it
        if not self.unit:GetBlueprint().Transport.CanFireFromTransport then
            if transportstate then
                self.WeaponDisabledOnTransport = true
                self:SetWeaponEnabled(false)
            else
                self:SetWeaponEnabled(true)
                self.WeaponDisabledOnTransport = false
            end
        end        
    end,

    #Method to retreive onTransport information. True if the parent unit has been loaded on to a transport unit
    GetOnTransport = function(self)
        return self.onTransport
    end,
    
    #This is the function to set a weapon enabled. 
    #If the weapon is enhabled by an enhancement, this will check to see if the unit has the enhancement before
    #allowing it to try to be enabled or disabled.
    SetWeaponEnabled = function(self, enable)
        if not enable then
            self:SetEnabled(enable)
            return
        end
        local bp = self:GetBlueprint().EnabledByEnhancement
        if bp then
            local id = self.unit:GetEntityId()
            if SimUnitEnhancements[id] then
                for k, v in SimUnitEnhancements[id] do
                    if v == bp then
                        self:SetEnabled(enable)
                        return
                    end
                end
            end
            #Enhancement needed but doesn't have it, don't allow weapon to be enabled.
            return
        end
        self:SetEnabled(enable)
    end,
}

end

else
-- ****************************************************************************
-- **
-- **  File     :  /lua/sim/Weapon.lua
-- **  Author(s):  John Comes
-- **
-- **  Summary  : The base weapon class for all weapons in the game.
-- **
-- **  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
-- ****************************************************************************

local Entity = import("/lua/sim/entity.lua").Entity
local NukeDamage = import("/lua/sim/nukedamage.lua").NukeAOE
local ParseEntityCategoryProperly = import("/lua/sim/categoryutils.lua").ParseEntityCategoryProperly
---@type false | EntityCategory[]
local cachedPriorities = false
local RecycledPriTable = {}

local DebugWeaponComponent = import("/lua/sim/weapons/components/debugweaponcomponent.lua").DebugWeaponComponent

--- Table of damage information passed from the weapon to the projectile
--- Can be assigned as a meta table to the projectile's damage table to reduce memory usage for unchanged values
---@class WeaponDamageTable
---@field DamageToShields number        # weaponBlueprint.DamageToShields
---@field InitialDamageAmount number    # weaponBlueprint.InitialDamage or 0
---@field DamageRadius number           # weaponBlueprint.DamageRadius + Weapon.DamageRadiusMod
---@field DamageAmount number           # weaponBlueprint.Damage + Weapon.DamageMod
---@field DamageType DamageType         # weaponBlueprint.DamageType
---@field DamageFriendly boolean        # weaponBlueprint.DamageFriendly or true
---@field CollideFriendly boolean       # weaponBlueprint.CollideFriendly or false
---@field DoTTime number                # weaponBlueprint.DoTTime
---@field DoTPulses number              # weaponBlueprint.DoTPulses
---@field MetaImpactAmount any          # weaponBlueprint.MetaImpactAmount
---@field MetaImpactRadius any          # weaponBlueprint.MetaImpactRadius
---@field ArtilleryShieldBlocks boolean # weaponBlueprint.ArtilleryShieldBlocks
---@field Buffs BlueprintBuff[]         # Active buffs for the weapon
---@field __index WeaponDamageTable

---@return EntityCategory[]
local function ParsePriorities()
    local idlist = EntityCategoryGetUnitList(categories.ALLUNITS)
    local finalPriorities = {}
    local StringFind = string.find
    local ParseEntityCategoryProperly = ParseEntityCategoryProperly
    local ParseEntityCategory = ParseEntityCategory

    for _, id in idlist do
        local weapons = GetUnitBlueprintByName(id).Weapon
        if not weapons then
            continue
        end
        for _, weapon in weapons do
            local priorities = weapon.TargetPriorities
            if not priorities then
                continue
            end
            for _, priority in priorities do
                if not finalPriorities[priority] then
                    if StringFind(priority, '%(', 1, true) then
                        finalPriorities[priority] = ParseEntityCategoryProperly(priority)
                    else
                        finalPriorities[priority] = ParseEntityCategory(priority)
                    end
                end
            end
        end
    end
    return finalPriorities
end

local WeaponMethods = moho.weapon_methods

---@class Weapon : moho.weapon_methods, InternalObject, DebugWeaponComponent
---@field AimControl? moho.AimManipulator
---@field AimLeft? moho.AimManipulator
---@field AimRight? moho.AimManipulator
---@field Army Army
---@field AmbientSounds table<SoundBlueprint, Entity>
---@field Blueprint WeaponBlueprint
---@field Brain AIBrain
---@field CollideFriendly boolean
---@field DamageMod number
---@field DamageModifiers number[] # Set of damage multipliers used by collision beams for the weapon
---@field DamageRadiusMod number
---@field damageTableCache WeaponDamageTable? # nil when the damage table needs to be refreshed from the weapon blueprint
---@field damageTableCacheValid boolean? # false when the damage table needs to be updated with changed damage/radius modifiers or Buffs
---@field DisabledBuffs table
---@field DisabledFiringBones Bone[] # Bones that `Unit.Animator` cannot move when this weapon has a target
---@field EnergyRequired? number
---@field EnergyDrainPerSecond? number
---@field Label string
---@field NumTargets number
---@field Trash TrashBag
---@field unit Unit
---@field MaxRadius? number
---@field MinRadius? number
---@field onTransport boolean # True if the parent unit has been loaded on to a transport unit.
Weapon = ClassWeapon(WeaponMethods, DebugWeaponComponent) {

    -- stored here for mods compatibility, overridden in the inner table when written to
    DamageMod = 0,
    DamageRadiusMod = 0,

    ---@param self Weapon
    ---@param unit Unit
    __init = function(self, unit)
        self.unit = unit
    end,

    ---@param self Weapon
    OnCreate = function(self)
        -- Store blueprint for improved access pattern, see benchmark on blueprints
        local bp = self:GetBlueprint()
        self.Blueprint = bp

        -- Legacy information stored for backwards compatibility
        self.Label = bp.Label
        self.EnergyRequired = bp.EnergyRequired
        self.EnergyDrainPerSecond = bp.EnergyDrainPerSecond

        local unit = self.unit
        self.Brain = unit:GetAIBrain()
        self.Army = unit:GetArmy()
        self.Trash = unit.Trash

        self:SetValidTargetsForCurrentLayer(unit.Layer)

        if bp.Turreted then
            self:SetupTurret(bp)
        end

        self:SetWeaponPriorities()
        self.DisabledBuffs = {}
        local initStore = bp.InitialProjectileStorage
        if initStore and initStore > 0 then
            local maxProjStore = bp.MaxProjectileStorage
            if maxProjStore and maxProjStore < initStore then
                initStore = maxProjStore
            end
            self:ForkThread(self.AmmoThread, bp.NukeWeapon, initStore)
        end
		if DiskGetFileInfo('lua/CustomFactions/Nomads.lua') then
		self:DetermineColourIndex()
		end

        self.CollideFriendly = bp.CollideFriendly or false
    end,
	
	DetermineColourIndex = function(self)
        --we determine the index once on create then save it in the entity table to save on sim slowdown
        if not self.unit.ColourIndex then
            WARN('crazy unit is crazy - no colour index despite when its set OnPreCreate! blueprintID: ' .. self.unit.UnitId)
        end
        self.ColourIndex = self.unit.ColourIndex or 383.999
    end,
	
	SwitchAimController = function(self)
        -- Alternate between aim controller after each shot so each barrel fires at the unit and no shots are wasted.
        if self.DoAlternateDualAimController then
            if self.AlternateDualAimCtrlThread then
                KillThread(self.AlternateDualAimCtrlThread)
                self.AlternateDualAimCtrlThread = nil
            end

            local bp = self:GetBlueprint()
            local rack = bp.RackBones[ self:GetNextRackSalvoNumber() ]
            local switchTo = rack.TurretBoneDualManip
            local delay = rack.TurretBoneDualManipSwitchDelay or (0.2 * (1 / self.RateOfFire)) -- switch when half way to next salvo, calculate in real time to include buffs and alike
            self.AlternateDualAimCtrlThread = self:ForkThread( self.SwitchAimControllerThread, switchTo, delay )
        end
    end,

    ---@param self Weapon
    ---@param nuke NukeProjectile
    ---@param amount number
    AmmoThread = function(self, nuke, amount)
        WaitSeconds(0.1)
        if nuke then
            self.unit:GiveNukeSiloAmmo(amount)
        else
            self.unit:GiveTacticalSiloAmmo(amount)
        end
    end,

    ---@param self Weapon
    ---@param bp? WeaponBlueprint
    SetupTurret = function(self, bp)
        bp = bp or self.Blueprint -- defensive programming

        local unit = self.unit
        local precedence = bp.AimControlPrecedence or 10

        local yawBone = bp.TurretBoneYaw
        local pitchBone = bp.TurretBonePitch
        local muzzleBone = bp.TurretBoneMuzzle
        local useDualManipulators = bp.TurretDualManipulators
        local pitchBone2, muzzleBone2
        if useDualManipulators then
            pitchBone2, muzzleBone2 = bp.TurretBoneDualPitch, bp.TurretBoneDualMuzzle
        end
        local yawBone2 = bp.TurretBoneDualYaw

        -- verify bones so that issues are easier to debug, since `CreateAimController` fails silently.
        local issues = ''
        if not yawBone then issues = issues .. 'TurretBoneYaw missing from blueprint, '
        elseif not unit:ValidateBone(yawBone) then issues = issues .. 'TurretBoneYaw "' .. tostring(yawBone) .. '" does not exist in unit mesh, ' end
        if not pitchBone then issues = issues .. 'TurretBonePitch missing from blueprint, '
        elseif not unit:ValidateBone(pitchBone) then issues = issues .. 'TurretBonePitch "' .. tostring(pitchBone) .. '" does not exist in unit mesh, ' end
        if not muzzleBone then issues = issues .. 'TurretBoneMuzzle missing from blueprint, '
        elseif not unit:ValidateBone(muzzleBone) then issues = issues .. 'TurretBoneMuzzle "' .. tostring(muzzleBone) .. '" does not exist in unit mesh, ' end

        if useDualManipulators then
            if not pitchBone then issues = issues .. 'TurretBonePitch missing from blueprint, '
            elseif not unit:ValidateBone(pitchBone2) then issues = issues .. 'TurretBoneDualPitch "' .. tostring(pitchBone2) .. '" does not exist in unit mesh, ' end
            if not muzzleBone then issues = issues .. 'TurretBoneMuzzle missing from blueprint, '
            elseif not unit:ValidateBone(muzzleBone2) then issues = issues .. 'TurretBoneDualMuzzle "' .. tostring(muzzleBone2) .. '" does not exist in unit mesh, ' end
        end

        if yawBone2 and not unit:ValidateBone(yawBone2) then issues = issues .. 'TurretBoneDualYaw "' .. tostring(yawBone2) .. '" does not exist in unit mesh, ' end

        if issues ~= '' then
            WARN(string.format('Weapon "%s" aborting turret setup due to the following bone issues: %s.\n'
                    , tostring(bp.BlueprintId or bp.Label)
                    , string.sub(issues, 1, -3)
                )
                , debug.traceback()
            )
            return
        end

        -- Set up turret aim controllers if bones are valid.

        local aimControl, aimRight, aimLeft, aimYaw2
        local selfTrash = self.Trash
        if useDualManipulators then
            ---@diagnostic disable-next-line: param-type-mismatch
            aimControl = CreateAimController(self, 'Torso', yawBone)
            ---@diagnostic disable-next-line: param-type-mismatch
            aimRight = CreateAimController(self, 'Right', pitchBone, pitchBone, muzzleBone)
            ---@diagnostic disable-next-line: param-type-mismatch
            aimLeft = CreateAimController(self, 'Left', pitchBone2, pitchBone2, muzzleBone2)
            self.AimRight = aimRight
            self.AimLeft = aimLeft
            aimControl:SetPrecedence(precedence)
            aimRight:SetPrecedence(precedence)
            aimLeft:SetPrecedence(precedence)
            if EntityCategoryContains(categories.STRUCTURE, unit) then
                aimControl:SetResetPoseTime(9999999)
            end
            self:SetFireControl('Right')
            selfTrash:Add(aimControl)
            selfTrash:Add(aimRight)
            selfTrash:Add(aimLeft)
        else
            ---@diagnostic disable-next-line: param-type-mismatch
            aimControl = CreateAimController(self, 'Default', yawBone, pitchBone, muzzleBone)
            if EntityCategoryContains(categories.STRUCTURE, unit) then
                aimControl:SetResetPoseTime(9999999)
            end
            selfTrash:Add(aimControl)
            aimControl:SetPrecedence(precedence)
            if bp.RackSlavedToTurret and not table.empty(bp.RackBones) then
                for _, v in bp.RackBones do
                    local rackBone = v.RackBone
                    if rackBone ~= pitchBone then
                        ---@diagnostic disable-next-line: param-type-mismatch
                        local slaver = CreateSlaver(unit, rackBone, pitchBone)
                        slaver:SetPrecedence(precedence - 1)
                        selfTrash:Add(slaver)
                    end
                end
            end
        end

        if yawBone2 then
            aimYaw2 = CreateAimController(self, 'Yaw2', yawBone2)
            aimYaw2:SetPrecedence(precedence - 1)
            if EntityCategoryContains(categories.STRUCTURE, unit) then
                aimYaw2:SetResetPoseTime(9999999)
            end
            selfTrash:Add(aimYaw2)
        end
        self.AimControl = aimControl

        -- Validate turret yaw, pitch, and speeds

        if not bp.TurretYaw then issues = issues .. 'TurretYaw missing from blueprint, ' end
        if not bp.TurretYawRange then issues = issues .. 'TurretYawRange missing from blueprint, ' end
        if not bp.TurretYawSpeed then issues = issues .. 'TurretYawSpeed missing from blueprint, ' end
        if not bp.TurretPitch then issues = issues .. 'TurretPitch missing from blueprint, ' end
        if not bp.TurretPitchRange then issues = issues .. 'TurretPitchRange missing from blueprint, ' end
        if not bp.TurretPitchSpeed then issues = issues .. 'TurretPitchSpeed missing from blueprint, ' end

        if issues ~= '' then
            WARN(string.format('Weapon "%s" aborting turret setup due to the following turret number issues: %s.\n'
                    , tostring(bp.BlueprintId or bp.Label)
                    , string.sub(issues, 1, -3)
                )
                , debug.traceback()
            )
            return
        end

        -- Set up turret yaw, pitch, and speeds if they're valid.

        local turretyawmin, turretyawmax = self:GetTurretYawMinMax(bp)
        local turretyawspeed = self:GetTurretYawSpeed(bp)
        local turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax(bp)
        local turretpitchspeed = self:GetTurretPitchSpeed(bp)

        aimControl:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
        if aimRight and aimLeft then -- although, they should both exist if either one does
            turretyawmin = turretyawmin / 12
            turretyawmax = turretyawmax / 12
            aimRight:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
            aimLeft:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, turretpitchmin, turretpitchmax, turretpitchspeed)
        end

        if aimYaw2 then
            local turretYawMin2 = turretyawmin
            local turretYawMax2 = turretyawmax
            if bp.TurretDualYaw and bp.TurretDualYawRange then
                turretYawMin2 = bp.TurretDualYaw - bp.TurretDualYawRange
                turretYawMax2 = bp.TurretDualYaw + bp.TurretDualYawRange
            end

            local turretYawSpeed2 = bp.TurretDualYawSpeed or turretyawspeed
            aimYaw2:SetFiringArc(turretYawMin2, turretYawMax2, turretYawSpeed2, 0, 0, 0)
        end
    end,

    ---@param self Weapon
    ---@param enabled boolean
    AimManipulatorSetEnabled = function(self, enabled)
        local aimControl = self.AimControl
        if aimControl then
            aimControl:SetEnabled(enabled)
        end
    end,

    ---@param self Weapon
    GetAimManipulator = function(self)
        return self.AimControl
    end,

    ---@param self Weapon
    ---@param speed number
    SetTurretYawSpeed = function(self, speed)
        local aimControl = self.AimControl
        if aimControl then
            local turretyawmin, turretyawmax = self:GetTurretYawMinMax()
            local turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax()
            local turretpitchspeed = self:GetTurretPitchSpeed()
            aimControl:SetFiringArc(turretyawmin, turretyawmax, speed, turretpitchmin, turretpitchmax, turretpitchspeed)
        end
    end,

    ---@param self Weapon
    ---@param speed number
    ---@param bp? WeaponBlueprint
    SetTurretPitchSpeed = function(self, speed, bp)
        local aimControl = self.AimControl
        if aimControl then
            bp = bp or self.Blueprint -- backwards compatibility for mods
            local turretyawmin, turretyawmax = self:GetTurretYawMinMax(bp)
            local turretpitchmin, turretpitchmax = self:GetTurretPitchMinMax(bp)
            local turretyawspeed = self:GetTurretYawSpeed(bp)
            aimControl:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, turretpitchmin, turretpitchmax, speed)
        end
    end,
	
	SetTurretPitch = function(self, value, value2)
        local turretyawmin, turretyawmax = self:GetTurretYawMinMax()
        local turretpitchmin, turretpitchmax = value, value2
        local turretyawspeed = self:GetTurretYawSpeed()
		local turretpitchspeed = self:GetTurretPitchSpeed()
        if self.AimControl then
            self.AimControl:SetFiringArc(turretyawmin, turretyawmax, turretyawspeed, value, value2, turretpitchspeed)
        end
    end,

    --- Retrieves the min / max yaw values of the weapon
    ---@param self Weapon
    ---@param bp? WeaponBlueprint Optional blueprint value that is manually retrieved if not present
    GetTurretYawMinMax = function(self, bp)
        bp = bp or self.Blueprint -- backwards compatibility for mods
        local turretyawmin = bp.TurretYaw - bp.TurretYawRange
        local turretyawmax = bp.TurretYaw + bp.TurretYawRange
        return turretyawmin, turretyawmax
    end,

    --- Retrieves the yaw speed of the weapon
    ---@param self Weapon
    ---@param bp? WeaponBlueprint Optional blueprint value that is manually retrieved if not present
    GetTurretYawSpeed = function(self, bp)
        bp = bp or self.Blueprint -- backwards compatibility for mods
        return bp.TurretYawSpeed
    end,

    --- Retrieves the min / max pitch values of the weapon
    ---@param self Weapon
    ---@param bp? WeaponBlueprint Optional blueprint value that is manually retrieved if not present
    GetTurretPitchMinMax = function(self, bp)
        bp = bp or self.Blueprint -- backwards compatibility for mods
        local turretpitchmin = bp.TurretPitch - bp.TurretPitchRange
        local turretpitchmax = bp.TurretPitch + bp.TurretPitchRange
        return turretpitchmin, turretpitchmax
    end,

    --- Retrieves the pitch speed of the weapon
    ---@param self Weapon
    ---@param bp? WeaponBlueprint Optional blueprint value that is manually retrieved if not present
    GetTurretPitchSpeed = function(self, bp)
        bp = bp or self.Blueprint -- backwards compatibility for mods
        return bp.TurretPitchSpeed
    end,

    ---@param self Weapon
    OnFire = function(self)
        self:PlayWeaponSound('Fire')
        self:DoOnFireBuffs()
    end,

    ---@param self Weapon
    OnEnableWeapon = function(self)
    end,

    ---@param self Weapon
    OnGotTarget = function(self)
        -- a few non-walker units may use `Animator` as well
        local animator = self.unit--[[@as WalkingLandUnit]] .Animator
        if self.DisabledFiringBones and animator then
            for _, value in self.DisabledFiringBones do
                animator:SetBoneEnabled(value, false)
            end
        end
    end,

    ---@param self Weapon
    OnLostTarget = function(self)
        -- a few non-walker units may use `Animator` as well
        local animator = self.unit--[[@as WalkingLandUnit]] .Animator
        if self.DisabledFiringBones and animator then
            for _, value in self.DisabledFiringBones do
                animator:SetBoneEnabled(value, true)
            end
        end
    end,

    ---@param self Weapon
    ---@param label string # label of the aim controller that started tracking
    OnStartTracking = function(self, label)
        self:PlayWeaponSound('BarrelStart')
        self:PlayWeaponAmbientSound('BarrelLoop')
    end,

    ---@param self Weapon
    ---@param label string # label of the aim controller that stopped tracking
    OnStopTracking = function(self, label)
        self:PlayWeaponSound('BarrelStop')
        self:StopWeaponAmbientSound('BarrelLoop')
        if EntityCategoryContains(categories.STRUCTURE, self.unit) then
            self.AimControl:SetResetPoseTime(9999999)
        end
    end,

    ---@param self Weapon
    ---@param sound SoundBlueprint | string # The string is the key for the audio in the weapon blueprint
    PlayWeaponSound = function(self, sound)
        local weaponSound = self.Blueprint.Audio[sound]
        if not weaponSound then return end
        self:PlaySound(weaponSound)
    end,

    ---@param self Weapon
    ---@param sound SoundBlueprint | string # The string is the key for the audio in the weapon blueprint
    PlayWeaponAmbientSound = function(self, sound)
        local audio = self.Blueprint.Audio[sound]
        if not audio then return end
        local ambientSounds = self.AmbientSounds
        if not self.AmbientSounds then
            ambientSounds = {}
            self.AmbientSounds = ambientSounds
        end
        local ambientSound = ambientSounds[sound]
        if not ambientSound then
            ---@type Entity
            ambientSound = Entity {}
            ambientSounds[sound] = ambientSound
            self.Trash:Add(ambientSound)
            ambientSound:AttachTo(self.unit, -1)
        end
        ambientSound:SetAmbientSound(audio, nil)
    end,

    ---@param self Weapon
    ---@param sound SoundBlueprint | string # The string is the key for the audio in the weapon blueprint
    StopWeaponAmbientSound = function(self, sound)
        local ambientSounds = self.AmbientSounds
        if not ambientSounds then return end
        local ambientSound = ambientSounds[sound]
        if not ambientSound then return end
        if not self.Blueprint.Audio[sound] then return end
        ambientSound:Destroy()
        ambientSounds[sound] = nil
    end,

    ---@param self Weapon
    ---@param new HorizontalMovementState
    ---@param old HorizontalMovementState
    OnMotionHorzEventChange = function(self, new, old)
    end,

    ---@param self Weapon
    ---@return WeaponDamageTable
    GetNewDamageTable = function(self)
        local weaponBlueprint = self.Blueprint

        local damageFriendly = weaponBlueprint.DamageFriendly
        if damageFriendly == nil then
            damageFriendly = true
        end
        local damageTable = {
            DamageToShields = weaponBlueprint.DamageToShields,
            InitialDamageAmount = weaponBlueprint.InitialDamage or 0,
            DamageType = weaponBlueprint.DamageType,
            DamageFriendly = damageFriendly,
            CollideFriendly = weaponBlueprint.CollideFriendly or false,
            DoTTime = weaponBlueprint.DoTTime,
            DoTPulses = weaponBlueprint.DoTPulses,
            MetaImpactAmount = weaponBlueprint.MetaImpactAmount,
            MetaImpactRadius = weaponBlueprint.MetaImpactRadius,
            ArtilleryShieldBlocks = weaponBlueprint.ArtilleryShieldBlocks,
        }
        -- Projectiles use the damage table as a metatable for their `DamageData` table.
        -- This saves memory by not copying the damage table contents for every projectile.
        -- See `Projectile.PassMetaDamage`
        damageTable.__index = damageTable

        return damageTable
    end,

    ---@param self Weapon
    ---@return WeaponDamageTable
    GetUpdatedDamageTable = function(self)
        local damageTable = self.damageTableCache --[[@as WeaponDamageTable]]
        local weaponBlueprint = self.Blueprint

        -- Add buff
        damageTable.DamageRadius = weaponBlueprint.DamageRadius + self.DamageRadiusMod
        damageTable.DamageAmount = weaponBlueprint.Damage + self.DamageMod
        damageTable.Buffs = {}
        if weaponBlueprint.Buffs ~= nil then
            for k, v in weaponBlueprint.Buffs do
                if not self.DisabledBuffs[v.BuffType] then
                    damageTable.Buffs[k] = v
                end
            end
        end

        self.damageTableCacheValid = true

        return damageTable
    end,

    ---@param self Weapon
    ---@return WeaponDamageTable
    GetDamageTable = function(self)
        if not self.damageTableCacheValid then
            if not self.damageTableCache then
                self.damageTableCache = self:GetNewDamageTable()
            end
            self.damageTableCache = self:GetUpdatedDamageTable()
        end
        return self.damageTableCache --[[@as WeaponDamageTable]]
    end,

    ---@param self Weapon
    ---@param bone Bone
    ---@return Projectile
    CreateProjectileForWeapon = function(self, bone)
        local proj = self:CreateProjectile(bone)

        -- used for the retargeting feature
        proj.CreatedByWeapon = self

        -- used for tactical / strategic defenses to ignore all other collisions
        proj.OriginalTarget = self:GetCurrentTarget()
        if proj.OriginalTarget.GetSource then
            proj.OriginalTarget = proj.OriginalTarget:GetSource()
        end

        local damageTable = self:GetDamageTable()
        if proj and not proj:BeenDestroyed() then
            proj:PassMetaDamage(damageTable)
            local bp = self.Blueprint

            if bp.NukeOuterRingDamage and bp.NukeOuterRingRadius and bp.NukeOuterRingTicks and bp.NukeOuterRingTotalTime and
                bp.NukeInnerRingDamage and bp.NukeInnerRingRadius and bp.NukeInnerRingTicks and bp.NukeInnerRingTotalTime then
                proj.InnerRing = NukeDamage()
                proj.InnerRing:OnCreate(bp.NukeInnerRingDamage, bp.NukeInnerRingRadius, bp.NukeInnerRingTicks, bp.NukeInnerRingTotalTime)
                proj.OuterRing = NukeDamage()
                proj.OuterRing:OnCreate(bp.NukeOuterRingDamage, bp.NukeOuterRingRadius, bp.NukeOuterRingTicks, bp.NukeOuterRingTotalTime)

                -- Need to store these three for later, in case the missile lands after the launcher dies
                proj.Launcher = self.unit
                proj.Army = self.Army
                proj.Brain = self.Brain
            end
        end
        return proj
    end,

    ---@param self Weapon
    ---@param newLayer Layer
    SetValidTargetsForCurrentLayer = function(self, newLayer)
        -- LOG('SetValidTargetsForCurrentLayer, layer = ', newLayer)
        local weaponBlueprint = self.Blueprint
        if weaponBlueprint.FireTargetLayerCapsTable then
            if weaponBlueprint.FireTargetLayerCapsTable[newLayer] then
                -- LOG('Setting Target Layer Caps to ', weaponBlueprint.FireTargetLayerCapsTable[newLayer])
                self:SetFireTargetLayerCaps(weaponBlueprint.FireTargetLayerCapsTable[newLayer])
            else
                -- LOG('Setting Target Layer Caps to None')
                self:SetFireTargetLayerCaps('None')
            end
        end
    end,

    ---@param self Weapon
    OnDestroy = function(self)
    end,

    ---@param self Weapon
    ---@param priorities? EntityCategory[] | UnparsedCategory[] | false
    SetWeaponPriorities = function(self, priorities)
        if priorities then
            if type(priorities[1]) == 'string' then
                local count = 1
                local priorityTable = RecycledPriTable
                for _, v in priorities do
                    priorityTable[count] = ParseEntityCategory(v)
                    count = count + 1
                end
                self:SetTargetingPriorities(priorityTable)
                for i = 1, count - 1 do
                    priorityTable[i] = nil
                end
            else
                self:SetTargetingPriorities(priorities)
            end
        else
            priorities = cachedPriorities
            if not priorities then
                priorities = ParsePriorities()
                cachedPriorities = priorities
            end
            local bp = self.Blueprint.TargetPriorities
            if bp then
                local count = 0
                local priorityTable = RecycledPriTable
                for _, v in bp do
                    count = count + 1
                    if priorities[v] then
                        priorityTable[count] = priorities[v]
                    else
                        if string.find(v, '%(') then
                            cachedPriorities[v] = ParseEntityCategoryProperly(v)
                            priorityTable[count] = priorities[v]
                        else
                            cachedPriorities[v] = ParseEntityCategory(v)
                            priorityTable[count] = priorities[v]
                        end
                    end
                end
                self:SetTargetingPriorities(priorityTable)
                for i = 1, count do
                    priorityTable[i] = nil
                end
            end
        end
    end,

    ---@param self Weapon
    WeaponUsesEnergy = function(self)
        return self.EnergyRequired and self.EnergyRequired > 0
    end,

    ---@param self Weapon
    ---@param fn function
    ---@param ... any
    ---@return thread|nil
    ForkThread = function(self, fn, ...)
        if fn then
            local thread = ForkThread(fn, self, unpack(arg))
            self.Trash:Add(thread)
            return thread
        else
            return nil
        end
    end,

    ---@param self Weapon
    ---@param old number
    ---@param new number
    OnVeteranLevel = function(self, old, new)
        local bp = self.Blueprint.Buffs
        if not bp then return end

        local lvlkey = 'VeteranLevel' .. new
        for _, v in bp do
            if v.Add[lvlkey] == true then
                self:AddBuff(v)
            end
        end
    end,

    ---@param self Weapon
    ---@param buffTbl BlueprintBuff
    AddBuff = function(self, buffTbl)
        self.unit:AddWeaponBuff(buffTbl, self)
    end,

    ---@param self Weapon
    ---@param dmgMod number
    AddDamageMod = function(self, dmgMod)
        self.DamageMod = self.DamageMod + dmgMod
        self.damageTableCacheValid = false
    end,

    ---@param self Weapon
    ---@param dmgRadMod? number This is optional
    AddDamageRadiusMod = function(self, dmgRadMod)
        if dmgRadMod then
            self.DamageRadiusMod = self.DamageRadiusMod + dmgRadMod
            self.damageTableCacheValid = false
        end
    end,

    ---@param self Weapon
    DoOnFireBuffs = function(self)
        local data = self.Blueprint
        if data.Buffs then
            for _, buff in data.Buffs do
                if buff.Add.OnFire then
                    self.unit:AddBuff(buff)
                end
            end
        end
    end,

    ---@param self Weapon
    ---@param buffname string
    DisableBuff = function(self, buffname)
        if buffname then
            self.DisabledBuffs[buffname] = true
            self.damageTableCacheValid = false
        else
            error('DisableBuff in weapon.lua does not have a buffname')
        end
    end,

    ---@param self Weapon
    ---@param buffname string
    ReEnableBuff = function(self, buffname)
        if buffname then
            self.DisabledBuffs[buffname] = nil
            self.damageTableCacheValid = false
        else
            error('ReEnableBuff in weapon.lua does not have a buffname')
        end
    end,

    --- Method to mark weapon when parent unit gets loaded on to a transport unit
    ---@param self Weapon
    ---@param transportstate boolean
    SetOnTransport = function(self, transportstate)
        self.onTransport = transportstate
        if not transportstate then
            -- send a message to tell the weapon that the unit just got dropped and needs to restart aim
            self:OnLostTarget()
        end
        -- Disable weapon if on transport and not allowed to fire from it
        if not self.unit:GetBlueprint().Transport.CanFireFromTransport then
            if transportstate then
                self.WeaponDisabledOnTransport = true
                self:SetWeaponEnabled(false)
            else
                self:SetWeaponEnabled(true)
                self.WeaponDisabledOnTransport = false
            end
        end
    end,

    --- Method to retreive onTransport information. True if the parent unit has been loaded on to a transport unit.
    ---@param self Weapon
    GetOnTransport = function(self)
        return self.onTransport
    end,

    --- This is the function to set a weapon enabled.
    --- If the weapon is enhabled by an enhancement, this will check to see if the unit has the
    --- enhancement before allowing it to try to be enabled or disabled.
    ---@param self Weapon
    ---@param enable boolean
    SetWeaponEnabled = function(self, enable)
        if not IsDestroyed(self) then
            if not enable then
                self:SetEnabled(enable)
                return
            end
            local enabledByEnh = self.Blueprint.EnabledByEnhancement
            if enabledByEnh then
                local enhancements = SimUnitEnhancements[self.unit.EntityId]
                if enhancements then
                    for _, enh in enhancements do
                        if enh == enabledByEnh then
                            self:SetEnabled(enable)
                            return
                        end
                    end
                end
                -- enhancement needed, but doesn't have it; don't allow weapon to be enabled
                return
            end
            self:SetEnabled(enable)
        end
    end,

    ---@param self Weapon
    ---@param rateOfFire number
    DisabledWhileReloadingThread = function(self, rateOfFire)

        -- attempts to fix weapons that intercept projectiles to being stuck on a projectile while reloading, preventing
        -- other weapons from targeting that projectile. Is a side effect of the blueprint field `DesiredShooterCap`. This
        -- is the more aggressive variant of `TargetResetWhenReady` as it completely disables the weapon.

        local reloadTime = math.floor(10 * rateOfFire) - 1
        if reloadTime > 4 then
            if IsDestroyed(self) then
                return
            end

            self:SetEnabled(false)
            WaitTicks(reloadTime)

            if IsDestroyed(self) then
                return
            end

            self:SetEnabled(true)
        end
    end,

    ---------------------------------------------------------------------------
    --#region Properties

    ---@param self Weapon
    ---@return number
    GetMaxRadius = function(self)
        return self.MaxRadius or self.Blueprint.MaxRadius
    end,

    ---@param self Weapon
    GetMinRadius = function(self)
        return self.MinRadius or self.Blueprint.MinRadius
    end,

    ---------------------------------------------------------------------------
    --#region Hooks

    ---@param self Weapon
    ---@param radius number
    ChangeMaxRadius = function(self, radius)
        WeaponMethods.ChangeMaxRadius(self, radius)
        self.MaxRadius = radius
    end,

    ---@param self Weapon
    ---@param radius number
    ChangeMinRadius = function(self, radius)
        WeaponMethods.ChangeMinRadius(self, radius)
        self.MinRadius = radius
    end,
}
end
