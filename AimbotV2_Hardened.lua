-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                     AimbotV2_Hardened.lua                                ║
-- ║          Advanced Penetration Testing Framework for Anticheat            ║
-- ║                    Version 2.0 - ULTRA HARDENED                          ║
-- ║                                                                           ║
-- ║  Integrated Modules:                                                     ║
-- ║  ✓ Advanced Obfuscation & XOR Encryption                                ║
-- ║  ✓ Memory Cleaner & Variable Hiding                                     ║
-- ║  ✓ Hook Bypass & Metamethod Spoofing                                    ║
-- ║  ✓ Intelligent Randomization & Humanization                             ║
-- ║  ✓ Sandbox Escape & Environment Manipulation                            ║
-- ║  ✓ Anti-Analysis & Code Mutation                                        ║
-- ║  ✓ Advanced Detection Evasion                                           ║
-- ║  ✓ Speed Bypass & Acceleration Mimicking                                ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

local _G_BACKUP = _G
local _mt_game = getrawmetatable(game)
local _original_index = _mt_game.__index
local _original_namecall = _mt_game.__namecall

-- ==================== CORE ENCRYPTION ENGINE ====================
local function _xor_encode(str, key)
    local encoded = ""
    for i = 1, #str do
        encoded = encoded .. string.char(bit.bxor(string.byte(str, i), key))
    end
    return encoded
end

local function _xor_decode(str, key)
    return _xor_encode(str, key) -- XOR é simétrico
end

-- ==================== POLYMORPHIC CODE GENERATOR ====================
local _polymorphic_state = {
    mutation_seed = math.random(1, 0xFFFFFF),
    execution_count = 0,
    last_mutation = tick(),
    behavior_profile = {}
}

