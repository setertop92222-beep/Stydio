-- ============================================
-- HCM2_STUDIO - МЕНЮ ВЫБОРА УСТРОЙСТВА
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ============================================
-- СПИСКИ СКРИПТОВ
-- ============================================

local SCRIPTS_PC = {
    {"[FPS] One Tap", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/onetap.lua"},
    {"ESP с разделами", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/esp_sections.lua"},
    {"ESP", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/esp.lua"},
    {"Aimbot", "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/aimbot.lua"},
    -- ДОБАВЛЯЙ СЮДА:
    -- {"Название", "https://ссылка.lua"},
}

local SCRIPTS_MOBILE = {
    {"Mobile ESP", "https://raw.githubusercontent.com/ТВОЙ_АККАУНТ/РЕПО/main/mobile_esp.lua"},
    {"Mobile Aimbot", "https://raw.githubusercontent.com/ТВОЙ_АККАУНТ/РЕПО/main/mobile_aimbot.lua"},
    -- ДОБАВЛЯЙ СЮДА:
    -- {"Название", "https://ссылка.lua"},
}

-- ============================================
-- ЦВЕТА
-- ============================================

local COLORS = {
    Background = Color3.fromRGB(15, 15, 20),
    Dark = Color3.fromRGB(25, 25, 35),
    Accent = Color3.fromRGB(255, 215, 0),
    Accent2 = Color3.fromRGB(255, 100, 0),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(120, 120, 140),
    Border = Color3.fromRGB(255, 215, 0),
}

-- ============================================
-- ФУНКЦИИ
-- ============================================

local function CreateLabel(parent, size, pos, text, color, sizeText)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.Size = size
    label.Position = pos
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color or COLORS.Text
    label.TextSize = sizeText or 16
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    return label
end

local function LoadScript(url, name)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success and result then
        loadstring(result)()
        print("✅ " .. name .. " загружен!")
    else
        print("❌ Ошибка загрузки " .. name)
    end
end

-- ============================================
-- МЕНЮ ВЫБОРА УСТРОЙСТВА
-- ============================================

local function ShowDeviceMenu()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HCM2Device" then gui:Destroy() end
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HCM2Device"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 460, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -230, 0.5, -160)
    mainFrame.BackgroundColor3 = COLORS.Dark
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = COLORS.Border
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = mainFrame
    stroke.Color = COLORS.Accent
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    
    local title = CreateLabel(mainFrame, UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 15), "HCM2_STUDIO", COLORS.Accent, 26)
    title.Font = Enum.Font.GothamBlack
    title.TextStrokeColor3 = COLORS.Accent2
    title.TextStrokeTransparency = 0.7
    
    CreateLabel(mainFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 50), "Выбери своё устройство", COLORS.TextDim, 13)
    
    local divider = Instance.new("Frame")
    divider.Parent = mainFrame
    divider.Size = UDim2.new(0.9, 0, 0, 1)
    divider.Position = UDim2.new(0.05, 0, 0, 75)
    divider.BackgroundColor3 = COLORS.Border
    divider.BackgroundTransparency = 0.5
    divider.BorderSizePixel = 0
    
    -- Кнопка ПК
    local pcBtn = Instance.new("TextButton")
    pcBtn.Parent = mainFrame
    pcBtn.Size = UDim2.new(0.4, -10, 0, 170)
    pcBtn.Position = UDim2.new(0.05, 10, 0, 95)
    pcBtn.BackgroundColor3 = COLORS.Background
    pcBtn.BorderSizePixel = 2
    pcBtn.BorderColor3 = COLORS.Border
    pcBtn.Text = ""
    pcBtn.AutoButtonColor = false
    
    local pcCorner = Instance.new("UICorner")
    pcCorner.CornerRadius = UDim.new(0, 15)
    pcCorner.Parent = pcBtn
    
    CreateLabel(pcBtn, UDim2.new(1, 0, 0, 70), UDim2.new(0, 0, 0, 20), "💻", COLORS.Text, 55)
    CreateLabel(pcBtn, UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 105), "КОМПЬЮТЕР", COLORS.Accent, 16)
    
    -- Кнопка Телефон
    local mobileBtn = Instance.new("TextButton")
    mobileBtn.Parent = mainFrame
    mobileBtn.Size = UDim2.new(0.4, -10, 0, 170)
    mobileBtn.Position = UDim2.new(0.55, 10, 0, 95)
    mobileBtn.BackgroundColor3 = COLORS.Background
    mobileBtn.BorderSizePixel = 2
    mobileBtn.BorderColor3 = COLORS.Border
    mobileBtn.Text = ""
    mobileBtn.AutoButtonColor = false
    
    local mobileCorner = Instance.new("UICorner")
    mobileCorner.CornerRadius = UDim.new(0, 15)
    mobileCorner.Parent = mobileBtn
    
    CreateLabel(mobileBtn, UDim2.new(1, 0, 0, 70), UDim2.new(0, 0, 0, 20), "📱", COLORS.Text, 55)
    CreateLabel(mobileBtn, UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 105), "ТЕЛЕФОН", COLORS.Accent, 16)
    
    CreateLabel(mainFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 285), "BY MC | HCM2_STUDIO © 2026", COLORS.TextDim, 11)
    
    pcBtn.MouseEnter:Connect(function()
        TweenService:Create(pcBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 35, 0)}):Play()
    end)
    pcBtn.MouseLeave:Connect(function()
        TweenService:Create(pcBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.Background}):Play()
    end)
    
    mobileBtn.MouseEnter:Connect(function()
        TweenService:Create(mobileBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 35, 0)}):Play()
    end)
    mobileBtn.MouseLeave:Connect(function()
        TweenService:Create(mobileBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.Background}):Play()
    end)
    
    pcBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        task.wait(0.1)
        ShowScriptList("PC")
    end)
    
    mobileBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        task.wait(0.1)
        ShowScriptList("MOBILE")
    end)
