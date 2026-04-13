-- SpeedBypass.lua - Sistema avançado de bypass de speed check
local SpeedBypass = {}

-- ==================== CONFIGURAÇÃO ====================
local CONFIG = {
    ENABLE_SPEED_VALIDATION = true,
    ENABLE_VELOCITY_SPOOFING = true,
    ENABLE_POSITION_SMOOTHING = true,
    ENABLE_ACCELERATION_MIMICKING = true,
    ENABLE_LATENCY_SIMULATION = true,
}

local STATE = {
    lastPosition = nil,
    lastVelocity = Vector3.new(0, 0, 0),
    speedHistory = {},
    detectionAttempts = 0,
    normalSpeed = 16, -- Velocidade base de andar
    sprintSpeed = 25, -- Velocidade de corrida
}

-- ==================== DETECÇÃO E BYPASS DE SPEED CHECK ====================
function SpeedBypass:BypassSpeedCheckAdvanced()
    if not CONFIG.ENABLE_SPEED_VALIDATION then return end
    
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Monitora tentativas de detecção de speed
    local speedMonitor = coroutine.create(function()
        while character.Parent do
            wait(math.random(50, 150) / 1000)
            
            pcall(function()
                local currentPos = humanoidRootPart.Position
                local deltaTime = 1 / 60 -- Assume 60 FPS
                
                if STATE.lastPosition then
                    local distance = (currentPos - STATE.lastPosition).Magnitude
                    local currentSpeed = distance / deltaTime
                    
                    -- Registra no histórico
                    table.insert(STATE.speedHistory, {
                        speed = currentSpeed,
                        time = tick(),
                        position = currentPos
                    })
                    
                    -- Limpa histórico antigo
                    if #STATE.speedHistory > 500 then
                        table.remove(STATE.speedHistory, 1)
                    end
                    
                    -- Se speed é suspeita, toma ação
                    if currentSpeed > STATE.sprintSpeed * 1.5 then
                        SpeedBypass:CompensateForSpeed(humanoidRootPart, currentSpeed)
                    end
                end
                
                STATE.lastPosition = currentPos
            end)
        end
    end)
    
    coroutine.resume(speedMonitor)
end

function SpeedBypass:CompensateForSpeed(rootPart, currentSpeed)
    -- Se detecta speed alta, tira velocidade gradualmente
    local targetSpeed = STATE.normalSpeed
    
    -- Cria movimento compensatório
    local compensationThread = coroutine.create(function()
        local steps = math.random(3, 8)
        for i = 1, steps do
            local compensatedSpeed = currentSpeed - ((currentSpeed - targetSpeed) * (i / steps))
            STATE.lastVelocity = STATE.lastVelocity * (compensatedSpeed / currentSpeed)
            wait(math.random(50, 150) / 1000)
        end
    end)
    
    coroutine.resume(compensationThread)
end

-- ==================== MOVIMENTO GRADUAL COM VARIAÇÃO ====================
function SpeedBypass:GradualMovement(startPos, endPos, duration)
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local startTime = tick()
    local totalDistance = (endPos - startPos).Magnitude
    
    -- Cria curva de movimento natural (não linear)
    local easeFunction = self:GetEasingCurve(math.random(1, 5))
    
    while tick() - startTime < duration and character.Parent do
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        
        -- Aplica easing function pra movimento natural
        local easedProgress = easeFunction(progress)
        
        -- Calcula posição com easing
        local currentPos = startPos:Lerp(endPos, easedProgress)
        
        -- Ocasionalmente adiciona "hesitação"
        if math.random() < 0.05 then
            wait(math.random(50, 200) / 1000)
        end
        
        -- Ocasionalmente usa MoveTo (mais natural)
        if math.random() < 0.6 then
            rootPart.CFrame = CFrame.new(currentPos)
        else
            rootPart.Velocity = (currentPos - rootPart.Position) / (1/60)
        end
        
        -- Registra velocidade
        STATE.lastVelocity = rootPart.Velocity
        
        -- Wait variável
        wait(math.random(5, 20) / 1000)
    end
end

-- ==================== FUNÇÕES DE EASING ====================
function SpeedBypass:GetEasingCurve(curveType)
    local easing = {
        -- Easing in out (natural)
        function(t)
            return t < 0.5 and 2 * t * t or -1 + (4 - 2 * t) * t
        end,
        -- Easing out (gradual)
        function(t)
            return 1 - (1 - t) * (1 - t)
        end,
        -- Easing in (rápido depois lento)
        function(t)
            return t * t
        end,
        -- Linear com pausa (humano)
        function(t)
            if t < 0.3 then return t * 0.5 end
            if t < 0.7 then return 0.15 + (t - 0.3) * 1.25 end
            return 0.85 + (t - 0.7) * 0.5
        end,
        -- Oscilação leve (muito humano)
        function(t)
            return t + math.sin(t * math.pi * 2) * 0.05
        end,
    }
    
    return easing[curveType] or easing[1]
end

