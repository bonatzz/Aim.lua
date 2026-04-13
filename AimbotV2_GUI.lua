-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                    AimbotV2_Hardened_GUI.lua                             ║
-- ║              Modern Dark Theme GUI - Glassmorphism Style                  ║
-- ║                     Minimalista & Futurista                               ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ==================== CONFIGURAÇÕES DA GUI ====================
local GUI_CONFIG = {
    PRIMARY_COLOR = Color3.fromRGB(20, 20, 30),      -- Cinza escuro/quase preto
    ACCENT_COLOR = Color3.fromRGB(0, 150, 255),     -- Azul neon
    SECONDARY_COLOR = Color3.fromRGB(40, 40, 55),   -- Cinza suave
    TEXT_COLOR = Color3.fromRGB(255, 255, 255),     -- Branco
    TEXT_SECONDARY = Color3.fromRGB(180, 180, 200), -- Cinza claro
    HOVER_COLOR = Color3.fromRGB(30, 30, 45),       -- Hover escuro
    ACCENT_PURPLE = Color3.fromRGB(150, 50, 200),   -- Roxo neon (alternativa)
}

local AIMBOT_CONFIG = {
    enabled = true,
    esp_enabled = true,
    fov = 50,
    smooth = 0.25,
    max_fov = 120,
    min_fov = 10,
    max_smooth = 1.0,
    min_smooth = 0.01
}

-- ==================== CRIAR TELA PRINCIPAL ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotV2GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndex = 10
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- ==================== BOTÃO FLUTUANTE MINIMIZADO ====================
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, 60, 0, 60)
FloatingButton.Position = UDim2.new(0.85, 0, 0.85, 0)
FloatingButton.BackgroundColor3 = GUI_CONFIG.ACCENT_COLOR
FloatingButton.BackgroundTransparency = 0.2
FloatingButton.TextColor3 = GUI_CONFIG.TEXT_COLOR
FloatingButton.TextSize = 24
FloatingButton.Text = "⚙️"
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.BorderSizePixel = 0
FloatingButton.Parent = ScreenGui

local FloatingButtonCorner = Instance.new("UICorner")
FloatingButtonCorner.CornerRadius = UDim.new(0, 15)
FloatingButtonCorner.Parent = FloatingButton

local FloatingButtonStroke = Instance.new("UIStroke")
FloatingButtonStroke.Color = GUI_CONFIG.ACCENT_COLOR
FloatingButtonStroke.Thickness = 2
FloatingButtonStroke.Parent = FloatingButton

local FloatingButtonGlow = Instance.new("Frame")
FloatingButtonGlow.Name = "Glow"
FloatingButtonGlow.Size = UDim2.new(1, 10, 1, 10)
FloatingButtonGlow.Position = UDim2.new(-0.25, 0, -0.25, 0)
FloatingButtonGlow.BackgroundColor3 = GUI_CONFIG.ACCENT_COLOR
FloatingButtonGlow.BackgroundTransparency = 0.8
FloatingButtonGlow.BorderSizePixel = 0
FloatingButtonGlow.ZIndex = 9
FloatingButtonGlow.Parent = FloatingButton

local GlowCorner = Instance.new("UICorner")
GlowCorner.CornerRadius = UDim.new(0, 20)
GlowCorner.Parent = FloatingButtonGlow

-- ==================== PAINEL PRINCIPAL ====================
local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 320, 0, 500)
MainPanel.Position = UDim2.new(0.65, 0, 0.3, 0)
MainPanel.BackgroundColor3 = GUI_CONFIG.PRIMARY_COLOR
MainPanel.BackgroundTransparency = 0.1
MainPanel.BorderSizePixel = 0
MainPanel.Visible = false
MainPanel.Parent = ScreenGui

-- Efeito glassmorphism
local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 20)
PanelCorner.Parent = MainPanel

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = GUI_CONFIG.ACCENT_COLOR
PanelStroke.Thickness = 1.5
PanelStroke.Transparency = 0.5
PanelStroke.Parent = MainPanel

