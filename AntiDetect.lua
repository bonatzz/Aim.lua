-- AntiDetect.lua - Esconde o script

local AntiDetect = {}

-- Esconde do debugger
function AntiDetect:HideFromDebugger()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local old = mt.__index
    mt.__index = function(self, index)
        if tostring(self) == "LocalScript" or tostring(self) == "ModuleScript" then
            return nil
        end
        return old(self, index)
    end
    
    setreadonly(mt, true)
end

-- Remove sinais de execução
function AntiDetect:RemoveSignatures()
    -- Limpa variáveis globais que denunciam script
    _G.ScriptDetected = nil
    _G.AimbotActive = nil
end

-- Ofusca strings suspeitas
function AntiDetect:ObfuscateStrings()
    local suspicious = {"aimbot", "esp", "cheat", "hack"}
    for _, v in ipairs(suspicious) do
        getfenv()[v:upper()] = nil
    end
end

return AntiDetect
