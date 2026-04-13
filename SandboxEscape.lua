local SandboxEscape = {}

function SandboxEscape:EscapeRestrictions()
    local success, result = pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        return true
    end)
    
    if not success then
        warn("Sandbox muito restritivo!")
    end
end

function SandboxEscape:BypassLoadstring()
    local oldLoadstring = loadstring
    
    loadstring = function(code)
        local obfuscated = code:gsub("_G%.", "_G_"):gsub("getfenv%.", "getfenv_")
        return oldLoadstring(obfuscated)
    end
end

function SandboxEscape:AccessPrivateMemory()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    local old = mt.__index
    mt.__index = function(self, key)
        if key == "_private" then
            return old(self, key)
        end
        return old(self, key)
    end
    
    setreadonly(mt, true)
end

function SandboxEscape:HookPrint()
    local oldPrint = print
    print = function(...)
        local args = {...}
        local str = table.concat(args, " ")
        if not str:find("AIMBOT") and not str:find("CHEAT") then
            oldPrint(...)
        end
    end
end

return SandboxEscape
