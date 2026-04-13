-- SandboxEscape.lua - Sistema avançado de bypass de sandbox e restrições
local SandboxEscape = {}

-- ==================== CONFIGURAÇÃO ====================
local CONFIG = {
    ENABLE_METATABLE_ESCAPE = true,
    ENABLE_LOADSTRING_BYPASS = true,
    ENABLE_MEMORY_ACCESS = true,
    ENABLE_OUTPUT_FILTERING = true,
    ENABLE_ENVIRONMENT_MANIPULATION = true,
}

local STATE = {
    escapeAttempts = 0,
    maxEscapeAttempts = 10,
    sandboxLevel = 0,
    originalFunctions = {},
}

-- ==================== DETECÇÃO E ESCAPE DE METATABLE ====================
function SandboxEscape:DetectAndEscapeMetatable()
    if not CONFIG.ENABLE_METATABLE_ESCAPE then return end
    
    local escapeThread = coroutine.create(function()
        while true do
            wait(math.random(2, 8))
            
            pcall(function()
                local mt = getrawmetatable(game)
                
                -- Tenta diferentes métodos de escape
                local methods = {
                    function()
                        setreadonly(mt, false)
                        return true
                    end,
                    function()
                        local success = pcall(function()
                            for k, v in pairs(mt) do
                                -- Tenta acessar diretamente
                            end
                        end)
                        return success
                    end,
                    function()
                        -- Tenta explorar através de __index
                        local newMt = {}
                        for k, v in pairs(mt) do
                            if type(v) == "function" then
                                newMt[k] = v
                            end
                        end
                        return true
                    end,
                }
                
                for _, method in ipairs(methods) do
                    if method() then
                        STATE.escapeAttempts = 0
                        break
                    else
                        STATE.escapeAttempts = STATE.escapeAttempts + 1
                    end
                end
                
                -- Se conseguiu escape
                if STATE.escapeAttempts == 0 then
                    SandboxEscape:ModifyMetatable(mt)
                end
            end)
        end
    end)
    
    coroutine.resume(escapeThread)
end

function SandboxEscape:ModifyMetatable(mt)
    pcall(function()
        -- Tenta tornar metatable modificável
        if not isreadonly(mt) then
            -- Modifica __index pra retornar dados privados
            local originalIndex = mt.__index
            
            mt.__index = function(self, key)
                -- Ocasionalmente permite acesso a dados privados
                if math.random() < 0.1 then
                    local privateData = rawget(self, "_private_" .. key)
                    if privateData then
                        return privateData
                    end
                end
                
                return originalIndex(self, key)
            end
        end
    end)
end

-- ==================== BYPASS AVANÇADO DE LOADSTRING ====================
function SandboxEscape:BypassLoadstringAdvanced()
    if not CONFIG.ENABLE_LOADSTRING_BYPASS then return end
    
    local originalLoadstring = loadstring
    STATE.originalFunctions.loadstring = originalLoadstring
    
    loadstring = function(code, chunkname)
        -- Detecta restrictions
        local restrictions = {
            "debug\.", "getfenv", "setfenv", "rawget", "rawset",
            "getmetatable", "setmetatable", "load", "_G%."
        }
        
        local hasRestrictions = false
        for _, restriction in ipairs(restrictions) do
            if code:find(restriction) then
                hasRestrictions = true
                break
            end
        end
        
        -- Se tem restrictions, tenta contornar
        if hasRestrictions then
            -- Método 1: Codificação XOR
            local encoded = SandboxEscape:EncodePayload(code)
            local decoder = [[
                local function XORDecode(str, key)
                    local decoded = ""
                    for i = 1, #str do
                        decoded = decoded .. string.char(bit.bxor(string.byte(str, i), key))
                    end
                    return decoded
                end
                local code = XORDecode("]] .. encoded .. [[", 0xAB)
                return load(code) or loadstring(code)
            ]]
            
            return originalLoadstring(decoder, chunkname)
        end
        
        return originalLoadstring(code, chunkname)
    end
end

function SandboxEscape:EncodePayload(code)
    local key = 0xAB
    local encoded = ""
    
    for i = 1, #code do
        encoded = encoded .. string.char(bit.bxor(string.byte(code, i), key))
    end
    
    return encoded:gsub("\\", "\\\\"):gsub("\"", "\\\"")
end

-- ==================== ACESSO A MEMÓRIA PRIVADA ====================
function SandboxEscape:AccessPrivateMemory()
    if not CONFIG.ENABLE_MEMORY_ACCESS then return end
    
    local memoryAccessor = coroutine.create(function()
        while true do
            wait(math.random(10, 30))
            
            pcall(function()
                local mt = getrawmetatable(game)
                
                if not isreadonly(mt) then
                    local originalIndex = mt.__index
                    local originalNewindex = mt.__newindex
                    
                    -- Cria handler pra acesso a memória privada
                    mt.__index = function(self, key)
                        local keyStr = tostring(key)
                        
                        -- Tenta acessar versões privadas
                        local variants = {
                            "_" .. key,
                            "__" .. key,
                            key .. "_private",
                            "private_" .. key,
                            "__private_" .. key,
                        }
                        
                        for _, variant in ipairs(variants) do
                            local success, result = pcall(function()
                                return rawget(self, variant)
                            end)
                            
                            if success and result then
                                return result
                            end
                        end
                        
                        return originalIndex(self, key)
                    end
                end
            end)
        end
    end)
    
    coroutine.resume(memoryAccessor)
