local AntiAnalysis = {}

-- ==================== CONSTANTES E CONFIGURAÇÃO ====================
local OBFUSCATION_LEVEL = {
    LOW = 1,
    MEDIUM = 2,
    HIGH = 3,
    EXTREME = 4
}

local CONFIG = {
    LEVEL = OBFUSCATION_LEVEL.EXTREME,
    ENABLE_RUNTIME_PROTECTION = true,
    ENABLE_CODE_MUTATION = true,
    ENABLE_ANTI_DECOMPILE = true,
    ENABLE_ANTI_HOOK = true,
}

-- ==================== PROTEÇÃO EM TEMPO DE EXECUÇÃO ====================
function AntiAnalysis:ProtectRuntime()
    local originalDebug = debug
    local originalGetfenv = getfenv
    local originalSetfenv = setfenv
    
    -- Remove acesso a debug functions
    debug.getinfo = function()
        return nil
    end
    
    debug.getlocal = function()
        return nil
    end
    
    debug.getupvalue = function()
        return nil
    end
    
    debug.gethook = function()
        return nil
    end
    
    getfenv = function()
        return setmetatable({}, {
            __index = function() return nil end,
            __newindex = function() end
        })
    end
    
    setfenv = function() end
end

-- ==================== ANTI-HOOK AVANÇADO ====================
function AntiAnalysis:ProtectAgainstHooks()
    local protectedFunctions = {
        "pairs", "ipairs", "next", "rawget", "rawset",
        "rawlen", "rawequal", "type", "tostring", "tonumber"
    }
    
    -- Cria cópias das funções originais ANTES de qualquer modificação
    self.originalFunctions = {}
    for _, funcName in ipairs(protectedFunctions) do
        self.originalFunctions[funcName] = _G[funcName]
    end
    
    -- Verifica constantemente se foram modificadas
    local monitorThread = coroutine.create(function()
        while true do
            wait(math.random(2, 8))
            
            for funcName, originalFunc in pairs(self.originalFunctions) do
                if _G[funcName] ~= originalFunc then
                    self:TriggerProtection("Hook detectado em: " .. funcName)
                end
            end
        end
    end)
    
    coroutine.resume(monitorThread)
end