-- ==================== BARRA SUPERIOR ====================
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = GUI_CONFIG.SECONDARY_COLOR
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
TopBar.Parent = MainPanel

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 20)
TopBarCorner.Parent = TopBar

-- Título
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = GUI_CONFIG.TEXT_COLOR
TitleLabel.TextSize = 18
TitleLabel.Text = "AimbotV2_Hardened"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local VersionLabel = Instance.new("TextLabel")
VersionLabel.Name = "Version"
VersionLabel.Size = UDim2.new(0, 80, 1, 0)
VersionLabel.Position = UDim2.new(0.55, 0, 0, 0)
VersionLabel.BackgroundTransparency = 1
VersionLabel.TextColor3 = GUI_CONFIG.TEXT_SECONDARY
VersionLabel.TextSize = 12
VersionLabel.Text = "v2.0.1"
VersionLabel.Font = Enum.Font.GothamMedium
VersionLabel.Parent = TopBar

-- Botão Minimizar
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(0.75, 0, 0.1, 0)
MinimizeBtn.BackgroundColor3 = GUI_CONFIG.HOVER_COLOR
MinimizeBtn.BackgroundTransparency = 0.5
MinimizeBtn.TextColor3 = GUI_CONFIG.TEXT_COLOR
MinimizeBtn.TextSize = 14
MinimizeBtn.Text = "−"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = TopBar

local MinimizeBtnCorner = Instance.new("UICorner")
MinimizeBtnCorner.CornerRadius = UDim.new(0, 8)
MinimizeBtnCorner.Parent = MinimizeBtn

-- Botão Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.88, 0, 0.1, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.TextColor3 = GUI_CONFIG.TEXT_COLOR
CloseBtn.TextSize = 14
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

-- ==================== ABAS ====================
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(1, 0, 0, 45)
TabsContainer.Position = UDim2.new(0, 0, 0, 50)
TabsContainer.BackgroundColor3 = GUI_CONFIG.PRIMARY_COLOR
TabsContainer.BackgroundTransparency = 0.2
TabsContainer.BorderSizePixel = 0
TabsContainer.Parent = MainPanel

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.Parent = TabsContainer

local function CreateTab(name, icon)
    local Tab = Instance.new("TextButton")
    Tab.Name = name .. "Tab"
    Tab.Size = UDim2.new(0, 80, 1, 0)
    Tab.BackgroundColor3 = GUI_CONFIG.SECONDARY_COLOR
    Tab.BackgroundTransparency = 0.7
    Tab.TextColor3 = GUI_CONFIG.TEXT_SECONDARY
    Tab.TextSize = 12
    Tab.Text = icon .. " " .. name
    Tab.Font = Enum.Font.GothamMedium
    Tab.BorderSizePixel = 0
    Tab.Parent = TabsContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = Tab
    
    return Tab
end

local MainTab = CreateTab("Main", "⚔️")
local SettingsTab = CreateTab("Settings", "⚙️")

-- ==================== ÁREA DE CONTEÚDO ====================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, 0, 1, -95)
ContentArea.Position = UDim2.new(0, 0, 0, 95)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel = 0
ContentArea.Parent = MainPanel

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.FillDirection = Enum.FillDirection.Vertical
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = ContentArea

-- Padding
local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.Parent = ContentArea

-- ==================== FUNÇÃO PARA CRIAR BOTÕES ====================
local function CreateButton(name, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Button"
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.BackgroundColor3 = GUI_CONFIG.SECONDARY_COLOR
    Button.BackgroundTransparency = 0.3
    Button.TextColor3 = GUI_CONFIG.TEXT_COLOR
    Button.TextSize = 14
    Button.Text = name
    Button.Font = Enum.Font.GothamMedium
    Button.BorderSizePixel = 0
    Button.Parent = ContentArea
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = Button
    
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = GUI_CONFIG.ACCENT_COLOR
    ButtonStroke.Thickness = 1
    ButtonStroke.Transparency = 0.7
    ButtonStroke.Parent = Button
    
    -- Animação ao clicar
    Button.MouseButton1Click:Connect(function()
        Button.BackgroundTransparency = 0.1
        task.wait(0.1)
        Button.BackgroundTransparency = 0.3
        if callback then callback() end
    end)
    
    -- Hover effect
    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = GUI_CONFIG.HOVER_COLOR
        Button.BackgroundTransparency = 0.2
    end)
    
    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = GUI_CONFIG.SECONDARY_COLOR
        Button.BackgroundTransparency = 0.3
    end)
    
    return Button
