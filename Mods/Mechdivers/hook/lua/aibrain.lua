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
		self:ForkThread(self.CheckDeimosAmmuntionStorageStep1)
    end,
	
	OnCreateAI = function(self, planName)
	OldAIBrain.OnCreateAI(self)
		self:ForkThread(self.CheckAssaultDroneStationStep1)
		self:ForkThread(self.CheckDetectorTowerStep1)
		self:ForkThread(self.CheckDetectorFactoryStriderStep1)
		self:ForkThread(self.CheckScoutDroneStep1)
		self:ForkThread(self.CheckCommissarStep1)
		self:ForkThread(self.CheckDeimosAmmuntionMechanic)
		self:ForkThread(self.CheckDeimosAmmuntionStorageStep1)
    end,
	
	DeimosAmmuntionMechanic = function(self)
			local number = 1
	        while true do
			local labs = self:GetListOfUnits(categories.DEIMOSAMMOSTORAGE, true)
			local labs2 = self:GetListOfUnits(categories.DEIMOSARTILLERY, true)
			if table.getn(labs) == 1 and table.getn(labs2) == 1 then
			if labs[number]:GetFractionComplete() == 1 then
				for k in labs2 do			
				local SiloAmount = labs2[k]:GetTacticalSiloAmmoCount()
				local StorageAmount = labs[number]:GetTacticalSiloAmmoCount()
				if SiloAmount == 0 and StorageAmount >= 1 then
				labs[number]:RemoveTacticalSiloAmmo(1)
				labs2[k]:GiveTacticalSiloAmmo(1)
				elseif SiloAmount == 0 and StorageAmount == 0 then
				while true do
				if table.getn(labs) > 1 and labs[number]:GetFractionComplete() == 1 and labs[number]:GetTacticalSiloAmmoCount() > 1 then
				
				else
				if number > table.getn(labs2) then
				number = 1
				else
				number = number + 1
				end
				end
				WaitSeconds(0.1)
				end
				end
				end
			end	
			end
			WaitSeconds(1)
			end
    end,
	
	CheckDeimosAmmuntionStorageStep1 = function(self)
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
				self:ForkThread(self.CheckDeimosAmmuntionStorageStep2)
				break
			end
			WaitSeconds(1)
			end
    end,
	
	CheckDeimosAmmuntionStorageStep2 = function(self)
	        while true do
			local labs = self:GetListOfUnits(categories.DEIMOSAMMOSTORAGE, true)
			if table.getn(labs) >= 1 then
				import("/lua/ScenarioFramework.lua").RestrictEnhancements({})
				self:ForkThread(self.CheckDeimosAmmuntionStorageStep1)
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