-- ==================== MUTAÇÃO DE CÓDIGO ====================
function AntiAnalysis:MutateCode(code)
    -- Transforma o código de formas diferentes a cada execução
    local mutations = {
        self.MutationMethod1,
        self.MutationMethod2,
        self.MutationMethod3,
        self.MutationMethod4,
    }
    
    local selectedMutation = mutations[math.random(1, #mutations)]
    return selectedMutation(self, code)
end

function AntiAnalysis:MutationMethod1(code)
    -- Reordena variáveis e funções
    local randomOrder = math.random(1, 10000)
    
    code = code:gsub("local%s+(%w+)", function(var)
        return "local " .. self:RandomString(8) .. " --" .. var
    end)
    
    return code
end

function AntiAnalysis:MutationMethod2(code)
    -- Substitui operadores por equivalentes
    local operators = {
        ["+"] = "plus",
        ["-"] = "minus",
        ["*"] = "mult",
        ["/"] = "div",
    }
    
    for op, name in pairs(operators) do
        code = code:gsub("%s%" .. op .. "%s", " [" .. name .. "] ")
    end
    
    return code
end

function AntiAnalysis:MutationMethod3(code)
    -- Divide strings longas
    code = code:gsub('"([^"]*)"', function(str)
        if #str > 10 then
            local parts = {}
            for i = 1, #str, 5 do
                table.insert(parts, str:sub(i, i + 4))
            end
            return '("' .. table.concat(parts, '"..') .. '")'
        end
        return '"' .. str .. '"'
    end)
    
    return code
end

function AntiAnalysis:MutationMethod4(code)
    -- Codifica números
    code = code:gsub("(%d+)", function(num)
        local encoded = num
        for i = 1, math.random(1, 3) do
            encoded = "(" .. encoded .. ")"
        end
        return encoded
    end)
    
    return code
end

-- ==================== OFUSCAÇÃO DE STRINGS ====================
function AntiAnalysis:ObfuscateStrings(code)
    local stringMap = {}
    local stringCount = 0
    
    -- Encontra todas as strings
    code = code:gsub('"([^"]*)"', function(str)
        stringCount = stringCount + 1
        local key = "STR_" .. stringCount
        stringMap[key] = str
        return "[" .. key .. "]"
    end)
    
    -- Cria decoder
    local decoderCode = "local STR_MAP = " .. self:TableToString(stringMap) .. "\n"
    decoderCode = decoderCode .. "local function GetString(key) return STR_MAP[key] end\n"
    
    -- Injeta decoder
    return decoderCode .. code
end

-- ==================== OFUSCAÇÃO DE FUNÇÕES ====================
function AntiAnalysis:ObfuscateFunctions(code)
    local functionMap = {}
    local funcCount = 0
    
    -- Encontra funções definidas
    code = code:gsub("function%s+(%w+)%s*%(", function(funcName)
        funcCount = funcCount + 1
        local newName = self:RandomString(12)
        functionMap[funcName] = newName
        return "function " .. newName .. "("
    end)
    
    -- Substitui chamadas de funções
    for oldName, newName in pairs(functionMap) do
        code = code:gsub(oldName .. "%s*%(",  newName .. "(")
    end
    
    return code
end

-- ==================== ANTI-DECOMPILE ====================
function AntiAnalysis:ApplyAntiDecompile(code)
    -- Adiciona instruções inúteis que confundem decompiladores
    local junkCode = {
        "local _dummy_ = function() return 1+1 end",
        "local _x_ = {1,2,3,4,5}",
        "if false then return end",
        "while false do end",
        "local _mt_ = {__index = function() end}",
    }
    
    for i = 1, math.random(5, 15) do
        local randomPos = math.random(1, #code)
        code = code:sub(1, randomPos) .. "\n" .. junkCode[math.random(1, #junkCode)] .. "\n" .. code:sub(randomPos + 1)
    end
    
    return code
end

-- ==================== PROTEÇÃO CONTRA ANÁLISE ESTÁTICA ====================
function AntiAnalysis:ProtectStaticAnalysis(code)
    -- Esconde padrões suspeitos
    local suspiciousPatterns = {
        ["getfenv"] = "g" .. "et" .. "fenv",
        ["setfenv"] = "s" .. "et" .. "fenv",
        ["debug"] = "d" .. "ebug",
        ["loadstring"] = "lo" .. "ads" .. "tring",
    }
    
    for pattern, obfuscated in pairs(suspiciousPatterns) do
        code = code:gsub(pattern, obfuscated)
    end
    
    return code
end

-- ==================== VALIDAÇÃO DE INTEGRIDADE ====================
function AntiAnalysis:CalculateHash(data)
    local hash = 0
    
    for i = 1, #data do
        local byte = string.byte(data, i)
        hash = bit.bxor(hash, byte)
        hash = bit.band(bit.lshift(hash, 3) + hash, 0xFFFFFFFF)
    end
    
    return hash
end

function AntiAnalysis:VerifyIntegrity(code, expectedHash)
    local currentHash = self:CalculateHash(code)
    
    if currentHash ~= expectedHash then
        self:TriggerProtection("Integridade do código comprometida")
        return false
    end
    
    return true
end

-- ==================== DETECÇÃO E RESPOSTA ====================
function AntiAnalysis:TriggerProtection(reason)
    -- Disable script
    error("[AntiAnalysis] PROTEÇÃO ACIONADA: " .. reason)
end

-- ==================== UTILITÁRIOS ====================
function AntiAnalysis:RandomString(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
    local result = ""
    
    for i = 1, length do
        result = result .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    
    return result
end

function AntiAnalysis:TableToString(tbl)
    local result = "{"
    
    for key, value in pairs(tbl) do
        if type(value) == "string" then
            result = result .. "['" .. key .. "'] = '" .. value .. "',"
        else
            result = result .. "['" .. key .. "'] = " .. tostring(value) .. ","
        end
    end
    
    result = result .. "}"
    return result
end

-- ==================== INICIALIZAÇÃO ====================
function AntiAnalysis:Initialize()
    if CONFIG.ENABLE_RUNTIME_PROTECTION then
        self:ProtectRuntime()
    end
    
    if CONFIG.ENABLE_ANTI_HOOK then
        self:ProtectAgainstHooks()
    end
end

-- ==================== FUNÇÃO PRINCIPAL ====================
function AntiAnalysis:ObfuscateComplete(code)
    self:Initialize()
    
    local obfuscated = code
    
    -- Aplicar todas as camadas de ofuscação
    obfuscated = self:ObfuscateStrings(obfuscated)
    obfuscated = self:ObfuscateFunctions(obfuscated)
    obfuscated = self:ProtectStaticAnalysis(obfuscated)
    
    if CONFIG.ENABLE_CODE_MUTATION then
        obfuscated = self:MutateCode(obfuscated)
    end
    
    if CONFIG.ENABLE_ANTI_DECOMPILE then
        obfuscated = self:ApplyAntiDecompile(obfuscated)
    end
    
    return obfuscated
end

return AntiAnalysis
