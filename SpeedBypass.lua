-- SpeedBypass.lua - Bypass de speed check

local SpeedBypass = {}

function SpeedBypass:BypassSpeedCheck()
    -- Faz movimentos gradualmente pra não disparar speed check
    local player = game:GetService("Players").LocalPlayer
    local char = player.Character
    
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            -- Limita velocidade de movimento
            humanoid.MaxHealth = humanoid.MaxHealth
        end
    end
end

function SpeedBypass:GradualMovement(startPos, endPos, duration)
    local start = tick()
    local player = game:GetService("Players").LocalPlayer
    
    while tick() - start < duration do
        local progress = (tick() - start) / duration
        local newPos = startPos:Lerp(endPos, progress)
        
        if player.Character then
            player.Character:MoveTo(newPos)
        end
        
        wait(0.01)
    end
end

return SpeedBypass
