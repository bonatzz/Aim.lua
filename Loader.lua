-- ╔════════════════════════════════════════════════════════════════╗
-- ║     LOADER.LUA - PROTEÇÃO + AIMBOT REFORÇADO (INLINE)          ║
-- ║                                                                 ║
-- ║  Execute ISTO no seu executor Delta                            ║
-- ║  Copia e cola TUDO no console do Delta                         ║
-- ║                                                                 ║
-- ║  Aim.lua v5.0 - Mobile Optimized - AIMBOT REFORÇADO            ║
-- ╚════════════════════════════════════════════════════════════════╝

print("═" .. string.rep("═", 50))
print("⏳ Iniciando Aim.lua v5.0 - AIMBOT REFORÇADO...")
print("═" .. string.rep("═", 50))

-- ==================== PROTEÇÃO REFORÇADA ====================
local _mt_game = getrawmetatable(game)
local _protection_active = false

local function _protect_metamethods()
    pcall(function()
        if isreadonly(_mt_game) then return end
        local _orig_index = _mt_game.__index
        local _orig_newindex = _mt_game.__newindex
        local _orig_namecall = _mt_game.__namecall
        
        _mt_game.__index = function(self, key)
            if math.random() < 0.05 then task.delay(0.001, function() end) end
            return _orig_index(self, key)
        end
        
        _mt_game.__newindex = function(self, key, value)
            if math.random() < 0.05 then task.delay(0.001, function() end) end
            return _orig_newindex(self, key, value)
        end
        
        _mt_game.__namecall = function(self, ...)
            if math.random() < 0.05 then task.delay(0.001, function() end) end
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
                    result.source = result.source:gsub("exploit", "game"):gsub("cheat", "script"):gsub("delta", "system")
                end
                return result
            end
            return nil
        end
        
        debug.getlocal = function(level, index)
            if math.random() < 0.6 then return nil end
            return _orig_getlocal and _orig_getlocal(level, index)
        end
        
        debug.getupvalue = function(func, index)
            if math.random() < 0.6 then return nil end
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
        print = print, warn = warn, type = type, pairs = pairs,
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

print("🛡️  Ativando proteção...")
_protect_metamethods()
_protect_analysis()
_escape_sandbox()
_protect_hooks()
_clean_thread()
print("✅ Proteção ativada!")

task.wait(1)

-- ==================== AIMBOT REFORÇADO ====================
print("🎯 Ativando aimbot REFORÇADO...")

local fov = 80
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Cam = game.Workspace.CurrentCamera
local frame_counter = 0

-- ==================== SMOOTH AIMING ====================
local current_target = nil
local lock_strength = 0.35

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

local function _adaptive_delay()
    local distributions = {
        gaussian = function() return _gaussian_random(0.05, 0.02) end,
        exponential = function() return _exponential_random(0.05) end,
    }
    
    local chosen = math.random(1, 2) == 1 and "gaussian" or "exponential"
    local delay = distributions[chosen]()
    return math.max(0.01, math.min(0.15, delay))
end

local _camera_history = { positions = {}, velocities = {}, timestamps = {} }

local function _initialize_camera_history()
    local cam = Cam
    for i = 1, 60 do
        table.insert(_camera_history.positions, cam.CFrame.Position)
        table.insert(_camera_history.timestamps, tick() - (60 - i) * (1/60))
    end
end

local function _record_camera_state()
    table.insert(_camera_history.positions, Cam.CFrame.Position)
    table.insert(_camera_history.timestamps, tick())
    
    if #_camera_history.positions > 300 then
        table.remove(_camera_history.positions, 1)
        table.remove(_camera_history.timestamps, 1)
    end
end

-- ==================== PREDICTION + SMOOTH AIM ====================
local function predictPosition(targetHead, leadDistance)
    if not targetHead then return targetHead.Position end
    
    local targetPos = targetHead.Position
    local cameraPos = Cam.CFrame.Position
    local distance = (targetPos - cameraPos).Magnitude
    
    local lead = math.max(0, distance / 1000) * leadDistance
    
    return targetPos
end

local function smoothAim(targetHead)
    if not targetHead then return end
    
    _adaptive_delay()
    
    local predictedPos = predictPosition(targetHead, 0.5)
    local direction = (predictedPos - Cam.CFrame.Position).Unit
    
    local targetCFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + direction)
    Cam.CFrame = Cam.CFrame:Lerp(targetCFrame, lock_strength)
    
    _record_camera_state()
end

-- ==================== GET CLOSEST PLAYER (REFORÇADO) ====================
local function getClosestPlayerInFOV()
    local nearest = nil
    local last = math.huge
    local playerMousePos = Cam.ViewportSize / 2

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local part = player.Character:FindFirstChild("Head")
            if part then
                local ePos, isVisible = Cam:WorldToViewportPoint(part.Position)
                
                if isVisible then
                    local distance = (Vector2.new(ePos.x, ePos.y) - playerMousePos).Magnitude
                    
                    if distance < last and distance < fov then
                        last = distance
                        nearest = player
                    end
                end
            end
        end
    end

    return nearest
end

_initialize_camera_history()

-- ==================== MAIN LOOP (MAIS RÁPIDO) ====================
RunService.RenderStepped:Connect(function()
    frame_counter = frame_counter + 1
    
    local closest = getClosestPlayerInFOV()
    
    if closest and closest.Character then
        local head = closest.Character:FindFirstChild("Head")
        if head then
            current_target = head
            smoothAim(head)
        end
    else
        current_target = nil
    end
end)

print("✅ Aimbot REFORÇADO ativado!")
print("\n═" .. string.rep("═", 50))
print("✅ SISTEMA COMPLETO PRONTO!")
print("🎯 Aim.lua v5.0 - DELTA MOBILE")
print("🔫 Aimbot REFORÇADO - Grudado no alvo!")
print("═" .. string.rep("═", 50))
