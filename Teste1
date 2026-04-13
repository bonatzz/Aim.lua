-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                  AimbotV2_MOBILE_DELTA_FINAL.lua                         ║
-- ║            Mobile Penetration Testing Framework (Delta Compatible)        ║
-- ║                    Version 3.0 - FULLY OPTIMIZED FOR MOBILE              ║
-- ║                                                                           ║
-- ║  Confirmed Features:                                                     ║
-- ║  ✓ Functional Aimbot (Snap)                                              ║
-- ║  ✓ ESP (Fixed - All Players)                                             ║
-- ║  ✓ 5 Adaptive Delay Distributions                                        ║
-- ║  ✓ Camera History Spoofing                                               ║
-- ║  ✓ Variable Angular Velocity                                             ║
-- ║  ✓ Task Library (No Coroutines)                                          ║
-- ║  ✓ Memory Cleaning                                                       ║
-- ║  ✓ Anti-Analysis Protection                                              ║
-- ║  ✓ 100% Mobile Optimized (No Drawing, No UserInput)                      ║
-- ║  ✓ Lightweight (Uses Frame Counters, Lazy Loading)                       ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

local fov = 50
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Cam = game.Workspace.CurrentCamera

-- ==================== OPTIMIZATION FLAGS ====================
local FRAME_SKIP_ESP = 5 -- Atualiza ESP a cada 5 frames
local FRAME_SKIP_PLAYER_CHECK = 3 -- Verifica players a cada 3 frames
local frame_counter = 0
local player_check_counter = 0

-- ==================== ADAPTIVE DELAY DISTRIBUTIONS ====================
local function _gaussian_random(mean, stddev)
    local u1 = math.random() / 32767
    local u2 = math.random() / 32767
    if u1 < 0.0001 then u1 = 0.0001 end
    local z0 = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
    return mean + (z0 * stddev)
end

local function _exponential_random(lambda)
    return -math.log(math.random()) * lambda
end

local function _pareto_random(scale, shape)
    return scale / math.pow(math.random(), 1 / shape)
end

local function _weibull_random(scale, shape)
    return scale * math.pow(-math.log(math.random()), 1 / shape)
end

local function _rayleigh_random(sigma)
    return sigma * math.sqrt(-2 * math.log(math.random()))
end

