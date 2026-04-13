-- ╔════════════════════════════════════════════════════════════════╗
-- ║     LOADER DELTA - PROTEÇÃO REFORÇADA + AIMBOT INTEGRADO       ║
-- ║                                                                 ║
-- ║  Sistema completo em sequência:                                ║
-- ║  1️⃣  Proteção carrega e ativa (Background)                    ║
-- ║  2️⃣  Aimbot carrega e executa                                 ║
-- ║                                                                 ║
-- ║  ⚠️  EXECUTE APENAS ESTE ARQUIVO NO DELTA                      ║
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

-- ╔════════════════════════════════════════════════════════════════╗
print("\n")
print("═" .. string.rep("═", 58))
print("║" .. string.rep(" ", 58) .. "║")
print("║" .. "  ⏳ INICIANDO PIPELINE INTEGRADO - AIM.LUA v4.0".ljust(58) .. "║")
print("║" .. string.rep(" ", 58) .. "║")
print("═" .. string.rep("═", 58))

-- 1️⃣ PROTEÇÃO PRIMEIRO (Background - Lazy Loading)
print("\n🛡️  [ETAPA 1/2] Carregando módulo de proteção reforçada...")
print("   └─ Anti-Detection, Anti-Hook, Anti-Analysis...")

local protectionCode = LoadScript("https://raw.githubusercontent.com/bonatzz/Aim.lua/refs/heads/main/Protection_Reforced.lua")

if protectionCode then
    local Protection = loadstring(protectionCode)()
    if Protection and Protection.init then
        Protection.init()
        print("   ✅ Proteção ativada!")
    end
else
    warn("⚠️  Proteção falhou - continuando mesmo assim...")
end

task.wait(1.5)

-- 2️⃣ AIMBOT DEPOIS (Após proteção estar ativa em background)
print("\n🎯 [ETAPA 2/2] Carregando módulo de aimbot...")
print("   └─ Distâncias adaptativas, delays variados...")

local aimbotCode = LoadScript("https://raw.githubusercontent.com/bonatzz/Aim.lua/refs/heads/main/Aimbot_Main_NoESP.lua")

if aimbotCode then
    Execute(aimbotCode, "Aimbot")
    print("   ✅ Aimbot ativado!")
else
    warn("❌ Aimbot falhou ao carregar")
end

-- ╔════════════════════════════════════════════════════════════════╗
print("\n")
print("═" .. string.rep("═", 58))
print("║" .. string.rep(" ", 58) .. "║")
print("║" .. "  ✅ SISTEMA INTEGRADO E PRONTO PARA USAR!".ljust(58) .. "║")
print("║" .. "  🚀 Bem-vindo ao Aim.lua v4.0 - DELTA MOBILE".ljust(58) .. "║")
print("║" .. string.rep(" ", 58) .. "║")
print("═" .. string.rep("═", 58))
print("\n")
