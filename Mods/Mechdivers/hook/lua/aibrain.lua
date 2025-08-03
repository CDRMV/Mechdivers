local OldAIBrain = AIBrain 


AIBrain = Class(OldAIBrain) {

AIBrainCampaignOptions = {},

GetAIBrainCampaignOptions = function(Array)
AIBrainCampaignOptions = Array
end,


    OnCreateHuman = function(self, planName)
	OldAIBrain.OnCreateHuman(self)
		
		self:ForkThread(self.CheckDetectorTowerStep1)
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

	

} 