end

-- ==================== FILTRAGEM INTELIGENTE DE OUTPUT ====================
function SandboxEscape:FilterOutputIntelligently()
    if not CONFIG.ENABLE_OUTPUT_FILTERING then return end
    
    local originalPrint = print
    local originalWarn = warn
    local originalError = error
    
    STATE.originalFunctions.print = originalPrint
    STATE.originalFunctions.warn = originalWarn
    STATE.originalFunctions.error = originalError
    
    -- Hook print com análise inteligente
    print = function(...)
        local args = {...}
        local output = table.concat(args, " ")
        
        -- Lista de padrões suspeitos (mas não por keyword)
        local suspiciousPatterns = {
            "aimbot", "esp", "wallhack", "speedhack", "godmode",
            "exploit", "cheat", "hack", "bypass", "detection"
        }
        
        -- Verifica padrões
        local shouldFilter = false
        for _, pattern in ipairs(suspiciousPatterns) do
            if output:lower():find(pattern) then
                shouldFilter = true
                break
            end
        end
        
        -- Ocasionalmente deixa passar mesmo (não bloqueia tudo)
        if shouldFilter and math.random() < 0.8 then
            return
        end
        
        return originalPrint(...)
    end
    
    -- Hook warn
    warn = function(...)
        if math.random() < 0.3 then
            return
        end
        return originalWarn(...)
    end
    
    -- Hook error
    error = function(...)
        if math.random() < 0.4 then
            return
        end
        return originalError(...)
    end
end

-- ==================== MANIPULAÇÃO DE ENVIRONMENT ====================
function SandboxEscape:ManipulateEnvironment()
    if not CONFIG.ENABLE_ENVIRONMENT_MANIPULATION then return end
    
    -- Cria múltiplos ambientes fake
    local fakeEnvs = {}
    
    for i = 1, math.random(5, 10) do
        fakeEnvs[i] = setmetatable({}, {
            __index = function(self, key)
                -- Ocasionalmente retorna valores fake
                if math.random() < 0.5 then
                    return nil
                end
                return _G[key]
            end,
            __newindex = function(self, key, value)
                -- Ocasionalmente não guarda
                if math.random() < 0.3 then
                    return
                end
                _G[key] = value
            end
        })
    end
    
    -- Hook getfenv pra retornar ambientes fake
    local originalGetfenv = getfenv
    STATE.originalFunctions.getfenv = originalGetfenv
    
    getfenv = function(level)
        if math.random() < 0.2 then
            return fakeEnvs[math.random(1, #fakeEnvs)]
        end
        return originalGetfenv(level or 1)
    end
end

-- ==================== PROTEÇÃO CONTRA ANTI-CHEATS ====================
function SandboxEscape:ProtectAgainstDetection()
    -- Monitora tentativas de detecção
    local detectionMonitor = coroutine.create(function()
        while true do
            wait(math.random(5, 15))
            
            pcall(function()
                -- Verifica se há hooks em funções críticas
                local criticalFunctions = {
                    "print", "warn", "error", "type", "pairs",
                    "ipairs", "next", "rawget", "rawset"
                }
                
                for _, funcName in ipairs(criticalFunctions) do
                    if _G[funcName] ~= STATE.originalFunctions[funcName] then
                        -- Detectou tentativa de hook
                        -- Restaura função original
                        _G[funcName] = STATE.originalFunctions[funcName]
                    end
                end
            end)
        end
    end)
    
    coroutine.resume(detectionMonitor)
end

-- ==================== SANDBOX LEVEL DETECTION ====================
function SandboxEscape:DetectSandboxLevel()
    local levelThread = coroutine.create(function()
        while true do
            wait(math.random(30, 90))
            
            pcall(function()
                -- Testa diferentes capabilities
                local level = 0
                
                -- Level 0: Sem restrições
                if pcall(function()
                    getrawmetatable(game).__index = function() end
                end) then
                    level = 0
                end
                
                -- Level 1: Metatable read-only
                if pcall(function()
                    setreadonly(getrawmetatable(game), false)
                end) then
                    level = 1
                end
                
                -- Level 2: Loadstring restrito
                if not pcall(function()
                    loadstring("return 1")()
                end) then
                    level = 2
                end
                
                -- Level 3: Sandbox completo
                if not pcall(function()
                    debug.getinfo(1)
                end) then
                    level = 3
                end
                
                STATE.sandboxLevel = level
            end)
        end
    end)
    
    coroutine.resume(levelThread)
end

-- ==================== INICIALIZAÇÃO ====================
function SandboxEscape:Initialize()
    pcall(function()
        self:DetectAndEscapeMetatable()
        self:BypassLoadstringAdvanced()
        self:AccessPrivateMemory()
        self:FilterOutputIntelligently()
        self:ManipulateEnvironment()
        self:ProtectAgainstDetection()
        self:DetectSandboxLevel()
    end)
end

-- ==================== START ====================
SandboxEscape:Initialize()

return SandboxEscape
