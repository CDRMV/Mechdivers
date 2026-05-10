#****************************************************************************
#**
#**  File     :  /units/UEL0303b/UEL0303b_script.lua
#**  Author(s):  CDRMV
#**
#**  Summary  :  UEF Patroit/Emancipator Mech Script
#**
#**  Copyright © 2025, Commander Survival Kit Project
#****************************************************************************

local DummyUnit = import('/lua/defaultunits.lua').MobileUnit
local TDFMachineGunWeapon = import('/mods/Mechdivers/lua/CSKMDWeapons.lua').DummyTurretWeapon
local barrelBones = { 'Shell01.001', 'Shell02.001', 'Shell03.001', 'Shell04.001', 'Shell05.001', 'Shell06.001' }
local recoilBones = { 'Shell01.001', 'Shell02.001', 'Shell03.001', 'Shell04.001', 'Shell05.001', 'Shell06.001' }
local muzzleBones = { 'Shell01.001', 'Shell02.001', 'Shell03.001', 'Shell04.001', 'Shell05.001', 'Shell06.001' }
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('/lua/utilities.lua')
local number = 0
R_Shotgun = Class(DummyUnit) {

    Weapons = {
		FlakCannon = Class(TDFMachineGunWeapon) 
        {
			OnWeaponFired = function(self, target)
			number = number + 1
			if number == 1 then
			self.unit:HideBone('Shell05', true)
			end
			
			if number == 2 then
			self.unit:HideBone('Shell04', true)
			end
			
			if number == 3 then
			self.unit:HideBone('Shell03', true)
			end
			
			if number == 4 then
			self.unit:HideBone('Shell02', true)
			end
			
			if number == 5 then
			self.unit:HideBone('Shell01', true)
			end
			
			if number == 6 then
			self.unit:HideBone('Shell06', true)
			
			self:SetEnabled(false)
			self:DoReload()
			end
			
			
			
			end,
            OnCreate = function(self)
                TDFMachineGunWeapon.OnCreate(self)
                self.losttarget = false      
                self.initialaim = true
                self.PitchRotators = {}
                self.restdirvector = {}
                self.currentbarrel = 1                
            end,
			
			DoReload = function(self)
				ForkThread( function()
				if number == 6 then
							self.unit:HideBone('Shell01_Hull', true)
                
                    self.Rotator:SetSpeed(120)
                    self.Goal = self.Goal + 60
                    if self.Goal >= 360 then
                        self.Goal = 0
                    end
                    WaitSeconds(0.5)
                    self.Rotator:SetGoal(self.Goal)
                    self.currentbarrel = self.currentbarrel + 1
                    #Increment barrel number
                    if self.currentbarrel > 6 then
                        self.currentbarrel = 1
                    end
                    self.rotatedbarrel = true
			
			
			self.unit:ShowBone('Shell01_Hull', true)	
			self.unit:ShowBone('Shell01', true)
			
			self.unit:HideBone('Shell06_Hull', true)
                
                    self.Rotator:SetSpeed(120)
                    self.Goal = self.Goal + 60
                    if self.Goal >= 360 then
                        self.Goal = 0
                    end
                    WaitSeconds(0.5)
                    self.Rotator:SetGoal(self.Goal)
                    self.currentbarrel = self.currentbarrel + 1
                    #Increment barrel number
                    if self.currentbarrel > 6 then
                        self.currentbarrel = 1
                    end
                    self.rotatedbarrel = true
				
			self.unit:ShowBone('Shell06_Hull', true)	
			self.unit:ShowBone('Shell06', true)
			
			self.unit:HideBone('Shell05_Hull', true)
                
                    self.Rotator:SetSpeed(120)
                    self.Goal = self.Goal + 60
                    if self.Goal >= 360 then
                        self.Goal = 0
                    end
                    WaitSeconds(0.5)
                    self.Rotator:SetGoal(self.Goal)
                    self.currentbarrel = self.currentbarrel + 1
                    #Increment barrel number
                    if self.currentbarrel > 6 then
                        self.currentbarrel = 1
                    end
                    self.rotatedbarrel = true
				
			self.unit:ShowBone('Shell05_Hull', true)	
			self.unit:ShowBone('Shell05', true)
			
			self.unit:HideBone('Shell04_Hull', true)
                
                    self.Rotator:SetSpeed(120)
                    self.Goal = self.Goal + 60
                    if self.Goal >= 360 then
                        self.Goal = 0
                    end
                    WaitSeconds(0.5)
                    self.Rotator:SetGoal(self.Goal)
                    self.currentbarrel = self.currentbarrel + 1
                    #Increment barrel number
                    if self.currentbarrel > 6 then
                        self.currentbarrel = 1
                    end
                    self.rotatedbarrel = true
				
			self.unit:ShowBone('Shell04_Hull', true)	
			self.unit:ShowBone('Shell04', true)
			
			self.unit:HideBone('Shell03_Hull', true)
                
                    self.Rotator:SetSpeed(120)
                    self.Goal = self.Goal + 60
                    if self.Goal >= 360 then
                        self.Goal = 0
                    end
                    WaitSeconds(0.5)
                    self.Rotator:SetGoal(self.Goal)
                    self.currentbarrel = self.currentbarrel + 1
                    #Increment barrel number
                    if self.currentbarrel > 6 then
                        self.currentbarrel = 1
                    end
                    self.rotatedbarrel = true
				
			self.unit:ShowBone('Shell03_Hull', true)	
			self.unit:ShowBone('Shell03', true)
			
			self.unit:HideBone('Shell02_Hull', true)
                
                    self.Rotator:SetSpeed(120)
                    self.Goal = self.Goal + 60
                    if self.Goal >= 360 then
                        self.Goal = 0
                    end
                    WaitSeconds(0.5)
                    self.Rotator:SetGoal(self.Goal)
                    self.currentbarrel = self.currentbarrel + 1
                    #Increment barrel number
                    if self.currentbarrel > 6 then
                        self.currentbarrel = 1
                    end
                    self.rotatedbarrel = true
				
			self.unit:ShowBone('Shell02_Hull', true)	
			self.unit:ShowBone('Shell02', true)
				number = 0
				self:SetEnabled(true)
			end	
			end)	
            end,
            
            
            OnLostTarget = function(self)
                #Mark target lost 
                TDFMachineGunWeapon.OnLostTarget(self)
                self.losttarget = true  
            end,
            
            PlayFxWeaponPackSequence = function(self)
                if self.PitchRotators then
                    #We repacked the unit lets delete the rotators
                    for k, v in barrelBones do
                        if self.PitchRotators[k] then
                            self.PitchRotators[k]:Destroy()
                            self.PitchRotators[k] = nil
                        end
                    end                
                end
                self.losttarget = false      
                self.initialaim = true
                TDFMachineGunWeapon.PlayFxWeaponPackSequence(self)
                #self.currentbarrel = 1
            end, 	        
            
            CreateProjectileAtMuzzle = function(self, muzzle)
                if self.initialaim then
                    #CreateRotator(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
                    self.Rotator = CreateRotator(self.unit, 'Spinner', 'y')
                    self.unit.Trash:Add(self.Rotator)
                    self.Goal = 0
                
                    #Get the initial position after unpacking
                    local barrel = self.currentbarrel
                    self.restdirvector.x, self.restdirvector.y, self.restdirvector.z = self.unit:GetBoneDirection( barrelBones[barrel] )
                    local basedirvector = {}
                    basedirvector.x, basedirvector.y, basedirvector.z  = self.unit:GetBoneDirection('Launcher_Muzzle')
                    self.basediftorest = Util.GetAngleInBetween(self.restdirvector, basedirvector)
                end
                if self.losttarget or self.initialaim then
                    #Setting pitch to aim barrel
                    local dirvector = {}
                    dirvector.x, dirvector.y, dirvector.z  = self.unit:GetBoneDirection('Launcher_Muzzle')
                    local basedirvector = {}
                    basedirvector.x, basedirvector.y, basedirvector.z  = self.unit:GetBoneDirection('Launcher_Muzzle')
                    local basediftoaim = Util.GetAngleInBetween(dirvector, basedirvector)
                    self.pitchdif = self.basediftorest - basediftoaim
                    if self.losttarget then
                        self.losttarget = false
                    end 
                    if self.initialaim then
                        self.initialaim = false
                    end 
                end
                
                local muzzleIdx = 0
                for i=1, self.unit:GetBoneCount() do
                    if self.unit:GetBoneName(i) == 'Launcher_Muzzle' then
                        muzzleIdx = i
                        break
                    end
                end
                
                TDFMachineGunWeapon.CreateProjectileAtMuzzle(self, muzzleIdx)
            end,         
            
            PlayFxRackSalvoReloadSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(200)
                end
                TDFMachineGunWeapon.PlayFxRackSalvoChargeSequence(self)
            end,
            PlayRackRecoil = function(self, rackList)
                #self:ForkThread(self:FakeRecoil())
                local currentfakerack = {}
                currentfakerack.RackBone = recoilBones[self.currentbarrel]
                currentfakerack.MuzzleBones = muzzleBones[self.currentbarrel]
                
                table.insert( rackList, currentfakerack )
                TDFMachineGunWeapon.PlayRackRecoil(self, rackList)
                if not self.losttarget then
                    self.Rotator:SetSpeed(120)
                    self.Goal = self.Goal + 60
                    if self.Goal >= 360 then
                        self.Goal = 0
                    end
                    WaitSeconds(0.5)
                    self.Rotator:SetGoal(self.Goal)
                    self.currentbarrel = self.currentbarrel + 1
                    #Increment barrel number
                    if self.currentbarrel > 6 then
                        self.currentbarrel = 1
                    end
                    self.rotatedbarrel = true
                end
            end, 			
        },
    },

    Parent = nil,

    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.Pod = podName
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Parent:NotifyOfPodDeath(self.Pod)
        self.Parent = nil
        DummyUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
	  
}
TypeClass = R_Shotgun