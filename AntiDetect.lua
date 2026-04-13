-- AntiDetect.lua - Sistema avançado de ocultação de script
local AntiDetect = {}

-- ==================== CONFIGURAÇÃO ====================
local CONFIG = {
    ENABLE_SIGNATURE_HIDING = true,
    ENABLE_ENVIRONMENT_CLEANING = true,
    ENABLE_CALL_STACK_PROTECTION = true,
    ENABLE_MEMORY_OBFUSCATION = true,
    ENABLE_STRING_ENCRYPTION = true,
    ENABLE_METAMETHOD_SPOOFING = true,
}

local HIDDEN_VARIABLES = {}
local ENCRYPTED_STRINGS = {}

-- ==================== PROTEÇÃO DE CALL STACK ====================
function AntiDetect:ProtectCallStack()
    if not CONFIG.ENABLE_CALL_STACK_PROTECTION then return end
    
    -- Intercepta debug.traceback
    local originalTraceback = debug.traceback
    debug.traceback = function(...)
        local result = originalTraceback(...)
        
        -- Remove informações suspeitas do stack trace
        result = result:gsub("AntiDetect", "")
        result = result:gsub("Aimbot", "")
        result = result:gsub("Script", "Game")
        result = result:gsub("cheat", "feature")
        result = result:gsub("exploit", "tool")
        
        return result
    end
    
    -- Intercepta debug.getinfo
    local originalGetInfo = debug.getinfo
    debug.getinfo = function(level, what)
        local info = originalGetInfo(level or 1, what or "Slnf")
        
        if info then
            info.source = info.source:gsub("AntiDetect", "@main")
            info.short_src = info.short_src:gsub("AntiDetect", "main")
        end
        
        return info
    end
end

-- ==================== LIMPEZA INTELIGENTE DE ENVIRONMENT ====================
function AntiDetect:CleanEnvironment()
    if not CONFIG.ENABLE_ENVIRONMENT_CLEANING then return end
    
    -- Palavras-chave suspeitas que um anticheat procura
    local suspiciousKeywords = {
        "aimbot", "esp", "cheat", "hack", "exploit", "bypass",
        "undetectable", "anticheat", "detection", "banwave",
        "wallhack", "speedhack", "speedrun", "godmode",
    }
    
    -- Em vez de apenas deletar, cria variáveis fake
    for _, keyword in ipairs(suspiciousKeywords) do
        -- Não deleta, apenas esconde
        if rawget(_G, keyword) then
            rawset(_G, keyword, nil)
        end
        
        -- Cria metatable para interceptar acesso
        if not rawget(_G, keyword) then
            setmetatable(_G, {
                __index = function(self, key)
                    if key == keyword then
                        return nil -- Retorna nil pra qualquer acesso
                    end
                end,
                __newindex = function(self, key, value)
                    if key ~= keyword then
                        rawset(_G, key, value)
                    end
                end
            })
        end
    end
end

-- ==================== OFUSCAÇÃO DE MEMÓRIA ====================
function AntiDetect:ObfuscateMemory()
    if not CONFIG.ENABLE_MEMORY_OBFUSCATION then return end
    
    local env = getfenv(1)
    
    -- Copia referências legitimas
    local legitimateFunctions = {
        "print", "warn", "error", "type", "pairs", "ipairs",
        "next", "tonumber", "tostring", "math", "table", "string"
    }
    
    -- Cria novo environment clean
    local cleanEnv = {}
    for _, func in ipairs(legitimateFunctions) do
        cleanEnv[func] = _G[func]
    end
    
    -- Remove referências que podem denunciar o script
    for key, value in pairs(env) do
        if type(value) == "function" then
            local info = debug.getinfo(value)
            
            -- Se função tem nome suspeito ou source unknown
            if info and (
                key:lower():find("cheat") or
                key:lower():find("exploit") or
                info.source:find("AntiDetect") or
                info.source:find("loadstring")
            ) then
                rawset(env, key, nil)
                HIDDEN_VARIABLES[key] = value -- Armazena secretamente
            end
        end
    end
end

-- ==================== ENCRIPTAÇÃO DE STRINGS ====================
function AntiDetect:EncryptStrings()
    if not CONFIG.ENABLE_STRING_ENCRYPTION then return end
    
    -- Cria função para encriptar strings em runtime
    local function XOREncrypt(str, key)
        local encrypted = ""
        for i = 1, #str do
            encrypted = encrypted .. string.char(bit.bxor(string.byte(str, i), key))
        end
        return encrypted
    end
    
    -- Strings suspeitas encriptadas
    local suspiciousStrings = {
        "aimbot", "esp", "wallhack", "detection", "anticheat",
        "debug.getinfo", "debug.traceback", "exploit",
    }
    
    local encryptionKey = math.random(1, 255)
    
    for _, str in ipairs(suspiciousStrings) do
        ENCRYPTED_STRINGS[str] = {
            encrypted = XOREncrypt(str, encryptionKey),
            key = encryptionKey
        }
    end
    
    -- Função para descriptografar (só quando necessário)
    local function DecryptString(str)
        local encrypted = ENCRYPTED_STRINGS[str]
        if encrypted then
            local decrypted = ""
            for i = 1, #encrypted.encrypted do
                decrypted = decrypted .. string.char(
                    bit.bxor(string.byte(encrypted.encrypted, i), encrypted.key)
                )
            end
            return decrypted
        end
        return str
    end
    
    return DecryptString
