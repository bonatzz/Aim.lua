-- ╔════════════════════════════════════════════════════════════════╗
-- ║            Loader.lua - PROTEÇÃO + AIMBOT INTEGRADO            ║
-- ║                                                                 ║
-- ║  Execute ISTO no seu executor Delta                            ║
-- ║                                                                 ║
-- ║  Sequência automática:                                         ║
-- ║  1️⃣  Protection.lua (carrega)                                 ║
-- ║  2️⃣  Main.lua (aimbot executa)                                ║
-- ║                                                                 ║
-- ╚════════════════════════════════════════════════════════════════╝

local function LoadScript(url)
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    
    if ok then
        return res
    else
        warn("❌ Erro ao carregar:", url)
        return nil
    end
end

local function Execute(code, name)
    if not code then
        warn("❌ " .. name .. " não carregou")
        return false
    end
    
    local func, err = loadstring(code)
    if not func then
        warn("❌ Erro ao compilar " .. name .. ":", err)
        return false
    end
    
    local ok, execErr = pcall(func)
    if not ok then
        warn("❌ Erro na execução de " .. name .. ":", execErr)
        return false
    end
    
    return true
end

print("\n" .. "═":rep(60))
print("⏳ Iniciando Aim.lua...")
print("═":rep(60))

-- 1️⃣ PROTEÇÃO PRIMEIRO
print("\n🛡️  [1/2] Carregando Protection.lua...")
local protectionCode = LoadScript("https://raw.githubusercontent.com/bonatzz/Aim.lua/refs/heads/main/Protection.lua")

if protectionCode then
    local Protection = loadstring(protectionCode)()
    if Protection and Protection.init then
        Protection.init()
    end
else
    warn("⚠️  Proteção falhou")
end

task.wait(1)

-- 2️⃣ AIMBOT DEPOIS
print("\n🎯 [2/2] Carregando Main.lua...")
local mainCode = LoadScript("https://raw.githubusercontent.com/bonatzz/Aim.lua/refs/heads/main/Main.lua")

if mainCode then
    Execute(mainCode, "Main")
else
    warn("❌ Main.lua falhou")
end

print("\n" .. "═":rep(60))
print("✅ Sistema pronto!")
print("═":rep(60) .. "\n")
