local Obfuscator = {}

function Obfuscator:ObfuscateCode(code)
    local obfuscated = code
    
    -- Ofusca strings
    obfuscated = obfuscated:gsub('"([^"]*)"', function(str)
        return '"' .. self:EncodeString(str) .. '"'
    end)
    
    -- Remove comentários
    obfuscated = obfuscated:gsub('%-%-[^\n]*', '')
    
    -- Ofusca nomes de funções
    obfuscated = obfuscated:gsub('function%s+(%w+)', function(name)
        return 'function ' .. self:RandomName()
    end)
    
    return obfuscated
end

function Obfuscator:EncodeString(str)
    local encoded = ""
    for i = 1, #str do
        encoded = encoded .. string.char(string.byte(str, i) + 5)
    end
    return encoded
end

function Obfuscator:RandomName()
    local chars = "abcdefghijklmnopqrstuvwxyz"
    local name = ""
    for i = 1, math.random(8, 16) do
        name = name .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return name
end

function Obfuscator:MinifyCode(code)
    code = code:gsub('%s+', ' ')
    code = code:gsub(',%s+', ',')
    code = code:gsub('=%s+', '=')
    code = code:gsub('%(%s+', '(')
    code = code:gsub('%s+%)', ')')
    return code
end

return Obfuscator