end

-- ==================== SPOOFING DE METAMETHODS ====================
function AntiDetect:SpoofMetamethods()
    if not CONFIG.ENABLE_METAMETHOD_SPOOFING then return end
    
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local originalIndex = mt.__index
    local originalNamecall = mt.__namecall
    
    -- Cria resposta fake pra queries suspeitas
    mt.__index = function(self, index)
        local indexStr = tostring(index):lower()
        
        -- Se anticheat procura por scripts, retorna fake
        if indexStr:find("script") or indexStr:find("exploit") then
            -- Retorna objeto vazio que parece legítimo
            return setmetatable({}, {
                __index = function() return nil end,
                __tostring = function() return "Workspace" end
            })
        end
        
        return originalIndex(self, index)
    end
    
    -- Hook para namecall (chamadas de método)
    mt.__namecall = function(self, ...)
        local args = {...}
        local method = args[#args]
        
        -- Detecta tentativas de encontrar scripts
        if method == "FindFirstChild" or method == "FindFirstChildOfClass" then
            if args[1] and tostring(args[1]):lower():find("script") then
                return nil -- Nega existência
            end
        end
        
        -- Detecta tentativas de acessar source code
        if method == "GetSource" or method == "GetChildren" then
            if math.random() < 0.05 then
                return nil -- Ocasionalmente nega
            end
        end
        
        return originalNamecall(self, ...)
    end
    
    setreadonly(mt, true)
end

-- ==================== PROTEÇÃO CONTRA ANÁLISE ESTÁTICA ====================
function AntiDetect:ProtectStaticAnalysis()
    -- Divide names de funções/variáveis para confundir análise
    local obfuscatedNames = {}
    
    for i = 1, 20 do
        local randomName = ""
        for j = 1, math.random(8, 16) do
            randomName = randomName .. string.char(math.random(97, 122))
        end
        table.insert(obfuscatedNames, randomName)
    end
    
    -- Retorna nomes aleatórios pra confundir decompiladores
    return obfuscatedNames
end

-- ==================== MONITORAMENTO DE DETECÇÃO ====================
function AntiDetect:MonitorForDetection()
    local detectionMonitor = coroutine.create(function()
        while true do
            wait(math.random(5, 15))
            
            -- Verifica se anticheat está tentando inspecionar
            local success, result = pcall(function()
                return debug.getinfo(1)
            end)
            
            if success and result then
                -- Se conseguiu getinfo, pode estar sendo analisado
                if math.random() < 0.1 then
                    -- Executa counter-measure
                    self:CounterDetection()
                end
            end
        end
    end)
    
    coroutine.resume(detectionMonitor)
end

function AntiDetect:CounterDetection()
    -- Quando detecta tentativa de análise, toma ação
    -- 1. Limpa mais dados
    -- 2. Muda comportamento
    -- 3. Esconde melhor
    
    self:CleanEnvironment()
    self:ProtectCallStack()
    self:SpoofMetamethods()
end

-- ==================== PROTEÇÃO CONTRA HOOKS ====================
function AntiDetect:ProtectAgainstHooks()
    -- Cria referências às funções ANTES de qualquer modificação
    local originalFunctions = {
        print = print,
        warn = warn,
        error = error,
        type = type,
        pairs = pairs,
        ipairs = ipairs,
        getfenv = getfenv,
        setfenv = setfenv,
    }
    
    -- Monitora se foram modificadas
    local hookMonitor = coroutine.create(function()
        while true do
            wait(math.random(10, 30))
            
            for name, originalFunc in pairs(originalFunctions) do
                if _G[name] ~= originalFunc then
                    -- Foi hookeada! Counter-measure
                    _G[name] = originalFunc -- Restaura
                end
            end
        end
    end)
    
    coroutine.resume(hookMonitor)
end

-- ==================== INICIALIZAÇÃO ====================
function AntiDetect:Initialize()
    pcall(function()
        self:ProtectCallStack()
        self:CleanEnvironment()
        self:ObfuscateMemory()
        self:EncryptStrings()
        self:SpoofMetamethods()
        self:ProtectStaticAnalysis()
        self:ProtectAgainstHooks()
        self:MonitorForDetection()
    end)
end

-- ==================== START ====================
AntiDetect:Initialize()

return AntiDetect
