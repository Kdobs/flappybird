---@diagnostic disable: undefined-global --vs code does not like the love funcitons
-- 0, 0 is the top left kinda makes things invereted for y(not cool)
-- must save before anything takes effect when running using alt L
 
-- might be easier to create one pipe object then draw both the upper and lower pipe from the frist pipe position


function love.load()
    Bird = {}
    Bird.y = 200
    Bird.x = 300
    Bird.width = 25
    Bird.yVel = 0 
    Score = 0
    love.graphics.setBackgroundColor(.14, .36, .46) -- light blue 
    love.window.setMode(0,0)
    Width, Height = love.graphics.getDimensions( )
    ActivePipes = 0 -- number of active pipes decrement when a pipe is destroyed increment when a pipe is created max will be 4
    PipeQueue = List.new() -- creates a queue push to the right pop from the left
    Timer = 4 -- needed for timeing the pipes
end
local Pause = false
function love.update(dt)
    if Pause then --prevents the update fucntion from running to pause the game 
        -- put pause menu here
        return 
        end  

    Bird.yVel = Bird.yVel + (516 * dt)
    Bird.y = Bird.y + (Bird.yVel * dt)
    Timer = Timer + dt
    Outofbounds()
    
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
            Hitdetection(currentpipe) -- check for hit detection
            if currentpipe.x >= -175 then --only puts the pipe back in the queue if it is on the screen should be destroyed by the garbage collector
                currentpipe.x = currentpipe.x - 1
                currentpipe.x2 = currentpipe.x2 - 1
                
                List.pushright(PipeQueue, currentpipe)
            else
                ActivePipes = ActivePipes -1
                Score = Score + 1
            end
            
        end
    end
    
end

function love.draw()
    --drawing the bird
    love.graphics.setColor(255, 255, 0)
    love.graphics.circle("fill", Bird.x, Bird.y, Bird.width) --draw the bird
    -- draw the pipes
    for i = 1, ActivePipes do
        local currentpipe = List.popleft(PipeQueue)
        love.graphics.rectangle("fill", currentpipe.x, currentpipe.y, currentpipe.width, currentpipe.height) -- top pipe or x,y
        love.graphics.rectangle("fill", currentpipe.x2, currentpipe.y2, currentpipe.width2, currentpipe.height2) -- bottom pipe or x2,y2
        List.pushright(PipeQueue, currentpipe)
    end
    love.graphics.print(Score,100, 100, 0, 2,2)
end

function love.keypressed(key)
    if key == "w" then -- jump
        if Bird.y > 0 then 
            Bird.yVel = -165
        end
    end
    if key == "e" then --exit
        love.event.quit()
    end
    if key == "p" then 
        Pause = not Pause
        
    end
    if key == "r" then
        Reset()
    end
end

function PipeGenerator()
    -- this function will create a pipe object with the randomized position
    local newpipe = {}
    local pipewidth = 175 -- final pipe width
    -- local positon = 1 -- testing positions
    local positon = math.random(3) -- random number between 1 and 3 for high middle and low position
    local pipegap = 150 -- pixel gap between the pipes
    local offset  = 150 -- offset for the high and low pipes

    -- x, y top pipe and x2, y2 are bottom pipes
    if positon == 1 then -- high position
        --top pipe
        newpipe.x = Width
        newpipe.y = 0
        newpipe.width = pipewidth
        newpipe.height = Height / 2 - pipegap - offset
        --bottom pipe
        newpipe.x2 = Width
        newpipe.y2 = Height / 2 - offset
        newpipe.width2 = pipewidth
        newpipe.height2 = Height / 2 + offset

    elseif positon == 2 then -- middle position
        --top pipe
        newpipe.x = Width
        newpipe.y = 0
        newpipe.width = pipewidth
        newpipe.height = Height / 2 - pipegap /2
        --bottom pipe
        newpipe.x2 = Width
        newpipe.y2 = Height / 2 + 75
        newpipe.width2 = pipewidth
        newpipe.height2 = Height / 2 + pipegap/2

    else -- low position
        --top pipe
        newpipe.x = Width
        newpipe.y = 0
        newpipe.width = pipewidth
        newpipe.height = Height / 2 + offset
        --bottom pipe
        newpipe.x2 = Width
        newpipe.y2 = Height / 2 + pipegap + offset
        newpipe.width2 = pipewidth
        newpipe.height2 = Height/ 2 + pipegap + offset
    end
    return newpipe
end

function Reset()
    love.event.quit("restart") -- reset the game state 
end

function Hitdetection(pipe)
    --this function detects when the bird hits a pipe
    -- check the top pipe
    if(pipe.x < Bird.x + Bird.width and pipe.x + pipe.width > Bird.x - Bird.width)then
        if(pipe.y < Bird.y and pipe.y + pipe.height > Bird.y  - Bird.width) then
            Hit()
        end
    end  
    -- check the bottom pipe
    if(pipe.x2 < Bird.x + Bird.width and pipe.x2 + pipe.width2 > Bird.x - Bird.width)then
        if(pipe.y2 < Bird.y + Bird.width and pipe.y2 + pipe.height2 > Bird.y + Bird.width) then
            Hit()
        end
    end  
end

function Hit()
    --call when the bird hits a pipe
    --print("Hit detected")
    Reset()
end

function Outofbounds()
    -- checks if the bird is out of bounds
    if Bird.y < 0 or Bird.y > Height then
        --print("out of bounds")
        Reset()
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