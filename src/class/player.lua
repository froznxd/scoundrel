require("src.types")
local constants = require("src.constants")
local utils = require("src.utils")

local Player = {}
Player.__index = Player

---Creates a new instance of Player
---@param hp number
---@param weapon Card|nil
---@return Player
function Player.new(hp, weapon)
    local self = setmetatable({}, Player)

    self.hp = hp
    self.weapon = weapon
    self.weaponDamage = 0
    self.isWeaponEquipped = false

    return self
end

---player takes weapon damage
---@param card Card damage amount: 2 - 14
function Player:takeDamage(card)
    if (card.class ~= constants.CLASSES.MONSTER) then return end

    local monsterDamage = card.value
    local currentHP = self.hp
    local weaponDamage = self.weaponDamage

    local totalDamage = 0

    if (monsterDamage <= weaponDamage) then
        totalDamage = 0
    else
        totalDamage = monsterDamage - weaponDamage
    end

    self.hp = currentHP - totalDamage
    if (self.hp < 0) then self.hp = 0 end
end

---player heals hp
---@param card Card heal amount: 2 - 14
function Player:heal(card)
    if (card.class ~= constants.CLASSES.HEALTH) then return end

    local healAmount = card.value
    local currentHP = self.hp

    self.hp = currentHP + healAmount
    if (self.hp > constants.PLAYER_MAX_HP) then
        self.hp = constants.PLAYER_MAX_HP
    end
end

---player equips a weapon
---@param card Card
function Player:equipWeapon(card)
    if (card.class ~= constants.CLASSES.WEAPON) then return end

    self.weapon = card
    self.weaponDamage = card.value
    self.isWeaponEquipped = true
end

return Player
