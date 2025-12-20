
local OldOnSync = OnSync
function OnSync()
	OldOnSync ()
	
	if Sync.EnableButton == true then
	import('/mods/Mechdivers/UI/RefWindow.lua').ManageUI(true)
	elseif Sync.EnableButton == false then
	import('/mods/Mechdivers/UI/RefWindow.lua').ManageUI(false)
	end
	
end
