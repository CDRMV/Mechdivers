
local Explosion = import('/lua/defaultexplosions.lua')

function GetPlayableArea()
    if ScenarioInfo.MapData.PlayableRect then
        return ScenarioInfo.MapData.PlayableRect
    end
    return {0, 0, ScenarioInfo.size[1], ScenarioInfo.size[2]}
end

function SetRotation(unit, angle)
        local qx, qy, qz, qw = Explosion.QuatFromRotation(angle, 0, 1, 0)
        unit:SetOrientation({qx, qy, qz, qw}, true)
end

    ---@param self Unit
    ---@param angle number
function Rotate(unit, angle)
        local qx, qy, qz, qw = unpack(unit:GetOrientation())
        local a = math.atan2(2.0 * (qx * qz + qw * qy), qw * qw + qx * qx - qz * qz - qy * qy)
        local current_yaw = math.floor(math.abs(a) * (180 / math.pi) + 0.5)

        SetRotation(angle + current_yaw)
end

    ---@param self Unit
    ---@param tpos number
function RotateTowards(unit, tpos)
        local pos = unit:GetPosition()
        local rad = math.atan2(tpos[1] - pos[1], tpos[3] - pos[3])
        SetRotation(unit, rad * (180 / math.pi))
end

    ---@param self Unit
function RotateTowardsMid(unit)
        local x, y = GetMapSize()
        RotateTowards(unit, {x / 2, 0, y / 2})
end

