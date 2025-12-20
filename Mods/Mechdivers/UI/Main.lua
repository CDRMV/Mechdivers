function ManageDialog(boolean)
if boolean == false then
Sync.ManageDialog = boolean
Sync.EnableButton = boolean
else
Sync.ManageDialog = boolean
Sync.EnableButton = boolean
end
end

function ManageButton(Unit)
LOG(Sync.EnableButton)

if Sync.EnableButton == true then

elseif Sync.EnableButton == false then

Sync.ManageDialog = false
elseif Sync.EnableButton == nil then

Sync.ManageDialog = false
end

end

