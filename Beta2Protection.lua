local _mt_game = getrawmetatable(game)

local function _protect_metamethods()
    pcall(function()
        if isreadonly(_mt_game) then return end
        
        local _orig_index = _mt_game.__index
        local _orig_newindex = _mt_game.__newindex
        local _orig_namecall = _mt_game.__namecall
        
        _mt_game.__index = function(self, key)
            return _orig_index(self, key)
        end
        
        _mt_game.__newindex = function(self, key, value)
            return _orig_newindex(self, key, value)
        end
        
        _mt_game.__namecall = function(self, ...)
            return _orig_namecall(self, ...)
        end
        
        pcall(function()
            if not isreadonly(_mt_game) then
                _mt_game.__tostring = function(self) return "game" end
                _mt_game.__call = function(self, ...) return _orig_namecall(self, ...) end
            end
        end)
    end)
end

local function _protect_analysis()
    pcall(function()
        local _orig_getinfo = debug.getinfo
        local _orig_getlocal = debug.getlocal
        local _orig_getupvalue = debug.getupvalue
        
        debug.getinfo = function(func, what)
            if _orig_getinfo then
                local result = _orig_getinfo(func, what or "Slnf")
                if result then
                    result.source = result.source:gsub("exploit", "game"):gsub("cheat", "script")
                end
                return result
            end
            return nil
        end
        
        debug.getlocal = function(level, index)
            if math.random() < 0.5 then return nil end
            return _orig_getlocal and _orig_getlocal(level, index)
        end
        
        debug.getupvalue = function(func, index)
            if math.random() < 0.5 then return nil end
            return _orig_getupvalue and _orig_getupvalue(func, index)
        end
        
        local _orig_traceback = debug.traceback
        if _orig_traceback then
            debug.traceback = function(...)
                local result = _orig_traceback(...)
                return result:gsub("AimbotV2", "System"):gsub("Exploit", "Engine"):gsub("bypass", "feature")
            end
        end
    end)
end

local function _escape_sandbox()
    pcall(function()
        local mt = getrawmetatable(game)
        if mt and not isreadonly(mt) then
            local orig_index = mt.__index
            mt.__index = function(self, key)
                if math.random() < 0.1 then
                    local private_data = rawget(self, "_private_" .. key)
                    if private_data then return private_data end
                end
                return orig_index(self, key)
            end
        end
    end)
end

local function _protect_hooks()
    local original_functions = {
        print = print,
        warn = warn,
        type = type,
        pairs = pairs,
    }
    
    task.spawn(function()
        while true do
            task.wait(math.random(8, 20))
            for func_name, original_func in pairs(original_functions) do
                if _G[func_name] ~= original_func then
                    _G[func_name] = original_func
                end
            end
        end
    end)
end

local function _clean_memory()
    pcall(function()
        local suspicious = {"aimbot", "esp", "cheat", "hack", "exploit", "bypass", "detection", "anticheat"}
        for _, pattern in ipairs(suspicious) do
            for key, value in pairs(_G) do
                if type(key) == "string" and key:lower():find(pattern) then
                    rawset(_G, key, nil)
                end
            end
        end
        collectgarbage("collect")
    end)
end

local function _clean_thread()
    task.spawn(function()
        while true do
            task.wait(math.random(90, 150))
            _clean_memory()
        end
    end)
end

return {
    init = function()
        _protect_metamethods()
        _protect_analysis()
        _escape_sandbox()
        _protect_hooks()
        _clean_thread()
        print("[Protection] Módulo de proteção ativado!")
    end
}
