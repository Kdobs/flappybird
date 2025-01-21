---@diagnostic disable: undefined-global
-- 0, 0 is the top left kinda makes things invereted for y(not cool)
-- must save before anything takes effect when running using alt L

-- rectangels need at least 100 pixels of gap 
-- might be easier to create one pipe object then draw both the upper and lower pipe from the frist pipe position

function love.load()
    Bird = {}
    Bird.y = 200
    Bird.x = 300
    Bird.yVel = 0 
    love.graphics.setBackgroundColor(.14, .36, .46) -- light blue 
    love.window.setMode(0,0)
    Width, Height = love.graphics.getDimensions( )
    ActivePipes = 0 -- number of active pipes decrement when a pipe is destroyed increment when a pipe is created max will be 4
    PipeQueue = List.new() -- creates a queue push to the right pop from the left
    Timer = 4 -- needed for timeing the pipes
end
function love.update(dt)
    Bird.yVel = Bird.yVel + (516 * dt)
    Bird.y = Bird.y + (Bird.yVel * dt)
    Timer = Timer + dt
    
    if ActivePipes < 4 and Timer >= 4 then --should trigger every 5 seconds
        Timer = 0 --reset timer    
        local pipe = PipeGenerator() --create pipes
        List.pushright(PipeQueue, pipe) -- adding the pipe to the queue 
        ActivePipes = ActivePipes + 1
        
    end
    if (ActivePipes > 0) then
        -- need to loop through the queue to move the pipes, remove pipes 
        for i = 1, ActivePipes do
            -- takes a pipe out of the queue moves it and stores it again
            local currentpipe = List.popleft(PipeQueue)
            if currentpipe.x >= -175 then --only puts the pipe back in the queue if it is on the screen should be destroyed by the garbage collector
                currentpipe.x = currentpipe.x - 1
                currentpipe.x2 = currentpipe.x2 - 1
                List.pushright(PipeQueue, currentpipe)
            else
                ActivePipes = ActivePipes -1
            end
        end
    end
    
    love.reset()
end

function love.draw()
    love.graphics.setColor(255, 255, 0)
    love.graphics.circle("fill", 250, Bird.y, 25)
    for i = 1, ActivePipes do
        local currentpipe = List.popleft(PipeQueue)
        love.graphics.rectangle("fill", currentpipe.x, currentpipe.y, 175, currentpipe.y) -- top pipe or x,y
        love.graphics.rectangle("fill", currentpipe.x2, currentpipe.y2, 175, currentpipe.y2) -- bottom pipe or x2,y2
        List.pushright(PipeQueue, currentpipe)
    end
    love.graphics.print(ActivePipes,100, 100)
    

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
    local pipewidth = 175 -- final pipe width
    local positon = math.random(3) -- random number between 1 and 3 for high middle and low position
    -- x, y top pipe and x2,y2 are bottom pipes
    if positon == 1 then -- high position
        newpipe.x = Width       
        newpipe.y = Height / 2
        newpipe.width = pipewidth
        newpipe.height = 200
        newpipe.x2 = Width
        newpipe.y2 = Height / 2
        newpipe.widht2 = pipewidth
        newpipe.height2 = 200

    elseif positon == 2 then -- middle position
        newpipe.x = Width
        newpipe.y = Height / 3
        newpipe.width = pipewidth
        newpipe.height = 200
        newpipe.x2 = Width
        newpipe.y2 = Height / 3
        newpipe.widht2 = pipewidth
        newpipe.height2 = 200

    else -- low position
        newpipe.x = Width
        newpipe.y = Height / 4
        newpipe.width = pipewidth
        newpipe.height = 200
        newpipe.x2 = Width
        newpipe.y2 = Height / 2
        newpipe.widht2 = pipewidth
        newpipe.height2 = 200
        
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