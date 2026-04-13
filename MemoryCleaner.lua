local MemoryCleaner = {}

function MemoryCleaner:CleanGlobals()
    local suspicious = {
        "aimbot", "esp", "cheat", "hack", "script", 
        "loadstring", "getfenv", "setfenv", "debug"
    }
    
    for _, v in ipairs(suspicious) do
        _G[v] = nil
        _G[v:upper()] = nil
    end
end

function MemoryCleaner:ClearMemory()
    collectgarbage("collect")
    collectgarbage("stop")
    
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    for k, v in pairs(mt) do
        if type(v) == "function" and tostring(v):find("script") then
            mt[k] = nil
        end
    end
    
    setreadonly(mt, true)
end

function MemoryCleaner:RemoveDebugInfo()
    debug.sethook(nil)
    if debug.getinfo then
        debug.getinfo = function() return {} end
    end
end

function MemoryCleaner:HideFromProfiler()
    local old_newproxy = newproxy
    if old_newproxy then
        newproxy = function(...)
            return old_newproxy(...)
        end
    end
end

return MemoryCleaner
