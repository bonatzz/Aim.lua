-- ╔═══════════════════════════════════════════════════════════════════════════╗
-- ║                     AimbotV2_Complete.lua                                ║
-- ║          Fully Integrated Aimbot + Modern GUI System                     ║
-- ║                 Hardened Security + Glassmorphism UI                      ║
-- ║                                                                           ║
-- ║  Features:                                                               ║
-- ║  ✓ Hardened Aimbot with All 8 Security Modules                          ║
-- ║  ✓ Modern Dark Theme GUI (Glassmorphism)                                ║
-- ║  ✓ Real-time Interactive Controls                                       ║
-- ║  ✓ Synchronized GUI ↔ Aimbot Communication                              ║
-- ║  ✓ Tab System (Main/Settings)                                           ║
-- ║  ✓ Responsive Mobile-Friendly Design                                    ║
-- ║  ✓ Zero Conflicts, Optimal Performance                                  ║
-- ╚═══════════════════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = workspace

-- ==================== SHARED CONFIG (GUI ↔ AIMBOT) ====================
local SHARED_CONFIG = {
    -- Aimbot Settings
    aimbot_enabled = true,
    esp_enabled = true,
    fov = 50,
    smooth = 0.25,
    
    -- Limits
    max_fov = 120,
    min_fov = 10,
    max_smooth = 1.0,
    min_smooth = 0.01,
    
    -- GUI Settings
    gui_visible = false,
}

-- ==================== GUI COLOR SCHEME ====================
local GUI_COLORS = {
    PRIMARY = Color3.fromRGB(20, 20, 30),
    SECONDARY = Color3.fromRGB(40, 40, 55),
    ACCENT = Color3.fromRGB(0, 150, 255),
    ACCENT_PURPLE = Color3.fromRGB(150, 50, 200),
    TEXT = Color3.fromRGB(255, 255, 255),
    TEXT_SECONDARY = Color3.fromRGB(180, 180, 200),
    HOVER = Color3.fromRGB(30, 30, 45),
    DANGER = Color3.fromRGB(255, 50, 50),
}

-- ==================== AIMBOT STATE ====================
local AIMBOT_STATE = {
    players_alive = {},
    esp_cache = {},
    last_target = nil,
    last_update = 0,
    frame_count = 0,
    delay_history = {},
}

local _mt_game = getrawmetatable(game)
local _original_index = _mt_game.__index
local _original_namecall = _mt_game.__namecall

-- ==================== AIMBOT: ENCRYPTION ENGINE ====================
local function _xor_encode(str, key)
    local encoded = ""
    for i = 1, #str do
        encoded = encoded .. string.char(bit.bxor(string.byte(str, i), key))
    end
    return encoded
end

-- ==================== AIMBOT: GAUSSIAN RANDOMIZATION ====================
local function _gaussian_random(mean, stddev)
    local u1 = math.random() / 32767
    local u2 = math.random() / 32767
    if u1 < 0.0001 then u1 = 0.0001 end
    local z0 = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
    return mean + (z0 * stddev)
end

-- ==================== AIMBOT: METAMETHOD PROTECTION ====================
local function _protect_metamethods()
    pcall(function()
        if isreadonly(_mt_game) then return end
        
        local _orig_index = _mt_game.__index
        local _orig_newindex = _mt_game.__newindex
        local _orig_namecall = _mt_game.__namecall
        
        _mt_game.__index = function(self, key)
            return _orig_index(self, key)
        end
        
        _mt_game.__newindex = function(self, key, value)
            return _orig_newindex(self, key, value)
        end
        
        _mt_game.__namecall = function(self, ...)
            return _orig_namecall(self, ...)
        end
    end)
end

