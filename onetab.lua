local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ============================================
-- НАСТРОЙКИ
-- ============================================

local ESP_ENABLED = false
local AIMBOT_ENABLED = false
local AIMBOT_PART = "Head"
local AIMBOT_FOV = 200
local WALL_CHECK = true
local AIMBOT_SMOOTHNESS = 0.15 -- По умолчанию средний

local MAIN_MENU_URL = "https://raw.githubusercontent.com/setertop92222-beep/Stydio/refs/heads/main/devays.lua"

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
    Enemy = Color3.fromRGB(255, 50, 50),
    Ally = Color3.fromRGB(0, 255, 100),
    Bot = Color3.fromRGB(255, 165, 0),
    Selected = Color3.fromRGB(0, 200, 100),
    Back = Color3.fromRGB(255, 100, 100),
    Easy = Color3.fromRGB(0, 255, 100),
    Medium = Color3.fromRGB(255, 215, 0),
    Cheater = Color3.fromRGB(255, 50, 50),
}

-- ============================================
-- ХРАНИЛИЩА
-- ============================================

local espObjects = {}
local mainFrame = nil
local circleBtn = nil
local screenGui = nil
local fovCircle = nil
local menuOpen = false
local isAiming = false
local botCache = {}
local botUpdateTimer = 0
local smoothButtons = {}

-- ============================================
-- КЕШ БОТОВ
-- ============================================

local function UpdateBotCache()
    botCache = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and obj:FindFirstChild("Head") then
                table.insert(botCache, obj)
            end
        end
    end
end

RunService.Heartbeat:Connect(function(dt)
    botUpdateTimer = botUpdateTimer + dt
    if botUpdateTimer >= 3 then
        botUpdateTimer = 0
        UpdateBotCache()
    end
end)

-- ============================================
-- ESP
-- ============================================

local function GetEntityColor(char)
    if not char then return COLORS.Border end
    local plr = Players:GetPlayerFromCharacter(char)
    if plr then
        if plr == player then return Color3.fromRGB(0, 150, 255) end
        if plr.Team and player.Team then
            if plr.Team == player.Team then return COLORS.Ally
            else return COLORS.Enemy end
        end
        return COLORS.Enemy
    end
    return COLORS.Bot
end

local function ClearESP()
    for _, v in ipairs(espObjects) do
        if v and v.Parent then v:Destroy() end
    end
    espObjects = {}
end

local function UpdateESP()
    if not ESP_ENABLED then
        ClearESP()
        return
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and not char:FindFirstChild("HCM2_ESP") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local hl = Instance.new("Highlight")
                    hl.Name = "HCM2_ESP"
                    hl.Adornee = char
                    hl.FillColor = GetEntityColor(char)
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = GetEntityColor(char)
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = char
                    table.insert(espObjects, hl)
                end
            end
        end
    end
    
    for _, obj in ipairs(botCache) do
        if obj.Parent and not obj:FindFirstChild("HCM2_ESP") then
            local hl = Instance.new("Highlight")
            hl.Name = "HCM2_ESP"
            hl.Adornee = obj
            hl.FillColor = COLORS.Bot
            hl.FillTransparency = 0.5
            hl.OutlineColor = COLORS.Bot
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = obj
            table.insert(espObjects, hl)
        end
    end
end

local espTimer = 0
RunService.Heartbeat:Connect(function(dt)
    if not ESP_ENABLED then return end
    espTimer = espTimer + dt
    if espTimer >= 2 then
        espTimer = 0
        UpdateESP()
    end
end)

-- ============================================
-- ПРОВЕРКА СТЕНЫ
-- ============================================

local function IsVisible(targetPart)
    if not WALL_CHECK then return true end
    if not targetPart then return false end
    
    local myChar = player.Character
    if not myChar then return false end
    local myHead = myChar:FindFirstChild("Head")
    if not myHead then return false end
    
    local origin = myHead.Position
    local direction = (targetPart.Position - origin)
    local distance = direction.Magnitude
    if distance < 0.1 then return true end
    
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {myChar, targetPart.Parent, camera}
    
    local result = workspace:Raycast(origin, direction.Unit * distance, rayParams)
    
    if not result then return true end
    if result.Instance and result.Instance:IsDescendantOf(targetPart.Parent) then
        return true
    end
    return false