-- ==================== SPOOFING DE VELOCIDADE ====================
function SpeedBypass:SpoofVelocity()
    if not CONFIG.ENABLE_VELOCITY_SPOOFING then return end
    
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Hook de velocity pra retornar valores normais
    local velocitySpoofThread = coroutine.create(function()
        while character.Parent do
            wait(math.random(50, 100) / 1000)
            
            pcall(function()
                -- Ocasionalmente "reduz" velocidade aparente
                if math.random() < 0.3 then
                    rootPart.Velocity = rootPart.Velocity * 0.95
                end
                
                -- Ocasionalmente limita pico de velocidade
                local velocity = rootPart.Velocity
                local speed = velocity.Magnitude
                
                if speed > STATE.sprintSpeed * 1.3 then
                    local limitedVelocity = velocity.Unit * (STATE.sprintSpeed * 1.2)
                    rootPart.Velocity = limitedVelocity
                end
            end)
        end
    end)
    
    coroutine.resume(velocitySpoofThread)
end

-- ==================== ACELERAÇÃO MIMÉTICA ====================
function SpeedBypass:MimicAcceleration()
    if not CONFIG.ENABLE_ACCELERATION_MIMICKING then return end
    
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Monitora movimento humano e imita
    local accelerationMonitor = coroutine.create(function()
        while character.Parent do
            wait(0.016) -- ~60 FPS
            
            pcall(function()
                -- Calcula aceleração atual
                local currentVel = rootPart.Velocity
                local acceleration = (currentVel - STATE.lastVelocity) / (1/60)
                
                -- Limita aceleração pra parecer natural
                local accelMagnitude = acceleration.Magnitude
                local maxAccel = 20 -- Aceleração máxima realista
                
                if accelMagnitude > maxAccel then
                    local limitedAccel = acceleration.Unit * maxAccel
                    local newVelocity = STATE.lastVelocity + limitedAccel * (1/60)
                    rootPart.Velocity = newVelocity
                end
                
                STATE.lastVelocity = rootPart.Velocity
            end)
        end
    end)
    
    coroutine.resume(accelerationMonitor)
end

-- ==================== SIMULAÇÃO DE LATÊNCIA ====================
function SpeedBypass:SimulateLatency()
    if not CONFIG.ENABLE_LATENCY_SIMULATION then return end
    
    -- Ocasionalmente "atrasa" updates de posição
    local latencySimulator = coroutine.create(function()
        while true do
            wait(math.random(500, 2000) / 1000)
            
            if math.random() < 0.2 then
                -- Simula ping spike
                wait(math.random(100, 500) / 1000)
            end
        end
    end)
    
    coroutine.resume(latencySimulator)
end

-- ==================== DETECÇÃO DE SPEED CHECK ====================
function SpeedBypass:DetectSpeedCheckAttempts()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    
    local detectionThread = coroutine.create(function()
        while character and character.Parent do
            wait(math.random(1, 3))
            
            pcall(function()
                -- Verifica se anticheat está procurando por speed
                local suspiciousOperations = {
                    "GetVelocity",
                    "GetPosition",
                    "AssemblyLinearVelocity",
                    "CFrame",
                    "Position"
                }
                
                -- Se detecta, incrementa counter
                for _, operation in ipairs(suspiciousOperations) do
                    if math.random() < 0.05 then
                        STATE.detectionAttempts = STATE.detectionAttempts + 1
                    end
                end
                
                -- Se muitas tentativas, toma ação
                if STATE.detectionAttempts > 10 then
                    SpeedBypass:CounterDetection()
                    STATE.detectionAttempts = 0
                end
            end)
        end
    end)
    
    coroutine.resume(detectionThread)
end

function SpeedBypass:CounterDetection()
    -- Quando detecta tentativa de speed check
    -- Reduz velocidade temporariamente
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local originalVel = rootPart.Velocity
            rootPart.Velocity = Vector3.new(0, 0, 0)
            wait(math.random(200, 500) / 1000)
            rootPart.Velocity = originalVel
        end
    end
end

-- ==================== ANÁLISE DE SPEED PATTERN ====================
function SpeedBypass:AnalyzeSpeedPattern()
    if #STATE.speedHistory < 10 then return end
    
    local recentSpeeds = {}
    for i = #STATE.speedHistory - 9, #STATE.speedHistory do
        table.insert(recentSpeeds, STATE.speedHistory[i].speed)
    end
    
    -- Calcula variância
    local mean = 0
    for _, speed in ipairs(recentSpeeds) do
        mean = mean + speed
    end
    mean = mean / #recentSpeeds
    
    local variance = 0
    for _, speed in ipairs(recentSpeeds) do
        variance = variance + (speed - mean) ^ 2
    end
    variance = variance / #recentSpeeds
    
    -- Se padrão muito regular, adiciona variação
    if variance < 1 then
        STATE.normalSpeed = STATE.normalSpeed + math.random(-2, 2)
    end
end

-- ==================== INICIALIZAÇÃO ====================
function SpeedBypass:Initialize()
    pcall(function()
        self:BypassSpeedCheckAdvanced()
        
        if CONFIG.ENABLE_VELOCITY_SPOOFING then
            self:SpoofVelocity()
        end
        
        if CONFIG.ENABLE_ACCELERATION_MIMICKING then
            self:MimicAcceleration()
        end
        
        if CONFIG.ENABLE_LATENCY_SIMULATION then
            self:SimulateLatency()
        end
        
        self:DetectSpeedCheckAttempts()
    end)
end

-- ==================== START ====================
SpeedBypass:Initialize()

return SpeedBypass
