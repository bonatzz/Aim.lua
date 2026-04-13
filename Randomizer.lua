-- Randomizer.lua - Sistema avançado de randomização e humanização
local Randomizer = {}

-- ==================== CONFIGURAÇÃO ====================
local CONFIG = {
    ENABLE_ADVANCED_RANDOMIZATION = true,
    ENABLE_PATTERN_VARIATION = true,
    ENABLE_MOVEMENT_HUMANIZATION = true,
    ENABLE_TIMING_SPOOFING = true,
    ENABLE_BEHAVIORAL_DEVIATION = true,
}

local STATE = {
    delayHistory = {},
    patternHistory = {},
    movementHistory = {},
    lastRandomSeed = 0,
    deviationLevel = 0,
}

-- ==================== RANDOMIZAÇÃO AVANÇADA DE DELAY ====================
function Randomizer:GenerateSmartDelay()
    -- Gera delays baseados em distribuição natural (Gaussian)
    local mean = math.random(80, 150) / 1000
    local stdDev = math.random(20, 50) / 1000
    
    -- Box-Muller transform para distribuição normal
    local u1 = math.random() / 32767
    local u2 = math.random() / 32767
    
    local z0 = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
    local delay = mean + (z0 * stdDev)
    
    -- Clamp pra valores realistas
    delay = math.max(0.05, math.min(0.5, delay))
    
    -- Ocasionalmente adiciona "hesitação"
    if math.random() < 0.15 then
        delay = delay * math.random(200, 500) / 100
    end
    
    -- Registra no histórico
    table.insert(STATE.delayHistory, {
        delay = delay,
        time = tick()
    })
    
    -- Limpa histórico antigo
    if #STATE.delayHistory > 1000 then
        table.remove(STATE.delayHistory, 1)
    end
    
    return delay
end

function Randomizer:AnalyzeDelayPattern()
    -- Analisa padrões de delay pra evitar repetição
    if #STATE.delayHistory < 10 then
        return true
    end
    
    local recent = {}
    for i = #STATE.delayHistory - 9, #STATE.delayHistory do
        table.insert(recent, STATE.delayHistory[i].delay)
    end
    
    -- Calcula variância
    local mean = 0
    for _, v in ipairs(recent) do
        mean = mean + v
    end
    mean = mean / #recent
    
    local variance = 0
    for _, v in ipairs(recent) do
        variance = variance + (v - mean) ^ 2
    end
    variance = variance / #recent
    
    -- Se variância muito baixa, força mais variação
    if variance < 0.0001 then
        return false
    end
    
    return true
end

function Randomizer:RandomDelay()
    local delay = self:GenerateSmartDelay()
    
    -- Analisa se está seguindo padrão
    if not self:AnalyzeDelayPattern() then
        delay = delay * math.random(150, 300) / 100
    end
    
    wait(delay)
end

-- ==================== PADRÕES AVANÇADOS E DINÂMICOS ====================
function Randomizer:GenerateDynamicPatterns()
    -- Gera padrões que mudam em tempo real
    local patternCount = math.random(1, 8)
    local patterns = {}
    
    -- Padrão 1: Delay progressivo
    table.insert(patterns, function()
        for i = 1, math.random(2, 5) do
            wait(math.random(10, 30) / 1000 + (i * 0.005))
        end
    end)
    
    -- Padrão 2: Delay regressivo
    table.insert(patterns, function()
        local start = math.random(50, 100) / 1000
        for i = 1, math.random(2, 5) do
            wait(start - (i * 0.01))
        end
    end)
    
    -- Padrão 3: Spikes aleatórios
    table.insert(patterns, function()
        for i = 1, math.random(3, 6) do
            if math.random() < 0.3 then
                wait(math.random(200, 400) / 1000)
            else
                wait(math.random(10, 50) / 1000)
            end
        end
    end)
    
    -- Padrão 4: Oscilação
    table.insert(patterns, function()
        local min = math.random(20, 50) / 1000
        local max = math.random(100, 150) / 1000
        for i = 1, math.random(2, 4) do
            wait(min + (math.sin(i) * (max - min)))
        end
    end)
    
    -- Padrão 5: Pausa longa ocasional
    table.insert(patterns, function()
        if math.random() < 0.5 then
            wait(math.random(300, 600) / 1000)
        else
            for i = 1, 3 do
                wait(math.random(30, 80) / 1000)
            end
        end
    end)
    
    -- Padrão 6: Hesitação
    table.insert(patterns, function()
        for i = 1, math.random(1, 3) do
            wait(math.random(5, 15) / 1000)
            wait(math.random(50, 150) / 1000)
        end
    end)
    
    -- Padrão 7: Ritmo irregular
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
    
    -- Padrão 8: Pausa estruturada
    table.insert(patterns, function()
        wait(math.random(50, 100) / 1000)
        wait(math.random(50, 100) / 1000)
        wait(math.random(200, 300) / 1000)
    end)
    
    return patterns
end