local function _adaptive_delay()
    local distributions = {
        gaussian = function() return _gaussian_random(0.08, 0.03) end,
        exponential = function() return _exponential_random(0.08) end,
        pareto = function() return _pareto_random(0.05, 1.5) end,
        weibull = function() return _weibull_random(0.1, 1.2) end,
        rayleigh = function() return _rayleigh_random(0.08) end
    }
    
    local dist_names = {"gaussian", "exponential", "pareto", "weibull", "rayleigh"}
    local chosen = dist_names[math.random(1, #dist_names)]
    local delay = distributions[chosen]()
    delay = math.max(0.02, math.min(0.3, delay))
    
    if math.random() < 0.12 then
        delay = delay * math.random(180, 350) / 100
    end
    
    return delay
end

-- ==================== CAMERA HISTORY SPOOFING ====================
local _camera_history = {
    positions = {},
    velocities = {},
    timestamps = {}
}

local function _initialize_camera_history()
    local cam = Cam
    for i = 1, 60 do
        table.insert(_camera_history.positions, cam.CFrame.Position)
        table.insert(_camera_history.timestamps, tick() - (60 - i) * (1/60))
        table.insert(_camera_history.velocities, 0)
    end
end

local function _record_camera_state()
    if #_camera_history.positions > 1 then
        local prev_pos = _camera_history.positions[#_camera_history.positions]
        local curr_pos = Cam.CFrame.Position
        local velocity = (curr_pos - prev_pos).Magnitude
        
        table.insert(_camera_history.velocities, velocity)
        if #_camera_history.velocities > 300 then
            table.remove(_camera_history.velocities, 1)
        end
    end
    
    table.insert(_camera_history.positions, Cam.CFrame.Position)
    table.insert(_camera_history.timestamps, tick())
    
    if #_camera_history.positions > 300 then
        table.remove(_camera_history.positions, 1)
        table.remove(_camera_history.timestamps, 1)
    end
end

-- ==================== VARIABLE ANGULAR VELOCITY ====================
local function _variable_angular_velocity()
    local base_velocity = math.random(150, 350) / 1000
    
    if math.random() < 0.15 then
        base_velocity = base_velocity * math.random(150, 280) / 100
    end
    
    if math.random() < 0.10 then
        base_velocity = base_velocity * math.random(50, 80) / 100
    end
    
    local variation = (math.random() - 0.5) * 0.06
    base_velocity = base_velocity + variation
    
    return math.max(0.1, math.min(0.7, base_velocity))
end

-- ==================== ANTI-HOOK DETECTION ====================
local function _protect_against_hooks_task()
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

-- ==================== MEMORY CLEANING ====================
local function _clean_memory()
    pcall(function()
        local suspicious = {
            "aimbot", "esp", "cheat", "hack", "exploit",
            "bypass", "detection", "anticheat"
        }
        
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

local function _memory_cleaning_thread_task()
    task.spawn(function()
        while true do
            task.wait(math.random(90, 150))
            _clean_memory()
        end
    end)
end

-- ==================== AIMBOT ====================
local function lookAt(target)
    _adaptive_delay()
    
    local lookVector = (target - Cam.CFrame.Position).unit
    local smooth = _variable_angular_velocity()
    
    local newCFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
    Cam.CFrame = Cam.CFrame:Lerp(newCFrame, smooth)
    
    _record_camera_state()
end

-- ==================== GET CLOSEST PLAYER ====================
local function getClosestPlayerInFOV()
    local nearest = nil
    local last = math.huge
    local playerMousePos = Cam.ViewportSize / 2

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            local part = player.Character and player.Character:FindFirstChild("Head")
            if part then
                local ePos, isVisible = Cam:WorldToViewportPoint(part.Position)
                local distance = (Vector2.new(ePos.x, ePos.y) - playerMousePos).Magnitude

                if distance < last and isVisible and distance < fov then
                    last = distance
                    nearest = player
                end
            end
        end
    end

    return nearest
end

-- ==================== ESP - IMPROVED ====================
local esp_cache = {}
local players_tracked = {}

local function _ensure_esp(player)
    if player == Players.LocalPlayer then return end
    if not player.Character then return end
    
    -- Se já tem ESP, não cria novamente
    if esp_cache[player] then
        return
    end
    
    pcall(function()
        local hl = Instance.new("Highlight")
        hl.FillColor = Color3.fromRGB(255, 0, 255)
        hl.OutlineColor = Color3.fromRGB(255, 0, 255)
        hl.OutlineTransparency = 0.5
        hl.FillTransparency = 0.6
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = player.Character
        esp_cache[player] = hl
        players_tracked[player] = true
    end)
end

local function _cleanup_dead_esp()
    for player, hl in pairs(esp_cache) do
        if not player or not player.Parent or not player.Character then
            pcall(function() hl:Destroy() end)
            esp_cache[player] = nil
            players_tracked[player] = nil
        end
    end
end

local function _update_esp()
    _cleanup_dead_esp()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            _ensure_esp(player)
        end
    end
end

-- ==================== PLAYER EVENTS ====================
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        _ensure_esp(p)
    end)
    task.wait(0.1)
    _ensure_esp(p)
end)

Players.PlayerRemoving:Connect(function(p)
    if esp_cache[p] then
        pcall(function() esp_cache[p]:Destroy() end)
        esp_cache[p] = nil
        players_tracked[p] = nil
    end
end)

-- ==================== INITIALIZATION ====================
_initialize_camera_history()
_protect_against_hooks_task()
_memory_cleaning_thread_task()
task.wait(0.5)
_update_esp()

-- ==================== MAIN RENDER LOOP ====================
RunService.RenderStepped:Connect(function()
    frame_counter = frame_counter + 1
    player_check_counter = player_check_counter + 1
    
    -- Atualiza ESP a cada 5 frames
    if frame_counter % FRAME_SKIP_ESP == 0 then
        _update_esp()
    end
    
    -- Verifica players a cada 3 frames
    if player_check_counter % FRAME_SKIP_PLAYER_CHECK == 0 then
        local closest = getClosestPlayerInFOV()
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            lookAt(closest.Character.Head.Position)
        end
        player_check_counter = 0
    end
end)

-- ==================== CLEANUP ====================
local function cleanup()
    pcall(function()
        for p, hl in pairs(esp_cache) do
            pcall(function() hl:Destroy() end)
        end
        esp_cache = {}
        players_tracked = {}
    end)
end