end

-- ============================================
-- AIMBOT
-- ============================================

local function GetBodyPart(char, partName)
    if not char then return nil end
    if partName == "Head" then
        return char:FindFirstChild("Head")
    elseif partName == "UpperTorso" then
        return char:FindFirstChild("UpperTorso") 
            or char:FindFirstChild("Torso") 
            or char:FindFirstChild("Chest")
    end
    return char:FindFirstChild(partName)
end

local function GetNearestTarget()
    local closest = nil
    local closestDist = math.huge
    local centerX = camera.ViewportSize.X / 2
    local centerY = camera.ViewportSize.Y / 2
    local myChar = player.Character
    if not myChar then return nil end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and char ~= myChar then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local part = GetBodyPart(char, AIMBOT_PART)
                    if part then
                        local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                        if onScreen then
                            local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(centerX, centerY)).Magnitude
                            if dist2D <= AIMBOT_FOV and dist2D < closestDist then
                                if IsVisible(part) then
                                    closestDist = dist2D
                                    closest = part
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    for _, obj in ipairs(botCache) do
        if obj.Parent and obj ~= myChar then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local part = GetBodyPart(obj, AIMBOT_PART)
                if part then
                    local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist2D = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(centerX, centerY)).Magnitude
                        if dist2D <= AIMBOT_FOV and dist2D < closestDist then
                            if IsVisible(part) then
                                closestDist = dist2D
                                closest = part
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closest
end

-- AIMBOT только при зажатой ПКМ
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAiming = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        isAiming = false
    end
end)

-- Плавный Aimbot
RunService.RenderStepped:Connect(function()
    if not AIMBOT_ENABLED then return end
    if not isAiming then return end
    
    local target = GetNearestTarget()
    if target then
        local currentCF = camera.CFrame
        local targetCF = CFrame.new(currentCF.Position, target.Position)
        
        -- Плавная интерполяция
        camera.CFrame = currentCF:Lerp(targetCF, AIMBOT_SMOOTHNESS)
    end
end)

-- ============================================
-- ВОЗВРАТ
-- ============================================

local function ReturnToMainMenu()
    AIMBOT_ENABLED = false
    ESP_ENABLED = false
    ClearESP()
    botCache = {}
    
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HCM2NatTab" or gui.Name == "HCM2_FOV" then
            gui:Destroy()
        end
    end
    
    task.wait(0.2)
    local success, result = pcall(function()
        return game:HttpGet(MAIN_MENU_URL)
    end)
    if success and result then
        loadstring(result)()
    end
end

-- ============================================
-- КРУГ FOV
-- ============================================

local function CreateFOVCircle()
    local circleGui = Instance.new("ScreenGui")
    circleGui.Name = "HCM2_FOV"
    circleGui.Parent = CoreGui
    circleGui.ResetOnSpawn = false
    circleGui.IgnoreGuiInset = true
    
    fovCircle = Instance.new("Frame")
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    fovCircle.Size = UDim2.new(0, AIMBOT_FOV * 2, 0, AIMBOT_FOV * 2)
    fovCircle.BackgroundTransparency = 1
    fovCircle.BorderSizePixel = 2
    fovCircle.BorderColor3 = COLORS.Accent
    fovCircle.Visible = false
    fovCircle.Parent = circleGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = fovCircle
    
    local stroke = Instance.new("UIStroke")
    stroke.Parent = fovCircle
    stroke.Color = COLORS.Accent
    stroke.Thickness = 2
    stroke.Transparency = 0.3
end

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

-- ============================================
-- МЕНЮ
-- ============================================

