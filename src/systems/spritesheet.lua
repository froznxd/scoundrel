local spritesheet = {}

local COLS = 13
local ROWS = 4

local SUITS = { "spades", "clubs", "hearts", "diamonds" }
local RANKS = { "A", "K", "Q", "J", "10", "9", "8", "7", "6", "5", "4", "3", "2" }

function spritesheet.load(sheetPath, backPath)
    local sheet = {}
    sheet.image = love.graphics.newImage(sheetPath)
    sheet.image:setFilter("nearest", "nearest")

    local imgW = sheet.image:getWidth()
    local imgH = sheet.image:getHeight()
    sheet.cardW = imgW / COLS
    sheet.cardH = imgH / ROWS

    sheet.backImage = love.graphics.newImage(backPath)
    sheet.backImage:setFilter("nearest", "nearest")

    sheet.quads = {}

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
    return sheet.backImage
end

function spritesheet.getSuits()
    return SUITS
end

function spritesheet.getRanks()
    return RANKS
end

return spritesheet
