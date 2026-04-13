-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                        Core.lua - Main Script                            ║
-- ║                    Mobile Penetration Testing - Core Logic               ║
-- ║                                                                           ║
-- ║                                                    ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Cam = game.Workspace.CurrentCamera

-- ==================== CONFIG ====================
local fov = 50
local FRAME_SKIP_ESP = 5
local FRAME_SKIP_AIMBOT = 3
local frame_counter = 0

-- ==================== ADAPTIVE DELAYS (LIGHTWEIGHT) ====================
local function _get_adaptive_delay()
    local rnd = math.random(1, 5)
    
    if rnd == 1 then -- Gaussian
        local u1 = math.random() / 32767
        local u2 = math.random() / 32767
        if u1 < 0.0001 then u1 = 0.0001 end
        local z0 = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
        return math.max(0.02, math.min(0.3, 0.08 + (z0 * 0.03)))
    elseif rnd == 2 then -- Exponential
        return math.max(0.02, math.min(0.3, -math.log(math.random()) * 0.08))
    elseif rnd == 3 then -- Pareto
        return math.max(0.02, math.min(0.3, 0.05 / math.pow(math.random(), 1/1.5)))
    elseif rnd == 4 then -- Weibull
        return math.max(0.02, math.min(0.3, 0.1 * math.pow(-math.log(math.random()), 1/1.2)))
    else -- Rayleigh
        return math.max(0.02, math.min(0.3, 0.08 * math.sqrt(-2 * math.log(math.random()))))
    end
end

-- ==================== CAMERA HISTORY ====================
local _camera_history = {
    positions = {},
    timestamps = {}
}

local function _init_camera_history()
    local cam = Cam
    for i = 1, 60 do
        table.insert(_camera_history.positions, cam.CFrame.Position)
        table.insert(_camera_history.timestamps, tick() - (60 - i) * (1/60))
    end
end

local function _record_camera()
    table.insert(_camera_history.positions, Cam.CFrame.Position)
    table.insert(_camera_history.timestamps, tick())
    
    if #_camera_history.positions > 300 then
        table.remove(_camera_history.positions, 1)
        table.remove(_camera_history.timestamps, 1)
    end
end

-- ==================== VARIABLE VELOCITY ====================
local function _get_velocity()
    local base = math.random(150, 350) / 1000
    
    if math.random() < 0.15 then
        base = base * math.random(150, 280) / 100
    end
    if math.random() < 0.10 then
        base = base * math.random(50, 80) / 100
    end
    
    local var = (math.random() - 0.5) * 0.06
    return math.max(0.1, math.min(0.7, base + var))
end

-- ==================== AIMBOT ====================
local function lookAt(target)
    local lookVector = (target - Cam.CFrame.Position).unit
    local smooth = _get_velocity()
    
    local newCFrame = CFrame.new(Cam.CFrame.Position, Cam.CFrame.Position + lookVector)
    Cam.CFrame = Cam.CFrame:Lerp(newCFrame, smooth)
    
    _record_camera()
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

-- ==================== ESP ====================
local esp_cache = {}

local function _ensure_esp(player)
    if player == Players.LocalPlayer or not player.Character then return end
    if esp_cache[player] then return end
    
    pcall(function()
        local hl = Instance.new("Highlight")
        hl.FillColor = Color3.fromRGB(255, 0, 255)
        hl.OutlineColor = Color3.fromRGB(255, 0, 255)
        hl.OutlineTransparency = 0.5
        hl.FillTransparency = 0.6
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = player.Character
        esp_cache[player] = hl
    end)
end

local function _cleanup_esp()
    for player, hl in pairs(esp_cache) do
        if not player or not player.Parent or not player.Character then
            pcall(function() hl:Destroy() end)
            esp_cache[player] = nil
        end
    end
end

local function _update_esp()
    _cleanup_esp()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            _ensure_esp(player)
        end
    end
end

-- ==================== PLAYER EVENTS ====================
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.05)
        _ensure_esp(p)
    end)
    task.wait(0.1)
    _ensure_esp(p)
end)

Players.PlayerRemoving:Connect(function(p)
    if esp_cache[p] then
        pcall(function() esp_cache[p]:Destroy() end)
        esp_cache[p] = nil
    end
end)

-- ==================== LAZY LOAD PROTECTIONS ====================
local protections_loaded = false

local function _load_protections()
    if protections_loaded then return end
    protections_loaded = true
    
    task.spawn(function()
        local Protection = require(script.Parent:WaitForChild("Protection"))
        Protection.init()
    end)
end

-- ==================== INITIALIZATION ====================
_init_camera_history()
_update_esp()
task.spawn(_load_protections) -- Carrega em background

-- ==================== MAIN LOOP ====================
RunService.RenderStepped:Connect(function()
    frame_counter = frame_counter + 1
    
    if frame_counter % FRAME_SKIP_ESP == 0 then
        _update_esp()
    end
    
    if frame_counter % FRAME_SKIP_AIMBOT == 0 then
        local closest = getClosestPlayerInFOV()
        if closest and closest.Character and closest.Character:FindFirstChild("Head") then
            _get_adaptive_delay()
            lookAt(closest.Character.Head.Position)
        end
    end
end)

print("[Core] Aimbot carregado com sucesso!")
