require("src.types")

local Player = {}
Player.__index = Player

---Creates a new instance of Player
---@param hp number
---@param weapon number
---@return Player
function Player.new(hp, weapon)
    local self = setmetatable({}, Player)

    self.hp = hp
    self.weapon = weapon

    return self
end

function Player:takeDamage(damage)
    local currentHP = self.hp

    self.hp = currentHP - damage
    if (currentHP < 0) then self.hp = 0 end
end
