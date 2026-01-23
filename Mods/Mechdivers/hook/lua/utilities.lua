
do

local MathSqrt = math.sqrt

function GetDistanceBetweenTwoEntities(entity1, entity2)
if entity1:IsDead() or entity2:IsDead() or entity1:IsDead() and entity2:IsDead() then

else
    local pos1x, pos1y, pos1z = entity1:GetPositionXYZ()
    local pos2x, pos2y, pos2z = entity2:GetPositionXYZ()
    local dx, dy, dz = pos2x - pos1x, pos2y - pos1y, pos2z - pos1z
    return MathSqrt(dx*dx + dy*dy + dz*dz)
end	
end



end