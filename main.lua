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
    ActivePipes = 0 -- number of active pipes decrement when a pipe is destroyed increment when a pipe is created max will be 4
    PipeQueue = List.new() -- creates a queue push to the right pop from the left

end
function love.update(dt)
    Bird.yVel = Bird.yVel + (516 * dt)
    Bird.y = Bird.y + (Bird.yVel * dt)
    if ActivePipes < 4 then
        local pipe = PipeGenerator() --create pipes
        List.pushright(PipeQueue, pipe) -- adding the pipe to the queue 
        ActivePipes = ActivePipes + 1
    end
    if (ActivePipes > 0) then
        -- need to loop through the queue to move the pipes, remove pipes 
        for i = 1, ActivePipes do
            local pipecheck = List.popleft(PipeQueue)
            pipecheck.x = pipecheck.x + 20
            pipecheck.x2 = pipecheck.x2 + 20
        end
    end
    
    love.reset()
end

function love.draw()
    love.graphics.setColor(255, 255, 0)
    love.graphics.circle("fill", 250, Bird.y, 25)
    
    love.graphics.rectangle("fill",Width-500, 0, 200, Height /2 )
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
    local newpipe = {}
    
    local positon = math.random(3) -- random number between 1 and 3 for high middle and low position
    if positon == 1 then -- high position
        newpipe.x = Width
        newpipe.y = Height / 4
        newpipe.x2 = Width
        newpipe.y2 = Height / 2

    elseif positon == 2 then -- middle position
        newpipe.x = Width
        newpipe.y =  Height / 3
        newpipe.x2 = Width
        newpipe.y2 = Height / 3

    else -- low position
        newpipe.x = Width
        newpipe.y = Height / 2
        newpipe.x2 = Width
        newpipe.y2 = Height / 4
        
    end
    return newpipe
end

function love.reset()
    -- resets the bird if it falls off the screen will also need to add rest if it hits the pipes
    if Bird.y < 0 or Bird.y > 1080 then
        Bird.y = 200
        Bird.yVel = 0
    end
end

--need to implement a queue for pipe managment
    -- from the lua website  https://www.lua.org/pil/11.4.html
    List = {}
    function List.new ()
      return {first = 0, last = -1}
    end

    function List.pushleft (list, value)
        local first = list.first - 1
        list.first = first
        list[first] = value
      end
      
      function List.pushright (list, value)
        local last = list.last + 1
        list.last = last
        list[last] = value
      end
      
      function List.popleft (list)
        local first = list.first
        if first > list.last then error("list is empty") end
        local value = list[first]
        list[first] = nil        -- to allow garbage collection
        list.first = first + 1
        return value
      end
      
      function List.popright (list)
        local last = list.last
        if list.first > last then error("list is empty") end
        local value = list[last]
        list[last] = nil         -- to allow garbage collection
        list.last = last - 1
        return value
      end