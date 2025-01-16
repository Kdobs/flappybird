---@diagnostic disable: undefined-global
-- 0, 0 is the top left kinda makes things invereted for y(not cool)
-- must save before anything takes effect when running using alt L

-- rectangels need at least 100 pixels of gap 
-- might be easier to create one pipe object then draw both the upper and lower pipe from the frist pipe position

function love.load()
    Bird = {}
    Bird.y = 200
    Bird.yVel = 0 
    love.graphics.setBackgroundColor(.14, .36, .46) -- light blue 
    love.window.setMode(0,0)
    Width, Height = love.graphics.getDimensions( )
end
function love.update(dt)
    Bird.yVel = Bird.yVel + (516 * dt)
    Bird.y = Bird.y + (Bird.yVel * dt)
    love.reset()
end

function love.draw()
    love.graphics.setColor(255, 255, 0)
    love.graphics.circle("fill", 250, Bird.y, 25)
    love.graphics.rectangle("fill",Width - 500, Height - 500, 200, Height /2 )
end

function love.keypressed(key)
    if key == "w" then
        if Bird.y > 0 then 
            Bird.yVel = -165
        end
    end
    if key == "e" then
        love.window.close()
    end
end

function PipeGenerator()
    -- this function will create a pipe object with the randomized position
    local pipe = {}
    local positon = math.random(3) -- random number between 1 and 3 for high middle and low position
    if positon == 1 then -- high position
        pipe.x = 0
        pipe.y = 0

    elseif positon == 2 then -- middle position
        pipe.x = 0
        pipe.y = 0

    else -- low position
        pipe.x = 0
        pipe.y = 0
        
    end
    return pipe
end

function love.reset()
    -- resets the bird if it falls off the screen will also need to add rest if it hits the pipes
    if Bird.y < 0 or Bird.y > 1080 then
        Bird.y = 200
        Bird.yVel = 0
    end
end
