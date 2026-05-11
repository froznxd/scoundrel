return {
    -- font
    FONT_PATH = "assets/m6x11.ttf",
    FONT_SIZE_0 = 24,
    FONT_SIZE_1 = 32,
    FONT_SIZE_2 = 36,

    -- player
    PLAYER_MAX_HP = 20,

    -- card
    CARD_BASE_SCALE = 2,
    CARD_DRAG_SCALE = 2,
    CARD_LERP_SPEED = 20,
    CARD_SCALE_LERP_SPEED = 32,
    CARD_SNAP_RADIUS = 100,
    CARD_WIDTH = 100,
    CARD_HEIGHT = 150,

    SLOT_SPACING = 20,

    DECK_CARDS = {
        { suit = "spades",   rank = "K",  class = "monster" },
        { suit = "spades",   rank = "Q",  class = "monster" },
        { suit = "spades",   rank = "J",  class = "monster" },
        { suit = "spades",   rank = "10", class = "monster" },
        { suit = "spades",   rank = "9",  class = "monster" },
        { suit = "spades",   rank = "8",  class = "monster" },
        { suit = "spades",   rank = "7",  class = "monster" },
        { suit = "spades",   rank = "6",  class = "monster" },
        { suit = "spades",   rank = "5",  class = "monster" },
        { suit = "spades",   rank = "4",  class = "monster" },
        { suit = "spades",   rank = "3",  class = "monster" },
        { suit = "spades",   rank = "2",  class = "monster" },
        { suit = "spades",   rank = "A",  class = "monster" },
        { suit = "hearts",   rank = "K",  class = "health" },
        { suit = "hearts",   rank = "Q",  class = "health" },
        { suit = "hearts",   rank = "J",  class = "health" },
        { suit = "hearts",   rank = "10", class = "health" },
        { suit = "hearts",   rank = "9",  class = "health" },
        { suit = "hearts",   rank = "8",  class = "health" },
        { suit = "hearts",   rank = "7",  class = "health" },
        { suit = "hearts",   rank = "6",  class = "health" },
        { suit = "hearts",   rank = "5",  class = "health" },
        { suit = "hearts",   rank = "4",  class = "health" },
        { suit = "hearts",   rank = "3",  class = "health" },
        { suit = "hearts",   rank = "2",  class = "health" },
        { suit = "hearts",   rank = "A",  class = "health" },
        { suit = "diamonds", rank = "K",  class = "weapon" },
        { suit = "diamonds", rank = "Q",  class = "weapon" },
        { suit = "diamonds", rank = "J",  class = "weapon" },
        { suit = "diamonds", rank = "10", class = "weapon" },
        { suit = "diamonds", rank = "9",  class = "weapon" },
        { suit = "diamonds", rank = "8",  class = "weapon" },
        { suit = "diamonds", rank = "7",  class = "weapon" },
        { suit = "diamonds", rank = "6",  class = "weapon" },
        { suit = "diamonds", rank = "5",  class = "weapon" },
        { suit = "diamonds", rank = "4",  class = "weapon" },
        { suit = "diamonds", rank = "3",  class = "weapon" },
        { suit = "diamonds", rank = "2",  class = "weapon" },
        { suit = "diamonds", rank = "A",  class = "weapon" },
        { suit = "clubs",    rank = "K",  class = "monster" },
        { suit = "clubs",    rank = "Q",  class = "monster" },
        { suit = "clubs",    rank = "J",  class = "monster" },
        { suit = "clubs",    rank = "10", class = "monster" },
        { suit = "clubs",    rank = "9",  class = "monster" },
        { suit = "clubs",    rank = "8",  class = "monster" },
        { suit = "clubs",    rank = "7",  class = "monster" },
        { suit = "clubs",    rank = "6",  class = "monster" },
        { suit = "clubs",    rank = "5",  class = "monster" },
        { suit = "clubs",    rank = "4",  class = "monster" },
        { suit = "clubs",    rank = "3",  class = "monster" },
        { suit = "clubs",    rank = "2",  class = "monster" },
        { suit = "clubs",    rank = "A",  class = "monster" },
    },

    SUITS = { SPADES = "spades", HEARTS = "hearts", CLUBS = "clubs", DIAMONDS = "diamonds" },
    RANKS = { "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A" },
    CLASSES = { MONSTER = "monster", HEALTH = "health", WEAPON = "weapon" },

    VALUE_MAP = {
        ["2"] = 2,
        ["3"] = 3,
        ["4"] = 4,
        ["5"] = 5,
        ["6"] = 6,
        ["7"] = 7,
        ["8"] = 8,
        ["9"] = 9,
        ["10"] = 10,
        ["J"] = 11,
        ["Q"] = 12,
        ["K"] = 13,
        ["A"] = 14,
    },

    -- Green colors
    GREEN_COLOR = { 20 / 255, 65 / 255, 44 / 255 },
    GREEN_HOVER_COLOR = { 20 / 255, 80 / 255, 50 / 255 },
    GREEN_TEXT_COLOR = { 200 / 255, 229 / 255, 190 / 255 },

    -- Red colors
    RED_COLOR = { 0.75, 0.25, 0.25 },
    RED_HOVER_COLOR = { 0.85, 0.35, 0.35 },

    -- Blue colors
    BLUE_COLOR = { 0 / 255, 45 / 255, 80 / 255 },
    BLUE_HOVER_COLOR = { 0 / 255, 55 / 255, 90 / 255 },
    BLUE_TEXT_COLOR = { 210 / 255, 235 / 255, 255 / 255 },

    -- Yellow colors
    YELLOW_COLOR = { 0.75, 0.75, 0.25 },
    YELLOW_HOVER_COLOR = { 0.85, 0.85, 0.35 },

    -- Gold
    GOLD_COLOR = { 255 / 255, 170 / 255, 0 / 255 },
    GOLD_HOVER_COLOR = { 255 / 255, 185 / 255, 0 / 255 },

    -- Purple colors
    PURPLE_COLOR = { 0.5, 0.25, 0.5 },
    PURPLE_HOVER_COLOR = { 0.6, 0.35, 0.6 },

    -- White color
    WHITE_COLOR = { 1, 1, 1 },

    -- Gray color
    GRAY_COLOR = { 169 / 255, 154 / 255, 147 / 255 },
}
