-- ============================================
-- HCM2_STUDIO - ЕДИНЫЙ СКРИПТ
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ============================================
-- НАСТРОЙКИ
-- ============================================

-- ССЫЛКА НА ФАЙЛ С ПАРОЛЯМИ (RAW)
local PASSWORDS_URL = "https://raw.githubusercontent.com/setertop92222-beep/HeriCraft_HUB/refs/heads/main/passwords.lua"

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
    Error = Color3.fromRGB(255, 50, 50),
    Success = Color3.fromRGB(0, 255, 100),
}

-- ============================================
-- ФУНКЦИИ GUI
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
-- ЗАГРУЗКА ПАРОЛЕЙ С GITHUB
-- ============================================

local function LoadPasswords()
    local success, result = pcall(function()
        return game:HttpGet(PASSWORDS_URL)
    end)
    
    if success and result then
        local func, err = loadstring(result)
        if func then
            local loadedPasswords = func()
            if type(loadedPasswords) == "table" then
                print("✅ Загружено паролей: " .. #loadedPasswords)
                return loadedPasswords
            end
        end
    end
    print("❌ Ошибка загрузки паролей!")
    return {}
end

-- ============================================
-- 1. ЗАГРУЗОЧНЫЙ ЭКРАН
-- ============================================

local function ShowLoadingScreen(callback)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HCM2Loading"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 400, 0, 250)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
    mainFrame.BackgroundColor3 = COLORS.Background
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = COLORS.Border
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainFrame
    
    local logoText = CreateLabel(mainFrame, UDim2.new(1, 0, 0, 80), UDim2.new(0, 0, 0, 20), "HCM2", COLORS.Accent, 60)
    logoText.Font = Enum.Font.GothamBlack
    logoText.TextStrokeColor3 = COLORS.Accent2
    logoText.TextStrokeTransparency = 0.7
    
    local logoSub = CreateLabel(mainFrame, UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 95), "STUDIO", COLORS.Text, 20)
    logoSub.TextStrokeColor3 = COLORS.Accent
    logoSub.TextStrokeTransparency = 0.7
    
    local barBg = Instance.new("Frame")
    barBg.Parent = mainFrame
    barBg.Size = UDim2.new(0, 320, 0, 5)
    barBg.Position = UDim2.new(0.5, -160, 0, 150)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    barBg.BorderSizePixel = 0
    
    local barBgCorner = Instance.new("UICorner")
    barBgCorner.CornerRadius = UDim.new(1, 0)
    barBgCorner.Parent = barBg
    
    local barFill = Instance.new("Frame")
    barFill.Parent = barBg
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = COLORS.Accent
    barFill.BorderSizePixel = 0
    
    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = barFill
    
    local loadText = CreateLabel(mainFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 170), "Загрузка...", COLORS.TextDim, 13)
    local percentText = CreateLabel(mainFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 195), "0%", COLORS.Accent, 13)
    
    CreateLabel(mainFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 220), "BY MC | HCM2_STUDIO © 2026", COLORS.TextDim, 11)
    
    local steps = {
        {15, "Инициализация..."},
        {35, "Загрузка модулей..."},
        {55, "Проверка обновлений..."},
        {75, "Загрузка интерфейса..."},
        {100, "Готово!"},
    }
    
    for _, step in ipairs(steps) do
        loadText.Text = step[2]
        TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size = UDim2.new(step[1] / 100, 0, 1, 0)
        }):Play()
        percentText.Text = step[1] .. "%"
        task.wait(0.35)
    end
    
    task.wait(0.4)
    
    TweenService:Create(mainFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logoText, TweenInfo.new(0.4), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    TweenService:Create(logoSub, TweenInfo.new(0.4), {TextTransparency = 1, TextStrokeTransparency = 1}):Play()
    TweenService:Create(loadText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(percentText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    
    task.wait(0.5)
    screenGui:Destroy()
    
    if callback then
        task.spawn(callback)
    end
end

-- ============================================
-- 2. ОКНО ПРИВЕТСТВИЯ С ПРОВЕРКОЙ ПАРОЛЯ
-- ============================================

local function ShowWelcomeScreen(callback)
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HCM2Welcome" then gui:Destroy() end
    end
    
    -- Загружаем пароли
    local validPasswords = LoadPasswords()
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HCM2Welcome"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 450, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
    mainFrame.BackgroundColor3 = COLORS.Dark
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = COLORS.Border
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = mainFrame
    stroke.Color = COLORS.Accent
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    
    local logoText = CreateLabel(mainFrame, UDim2.new(1, 0, 0, 50), UDim2.new(0, 0, 0, 15), "HCM2_STUDIO", COLORS.Accent, 32)
    logoText.Font = Enum.Font.GothamBlack
    logoText.TextStrokeColor3 = COLORS.Accent2
    logoText.TextStrokeTransparency = 0.7
    
    CreateLabel(mainFrame, UDim2.new(1, 0, 0, 30), UDim2.new(0, 0, 0, 70), "👋 Добро пожаловать!", COLORS.Text, 18)
    CreateLabel(mainFrame, UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 100), "Введи пароль для активации", COLORS.TextDim, 13)
    
    local passBox = Instance.new("TextBox")
    passBox.Parent = mainFrame
    passBox.Size = UDim2.new(0.7, 0, 0, 45)
    passBox.Position = UDim2.new(0.15, 0, 0, 135)
    passBox.BackgroundColor3 = COLORS.Background
    passBox.BorderSizePixel = 2
    passBox.BorderColor3 = COLORS.Border
    passBox.Text = ""
    passBox.PlaceholderText = "🔑 Введите пароль..."
    passBox.TextColor3 = COLORS.Text
    passBox.PlaceholderColor3 = COLORS.TextDim
    passBox.TextSize = 16
    passBox.Font = Enum.Font.GothamMedium
    passBox.TextXAlignment = Enum.TextXAlignment.Center
    passBox.ClearTextOnFocus = false
    
    local passCorner = Instance.new("UICorner")
    passCorner.CornerRadius = UDim.new(0, 10)
    passCorner.Parent = passBox
    
    local activateBtn = Instance.new("TextButton")
    activateBtn.Parent = mainFrame
    activateBtn.Size = UDim2.new(0.5, 0, 0, 45)
    activateBtn.Position = UDim2.new(0.25, 0, 0, 195)
    activateBtn.BackgroundColor3 = COLORS.Background
    activateBtn.BorderSizePixel = 2
    activateBtn.BorderColor3 = COLORS.Border
    activateBtn.Text = "🚀 АКТИВИРОВАТЬ"
    activateBtn.TextColor3 = COLORS.Accent
    activateBtn.TextSize = 16
    activateBtn.Font = Enum.Font.GothamBold
    activateBtn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = activateBtn
    
    activateBtn.MouseEnter:Connect(function()
        TweenService:Create(activateBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 35, 0)
        }):Play()
    end)
    activateBtn.MouseLeave:Connect(function()
        TweenService:Create(activateBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.Background
        }):Play()
    end)
    
    local errorLabel = CreateLabel(mainFrame, UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, 250), "", COLORS.Error, 13)
    
    CreateLabel(mainFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 290), "BY MC | HCM2_STUDIO © 2026", COLORS.TextDim, 11)
    
    -- ============================================
    -- ПРОВЕРКА ПАРОЛЯ
    -- ============================================
    
    local function CheckPassword()
        local input = passBox.Text
        
        if input == "" then
            errorLabel.Text = "❌ Введите пароль!"
            task.wait(1.5)
            errorLabel.Text = ""
            return
        end
        
        -- Проверяем, есть ли пароль в списке с GitHub
        local found = false
        for _, pass in ipairs(validPasswords) do
            if pass == input then
                found = true
                break
            end
        end
        
        if found then
            errorLabel.Text = "✅ Пароль верный!"
            errorLabel.TextColor3 = COLORS.Success
            
            task.wait(0.4)
            
            TweenService:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            
            task.wait(0.35)
            screenGui:Destroy()
            
            if callback then
                task.spawn(callback)
            end
        else
            errorLabel.Text = "❌ Неверный пароль!"
            errorLabel.TextColor3 = COLORS.Error
            passBox.Text = ""
            task.wait(1.5)
            errorLabel.Text = ""
        end
    end
    
    activateBtn.MouseButton1Click:Connect(CheckPassword)
    passBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then CheckPassword() end
    end)
end

-- ============================================
-- 3. МЕНЮ ВЫБОРА УСТРОЙСТВА
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
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 460, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -230, 0.5, -160)
    mainFrame.BackgroundColor3 = COLORS.Dark
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = COLORS.Border
    
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
    
    -- Hover
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
-- 4. СПИСОК СКРИПТОВ
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
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 460, 0, 420)
    mainFrame.Position = UDim2.new(0.5, -230, 0.5, -210)
    mainFrame.BackgroundColor3 = COLORS.Dark
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = COLORS.Border
    
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

print("🏆 HCM2_STUDIO загружен!")
print("📥 Запуск...")

task.spawn(function()
    ShowLoadingScreen(function()
        task.wait(0.3)
        ShowWelcomeScreen(function()
            task.wait(0.3)
            ShowDeviceMenu()
        end)
    end)
end)