end

-- ==================== FUNÇÃO PARA CRIAR TOGGLES ====================
local function CreateToggle(name, initialState, callback)
    local Container = Instance.new("Frame")
    Container.Name = name .. "Toggle"
    Container.Size = UDim2.new(1, -20, 0, 40)
    Container.BackgroundColor3 = GUI_CONFIG.SECONDARY_COLOR
    Container.BackgroundTransparency = 0.3
    Container.BorderSizePixel = 0
    Container.Parent = ContentArea
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 10)
    ContainerCorner.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0, 200, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = GUI_CONFIG.TEXT_COLOR
    Label.TextSize = 14
    Label.Text = name
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    -- Switch (toggle button)
    local Switch = Instance.new("TextButton")
    Switch.Name = "Switch"
    Switch.Size = UDim2.new(0, 50, 0, 25)
    Switch.Position = UDim2.new(1, -60, 0.5, -12.5)
    Switch.BackgroundColor3 = initialState and GUI_CONFIG.ACCENT_COLOR or GUI_CONFIG.HOVER_COLOR
    Switch.BackgroundTransparency = 0.3
    Switch.TextTransparency = 1
    Switch.BorderSizePixel = 0
    Switch.Parent = Container
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(0, 12)
    SwitchCorner.Parent = Switch
    
    local SwitchState = initialState
    
    Switch.MouseButton1Click:Connect(function()
        SwitchState = not SwitchState
        Switch.BackgroundColor3 = SwitchState and GUI_CONFIG.ACCENT_COLOR or GUI_CONFIG.HOVER_COLOR
        if callback then callback(SwitchState) end
    end)
    
    return Container, Switch
end

-- ==================== FUNÇÃO PARA CRIAR SLIDERS ====================
local function CreateSlider(name, minValue, maxValue, initialValue, callback)
    local Container = Instance.new("Frame")
    Container.Name = name .. "Slider"
    Container.Size = UDim2.new(1, -20, 0, 60)
    Container.BackgroundColor3 = GUI_CONFIG.SECONDARY_COLOR
    Container.BackgroundTransparency = 0.3
    Container.BorderSizePixel = 0
    Container.Parent = ContentArea
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 10)
    ContainerCorner.Parent = Container
    
    -- Label + Valor
    local LabelContainer = Instance.new("Frame")
    LabelContainer.Size = UDim2.new(1, 0, 0, 20)
    LabelContainer.BackgroundTransparency = 1
    LabelContainer.BorderSizePixel = 0
    LabelContainer.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 150, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = GUI_CONFIG.TEXT_COLOR
    Label.TextSize = 12
    Label.Text = name
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = LabelContainer
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 80, 1, 0)
    ValueLabel.Position = UDim2.new(1, -90, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = GUI_CONFIG.ACCENT_COLOR
    ValueLabel.TextSize = 12
    ValueLabel.Text = tostring(initialValue)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = LabelContainer
    
    -- Slider bar
    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.BackgroundColor3 = GUI_CONFIG.HOVER_COLOR
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Container
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(0, 3)
    SliderBarCorner.Parent = SliderBar
    
    -- Progress bar
    local Progress = Instance.new("Frame")
    Progress.Name = "Progress"
    Progress.Size = UDim2.new((initialValue - minValue) / (maxValue - minValue), 0, 1, 0)
    Progress.BackgroundColor3 = GUI_CONFIG.ACCENT_COLOR
    Progress.BorderSizePixel = 0
    Progress.Parent = SliderBar
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 3)
    ProgressCorner.Parent = Progress
    
    -- Knob
    local Knob = Instance.new("TextButton")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new((initialValue - minValue) / (maxValue - minValue), -8, 0.5, -8)
    Knob.BackgroundColor3 = GUI_CONFIG.ACCENT_COLOR
    Knob.TextTransparency = 1
    Knob.BorderSizePixel = 0
    Knob.Parent = SliderBar
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(0, 8)
    KnobCorner.Parent = Knob
    
    local currentValue = initialValue
    local dragging = false
    
    Knob.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function()
        dragging = false
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mouse = game.Players.LocalPlayer:GetMouse()
            local sliderSize = SliderBar.AbsoluteSize.X
            local sliderPos = SliderBar.AbsolutePosition.X
            local mouseX = mouse.X
            
            local percentage = math.max(0, math.min(1, (mouseX - sliderPos) / sliderSize))
            currentValue = minValue + (percentage * (maxValue - minValue))
            currentValue = math.floor(currentValue * 100) / 100
            
            Progress.Size = UDim2.new(percentage, 0, 1, 0)
            Knob.Position = UDim2.new(percentage, -8, 0.5, -8)
            ValueLabel.Text = tostring(currentValue)
            
            if callback then callback(currentValue) end
        end
    end)
    
    return Container