-- ==================== AIMBOT: MEMORY CLEANER ====================
local function _clean_memory()
    pcall(function()
        local suspicious = {
            "aimbot", "esp", "cheat", "hack", "exploit",
            "bypass", "detection", "anticheat", "script",
            "wallhack", "speedhack", "godmode"
        }
        
        for _, pattern in ipairs(suspicious) do
            for key, value in pairs(_G) do
                if type(key) == "string" and key:lower():find(pattern) then
                    if math.random() < 0.6 then
                        rawset(_G, key, nil)
                    end
                end
            end
        end
        
        collectgarbage("collect")
    end)
end

-- ==================== AIMBOT: ANTI-ANALYSIS ====================
local function _protect_against_analysis()
    pcall(function()
        local _orig_debug_getinfo = debug.getinfo
        
        debug.getinfo = function(func, what)
            if _orig_debug_getinfo then
                local result = _orig_debug_getinfo(func, what or "Slnf")
                if result then
                    result.source = result.source:gsub("exploit", "game"):gsub("cheat", "script")
                end
                return result
            end
            return nil
        end
    end)
end

-- ==================== AIMBOT: PLAYER DETECTION ====================
local function _is_player_alive(p)
    return p and p.Character and p.Character:FindFirstChild("Humanoid") 
        and p.Character.Humanoid.Health > 0
end

local function _update_alive_players()
    if tick() - AIMBOT_STATE.last_update < 0.15 then return end
    
    AIMBOT_STATE.last_update = tick()
    AIMBOT_STATE.players_alive = {}
    
    local local_player = Players.LocalPlayer
    if not local_player then return end
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= local_player and _is_player_alive(p) then
            table.insert(AIMBOT_STATE.players_alive, p)
        end
    end
end

-- ==================== AIMBOT: TARGET ACQUISITION ====================
local function _get_closest_player()
    local closest, dist = nil, math.huge
    local cam = Workspace.CurrentCamera
    local center = cam.ViewportSize / 2
    
    for _, p in ipairs(AIMBOT_STATE.players_alive) do
        if p and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local screen_pos, vis = cam:WorldToViewportPoint(head.Position)
                if vis then
                    local screen_dist = (Vector2.new(screen_pos.X, screen_pos.Y) - center).Magnitude
                    if screen_dist < SHARED_CONFIG.fov and screen_dist < dist then
                        closest = p
                        dist = screen_dist
                    end
                end
            end
        end
    end
    
    return closest
end

-- ==================== AIMBOT: VARIABLE SMOOTHING ====================
local function _variable_smoothing()
    local base_smoothing = math.random(100, 300) / 1000
    
    if math.random() < 0.1 then
        base_smoothing = math.random(50, 100) / 1000
    end
    
    if math.random() < 0.15 then
        base_smoothing = math.random(350, 500) / 1000
    end
    
    local variation = (math.random() - 0.5) * 0.05
    base_smoothing = base_smoothing + variation
    
    return math.max(0.05, math.min(0.5, base_smoothing))
end

-- ==================== AIMBOT: AIM FUNCTION ====================
local function _aim_at(target)
    if not SHARED_CONFIG.aimbot_enabled or not target or not target.Character then 
        return 
    end
    
    local head = target.Character:FindFirstChild("Head")
    if not head then return end
    
    local smooth = _variable_smoothing()
    local cam = Workspace.CurrentCamera
    local current = cam.CFrame
    local goal = CFrame.new(current.Position, head.Position)
    
    cam.CFrame = current:Lerp(goal, smooth)
    
    AIMBOT_STATE.last_target = target
end

-- ==================== AIMBOT: ESP FUNCTION ====================
local function _update_esp(p)
    if p == Players.LocalPlayer or not SHARED_CONFIG.esp_enabled then 
        return 
    end
    
    local char = p.Character
    if not char then return end
    
    if AIMBOT_STATE.esp_cache[p] then 
        pcall(function() AIMBOT_STATE.esp_cache[p]:Destroy() end) 
    end
    
    pcall(function()
        local hl = Instance.new("Highlight")
        hl.FillColor = GUI_COLORS.ACCENT
        hl.OutlineColor = GUI_COLORS.ACCENT
        hl.OutlineTransparency = 1
        hl.FillTransparency = 0.5
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
        AIMBOT_STATE.esp_cache[p] = hl
    end)