end

-- ============================================
-- СПИСОК СКРИПТОВ
-- ============================================

function ShowScriptList(deviceType)
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HCM2ScriptList" then gui:Destroy() end
    end
    
    local scripts = (deviceType == "PC") and SCRIPTS_PC or SCRIPTS_MOBILE
    local deviceName = (deviceType == "PC") and "💻 Компьютер" or "📱 Телефон"
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HCM2ScriptList"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 460, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -230, 0.5, -210)
    mainFrame.BackgroundColor3 = COLORS.Dark
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = COLORS.Border
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = mainFrame
    stroke.Color = COLORS.Accent
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    
    local title = CreateLabel(mainFrame, UDim2.new(1, 0, 0, 35), UDim2.new(0, 0, 0, 15), "HCM2_STUDIO", COLORS.Accent, 22)
    title.Font = Enum.Font.GothamBlack
    title.TextStrokeColor3 = COLORS.Accent2
    title.TextStrokeTransparency = 0.7
    
    CreateLabel(mainFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 48), deviceName .. " - скрипты", COLORS.TextDim, 12)
    
    local divider = Instance.new("Frame")
    divider.Parent = mainFrame
    divider.Size = UDim2.new(0.9, 0, 0, 1)
    divider.Position = UDim2.new(0.05, 0, 0, 72)
    divider.BackgroundColor3 = COLORS.Border
    divider.BackgroundTransparency = 0.5
    divider.BorderSizePixel = 0
    
    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Parent = mainFrame
    scrollingFrame.Size = UDim2.new(1, -40, 0, 260)
    scrollingFrame.Position = UDim2.new(0, 20, 0, 85)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.ScrollBarThickness = 4
    scrollingFrame.ScrollBarImageColor3 = COLORS.Accent
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    local container = Instance.new("Frame")
    container.Parent = scrollingFrame
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundTransparency = 1
    
    local function CreateScriptButton(parent, yPos, name, url)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.BackgroundColor3 = COLORS.Background
        btn.BorderSizePixel = 1
        btn.BorderColor3 = COLORS.Border
        btn.Text = ""
        btn.AutoButtonColor = false

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn

        CreateLabel(btn, UDim2.new(0, 30, 1, 0), UDim2.new(0, 10, 0, 0), "▶", COLORS.Accent, 16)

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = btn
        nameLabel.Size = UDim2.new(1, -70, 1, 0)
        nameLabel.Position = UDim2.new(0, 45, 0, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = COLORS.Text
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamMedium
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 25, 0)}):Play()
            nameLabel.TextColor3 = COLORS.Accent
        end)

        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.Background}):Play()
            nameLabel.TextColor3 = COLORS.Text
        end)

        btn.MouseButton1Click:Connect(function()
            nameLabel.Text = "⏳ Загрузка..."
            nameLabel.TextColor3 = COLORS.Accent
            btn.BackgroundColor3 = Color3.fromRGB(60, 50, 0)
            
            task.wait(0.3)
            screenGui:Destroy()
            LoadScript(url, name)
        end)

        return btn
    end

    local yPos = 0
    for _, script in ipairs(scripts) do
        CreateScriptButton(container, yPos, script[1], script[2])
        yPos = yPos + 55
    end

    container.Size = UDim2.new(1, 0, 0, yPos + 10)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

    local backBtn = Instance.new("TextButton")
    backBtn.Parent = mainFrame
    backBtn.Size = UDim2.new(0.5, 0, 0, 35)
    backBtn.Position = UDim2.new(0.25, 0, 0, 360)
    backBtn.BackgroundColor3 = COLORS.Background
    backBtn.BorderSizePixel = 1
    backBtn.BorderColor3 = COLORS.Border
    backBtn.Text = "⬅ ВЕРНУТЬСЯ"
    backBtn.TextColor3 = COLORS.Accent
    backBtn.TextSize = 13
    backBtn.Font = Enum.Font.GothamBold
    backBtn.AutoButtonColor = false
    
    local backCorner = Instance.new("UICorner")
    backCorner.CornerRadius = UDim.new(0, 8)
    backCorner.Parent = backBtn
    
    backBtn.MouseEnter:Connect(function()
        TweenService:Create(backBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 25, 0)}):Play()
    end)
    backBtn.MouseLeave:Connect(function()
        TweenService:Create(backBtn, TweenInfo.new(0.2), {BackgroundColor3 = COLORS.Background}):Play()
    end)
    
    backBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        task.wait(0.1)
        ShowDeviceMenu()
    end)
end

-- ============================================
-- ЗАПУСК
-- ============================================

print("📱 HCM2_STUDIO - Меню загружено!")
ShowDeviceMenu()
