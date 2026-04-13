-- Loader com proteção + execução sequencial

local function Load(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)

    if ok then
        return res
    else
        warn("Erro ao carregar:", url)
        return nil
    end
end

local function Shield(code)
    local func, err = loadstring(code)

    if not func then
        warn("Erro ao compilar:", err)
        return false
    end

    local ok, execErr = pcall(func)

    if not ok then
        warn("Erro na execução:", execErr)
        return false
    end

    return true
end

-- 🔐 1. Executa proteção primeiro
local protectionCode = Load("https://raw.githubusercontent.com/bonatzz/Aim.lua/refs/heads/main/Protection.lua")

if protectionCode then
    Shield(protectionCode)
end

-- 🎯 2. Depois executa o Aimbot
local aimCode = Load("https://raw.githubusercontent.com/bonatzz/Aim.lua/refs/heads/main/Aimbot.lua")

if aimCode then
    Shield(aimCode)
end
