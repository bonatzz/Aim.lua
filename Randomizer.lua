local Randomizer = {}

function Randomizer:RandomDelay()
    local delay = math.random(50, 200) / 1000
    wait(delay)
end

function Randomizer:RandomPatterns()
    local patterns = {
        function() wait(math.random(1, 5) / 100) end,
        function() for i = 1, math.random(1, 3) do wait(0.01) end end,
        function() wait(math.random(1, 10) / 1000) end,
    }
    
    patterns[math.random(1, #patterns)]()
end

function Randomizer:HumanizeMouse()
    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
    local oldMove = mouse.Move
    
    mouse.Move = function(self, x, y)
        Randomizer:RandomDelay()
        return oldMove(self, x, y)
    end
end

function Randomizer:JitterMovement(position)
    local jitter = math.random(-5, 5) / 100
    return position + Vector3.new(jitter, jitter, jitter)
end

function Randomizer:VariableSmoothing()
    local smooths = {0.1, 0.15, 0.2, 0.25, 0.3}
    return smooths[math.random(1, #smooths)]
end

return Randomizer
