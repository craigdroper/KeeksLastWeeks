
ClubGUtils = Class{}

function ClubGUtils:renderScore(score)
    -- White font in top left corner
    local font = gFonts['large']
    local text = string.format('%d', score)
    local textW = font:getWidth(text)
    love.graphics.setFont(font)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(text, 0, 0)
    love.graphics.setColor(255, 255, 255, 255)
end

function ClubGUtils:renderHealth(health)
    -- Red font in bottom left corner
    local font = gFonts['large']
    local text = string.format('%d', health)
    local textW = font:getWidth(text)
    local textH = font:getHeight()
    love.graphics.setFont(font)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.print(text, 0, VIRTUAL_HEIGHT - textH)
    love.graphics.setColor(255, 255, 255, 255)
end