end

-- ==================== POPULATE MAIN TAB ====================
local aimbotToggle, aimbotSwitch = CreateToggle("Aimbot", AIMBOT_CONFIG.enabled, function(state)
    AIMBOT_CONFIG.enabled = state
end)

local espToggle, espSwitch = CreateToggle("ESP", AIMBOT_CONFIG.esp_enabled, function(state)
    AIMBOT_CONFIG.esp_enabled = state
end)

CreateSlider("FOV", AIMBOT_CONFIG.min_fov, AIMBOT_CONFIG.max_fov, AIMBOT_CONFIG.fov, function(value)
    AIMBOT_CONFIG.fov = value
end)

CreateSlider("Smooth", AIMBOT_CONFIG.min_smooth, AIMBOT_CONFIG.max_smooth, AIMBOT_CONFIG.smooth, function(value)
    AIMBOT_CONFIG.smooth = value
end)

CreateButton("Reentrar no Servidor", function()
    local teleportService = game:GetService("TeleportService")
    local placeId = game.PlaceId
    teleportService:Teleport(placeId, game.Players.LocalPlayer)
end)

CreateButton("Trocar de Servidor", function()
    local placeId = game.PlaceId
    local servers = game:GetService("HttpService"):GetAsync("https://games.roblox.com/v1/games/" .. placeId .. "/servers/0?sortOrder=Asc&limit=100")
    servers = game:GetService("HttpService"):JSONDecode(servers)
    
    if #servers.data > 0 then
        local randomServer = servers.data[math.random(1, #servers.data)]
        game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, randomServer.id)
    end
end)

-- ==================== EVENT LISTENERS ====================
FloatingButton.MouseButton1Click:Connect(function()
    MainPanel.Visible = not MainPanel.Visible
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainPanel.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Tab switching
MainTab.MouseButton1Click:Connect(function()
    MainTab.BackgroundTransparency = 0.1
    MainTab.TextColor3 = GUI_CONFIG.ACCENT_COLOR
    SettingsTab.BackgroundTransparency = 0.7
    SettingsTab.TextColor3 = GUI_CONFIG.TEXT_SECONDARY
    ContentArea.Visible = true
end)

SettingsTab.MouseButton1Click:Connect(function()
    SettingsTab.BackgroundTransparency = 0.1
    SettingsTab.TextColor3 = GUI_CONFIG.ACCENT_COLOR
    MainTab.BackgroundTransparency = 0.7
    MainTab.TextColor3 = GUI_CONFIG.TEXT_SECONDARY
    ContentArea.Visible = true
end)

-- ==================== RETURN AIMBOT CONFIG ====================
return AIMBOT_CONFIG
