local spritesheet = {}

local COLS = 14
local ROWS = 4

local SUITS = { "spades", "hearts", "clubs", "diamonds" }
local RANKS = { "A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K" }

function spritesheet.load(path)
    local sheet = {}
    sheet.image = love.graphics.newImage(path)
    sheet.image:setFilter("nearest", "nearest")

    local imgW = sheet.image:getWidth()
    local imgH = sheet.image:getHeight()
    sheet.cardW = imgW / COLS
    sheet.cardH = imgH / ROWS

    sheet.quads = {}
    sheet.back = love.graphics.newQuad(
        13 * sheet.cardW, 3 * sheet.cardH,
        sheet.cardW, sheet.cardH,
        imgW, imgH
    )

    for row, suit in ipairs(SUITS) do
        sheet.quads[suit] = {}
        for col, rank in ipairs(RANKS) do
            sheet.quads[suit][rank] = love.graphics.newQuad(
                (col - 1) * sheet.cardW, (row - 1) * sheet.cardH,
                sheet.cardW, sheet.cardH,
                imgW, imgH
            )
        end
    end

    return sheet
end

function spritesheet.getQuad(sheet, suit, rank)
    return sheet.quads[suit][rank]
end

function spritesheet.getBack(sheet)
    return sheet.back
end

function spritesheet.getSuits()
    return SUITS
end

function spritesheet.getRanks()
    return RANKS
end

return spritesheet
