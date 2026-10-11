#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB0101/UEB0101_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Tier 1 Land Factory Script
#**
#**  Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
local TLandFactoryUnit = nil
if version < 3652 then 
TLandFactoryUnit = import('/lua/Defaultunits.lua').BugHole
else
TLandFactoryUnit = import('/mods/Mechdivers/hook/lua/FAFDefaultunits.lua').FAFBugHole
end

TEB0201 = Class(TLandFactoryUnit) {}

TypeClass = TEB0201