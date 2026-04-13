local Obfuscator = loadstring(game:HttpGet("https://raw.githubusercontent.com/bonatzz/Aim.lua/main/Obfuscator.lua"))()
local MemoryCleaner = loadstring(game:HttpGet("https://raw.githubusercontent.com/bonatzz/Aim.lua/main/MemoryCleaner.lua"))()
local HookBypass = loadstring(game:HttpGet("https://raw.githubusercontent.com/bonatzz/Aim.lua/main/HookBypass.lua"))()
local Randomizer = loadstring(game:HttpGet("https://raw.githubusercontent.com/bonatzz/Aim.lua/main/Randomizer.lua"))()
local SandboxEscape = loadstring(game:HttpGet("https://raw.githubusercontent.com/bonatzz/Aim.lua/main/SandboxEscape.lua"))()
local AntiAnalysis = loadstring(game:HttpGet("https://raw.githubusercontent.com/bonatzz/Aim.lua/main/AntiAnalysis.lua"))()
local AntiCheat = loadstring(game:HttpGet("https://raw.githubusercontent.com/bonatzz/Aim.lua/main/AntiCheat.lua"))()
local AntiDetect = loadstring(game:HttpGet("https://raw.githubusercontent.com/bonatzz/Aim.lua/main/AntiDetect.lua"))()
local SpeedBypass = loadstring(game:HttpGet("https://raw.githubusercontent.com/bonatzz/Aim.lua/main/SpeedBypass.lua"))()

MemoryCleaner:CleanGlobals()
MemoryCleaner:ClearMemory()
MemoryCleaner:RemoveDebugInfo()
HookBypass:BypassMetamethods()
HookBypass:BlockDetectionCalls()
SandboxEscape:EscapeRestrictions()
AntiAnalysis:HideScriptExecution()
AntiAnalysis:FakeStackTrace()
AntiCheat:HideActivity()
AntiDetect:HideFromDebugger()

local fov = 50
local baseSmooth = 0.25
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Cam = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Config = { Enabled = true, ESP_Enabled = true }
local playersAlive = {}
local espCache = {}

local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 3
FOVring.Color = Color3.fromRGB(100, 200, 255)
FOVring.Filled = false
FOVring.Radius = fov

local function isPlayerAlive(p)
    return p and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0
end

local lastUpdate = 0
local function updateAlivePlayers()
    if tick() - lastUpdate < 0.2 then return end
    lastUpdate = tick()
    playersAlive = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isPlayerAlive(p) then
            table.insert(playersAlive, p)
        end
    end
end

local function getClosestPlayer()
    Randomizer:RandomDelay()
    local closest, dist = nil, math.huge
    local center = Cam.ViewportSize / 2
    for _, p in ipairs(playersAlive) do
        local head = p.Character:FindFirstChild("Head")
        if head then
            local screenPos, vis = Cam:WorldToViewportPoint(head.Position)
            if vis then
                local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if screenDist < fov and screenDist < dist then
                    closest = p
                    dist = screenDist
                end
            end
        end
    end
    return closest
end

local function aimAt(target)
    if Config.Enabled and target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        if head then
            Randomizer:RandomPatterns()
            local smooth = Randomizer:VariableSmoothing()
            local current = Cam.CFrame
            local goal = CFrame.new(current.Position, head.Position)
            Cam.CFrame = current:Lerp(goal, smooth)
        end
    end
end

local function updateESP(p)
    if p == LocalPlayer or not Config.ESP_Enabled then return end
    local char = p.Character
    if not char then return end
    if espCache[p] then pcall(function() espCache[p]:Destroy() end) end
    local hl = Instance.new("Highlight")
    hl.FillColor = Color3.fromRGB(255, 0, 255)
    hl.Parent = char
    espCache[p] = hl
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() updateESP(p) end)
end)

Players.PlayerRemoving:Connect(function(p)
    if espCache[p] then pcall(function() espCache[p]:Destroy() end) espCache[p] = nil end
end)

RunService.RenderStepped:Connect(function()
    updateAlivePlayers()
    FOVring.Position = Cam.ViewportSize / 2
    aimAt(getClosestPlayer())
end)