end

-- ==================== GUI SETUP ====================
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotV2GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndex = 10
ScreenGui.Parent = PlayerGui

-- ==================== GUI: FLOATING BUTTON ====================
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, 60, 0, 60)
FloatingButton.Position = UDim2.new(0.85, 0, 0.85, 0)
FloatingButton.BackgroundColor3 = GUI_COLORS.ACCENT
FloatingButton.BackgroundTransparency = 0.2
FloatingButton.TextColor3 = GUI_COLORS.TEXT
FloatingButton.TextSize = 24
FloatingButton.Text = "⚙️"
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.BorderSizePixel = 0
FloatingButton.Parent = ScreenGui

local FloatingButtonCorner = Instance.new("UICorner")
FloatingButtonCorner.CornerRadius = UDim.new(0, 15)
FloatingButtonCorner.Parent = FloatingButton

local FloatingButtonStroke = Instance.new("UIStroke")
FloatingButtonStroke.Color = GUI_COLORS.ACCENT
FloatingButtonStroke.Thickness = 2
FloatingButtonStroke.Parent = FloatingButton

-- ==================== GUI: MAIN PANEL ====================
local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0, 320, 0, 550)
MainPanel.Position = UDim2.new(0.65, 0, 0.25, 0)
MainPanel.BackgroundColor3 = GUI_COLORS.PRIMARY
MainPanel.BackgroundTransparency = 0.1
MainPanel.BorderSizePixel = 0
MainPanel.Visible = false
MainPanel.Parent = ScreenGui

local PanelCorner = Instance.new("UICorner")
PanelCorner.CornerRadius = UDim.new(0, 20)
PanelCorner.Parent = MainPanel

local PanelStroke = Instance.new("UIStroke")
PanelStroke.Color = GUI_COLORS.ACCENT
PanelStroke.Thickness = 1.5
PanelStroke.Transparency = 0.5
PanelStroke.Parent = MainPanel

-- ==================== GUI: TOP BAR ====================
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = GUI_COLORS.SECONDARY
TopBar.BackgroundTransparency = 0.3
TopBar.BorderSizePixel = 0
TopBar.Parent = MainPanel

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 20)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextColor3 = GUI_COLORS.TEXT
TitleLabel.TextSize = 18
TitleLabel.Text = "AimbotV2_Hardened"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(0.75, 0, 0.1, 0)
MinimizeBtn.BackgroundColor3 = GUI_COLORS.HOVER
MinimizeBtn.BackgroundTransparency = 0.5
MinimizeBtn.TextColor3 = GUI_COLORS.TEXT
MinimizeBtn.TextSize = 14
MinimizeBtn.Text = "−"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Parent = TopBar

local MinimizeBtnCorner = Instance.new("UICorner")
MinimizeBtnCorner.CornerRadius = UDim.new(0, 8)
MinimizeBtnCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0.88, 0, 0.1, 0)
CloseBtn.BackgroundColor3 = GUI_COLORS.DANGER
CloseBtn.BackgroundTransparency = 0.5
CloseBtn.TextColor3 = GUI_COLORS.TEXT
CloseBtn.TextSize = 14
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

-- ==================== GUI: TABS CONTAINER ====================
local TabsContainer = Instance.new("Frame")
TabsContainer.Name = "TabsContainer"
TabsContainer.Size = UDim2.new(1, 0, 0, 45)
TabsContainer.Position = UDim2.new(0, 0, 0, 50)
TabsContainer.BackgroundColor3 = GUI_COLORS.PRIMARY
TabsContainer.BackgroundTransparency = 0.2
TabsContainer.BorderSizePixel = 0
TabsContainer.Parent = MainPanel

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.Parent = TabsContainer

-- Create Tab Function
local function CreateTab(name, icon)
    local Tab = Instance.new("TextButton")
    Tab.Name = name .. "Tab"
    Tab.Size = UDim2.new(0, 80, 1, 0)
    Tab.BackgroundColor3 = GUI_COLORS.SECONDARY
    Tab.BackgroundTransparency = 0.7
    Tab.TextColor3 = GUI_COLORS.TEXT_SECONDARY
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

