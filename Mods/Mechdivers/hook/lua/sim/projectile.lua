do
DummyProjectile = Class(moho.projectile_methods) {
    ---@param self DummyProjectile
    ---@param inWater? boolean
    OnCreate = function(self, inWater)
        -- expected to be cached by all projectiles
        self.Blueprint = self:GetBlueprint()
        self.Army = self:GetArmy()
    end,

    ---@param self DummyProjectile
    ---@param targetType string
    ---@param targetEntity Unit | Prop
    OnImpact = function(self, targetType, targetEntity)
        self:Destroy()
    end,
}

end