#****************************************************************************
#**
#**  File     :  /cdimage/units/UEB0103/UEB0103_script.lua
#**  Author(s):  David Tomandl
#**
#**  Summary  :  UEF Tier 1 Naval Factory Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )
local TSeaFactoryUnit = nil
local EffectUtil = import('/lua/EffectUtilities.lua')

if version < 3652 then 
TSeaFactoryUnit = import('/lua/defaultunits.lua').TerminideSeaFactoryUnit
else
TSeaFactoryUnit = import('/mods/Mechdivers/hook/lua/FAFDefaultunits.lua').FAFTerminideSeaFactoryUnit
end

TEB0103 = Class(TSeaFactoryUnit) {    
}

TypeClass = TEB0103