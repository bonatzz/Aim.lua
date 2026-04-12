-- ===== AIMBOT PARA MOBILE + LOADSTRING =====
local fov = 40
local baseSmooth = 0.2

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Cam = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--================ CONFIG =================--
local Config = {
	Enabled = true,
	ESP_Enabled = true,
	ShowFOV = true,
	HumanizeMovement = true,
	AntiDetection = true,
	PredictionEnabled = true,
	TargetLock = true
}

--================ FOV RING =================--
local FOVring
pcall(function()
	FOVring = Drawing.new("Circle")
	FOVring.Visible = Config.ShowFOV
	FOVring.Thickness = 2
	FOVring.Color = Color3.fromRGB(100, 200, 255)
	FOVring.Filled = false
	FOVring.Radius = fov
	FOVring.Transparency = 0.8
end)

local function updateFOV()
	if FOVring and FOVring.Visible then
		pcall(function()
			FOVring.Position = Cam.ViewportSize / 2
		end)
	end
end

--================ STATUS TEXT (UI) =================--
local statusText
pcall(function()
	statusText = Drawing.new("Text")
	statusText.Size = 18
	statusText.Color = Color3.fromRGB(0, 255, 0)
	statusText.Position = Vector2.new(10, 10)
	statusText.Text = "✅ AIMBOT ATIVO"
end)

--================ CACHE DE ALVOS =================--
local targets = {}
local lastTargetUpdate = 0
local targetUpdateInterval = 0.2

local function updateTargets()
	local now = tick()
	if now - lastTargetUpdate < targetUpdateInterval then return end
	
	lastTargetUpdate = now
	targets = {}
	
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local humanoid = p.Character:FindFirstChild("Humanoid")
			if humanoid and humanoid.Health > 0 then
				local head = p.Character:FindFirstChild("Head")
				if head then
					table.insert(targets, p)
				end
			end
		end
	end
end

--================ DETECÇÃO DE ALVO =================--
local lastTarget = nil
local lastTargetTime = 0

local function getClosestPlayer()
	updateTargets()
	
	local nearest = nil
	local last = math.huge
	local center = Cam.ViewportSize / 2
	local camPos = Cam.CFrame.Position
	local now = tick()

	for _, p in ipairs(targets) do
		local char = p.Character
		if not char then continue end
		
		local head = char:FindFirstChild("Head")
		if not head then continue end

		local pos, vis = Cam:WorldToViewportPoint(head.Position)
		if not vis then continue end
		
		local screenDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
		local worldDist = (head.Position - camPos).Magnitude

		if Config.TargetLock and lastTarget and lastTarget == head then
			screenDist = screenDist * 0.6
		end

		if screenDist < fov and worldDist < last then
			last = worldDist
			nearest = {
				head = head,
				screenDist = screenDist,
				worldDist = worldDist,
				player = p
			}
		end
	end

	return nearest
end

--================ PREDIÇÃO =================--
local lastPos = {}

local function predictPosition(head, player)
	if not Config.PredictionEnabled then return head.Position end
	
	local predictedPos = head.Position
	
	if lastPos[player] then
		local vel = (head.Position - lastPos[player]) / 0.016
		predictedPos = head.Position + (vel * 0.08)
	end
	
	lastPos[player] = head.Position
	return predictedPos
end

--================ AIM ASSIST =================--
local lastAimTime = 0
local reactionDelay = 0.1

local function aimAssist(targetData)
	if not Config.Enabled or not targetData then return end
	
	local now = tick()
	if now - lastAimTime < reactionDelay then return end
	lastAimTime = now
	
	local target = targetData.head
	if not target or not target.Parent then return end
	
	local current = Cam.CFrame
	local targetPos = predictPosition(target, targetData.player)
	local goal = CFrame.new(current.Position, targetPos)
	
	local smooth = getSmooth(targetData.screenDist)
	
	Cam.CFrame = current:Lerp(goal, smooth)
	
	if Config.HumanizeMovement and Config.AntiDetection then
		local shakeX = getHumanShake()
		local shakeY = getHumanShake()
		pcall(function()
			Cam.CFrame = Cam.CFrame * CFrame.new(shakeX * 0.2, shakeY * 0.2, 0)
		end)
	end
	
	if lastTarget ~= target then
		lastTarget = target
		lastTargetTime = now
	end
end

--================ ESP =================--
local espCache = {}

local function applyESP(player)
	if player == LocalPlayer or not Config.ESP_Enabled then return end

	local function setup(char)
		if not char then return end

		if espCache[player] then
			pcall(function() 
				if espCache[player] and espCache[player].Parent then
					espCache[player]:Destroy() 
				end
			end)
			espCache[player] = nil
		end

		local humanoid = char:FindFirstChild("Humanoid")
		if not humanoid or humanoid.Health <= 0 then return end

		pcall(function()
			local hl = Instance.new("Highlight")
			hl.Name = "ESP"
			hl.FillTransparency = 0.65
			hl.OutlineTransparency = 0.2
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.FillColor = Color3.fromRGB(255, 0, 255)
			hl.Parent = char
			espCache[player] = hl
			
			humanoid.Died:Connect(function()
				pcall(function()
					if espCache[player] and espCache[player].Parent then
						espCache[player]:Destroy()
					end
					espCache[player] = nil
				end)
			end)
		end)
	end

	if player.Character then
		setup(player.Character)
	end

	player.CharacterAdded:Connect(setup)
end

for _, p in ipairs(Players:GetPlayers()) do
	applyESP(p)
end

Players.PlayerAdded:Connect(function(p)
	task.wait(0.1)
	applyESP(p)
end)

Players.PlayerRemoving:Connect(function(p)
	if espCache[p] then
		pcall(function()
			if espCache[p] and espCache[p].Parent then
				espCache[p]:Destroy()
			end
		end)
		espCache[p] = nil
	end
end)

--================ MAIN LOOP =================--
RunService.RenderStepped:Connect(function()
	updateFOV()

	pcall(function()
		local targetData = getClosestPlayer()
		if targetData then
			aimAssist(targetData)
		end
	end)
end)

print("✅ AIMBOT CARREGADO COM SUCESSO!")
