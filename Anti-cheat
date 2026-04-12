-- AntiCheat.lua - Anti-detecção de aimbot

local AntiCheat = {}

-- Esconde a atividade do script
function AntiCheat:HideActivity()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    
    setreadonly(mt, false)
    mt.__namecall = function(self, ...)
        local args = {...}
        local method = args[#args]
        
        -- Bloqueia detecção de scripts
        if method == "FindFirstChild" and args[1] == "Script" then
            return nil
        end
        
        return oldNamecall(self, ...)
    end
    setreadonly(mt, true)
end

-- Bypass de detecção de teleporte
function AntiCheat:TeleportBypass()
    local oldMoveTo = game:GetService("Players").LocalPlayer.Character.MoveTo
    if oldMoveTo then
        game:GetService("Players").LocalPlayer.Character.MoveTo = function(self, position)
            -- Faz teleporte gradual pra não detectar
            local steps = 5
            local start = self.Position
            for i = 1, steps do
                wait(0.01)
                self:MoveTo(start:Lerp(position, i / steps))
            end
        end
    end
end

-- Anti-lag detection
function AntiCheat:AntiLagDetect()
    -- Mantém FPS estável pra não detectar lag
    local lastTime = tick()
    while true do
        wait()
        local now = tick()
        if now - lastTime > 1 then
            -- Detectou lag, compensar
            lastTime = now
        end
    end
end

return AntiCheat