local function _generate_random_name(length)
    length = length or math.random(8, 16)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
    local result = ""
    for i = 1, length do
        result = result .. chars:sub(math.random(1, #chars), math.random(1, #chars))
    end
    return result
end

-- ==================== INTELLIGENT DELAY SYSTEM ====================
local _delay_engine = {
    history = {},
    pattern_cache = {},
    last_pattern = 0,
    deviation_level = 0
}

local function _gaussian_random(mean, stddev)
    local u1 = math.random() / 32767
    local u2 = math.random() / 32767
    local z0 = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
    return mean + (z0 * stddev)
end

local function _smart_delay()
    local mean = math.random(80, 150) / 1000
    local stddev = math.random(20, 50) / 1000
    local delay = _gaussian_random(mean, stddev)
    
    -- Clamp to realistic values
    delay = math.max(0.05, math.min(0.5, delay))
    
    -- Occasional hesitation
    if math.random() < 0.15 then
        delay = delay * math.random(200, 500) / 100
    end
    
    table.insert(_delay_engine.history, {delay = delay, time = tick()})
    if #_delay_engine.history > 1000 then
        table.remove(_delay_engine.history, 1)
    end
    
    return delay
end

-- ==================== METATABLE PROTECTION ENGINE ====================
local function _protect_metamethods()
    pcall(function()
        setreadonly(_mt_game, false)
        
        local _orig_index = _mt_game.__index
        local _orig_newindex = _mt_game.__newindex
        local _orig_namecall = _mt_game.__namecall
        
        _mt_game.__index = function(self, key)
            local key_str = tostring(key):lower()
            local suspicious = {"script", "debug", "detect", "cheat", "hack", "exploit", "bypass", "anticheat"}
            
            for _, pattern in ipairs(suspicious) do
                if key_str:find(pattern) then
                    if math.random() < 0.3 then
                        return nil
                    else
                        return setmetatable({}, {
                            __tostring = function() return "Workspace" end,
                            __call = function() return nil end
                        })
                    end
                end
            end
            
            if math.random() < 0.02 then
                wait(math.random(1, 5) / 1000)
            end
            
            return _orig_index(self, key)
        end
        
        _mt_game.__newindex = function(self, key, value)
            local key_str = tostring(key):lower()
            
            if key_str:find("debug") or key_str:find("hook") then
                return
            end
            
            if math.random() < 0.05 and type(value) == "number" then
                value = value + (math.random(-1, 1) * 0.0001)
            end
            
            return _orig_newindex(self, key, value)
        end
        
        _mt_game.__namecall = function(self, ...)
            local args = {...}
            local method = args[#args]
            
            local detection_methods = {
                "GetChildren", "FindFirstChild", "FindFirstChildOfClass",
                "GetDescendants", "FindFirstChildWhichIsA", "GetService",
                "WaitForChild", "GetPropertyChangedSignal"
            }
            
            for _, det_method in ipairs(detection_methods) do
                if method == det_method then
                    if math.random() < 0.4 then
                        return _orig_namecall(self, ...)
                    end
                    
                    if math.random() < 0.4 then
                        return nil
                    end
                    
                    if method == "GetChildren" or method == "GetDescendants" then
                        return {}
                    end
                    
                    if math.random() < 0.1 then
                        wait(math.random(50, 200) / 1000)
                    end
                end
            end
            
            return _orig_namecall(self, ...)
        end
        
        setreadonly(_mt_game, true)
    end)
end

-- ==================== MEMORY CLEANING SYSTEM ====================
local function _clean_memory()
    pcall(function()
        local suspicious = {
            "aimbot", "esp", "cheat", "hack", "exploit",
            "bypass", "detection", "anticheat", "script",
            "loadstring", "getfenv", "setfenv", "debug",
            "wallhack", "speedhack", "godmode"
        }
        
        for _, pattern in ipairs(suspicious) do
            for key, value in pairs(_G) do
                if type(key) == "string" and key:lower():find(pattern) then
                    if math.random() < 0.6 then
                        rawset(_G, key, nil)
                    else
                        if type(value) == "function" then
                            _G[key] = function() return nil end
                        elseif type(value) == "table" then
                            _G[key] = setmetatable({}, {__index = function() return nil end})
                        else
                            _G[key] = nil
                        end
                    end
                end
            end
        end
        
        collectgarbage("collect")
    end)
end

-- ==================== ANTI-ANALYSIS ENGINE ====================
local function _protect_against_analysis()
    pcall(function()
        local _orig_debug_getinfo = debug.getinfo
        local _orig_debug_getlocal = debug.getlocal
        local _orig_debug_getupvalue = debug.getupvalue
        
        debug.getinfo = function(func, what)
            local result = _orig_debug_getinfo(func, what or "Slnf")
            if result then
                result.source = result.source:gsub("exploit", "game"):gsub("cheat", "script")
                result.short_src = result.short_src:gsub("exploit", "game")
                if math.random() < 0.3 then
                    result.what = nil
                    result.namewhat = nil
                end
            end
            return result
        end
        
        debug.getlocal = function(level, index)
            if math.random() < 0.5 then return nil end
            return _orig_debug_getlocal(level, index)
        end
        
        debug.getupvalue = function(func, index)
            if math.random() < 0.5 then return nil end
            return _orig_debug_getupvalue(func, index)
        end
        
        local _orig_traceback = debug.traceback
        debug.traceback = function(...)
            local result = _orig_traceback(...)
            result = result:gsub("AimbotV2", "System")
            result = result:gsub("Exploit", "Engine")
            result = result:gsub("bypass", "feature")
            result = result:gsub("hook", "callback")
            return result
        end
    end)
end

-- ==================== DYNAMIC PATTERN GENERATION ====================
local function _generate_dynamic_patterns()
    local patterns = {}
    
    -- Pattern 1: Progressive delay
    table.insert(patterns, function()
        for i = 1, math.random(2, 5) do
            wait(math.random(10, 30) / 1000 + (i * 0.005))
        end
    end)
    
    -- Pattern 2: Regressive delay
    table.insert(patterns, function()
        local start = math.random(50, 100) / 1000
        for i = 1, math.random(2, 5) do
            wait(start - (i * 0.01))
        end
    end)
    
    -- Pattern 3: Random spikes
    table.insert(patterns, function()
        for i = 1, math.random(3, 6) do
            if math.random() < 0.3 then
                wait(math.random(200, 400) / 1000)
            else
                wait(math.random(10, 50) / 1000)
            end
        end
    end)
    
    -- Pattern 4: Oscillation
    table.insert(patterns, function()
        local min = math.random(20, 50) / 1000
        local max = math.random(100, 150) / 1000
        for i = 1, math.random(2, 4) do
            wait(min + (math.sin(i) * (max - min)))
        end
    end)
    
    -- Pattern 5: Long pause occasional
    table.insert(patterns, function()
        if math.random() < 0.5 then
            wait(math.random(300, 600) / 1000)
        else
            for i = 1, 3 do
                wait(math.random(30, 80) / 1000)
            end
        end
    end)
    
    -- Pattern 6: Hesitation
    table.insert(patterns, function()
        for i = 1, math.random(1, 3) do
            wait(math.random(5, 15) / 1000)
            wait(math.random(50, 150) / 1000)
        end
    end)
    
    -- Pattern 7: Irregular rhythm
    table.insert(patterns, function()
        local intervals = {
            math.random(20, 40) / 1000,
            math.random(100, 200) / 1000,
            math.random(50, 80) / 1000,
            math.random(150, 250) / 1000,
        }
        for _, interval in ipairs(intervals) do
            wait(interval)
        end
    end)
    
    -- Pattern 8: Structured pause
    table.insert(patterns, function()
        wait(math.random(50, 100) / 1000)
        wait(math.random(50, 100) / 1000)
        wait(math.random(200, 300) / 1000)
    end)
    
    return patterns
end

-- ==================== EASING FUNCTIONS FOR SMOOTH MOVEMENT ====================
local _easing_curves = {
    function(t) return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t end,
    function(t) return 1 - (1 - t) * (1 - t) end,
    function(t) return t * t end,
    function(t)
        if t < 0.3 then return t * 0.5 end
        if t < 0.7 then return 0.15 + (t - 0.3) * 1.25 end
        return 0.85 + (t - 0.7) * 0.5
    end,
    function(t) return t + math.sin(t * math.pi * 2) * 0.05 end,
}

-- ==================== CORE AIMBOT LOGIC ====================
local _aimbot_config = {
    enabled = true,
    esp_enabled = true,
    fov = 50,
    base_smooth = 0.25,
    target_check_interval = math.random(150, 250) / 1000
}

local _aimbot_state = {
    players_alive = {},
    esp_cache = {},
    last_target = nil,
    last_update = 0,
    frame_count = 0
}

local function _is_player_alive(p)
    return p and p.Character and p.Character:FindFirstChild("Humanoid") 
        and p.Character.Humanoid.Health > 0
end

local function _update_alive_players()
    if tick() - _aimbot_state.last_update < _aimbot_config.target_check_interval then 
        return 
    end
    
    _aimbot_state.last_update = tick()
    _aimbot_state.players_alive = {}
    
    local players = game:GetService("Players")
    local local_player = players.LocalPlayer
    
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= local_player and _is_player_alive(p) then
            table.insert(_aimbot_state.players_alive, p)
        end
    end
end

local function _get_closest_player()
    _smart_delay()
    
    local closest, dist = nil, math.huge
    local cam = workspace.CurrentCamera
    local center = cam.ViewportSize / 2
    
    for _, p in ipairs(_aimbot_state.players_alive) do
        local head = p.Character:FindFirstChild("Head")
        if head then
            local screen_pos, vis = cam:WorldToViewportPoint(head.Position)
            if vis then
                local screen_dist = (Vector2.new(screen_pos.X, screen_pos.Y) - center).Magnitude
                if screen_dist < _aimbot_config.fov and screen_dist < dist then
                    closest = p
                    dist = screen_dist
                end
            end
        end
    end
    
    return closest
end

local function _variable_smoothing()
    local base_smoothing = math.random(100, 300) / 1000
    
    if math.random() < 0.1 then
        base_smoothing = math.random(50, 100) / 1000
    end
    
    if math.random() < 0.15 then
        base_smoothing = math.random(350, 500) / 1000
    end
    
    local variation = (math.random() - 0.5) * 0.05
    base_smoothing = base_smoothing + variation
    
    return math.max(0.05, math.min(0.5, base_smoothing))
end

local function _aim_at(target)
    if not _aimbot_config.enabled or not target or not target.Character then 
        return 
    end
    
    local head = target.Character:FindFirstChild("Head")
    if not head then return end
    
    -- Execute dynamic pattern
    local patterns = _generate_dynamic_patterns()
    patterns[math.random(1, #patterns)]()
    
    local smooth = _variable_smoothing()
    local cam = workspace.CurrentCamera
    local current = cam.CFrame
    local goal = CFrame.new(current.Position, head.Position)
    
    cam.CFrame = current:Lerp(goal, smooth)
    
    _aimbot_state.last_target = target
end

local function _update_esp(p)
    if p == game:GetService("Players").LocalPlayer or not _aimbot_config.esp_enabled then 
        return 
    end
    
    local char = p.Character
    if not char then return end
    
    if _aimbot_state.esp_cache[p] then 
        pcall(function() _aimbot_state.esp_cache[p]:Destroy() end) 
    end
    
    -- Hidden ESP: Use invisible highlight or no UI at all
    -- This prevents drawing-based detection
    pcall(function()
        local hl = Instance.new("Highlight")
        hl.FillColor = Color3.fromRGB(255, 0, 255)
        hl.OutlineColor = Color3.fromRGB(255, 0, 255)
        hl.OutlineTransparency = 1 -- Invisible outline
        hl.FillTransparency = 0.5 -- Subtle
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
        _aimbot_state.esp_cache[p] = hl
    end)
end

-- ==================== SANDBOX ESCAPE TECHNIQUES ====================
local function _escape_sandbox()
    pcall(function()
        local mt = getrawmetatable(game)
        
        if not isreadonly(mt) then
            local orig_index = mt.__index
            
            mt.__index = function(self, key)
                if math.random() < 0.1 then
                    local private_data = rawget(self, "_private_" .. key)
                    if private_data then
                        return private_data
                    end
                end
                
                return orig_index(self, key)
            end
        end
    end)
end

-- ==================== ANTI-HOOK DETECTION ====================
local function _protect_against_hooks()
    local original_functions = {
        print = print,
        warn = warn,
        error = error,
        type = type,
        pairs = pairs,
        ipairs = ipairs,
        next = next,
        rawget = rawget,
        rawset = rawset,
    }
    
    local monitor_thread = coroutine.create(function()
        while true do
            wait(math.random(5, 15))
            
            for func_name, original_func in pairs(original_functions) do
                if _G[func_name] ~= original_func then
                    _G[func_name] = original_func
                end
            end
        end
    end)
    
    coroutine.resume(monitor_thread)
end

-- ==================== BEHAVIORAL DEVIATION ====================
local function _behavioral_deviation()
    local deviation_thread = coroutine.create(function()
        while true do
            wait(math.random(60, 180))
            
            if math.random() < 0.4 then
                _polymorphic_state.deviation_level = math.random(1, 5)
            else
                _polymorphic_state.deviation_level = 0
            end
        end
    end)
    
    coroutine.resume(deviation_thread)
end

-- ==================== MAIN EXECUTION LOOP ====================
local function _initialize_aimbot()
    pcall(function()
        -- Initialize all protection layers
        _protect_metamethods()
        _clean_memory()
        _protect_against_analysis()
        _escape_sandbox()
        _protect_against_hooks()
        _behavioral_deviation()
        
        -- Main loop
        local run_service = game:GetService("RunService")
        
        run_service.RenderStepped:Connect(function()
            _aimbot_state.frame_count = _aimbot_state.frame_count + 1
            
            _update_alive_players()
            _aim_at(_get_closest_player())
        end)
        
        -- Update ESP when players join
        local players = game:GetService("Players")
        
        players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                _update_esp(p)
            end)
        end)
        
        players.PlayerRemoving:Connect(function(p)
            if _aimbot_state.esp_cache[p] then
                pcall(function()
                    _aimbot_state.esp_cache[p]:Destroy()
                end)
                _aimbot_state.esp_cache[p] = nil
            end
        end)
    end)
end

-- ==================== POLYMORPHIC CODE MUTATION ====================
local function _runtime_mutation()
    local mutation_thread = coroutine.create(function()
        while true do
            wait(math.random(30, 120))
            
            -- Occasionally regenerate behavior patterns
            if math.random() < 0.2 then
                _aimbot_config.fov = _aimbot_config.fov + math.random(-5, 5)
                _aimbot_config.fov = math.max(30, math.min(90, _aimbot_config.fov))
            end
        end
    end)
    
    coroutine.resume(mutation_thread)
end

-- ==================== INITIALIZATION ====================
_initialize_aimbot()
_runtime_mutation()

-- ==================== CLEANUP ON DISABLE ====================
local function _cleanup()
    pcall(function()
        for p, esp in pairs(_aimbot_state.esp_cache) do
            pcall(function() esp:Destroy() end)
        end
        _aimbot_state.esp_cache = {}
    end)
end

-- Export interface
return {
    enable = function() _aimbot_config.enabled = true end,
    disable = function() _aimbot_config.enabled = false; _cleanup() end,
    set_fov = function(fov) _aimbot_config.fov = math.max(10, math.min(180, fov)) end,
    set_smooth = function(smooth) _aimbot_config.base_smooth = math.max(0.01, math.min(1, smooth)) end,
    toggle_esp = function()
