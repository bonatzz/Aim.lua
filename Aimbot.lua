-- ===== AIMBOT PARA MOBILE + LOADSTRING =====
local fov = 50
local baseSmooth = 0.25

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Cam = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--================ CONFIG =================--
local Config = {
    Enabled = true,
    ESP_Enabled = true
}

--================ FOV =================--
local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 3
FOVring.Color = Color3.fromRGB(100, 200, 255)
FOVring.Filled = false
FOVring.Radius = fov

local function updateFOV()
    FOVring.Position = Cam.ViewportSize / 2
end

--================ PLAYER TRACKING =================--
local playersAlive = {}

local function isPlayerAlive(player)
    if not player then return false end
    if not player.Character then return false end
    local humanoid = player.Character:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function updateAlivePlayers()
    playersAlive = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isPlayerAlive(player) then
            table.insert(playersAlive, player)
        end
    end
end

--================ AIMBOT =================--
local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local cameraPosition = Cam.CFrame.Position
    local viewCenter = Cam.ViewportSize / 2

    for _, player in ipairs(playersAlive) do
        local character = player.Character
        local head = character:FindFirstChild("Head")
        if head then
            local worldPosition = head.Position
            local screenPosition, visible = Cam:WorldToViewportPoint(worldPosition)
            if visible then
                local distance = (Vector2.new(screenPosition.X, screenPosition.Y) - viewCenter).Magnitude
                if distance < shortestDistance and distance < fov then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end

    return closestPlayer
end

local function aimAt(target)
    if not target then return end
    local character = target.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end

    local currentCameraCFrame = Cam.CFrame
    local goalCFrame = CFrame.new(currentCameraCFrame.Position, head.Position)

    Cam.CFrame = currentCameraCFrame:Lerp(goalCFrame, baseSmooth)
end

--================ ESP =================--
local espCache = {}

local function updateESP(player)
    if player == LocalPlayer or not Config.ESP_Enabled then return end
    local character = player.Character
    if not character then return end

    if espCache[player] then
        espCache[player]:Destroy()
    end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 255)
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.Parent = character

    espCache[player] = highlight
end

local function removeESP(player)
    if espCache[player] then
        espCache[player]:Destroy()
        espCache[player] = nil
    end
end

--================ MAIN =================--
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        updateESP(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

RunService.RenderStepped:Connect(function()
    updateAlivePlayers()
    updateFOV()

    local closestPlayer = getClosestPlayer()
    aimAt(closestPlayer)
end)