-- ==================== GUI: CONTENT AREA ====================
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

local Padding = Instance.new("UIPadding")
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)
Padding.PaddingTop = UDim.new(0, 10)
Padding.PaddingBottom = UDim.new(0, 10)
Padding.Parent = ContentArea

-- ==================== GUI: CREATE TOGGLE FUNCTION ====================
local function CreateToggle(name, initialState, callback)
    local Container = Instance.new("Frame")
    Container.Name = name .. "Toggle"
    Container.Size = UDim2.new(1, -20, 0, 40)
    Container.BackgroundColor3 = GUI_COLORS.SECONDARY
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
    Label.TextColor3 = GUI_COLORS.TEXT
    Label.TextSize = 14
    Label.Text = name
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    
    local Switch = Instance.new("TextButton")
    Switch.Name = "Switch"
    Switch.Size = UDim2.new(0, 50, 0, 25)
    Switch.Position = UDim2.new(1, -60, 0.5, -12.5)
    Switch.BackgroundColor3 = initialState and GUI_COLORS.ACCENT or GUI_COLORS.HOVER
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
        Switch.BackgroundColor3 = SwitchState and GUI_COLORS.ACCENT or GUI_COLORS.HOVER
        if callback then callback(SwitchState) end
    end)
    
    return Container, Switch
end

-- ==================== GUI: CREATE SLIDER FUNCTION ====================
local function CreateSlider(name, minValue, maxValue, initialValue, callback)
    local Container = Instance.new("Frame")
    Container.Name = name .. "Slider"
    Container.Size = UDim2.new(1, -20, 0, 60)
    Container.BackgroundColor3 = GUI_COLORS.SECONDARY
    Container.BackgroundTransparency = 0.3
    Container.BorderSizePixel = 0
    Container.Parent = ContentArea
    
    local ContainerCorner = Instance.new("UICorner")
    ContainerCorner.CornerRadius = UDim.new(0, 10)
    ContainerCorner.Parent = Container
    
    local LabelContainer = Instance.new("Frame")
    LabelContainer.Size = UDim2.new(1, 0, 0, 20)
    LabelContainer.BackgroundTransparency = 1
    LabelContainer.BorderSizePixel = 0
    LabelContainer.Parent = Container
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0, 150, 1, 0)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = GUI_COLORS.TEXT
    Label.TextSize = 12
    Label.Text = name
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = LabelContainer
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 80, 1, 0)
    ValueLabel.Position = UDim2.new(1, -90, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.TextColor3 = GUI_COLORS.ACCENT
    ValueLabel.TextSize = 12
    ValueLabel.Text = tostring(math.floor(initialValue * 100) / 100)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = LabelContainer
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "SliderBar"
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.BackgroundColor3 = GUI_COLORS.HOVER
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Container
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(0, 3)
    SliderBarCorner.Parent = SliderBar
    
    local Progress = Instance.new("Frame")
    Progress.Name = "Progress"
    Progress.Size = UDim2.new((initialValue - minValue) / (maxValue - minValue), 0, 1, 0)
    Progress.BackgroundColor3 = GUI_COLORS.ACCENT
    Progress.BorderSizePixel = 0
    Progress.Parent = SliderBar
    
    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 3)
    ProgressCorner.Parent = Progress
    
    local Knob = Instance.new("TextButton")
    Knob.Name = "Knob"
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new((initialValue - minValue) / (maxValue - minValue), -8, 0.5, -8)
    Knob.BackgroundColor3 = GUI_COLORS.ACCENT
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
            local mouse = Players.LocalPlayer:GetMouse()
            local sliderSize = SliderBar.AbsoluteSize.X
            local sliderPos = SliderBar.AbsolutePosition.X
            local mouseX = mouse.X
            
            local percentage = math.max(0, m
