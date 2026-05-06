---@class love.Image: userdata
---@class love.Quad: userdata

---@alias Suit "spades"|"hearts"|"clubs"|"diamonds"
---@alias Rank "A"|"2"|"3"|"4"|"5"|"6"|"7"|"8"|"9"|"10"|"J"|"Q"|"K"
---@alias CardClass "monster"|"heal"|"weapon"

---@class Spritesheet
---@field image love.Image
---@field cardW number
---@field cardH number
---@field quads table<Suit, table<Rank, love.Quad>>
---@field back love.Quad

---@class Slot
---@field x number
---@field y number
---@field w number
---@field h number
---@field card Card|nil

---@class Slots
---@field [integer] {x: number, y: number, w: number, h: number, card: Card|nil}

---@class CardDragging
---@field active boolean
---@field diffX number
---@field diffY number
---@
---@class Card
---@field sheet Spritesheet
---@field suit Suit
---@field rank Rank
---@field class CardClass
---@field quad love.Quad
---@field x number
---@field y number
---@field scale number
---@field targetX number
---@field targetY number
---@field dragging CardDragging
---@field isDraggable boolean
---@field width number
---@field height number
---@field faceUp boolean

---@class Player
---@field hp number
---@field weapon number
