-- 0, 0 is the top left kinda makes things invereted for y(not cool)
-- must save before anything takes effect when running using alt L



function love.load()
    bird = {}
    bird.y = 200
    bird.yVel = 0 -- need to incoperate velocity for the weighty feel
    love.graphics.setBackgroundColor(.14, .36, .46) -- light blue 
end
function love.update(dt)
    bird.yVel = bird.yVel + (516 * dt)
    bird.y = bird.y + (bird.yVel * dt)
end

function love.draw()

    love.graphics.circle("fill", 250, bird.y, 50)
    
end

function love.keypressed(key)
    if bird.y > 0 then 
        bird.yVel = -165
    end
end