function Randomizer:RandomPatterns()
    local patterns = self:GenerateDynamicPatterns()
    local selected = patterns[math.random(1, #patterns)]
    
    table.insert(STATE.patternHistory, {
        pattern = tostring(selected),
        time = tick()
    })
    
    if #STATE.patternHistory > 500 then
        table.remove(STATE.patternHistory, 1)
    end
    
    selected()
end

-- ==================== HUMANIZAÇÃO AVANÇADA DE MOVIMENTO ====================
function Randomizer:HumanizeMouse()
    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
    local originalMove = mouse.Move
    
    -- Cria layer de proteção
    local moveCounter = 0
    
    mouse.Move = function(self, x, y)
        moveCounter = moveCounter + 1
        
        -- Ocasionalmente adiciona delay
        if moveCounter % math.random(5, 15) == 0 then
            wait(Randomizer:GenerateSmartDelay())
        end
        
        -- Ocasionalmente adiciona micro-jitter
        if math.random() < 0.2 then
            x = x + math.random(-2, 2)
            y = y + math.random(-2, 2)
        end
        
        -- Ocasionalmente não move (simula hesitação)
        if math.random() < 0.05 then
            return
        end
        
        return originalMove(self, x, y)
    end
end

-- ==================== JITTER INTELIGENTE E ADAPTATIVO ====================
function Randomizer:JitterMovement(position)
    -- Jitter que varia baseado em histórico
    local jitterRange = math.random(3, 15) / 100
    
    -- Ocasionalmente usa jitter maior (menos preciso)
    if math.random() < 0.1 then
        jitterRange = jitterRange * math.random(200, 500) / 100
    end
    
    -- Ocasionalmente sem jitter (mais preciso, menos suspeito)
    if math.random() < 0.2 then
        jitterRange = 0
    end
    
    local jitterX = (math.random() - 0.5) * jitterRange * 2
    local jitterY = (math.random() - 0.5) * jitterRange * 2
    local jitterZ = (math.random() - 0.5) * jitterRange * 2
    
    -- Registra movimento
    table.insert(STATE.movementHistory, {
        jitter = {x = jitterX, y = jitterY, z = jitterZ},
        time = tick()
    })
    
    if #STATE.movementHistory > 500 then
        table.remove(STATE.movementHistory, 1)
    end
    
    return position + Vector3.new(jitterX, jitterY, jitterZ)
end

-- ==================== SUAVIZAÇÃO DINÂMICA ====================
function Randomizer:VariableSmoothing()
    -- Suavização que muda baseada em contexto
    local baseSmoothing = math.random(100, 300) / 1000
    
    -- Ocasionalmente muito suave (suspeito)
    if math.random() < 0.1 then
        baseSmoothing = math.random(50, 100) / 1000
    end
    
    -- Ocasionalmente muito áspero (menos preciso)
    if math.random() < 0.15 then
        baseSmoothing = math.random(350, 500) / 1000
    end
    
    -- Adiciona variação dentro do range
    local variation = (math.random() - 0.5) * 0.05
    baseSmoothing = baseSmoothing + variation
    
    return math.max(0.05, math.min(0.5, baseSmoothing))
end

-- ==================== DESVIO COMPORTAMENTAL ====================
function Randomizer:BehavioralDeviation()
    if not CONFIG.ENABLE_BEHAVIORAL_DEVIATION then return end
    
    local deviationThread = coroutine.create(function()
        while true do
            wait(math.random(60, 180))
            
            -- Ocasionalmente muda comportamento
            if math.random() < 0.4 then
                STATE.deviationLevel = math.random(1, 5)
            else
                STATE.deviationLevel = 0
            end
        end
    end)
    
    coroutine.resume(deviationThread)
end

-- ==================== TIMING SPOOFING ====================
function Randomizer:SpoofTiming()
    if not CONFIG.ENABLE_TIMING_SPOOFING then return end
    
    -- Hook em wait pra adicionar variação
    local originalWait = wait
    local waitCallCount = 0
    
    wait = function(duration)
        waitCallCount = waitCallCount + 1
        
        if duration then
            -- Adiciona variação aleatória
            local variation = duration * math.random(-20, 20) / 100
            local spoofedDuration = duration + variation
            return originalWait(math.max(0.001, spoofedDuration))
        end
        
        return originalWait()
    end
end

-- ==================== ANÁLISE DE PADRÃO ====================
function Randomizer:DetectPatternRepetition()
    if #STATE.patternHistory < 5 then
        return false
    end
    
    local recent = {}
    for i = #STATE.patternHistory - 4, #STATE.patternHistory do
        table.insert(recent, STATE.patternHistory[i].pattern)
    end
    
    -- Verifica se há repetição
    local firstPattern = recent[1]
    local repetitionCount = 0
    
    for _, pattern in ipairs(recent) do
        if pattern == firstPattern then
            repetitionCount = repetitionCount + 1
        end
    end
    
    -- Se repetiu muito, força nova variação
    if repetitionCount >= 4 then
        return true
    end
    
    return false
end

-- ==================== INICIALIZAÇÃO ====================
function Randomizer:Initialize()
    pcall(function()
        if CONFIG.ENABLE_MOVEMENT_HUMANIZATION then
            self:HumanizeMouse()
        end
        
        if CONFIG.ENABLE_BEHAVIORAL_DEVIATION then
            self:BehavioralDeviation()
        end
        
        if CONFIG.ENABLE_TIMING_SPOOFING then
            self:SpoofTiming()
        end
    end)
end

-- ==================== START ====================
Randomizer:Initialize()

return Randomizer
