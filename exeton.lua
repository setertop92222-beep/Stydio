-- ============================================
-- HCM2_STUDIO - ГЛАВНЫЙ ЗАГРУЗЧИК
-- ============================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ============================================
-- ССЫЛКИ
-- ============================================

local PASSWORDS_URL = "https://raw.githubusercontent.com/setertop92222-beep/Stydio/refs/heads/main/kay.lua"
local MENU_URL = "https://raw.githubusercontent.com/setertop92222-beep/Stydio/refs/heads/main/devays.lua"

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

local function LoadPasswords()
    local success, result = pcall(function()
        return game:HttpGet(PASSWORDS_URL)
    end)
    if success and result then
        local func = loadstring(result)
        if func then
            local data = func()
            if type(data) == "table" then
                return data
            end
        end
    end
    return {}
end

-- ============================================
-- 1. ЗАГРУЗОЧНЫЙ ЭКРАН
-- ============================================

local function ShowLoading(callback)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HCM2Loading"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    
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
        TweenService:Create(barFill, TweenInfo.new(0.3), {
            Size = UDim2.new(step[1] / 100, 0, 1, 0)
        }):Play()
        percentText.Text = step[1] .. "%"
        task.wait(0.3)
    end
    
    task.wait(0.3)
    
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
-- 2. ОКНО ПАРОЛЯ
-- ============================================

local function ShowPassword(callback)
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HCM2Password" then gui:Destroy() end
    end
    
    local validPasswords = LoadPasswords()
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HCM2Password"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 320)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
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
    
    -- Проверка
    local function CheckPassword()
        local input = passBox.Text
        
        if input == "" then
            errorLabel.Text = "❌ Введите пароль!"
            task.wait(1.5)
            errorLabel.Text = ""
            return
        end
        
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
            
            -- Плавное закрытие
            TweenService:Create(mainFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
            task.wait(0.5)
            screenGui:Destroy()
            
            -- Открываем меню
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
-- 3. ЗАПУСК
-- ============================================

print("🏆 HCM2_STUDIO загружен!")

task.spawn(function()
    ShowLoading(function()
        task.wait(0.3)
        ShowPassword(function()
            -- Загружаем меню с GitHub
            local success, result = pcall(function()
                return game:HttpGet(MENU_URL)
            end)
            if success and result then
                loadstring(result)()
                print("✅ Меню загружено!")
            else
                print("❌ Ошибка загрузки меню!")
            end
        end)
    end)
end)
