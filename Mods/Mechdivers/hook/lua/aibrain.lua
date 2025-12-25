local OldAIBrain = AIBrain 


AIBrain = Class(OldAIBrain) {

AIBrainCampaignOptions = {},

GetAIBrainCampaignOptions = function(Array)
AIBrainCampaignOptions = Array
end,


    OnCreateHuman = function(self, planName)
	OldAIBrain.OnCreateHuman(self)
		self:ForkThread(self.CheckAssaultDroneStationStep1)
		self:ForkThread(self.CheckDetectorTowerStep1)
		self:ForkThread(self.CheckDetectorFactoryStriderStep1)
		self:ForkThread(self.CheckScoutDroneStep1)
		self:ForkThread(self.CheckCommissarStep1)
		self:ForkThread(self.DeimosAmmuntionMechanic)
		self:ForkThread(self.DeimosAmmuntionEnhancementManageStep1)
		self:ForkThread(self.DeimosAmmuntionStorageStep1)
		self:ForkThread(self.DeimosArtilleryStep1)
    end,
	
	OnCreateAI = function(self, planName)
	OldAIBrain.OnCreateAI(self)
		self:ForkThread(self.CheckAssaultDroneStationStep1)
		self:ForkThread(self.CheckDetectorTowerStep1)
		self:ForkThread(self.CheckDetectorFactoryStriderStep1)
		self:ForkThread(self.CheckScoutDroneStep1)
		self:ForkThread(self.CheckCommissarStep1)
		self:ForkThread(self.DeimosAmmuntionMechanic)
		self:ForkThread(self.DeimosAmmuntionEnhancementManageStep1)
		self:ForkThread(self.DeimosAmmuntionStorageStep1)
		self:ForkThread(self.DeimosArtilleryStep1)
    end,
	
	DeimosAmmuntionMechanic = function(self)
			local number = 1
	        while true do
			local labs = self:GetListOfUnits(categories.DEIMOSAMMOSTORAGE, true)
			local labs2 = self:GetListOfUnits(categories.DEIMOSARTILLERY, true)
			if table.getn(labs) >= 1 and table.getn(labs2) >= 1 then
			if labs[number]:GetFractionComplete() == 1 then
				for k in labs2 do			
				local SiloAmount = labs2[k]:GetTacticalSiloAmmoCount()
				local StorageAmount = labs[number]:GetTacticalSiloAmmoCount()
				if SiloAmount == 0 and StorageAmount >= 1 then
				labs[number]:RemoveTacticalSiloAmmo(1)
				labs2[k]:GiveTacticalSiloAmmo(1)
				elseif SiloAmount == 0 and StorageAmount == 0 then
				if labs[1]:GetTacticalSiloAmmoCount() >= 1 then
				number = 1
				else
				if table.getn(labs) >= 1 then
				if labs[table.getn(labs)]:GetFractionComplete() == 1 then
				if labs[table.getn(labs)]:GetTacticalSiloAmmoCount() >= 1 then
				if number > table.getn(labs) then
				number = 1
				else
				number = table.getn(labs)
				end
				end
				end
				end
				end
				end
				end
			end	
			end
			WaitSeconds(1)
			end
    end,
	
	DeimosAmmuntionEnhancementManageStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.DEIMOSAMMOSTORAGE, true)
			if table.getn(labs) == 0 then
				import("/lua/ScenarioFramework.lua").RestrictEnhancements({
				'ExplosiveGrenade',
				'HighYieldExplosiveGrenade',
				'MiniNukeGrenade',
				'NapalmGrenade',
				'StunGrenade',
				'SmokeGrenade',
				})
				self:ForkThread(self.DeimosAmmuntionEnhancementManageStep2, 0)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	DeimosAmmuntionEnhancementManageStep2 = function(self, number)
	        while true do
			local labs = self:GetListOfUnits(categories.DEIMOSAMMOSTORAGE, true)
			if table.getn(labs) >= 1 and labs[1]:GetFractionComplete() == 1 then
				for c in labs do
				if labs[c]:GetTacticalSiloAmmoCount() >= 1 then
				import("/lua/ScenarioFramework.lua").RestrictEnhancements({})
				local labs2 = self:GetListOfUnits(categories.DEIMOSARTILLERY, true)
				for k in labs2 do
				if number == 0 then
				labs2[k]:RequestRefreshUI()
				number = 1
				end
				end
				self:ForkThread(self.DeimosAmmuntionEnhancementManageStep1)
				break
				elseif labs[c]:GetTacticalSiloAmmoCount() == 0 then
				import("/lua/ScenarioFramework.lua").RestrictEnhancements({
				'ExplosiveGrenade',
				'HighYieldExplosiveGrenade',
				'MiniNukeGrenade',
				'NapalmGrenade',
				'StunGrenade',
				'SmokeGrenade',
				})
				local labs2 = self:GetListOfUnits(categories.DEIMOSARTILLERY, true)
				for k in labs2 do
				if number == 1 then
				labs2[k]:RequestRefreshUI()
				number = 0
				end
				end
				self:ForkThread(self.DeimosAmmuntionEnhancementManageStep1)
				break
				end
				end
			end
			WaitSeconds(1)
			end
    end,
	
	DeimosAmmuntionStorageStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.DEIMOSAMMOSTORAGE, true)
			if table.getn(labs) >= 1 then
				AddBuildRestriction(self:GetArmyIndex(), categories.DEIMOSAMMOSTORAGE)
				self:ForkThread(self.DeimosAmmuntionStorageStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	DeimosAmmuntionStorageStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.DEIMOSAMMOSTORAGE, true)
			if table.getn(labs) < 1  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.DEIMOSAMMOSTORAGE)
				self:ForkThread(self.DeimosAmmuntionStorageStep1)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	DeimosArtilleryStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.DEIMOSARTILLERY, true)
			if table.getn(labs) >= 3 then
				AddBuildRestriction(self:GetArmyIndex(), categories.DEIMOSARTILLERY)
				self:ForkThread(self.DeimosArtilleryStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	DeimosArtilleryStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.DEIMOSARTILLERY, true)
			if table.getn(labs) < 1  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.DEIMOSARTILLERY)
				self:ForkThread(self.DeimosArtilleryStep1)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckAssaultDroneStationStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.ASSAULTDRONESTATION, true)
			if table.getn(labs) >= 6 then
				AddBuildRestriction(self:GetArmyIndex(), categories.ASSAULTDRONESTATION)
				self:ForkThread(self.CheckAssaultDroneStationStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckAssaultDroneStationStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.ASSAULTDRONESTATION, true)
			if table.getn(labs) < 6  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.ASSAULTDRONESTATION)
				self:ForkThread(self.CheckAssaultDroneStationStep1)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckDetectorTowerStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.DETECTORTOWER, true)
			if table.getn(labs) >= 3 then
				AddBuildRestriction(self:GetArmyIndex(), categories.DETECTORTOWER)
				self:ForkThread(self.CheckDetectorTowerStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckDetectorTowerStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.DETECTORTOWER, true)
			if table.getn(labs) < 3  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.DETECTORTOWER)
				self:ForkThread(self.CheckDetectorTowerStep1)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckDetectorFactoryStriderStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.DETECTORFACTORYSTRIDER, true)
			if table.getn(labs) >= 3 then
				AddBuildRestriction(self:GetArmyIndex(), categories.DETECTORFACTORYSTRIDER)
				self:ForkThread(self.CheckDetectorFactoryStriderStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckDetectorFactoryStriderStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.DETECTORFACTORYSTRIDER, true)
			if table.getn(labs) < 3  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.DETECTORFACTORYSTRIDER)
				self:ForkThread(self.CheckDetectorFactoryStriderStep1)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckScoutDroneStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.SCOUTDRONE, true)
			if table.getn(labs) >= 3 then
				AddBuildRestriction(self:GetArmyIndex(), categories.SCOUTDRONE)
				self:ForkThread(self.CheckScoutDroneStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckScoutDroneStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.SCOUTDRONE, true)
			if table.getn(labs) < 3  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.SCOUTDRONE)
				self:ForkThread(self.CheckScoutDroneStep1)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckCommissarStep1 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.OFFICER, true)
			if table.getn(labs) >= 3 then
				AddBuildRestriction(self:GetArmyIndex(), categories.OFFICER)
				self:ForkThread(self.CheckCommissarStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckCommissarStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.OFFICER, true)
			if table.getn(labs) < 3  then
				RemoveBuildRestriction(self:GetArmyIndex(), categories.OFFICER)
				self:ForkThread(self.CheckCommissarStep1)
				break
			end
			WaitSeconds(1)
			end
    end,

	

} 