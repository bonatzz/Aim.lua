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

--================ PLAYER TRACKING =================--

local PlayerTracking = {}
PlayerTracking.ActivePlayers = {}
PlayerTracking.LastUpdate = 0
PlayerTracking.UpdateInterval = 0.3  -- Atualiza a cada 0.3s

local function isPlayerAlive(player)
	if not player or not player.Character then
		return false
	end
	
	local humanoid = player.Character:FindFirstChild("Humanoid")
	if not humanoid then
		return false
	end
	
	-- Verifica se o humanoid está vivo (Health > 0)
	return humanoid.Health > 0
end

local function updateActivePlayers()
	local now = tick()
	
	-- Atualiza só a cada intervalo pra não processar muito
	if now - PlayerTracking.LastUpdate < PlayerTracking.UpdateInterval then
		return
	end
	
	PlayerTracking.LastUpdate = now
	PlayerTracking.ActivePlayers = {}
	
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			-- Só adiciona se estiver vivo
			if isPlayerAlive(p) then
				table.insert(PlayerTracking.ActivePlayers, p)
			end
		end
	end
end

--================ AIM =================--

local FOVring = Drawing.new("Circle")
FOVring.Visible = true
FOVring.Thickness = 2
FOVring.Color = Color3.fromRGB(128, 0, 128)
FOVring.Filled = false
FOVring.Radius = fov

local function updateFOV()
	FOVring.Position = Cam.ViewportSize / 2
end

local function getClosestPlayer()
	local nearest = nil
	local last = math.huge
	local center = Cam.ViewportSize / 2
	local camPos = Cam.CFrame.Position

	for _,p in ipairs(PlayerTracking.ActivePlayers) do
		-- Verifica novamente se está vivo
		if not isPlayerAlive(p) then
			goto continue
		end
		
		local char = p.Character
		local head = char and char:FindFirstChild("Head")

		if head then
			local pos, vis = Cam:WorldToViewportPoint(head.Position)
			local screenDist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
			
			-- Calcula distância em STUDS (mundo real)
			local worldDist = (head.Position - camPos).Magnitude

			if vis and screenDist < fov then
				-- PRIORIZA O MAIS PERTO (em studs)
				if worldDist < last then
					last = worldDist
					nearest = {head = head, screenDist = screenDist, worldDist = worldDist}
				end
			end
		end
		
		::continue::
	end

	return nearest, last
end

local function aimAssist(targetData)
	if not Config.Enabled or not targetData then return end
	
	local target = targetData.head
	
	-- Verifica NOVAMENTE se o alvo ainda está vivo
	if not target or not target.Parent or not isPlayerAlive(target.Parent.Parent) then
		return
	end
	
	local screenDist = targetData.screenDist
	
	local current = Cam.CFrame
	local goal = CFrame.new(current.Position, target.Position)

	local strength = 1 - (screenDist / fov)
	if strength < 0.1 then return end

	local smooth = baseSmooth + (strength * 0.4)

	Cam.CFrame = current:Lerp(goal, smooth)
end

--================ ESP =================--

local espCache = {}

local function isESPValid(player)
	if not player or not player.Character then
		return false
	end
	return isPlayerAlive(player)
end

local function applyESP(player)
	if player == LocalPlayer or not Config.ESP_Enabled then return end

	local function setup(char)
		if not char then return end

		if espCache[player] then
			pcall(function() espCache[player]:Destroy() end)
			espCache[player] = nil
		end

		local hl = Instance.new("Highlight")
		hl.Name = "ESP"
		hl.FillTransparency = 0.4
		hl.OutlineTransparency = 0
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.FillColor = Color3.fromRGB(255, 0, 255)
		hl.Parent = char

		espCache[player] = hl
	end

	if player.Character then
		setup(player.Character)
	end

	player.CharacterAdded:Connect(function(newChar)
		-- Quando reviver, atualiza ESP
		task.wait(0.05)
		setup(newChar)
	end)
end

-- Inicializa ESP para players existentes
for _,p in ipairs(Players:GetPlayers()) do
	applyESP(p)
end

-- Quando novo player entra
Players.PlayerAdded:Connect(function(p)
	task.wait(0.15)
	applyESP(p)
	print("📍 Novo player detectado: " .. p.Name)
end)

-- Quando player sai
Players.PlayerRemoving:Connect(function(p)
	if espCache[p] then
		pcall(function() espCache[p]:Destroy() end)
		espCache[p] = nil
	end
	print("❌ Player removido: " .. p.Name)
end)

--================ INPUT =================--

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.F6 then
		Config.Enabled = not Config.Enabled
		print("🎯 Aimbot " .. (Config.Enabled and "ON" or "OFF"))
	elseif input.KeyCode == Enum.KeyCode.F7 then
		Config.ESP_Enabled = not Config.ESP_Enabled
		print("👁️ ESP " .. (Config.ESP_Enabled and "ON" or "OFF"))
	end
end)

--================ LOOP =================--

RunService.RenderStepped:Connect(function()
	-- Atualiza lista de players vivos
	updateActivePlayers()
	
	updateFOV()

	local targetData = getClosestPlayer()

	if targetData then
		aimAssist(targetData)
	end
end)

print("✅ Aimbot Pro v3.0 Loaded!")
print("🎯 FOV: 50 | Modo: GRUDAR MUITO")
print("📍 Prioriza: Mais PERTO (em STUDS)")
print("💀 Detecta Mortes: ON")
print("🔄 Atualiza Players: Contínuo")
print("⌨️ F6=Toggle | F7=ESP")