local function CreateMenu()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui.Name == "HCM2NatTab" then gui:Destroy() end
    end
    
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HCM2NatTab"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false

    circleBtn = Instance.new("TextButton")
    circleBtn.Size = UDim2.new(0, 55, 0, 55)
    circleBtn.Position = UDim2.new(0, 15, 0, 300)
    circleBtn.BackgroundColor3 = COLORS.Dark
    circleBtn.BorderSizePixel = 2
    circleBtn.BorderColor3 = COLORS.Border
    circleBtn.Text = "HCM2"
    circleBtn.TextColor3 = COLORS.Accent
    circleBtn.TextSize = 12
    circleBtn.Font = Enum.Font.GothamBold
    circleBtn.TextScaled = true
    circleBtn.Draggable = true
    circleBtn.Parent = screenGui
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = circleBtn
    
    mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -300)
    mainFrame.BackgroundColor3 = COLORS.Dark
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = COLORS.Border
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = mainFrame
    
    local title = CreateLabel(mainFrame, UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 15), "HCM2_STUDIO", COLORS.Accent, 26)
    title.Font = Enum.Font.GothamBlack
    title.TextStrokeColor3 = COLORS.Accent2
    title.TextStrokeTransparency = 0.7
    
    CreateLabel(mainFrame, UDim2.new(1, 0, 0, 20), UDim2.new(0, 0, 0, 50), "BY MC | HCM2_STUDIO", COLORS.TextDim, 12)
    
    local divider = Instance.new("Frame")
    divider.Parent = mainFrame
    divider.Size = UDim2.new(0.9, 0, 0, 1)
    divider.Position = UDim2.new(0.05, 0, 0, 75)
    divider.BackgroundColor3 = COLORS.Border
    divider.BackgroundTransparency = 0.5
    divider.BorderSizePixel = 0
    
    -- ESP
    local espToggle = Instance.new("TextButton")
    espToggle.Parent = mainFrame
    espToggle.Size = UDim2.new(0.9, 0, 0, 40)
    espToggle.Position = UDim2.new(0.05, 0, 0, 90)
    espToggle.BackgroundColor3 = COLORS.Background
    espToggle.BorderSizePixel = 2
    espToggle.BorderColor3 = COLORS.Border
    espToggle.Text = "👁 ESP (Игроки + Боты)  ❌"
    espToggle.TextColor3 = COLORS.TextDim
    espToggle.TextSize = 14
    espToggle.Font = Enum.Font.GothamBold
    espToggle.AutoButtonColor = false
    
    local espCorner = Instance.new("UICorner")
    espCorner.CornerRadius = UDim.new(0, 8)
    espCorner.Parent = espToggle
    
    espToggle.MouseButton1Click:Connect(function()
        ESP_ENABLED = not ESP_ENABLED
        if ESP_ENABLED then
            espToggle.Text = "👁 ESP (Игроки + Боты)  ✅"
            espToggle.TextColor3 = COLORS.Accent
            espToggle.BorderColor3 = COLORS.Accent
            UpdateESP()
        else
            espToggle.Text = "👁 ESP (Игроки + Боты)  ❌"
            espToggle.TextColor3 = COLORS.TextDim
            espToggle.BorderColor3 = COLORS.Border
            ClearESP()
        end
    end)
    
    -- AIMBOT
    local aimToggle = Instance.new("TextButton")
    aimToggle.Parent = mainFrame
    aimToggle.Size = UDim2.new(0.9, 0, 0, 40)
    aimToggle.Position = UDim2.new(0.05, 0, 0, 140)
    aimToggle.BackgroundColor3 = COLORS.Background
    aimToggle.BorderSizePixel = 2
    aimToggle.BorderColor3 = COLORS.Border
    aimToggle.Text = "🎯 AIMBOT (ПКМ)  ❌"
    aimToggle.TextColor3 = COLORS.TextDim
    aimToggle.TextSize = 14
    aimToggle.Font = Enum.Font.GothamBold
    aimToggle.AutoButtonColor = false
    
    local aimCorner = Instance.new("UICorner")
    aimCorner.CornerRadius = UDim.new(0, 8)
    aimCorner.Parent = aimToggle
    
    aimToggle.MouseButton1Click:Connect(function()
        AIMBOT_ENABLED = not AIMBOT_ENABLED
        if AIMBOT_ENABLED then
            aimToggle.Text = "🎯 AIMBOT (ПКМ)  ✅"
            aimToggle.TextColor3 = COLORS.Selected
            aimToggle.BorderColor3 = COLORS.Selected
            if fovCircle then fovCircle.Visible = true end
        else
            aimToggle.Text = "🎯 AIMBOT (ПКМ)  ❌"
            aimToggle.TextColor3 = COLORS.TextDim
            aimToggle.BorderColor3 = COLORS.Border
            if fovCircle then fovCircle.Visible = false end
        end
    end)
    
    -- РЕЖИМ ПЛАВНОСТИ
    CreateLabel(mainFrame, UDim2.new(0.9, 0, 0, 20), UDim2.new(0.05, 0, 0, 190), "⚙️ РЕЖИМ ПЛАВНОСТИ", COLORS.Accent, 13).TextXAlignment = Enum.TextXAlignment.Left
    
    local smoothStatus = CreateLabel(mainFrame, UDim2.new(0.9, 0, 0, 18), UDim2.new(0.05, 0, 0, 210), "Выбрано: 🟡 Средний", COLORS.Medium, 11)
    
    -- Кнопки режимов
    local function CreateSmoothButton(parent, xPos, yPos, modeName, displayName, smoothness, color)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(0.28, 0, 0, 45)
        btn.Position = UDim2.new(xPos, 0, 0, yPos)
        btn.BackgroundColor3 = COLORS.Background
        btn.BorderSizePixel = 2
        btn.BorderColor3 = COLORS.Border
        btn.Text = displayName
        btn.TextColor3 = COLORS.Text
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = btn
        
        smoothButtons[modeName] = btn
        
        if smoothness == AIMBOT_SMOOTHNESS then
            btn.BackgroundColor3 = Color3.fromRGB(0, 50, 20)
            btn.BorderColor3 = color
            btn.TextColor3 = color
        end
        
        btn.MouseButton1Click:Connect(function()
            AIMBOT_SMOOTHNESS = smoothness
            smoothStatus.Text = "Выбрано: " .. displayName
            smoothStatus.TextColor3 = color
            
            for _, b in pairs(smoothButtons) do
                b.BackgroundColor3 = COLORS.Background
                b.BorderColor3 = COLORS.Border
                b.TextColor3 = COLORS.Text
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 50, 20)
            btn.BorderColor3 = color
            btn.TextColor3 = color
            
            print("⚙️ Режим плавности: " .. modeName .. " (" .. smoothness .. ")")
        end)
    end
    
    CreateSmoothButton(mainFrame, 0.05, 230, "Легкий", "🟢 Легкий", 0.05, COLORS.Easy)
    CreateSmoothButton(mainFrame, 0.36, 230, "Средний", "🟡 Средний", 0.15, COLORS.Medium)
    CreateSmoothButton(mainFrame, 0.67, 230, "Читерский", "🔴 Читер", 1.0, COLORS.Cheater)
    
    -- FOV
    CreateLabel(mainFrame, UDim2.new(0.9, 0, 0, 20), UDim2.new(0.05, 0, 0, 290), "🎯 FOV (радиус)", COLORS.Accent, 13).TextXAlignment = Enum.TextXAlignment.Left
    
    local function CreateFOVBtn(parent, xPos, size, label)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(0.2, 0, 0, 30)
        btn.Position = UDim2.new(xPos, 0, 0, 315)
        btn.BackgroundColor3 = COLORS.Background
        btn.BorderSizePixel = 1
        btn.BorderColor3 = COLORS.Border
        btn.Text = label
        btn.TextColor3 = COLORS.Text
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            AIMBOT_FOV = size
            if fovCircle then
                fovCircle.Size = UDim2.new(0, AIMBOT_FOV * 2, 0, AIMBOT_FOV * 2)
            end
        end)
    end
    
    CreateFOVBtn(mainFrame, 0.05, 100, "100")
    CreateFOVBtn(mainFrame, 0.28, 200, "200")
    CreateFOVBtn(mainFrame, 0.51, 300, "300")
    CreateFOVBtn(mainFrame, 0.74, 500, "500")
    
    -- ЧАСТЬ ТЕЛА
    CreateLabel(mainFrame, UDim2.new(0.9, 0, 0, 20), UDim2.new(0.05, 0, 0, 355), "🎯 ЧАСТЬ ТЕЛА", COLORS.Accent, 13).TextXAlignment = Enum.TextXAlignment.Left
    
    local function CreatePartBtn(parent, xPos, partName, displayName)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(0.42, 0, 0, 40)
        btn.Position = UDim2.new(xPos, 0, 0, 380)
        btn.BackgroundColor3 = COLORS.Background
        btn.BorderSizePixel = 2
        btn.BorderColor3 = COLORS.Border
        btn.Text = displayName
        btn.TextColor3 = COLORS.Text
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = btn
        
        if partName == AIMBOT_PART then
            btn.BackgroundColor3 = Color3.fromRGB(0, 50, 20)
            btn.BorderColor3 = COLORS.Selected
            btn.TextColor3 = COLORS.Selected
        end
        
        btn.MouseButton1Click:Connect(function()
            AIMBOT_PART = partName
            for _, child in ipairs(parent:GetChildren()) do
                if child:IsA("TextButton") and (child.Text == "🎯 Голова" or child.Text == "🫀 Живот") then
                    child.BackgroundColor3 = COLORS.Background
                    child.BorderColor3 = COLORS.Border
                    child.TextColor3 = COLORS.Text
                end
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 50, 20)
            btn.BorderColor3 = COLORS.Selected
            btn.TextColor3 = COLORS.Selected
        end)
    end
    
    CreatePartBtn(mainFrame, 0.05, "Head", "🎯 Голова")
    CreatePartBtn(mainFrame, 0.53, "UpperTorso", "🫀 Живот")
    
    -- ВОЗВРАТ
    local backToMainBtn = Instance.new("TextButton")
    backToMainBtn.Parent = mainFrame
    backToMainBtn.Size = UDim2.new(0.9, 0, 0, 45)
    backToMainBtn.Position = UDim2.new(0.05, 0, 0, 435)
    backToMainBtn.BackgroundColor3 = COLORS.Background
    backToMainBtn.BorderSizePixel = 2
    backToMainBtn.BorderColor3 = COLORS.Back
    backToMainBtn.Text = "🏠 ВЕРНУТЬСЯ В ХАБ"
    backToMainBtn.TextColor3 = COLORS.Back
    backToMainBtn.TextSize = 15
    backToMainBtn.Font = Enum.Font.GothamBold
    backToMainBtn.AutoButtonColor = false
    
    local backCorner = Instance.new("UICorner")
    backCorner.CornerRadius = UDim.new(0, 8)
    backCorner.Parent = backToMainBtn
    
    backToMainBtn.MouseEnter:Connect(function()
        TweenService:Create(backToMainBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(50, 20, 20)
        }):Play()
    end)
    backToMainBtn.MouseLeave:Connect(function()
        TweenService:Create(backToMainBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = COLORS.Background
        }):Play()
    end)
    
    backToMainBtn.MouseButton1Click:Connect(function()
        ReturnToMainMenu()
    end)
    
    CreateLabel(mainFrame, UDim2.new(1, 0, 0, 15), UDim2.new(0, 0, 0, 500), "BY MC | HCM2_STUDIO © 2026", COLORS.TextDim, 10)
    
    -- Кнопка закрытия
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = mainFrame
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -35, 0, 8)
    closeBtn.BackgroundColor3 = COLORS.Background
    closeBtn.BorderSizePixel = 1
    closeBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.AutoButtonColor = false
    
    local cbc = Instance.new("UICorner")
    cbc.CornerRadius = UDim.new(0, 6)
    cbc.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        menuOpen = false
        circleBtn.Text = "HCM2"
        circleBtn.BorderColor3 = COLORS.Border
    end)
    
    circleBtn.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen
        mainFrame.Visible = menuOpen
        
        if menuOpen then
            circleBtn.Text = "×"
            circleBtn.BorderColor3 = COLORS.Selected
        else
            circleBtn.Text = "HCM2"
            circleBtn.BorderColor3 = COLORS.Border
        end
    end)
    
    CreateFOVCircle()
end

UpdateBotCache()
CreateMenu()
