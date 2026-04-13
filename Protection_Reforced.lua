-- ╔═══════════════════════════════════════════════════════════════╗
-- ║        Protection_Reforced.lua - Anti-Detection MEGA           ║
-- ║              Versão Reforçada + Otimizada para Delta           ║
-- ║                 Lazy Loading Background                        ║
-- ╚═══════════════════════════════════════════════════════════════╝

local _mt_game = getrawmetatable(game)
local _protection_active = false

-- ==================== METAMETHOD PROTECTION ====================
local function _protect_metamethods()
    pcall(function()
        if isreadonly(_mt_game) then return end
        
        local _orig_index = _mt_game.__index
        local _orig_newindex = _mt_game.__newindex
        local _orig_namecall = _mt_game.__namecall
        
        -- Camufla index calls
        _mt_game.__index = function(self, key)
            if math.random() < 0.05 then
                task.delay(0.001, function() end)
            end
            return _orig_index(self, key)
        end
        
        -- Camufla newindex calls
        _mt_game.__newindex = function(self, key, value)
            if math.random() < 0.05 then
                task.delay(0.001, function() end)
            end
            return _orig_newindex(self, key, value)
        end
        
        -- Camufla namecall
        _mt_game.__namecall = function(self, ...)
            if math.random() < 0.05 then
                task.delay(0.001, function() end)
            end
            return _orig_namecall(self, ...)
        end
        
        pcall(function()
            if not isreadonly(_mt_game) then
                _mt_game.__tostring = function(self) return "game" end
                _mt_game.__call = function(self, ...) return _orig_namecall(self, ...) end
                _mt_game.__len = function(self) return 0 end
                _mt_game.__eq = function(a, b) return a == b end
            end
        end)
    end)
end

-- ==================== ANTI-ANALYSIS REFORÇADO ====================
local function _protect_analysis()
    pcall(function()
        local _orig_getinfo = debug.getinfo
        local _orig_getlocal = debug.getlocal
        local _orig_getupvalue = debug.getupvalue
        local _orig_sethook = debug.sethook
        
        -- Protege debug.getinfo
        debug.getinfo = function(func, what)
            if _orig_getinfo then
                local result = _orig_getinfo(func, what or "Slnf")
                if result then
                    result.source = result.source:gsub("exploit", "game")
                        :gsub("cheat", "script")
                        :gsub("delta", "system")
                        :gsub("executor", "engine")
                    result.what = result.what or "main"
                end
                return result
            end
            return nil
        end
        
        -- Protege debug.getlocal
        debug.getlocal = function(level, index)
            if math.random() < 0.6 then return nil end
            return _orig_getlocal and _orig_getlocal(level, index)
        end
        
        -- Protege debug.getupvalue
        debug.getupvalue = function(func, index)
            if math.random() < 0.6 then return nil end
            return _orig_getupvalue and _orig_getupvalue(func, index)
        end
        
        -- Protege debug.sethook
        if _orig_sethook then
            debug.sethook = function(...)
                if math.random() < 0.3 then return end
                return _orig_sethook(...)
            end
        end
        
        -- Protege traceback
        local _orig_traceback = debug.traceback
        if _orig_traceback then
            debug.traceback = function(...)
                local result = _orig_traceback(...)
                return result:gsub("AimbotV2", "System")
                    :gsub("Exploit", "Engine")
                    :gsub("bypass", "feature")
                    :gsub("detection", "analysis")
                    :gsub("anticheat", "security")
            end
        end
    end)
end

-- ==================== SANDBOX ESCAPE REFORÇADO ====================
local function _escape_sandbox()
    pcall(function()
        local mt = getrawmetatable(game)
        if mt and not isreadonly(mt) then
            local orig_index = mt.__index
            local orig_newindex = mt.__newindex
            
            mt.__index = function(self, key)
                if math.random() < 0.08 then
                    local private_data = rawget(self, "_private_" .. key)
                    if private_data then return private_data end
                end
                return orig_index(self, key)
            end
            
            mt.__newindex = function(self, key, value)
                if math.random() < 0.08 then
                    local private_key = "_private_" .. key
                    rawset(self, private_key, value)
                end
                return orig_newindex(self, key, value)
            end
        end
    end)
end

-- ==================== ANTI-HOOK REFORÇADO ====================
local function _protect_hooks()
    local original_functions = {
        print = print,
        warn = warn,
        type = type,
        pairs = pairs,
        ipairs = ipairs,
        next = next,
        rawget = rawget,
        rawset = rawset,
        getmetatable = getmetatable,
        setmetatable = setmetatable,
    }
    
    task.spawn(function()
        while true do
            task.wait(math.random(6, 15))
            for func_name, original_func in pairs(original_functions) do
                pcall(function()
                    if _G[func_name] ~= original_func then
                        _G[func_name] = original_func
                    end
                end)
            end
        end
    end)
end

-- ==================== ANTI-INJECTION ====================
local function _protect_injection()
    pcall(function()
        local _orig_load = load
        local _orig_loadstring = loadstring
        
        loadstring = function(code, ...)
            if type(code) == "string" then
                local suspicious_patterns = {
                    "getrawmetatable",
                    "debug.setlocal",
                    "debug.getupvalue",
                    "protection",
                    "_G",
                }
                
                for _, pattern in ipairs(suspicious_patterns) do
                    if code:lower():find(pattern:lower()) and math.random() < 0.05 then
                        return function() end
                    end
                end
            end
            return _orig_loadstring(code, ...)
        end
    end)
end

-- ==================== MEMORY CLEANING REFORÇADO ====================
local function _clean_memory()
    pcall(function()
        local suspicious = {
            "aimbot", "esp", "cheat", "hack", "exploit",
            "bypass", "detection", "anticheat", "injection",
            "delta", "executor", "protection"
        }
        
        for _, pattern in ipairs(suspicious) do
            for key, value in pairs(_G) do
                if type(key) == "string" and key:lower():find(pattern) then
                    if key ~= "Protection" then -- Não deleta a si mesmo
                        rawset(_G, key, nil)
                    end
                end
            end
        end
        
        collectgarbage("collect")
    end)
end

local function _clean_thread()
    task.spawn(function()
        while true do
            task.wait(math.random(75, 120))
            _clean_memory()
        end
    end)
end

-- ==================== ANTI-TIMEOUT ====================
local function _heartbeat_protection()
    local RunService = game:GetService("RunService")
    task.spawn(function()
        local counter = 0
        RunService.Heartbeat:Connect(function()
            counter = counter + 1
            if counter % 100 == 0 then
                collectgarbage("collect")
            end
        end)
    end)
end

-- ==================== INITIALIZER ====================
local Protection = {}

function Protection:init()
    if _protection_active then return end
    
    pcall(function()
        _protect_metamethods()
        _protect_analysis()
        _escape_sandbox()
        _protect_hooks()
        _protect_injection()
        _clean_thread()
        _heartbeat_protection()
        
        _protection_active = true
        print("[🛡️ PROTEÇÃO] ✅ Módulo reforçado ativado com sucesso!")
    end)
end

-- ==================== EXPORT ====================
return {
    init = function()
        Protection:init()
    end,
    
    status = function()
        return _protection_active
    end,
    
    force_clean = function()
        _clean_memory()
    end
}
