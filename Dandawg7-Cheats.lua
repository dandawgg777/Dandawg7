-- Dandawg7 Full Cheat by seraph - Fixed ESP + Working Menu + J Hotkey + Enhanced Features
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Settings = {
    Aimbot = {Enabled = true, FOV = 120, Smoothness = 0.15, TargetPart = "Head", TeamCheck = false},
    SilentAim = {Enabled = true, HitChance = 100},
    Triggerbot = {Enabled = true, Delay = 0},
    ESP = {Enabled = true, Boxes = true, Health = true, Distance = true, Tracers = false, Names = false},
    Rainbow = {Enabled = false}
}

-- ====================== LOADING SCREEN ======================
local LoadingGui = Instance.new("ScreenGui")
LoadingGui.Name = "Dandawg7_Loader"
LoadingGui.ResetOnSpawn = false
LoadingGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(0, 500, 0, 280)
LoadingFrame.Position = UDim2.new(0.5, -250, 0.5, -140)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = LoadingGui

Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 16)
Instance.new("UIStroke", LoadingFrame).Color = Color3.fromRGB(255, 0, 100); Instance.new("UIStroke", LoadingFrame).Thickness = 3

local TitleLoad = Instance.new("TextLabel", LoadingFrame)
TitleLoad.Size = UDim2.new(1, 0, 0, 60)
TitleLoad.BackgroundTransparency = 1
TitleLoad.Text = "DANDAWG7 PRO"
TitleLoad.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLoad.TextScaled = true
TitleLoad.Font = Enum.Font.GothamBlack

local Subtitle = Instance.new("TextLabel", LoadingFrame)
Subtitle.Size = UDim2.new(1, 0, 0, 30)
Subtitle.Position = UDim2.new(0, 0, 0, 55)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Loading cheat..."
Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
Subtitle.TextScaled = true
Subtitle.Font = Enum.Font.Gotham

local ProgressBG = Instance.new("Frame", LoadingFrame)
ProgressBG.Size = UDim2.new(0.85, 0, 0, 18)
ProgressBG.Position = UDim2.new(0.075, 0, 0.75, 0)
ProgressBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", ProgressBG)

local ProgressBar = Instance.new("Frame", ProgressBG)
ProgressBar.Size = UDim2.new(0, 0, 1, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
Instance.new("UICorner", ProgressBar)

local ProgressText = Instance.new("TextLabel", ProgressBG)
ProgressText.Size = UDim2.new(1, 0, 1, 0)
ProgressText.BackgroundTransparency = 1
ProgressText.Text = "0%"
ProgressText.TextColor3 = Color3.new(1,1,1)
ProgressText.Font = Enum.Font.GothamBold
ProgressText.TextScaled = true

local function StartLoading()
    TweenService:Create(ProgressBar, TweenInfo.new(5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.new(1,0,1,0)}):Play()
    for i = 0, 100, 5 do
        task.wait(0.25)
        ProgressText.Text = i .. "%"
    end
    for _, obj in pairs({LoadingFrame, TitleLoad, Subtitle, ProgressBG, ProgressBar}) do
        TweenService:Create(obj, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    end
    task.wait(0.6)
    LoadingGui:Destroy()
end
StartLoading()

-- ====================== DRAWING OBJECTS ======================
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2.5
FOVCircle.Radius = Settings.Aimbot.FOV
FOVCircle.Transparency = 0.75
FOVCircle.Visible = true
FOVCircle.NumSides = 100
FOVCircle.Color = Color3.fromRGB(255, 0, 100)

local rainbowHue = 0
local rainbowConnection

local espObjects = {}

-- ====================== MAIN GUI ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Dandawg7_Pro"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 480)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 0, 100)
UIStroke.Thickness = 2

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -140, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DANDAWG7 PRO CHEAT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- Draggable
local dragging = false
local dragInput, dragStart, startPos
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Tabs
local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(0, 140, 1, -50)
TabHolder.Position = UDim2.new(0, 0, 0, 50)
TabHolder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
TabHolder.Parent = MainFrame

local Tabs = {"Aimbot", "Visuals", "Misc", "Colors"}
local TabFrames = {}
local TabButtons = {}

for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*50)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = tabName
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextScaled = true
    btn.Parent = TabHolder
    Instance.new("UICorner", btn)
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -150, 1, -60)
    content.Position = UDim2.new(0, 150, 0, 60)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 6
    content.CanvasSize = UDim2.new(0,0,0,800)
    content.Parent = MainFrame
    content.Visible = false
    
    TabFrames[tabName] = content
    TabButtons[tabName] = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(TabFrames) do f.Visible = false end
        content.Visible = true
        for _, b in pairs(TabButtons) do b.BackgroundColor3 = Color3.fromRGB(30,30,30) end
        btn.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
    end)
end

TabFrames["Aimbot"].Visible = true
TabButtons["Aimbot"].BackgroundColor3 = Color3.fromRGB(255, 0, 100)

local function CreateToggle(parent, text, settingTable, settingKey, yOffset)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.95, 0, 0, 50)
    toggleFrame.Position = UDim2.new(0.025, 0, 0, yOffset)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggleFrame.Parent = parent
    Instance.new("UICorner", toggleFrame)
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.Parent = toggleFrame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 80, 0, 30)
    switch.Position = UDim2.new(0.85, 0, 0.5, -15)
    switch.BackgroundColor3 = settingTable[settingKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    switch.Text = settingTable[settingKey] and "ON" or "OFF"
    switch.TextColor3 = Color3.new(1,1,1)
    switch.Font = Enum.Font.GothamBold
    switch.Parent = toggleFrame
    Instance.new("UICorner", switch)
    
    switch.MouseButton1Click:Connect(function()
        settingTable[settingKey] = not settingTable[settingKey]
        local enabled = settingTable[settingKey]
        switch.BackgroundColor3 = enabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
        switch.Text = enabled and "ON" or "OFF"
    end)
end

-- Populate tabs
local aimY = 10
CreateToggle(TabFrames["Aimbot"], "Aimbot Enabled", Settings.Aimbot, "Enabled", aimY); aimY += 60
CreateToggle(TabFrames["Aimbot"], "Team Check", Settings.Aimbot, "TeamCheck", aimY)

local visY = 10
CreateToggle(TabFrames["Visuals"], "ESP Enabled", Settings.ESP, "Enabled", visY); visY += 60
CreateToggle(TabFrames["Visuals"], "ESP Boxes", Settings.ESP, "Boxes", visY); visY += 60
CreateToggle(TabFrames["Visuals"], "ESP Health", Settings.ESP, "Health", visY); visY += 60
CreateToggle(TabFrames["Visuals"], "ESP Distance", Settings.ESP, "Distance", visY)

local miscY = 10
CreateToggle(TabFrames["Misc"], "Silent Aim", Settings.SilentAim, "Enabled", miscY); miscY += 60
CreateToggle(TabFrames["Misc"], "Triggerbot", Settings.Triggerbot, "Enabled", miscY)

local colorY = 10
CreateToggle(TabFrames["Colors"], "Rainbow Mode", Settings.Rainbow, "Enabled", colorY)

-- Color Wheel
local ColorFrame = Instance.new("Frame")
ColorFrame.Size = UDim2.new(0, 200, 0, 200)
ColorFrame.Position = UDim2.new(0.1, 0, 0, colorY + 70)
ColorFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
ColorFrame.Parent = TabFrames["Colors"]

local ColorWheel = Instance.new("ImageLabel")
ColorWheel.Size = UDim2.new(1,0,1,0)
ColorWheel.Image = "rbxassetid://6020299373"
ColorWheel.Parent = ColorFrame

local PickerDot = Instance.new("Frame")
PickerDot.Size = UDim2.new(0,14,0,14)
PickerDot.BackgroundColor3 = Color3.new(1,1,1)
PickerDot.BorderSizePixel = 2
PickerDot.BorderColor3 = Color3.new(0,0,0)
PickerDot.Parent = ColorFrame

local selectedColor = Color3.fromRGB(255, 0, 100)
local draggingColor = false

ColorWheel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingColor = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingColor = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if not draggingColor then return end
    local mousePos = UserInputService:GetMouseLocation()
    local wheelCenter = ColorWheel.AbsolutePosition + ColorWheel.AbsoluteSize/2
    local radius = ColorWheel.AbsoluteSize.X / 2
    local diff = (mousePos - wheelCenter)
    local dist = diff.Magnitude
    if dist > radius then diff = diff.Unit * radius end
    PickerDot.Position = UDim2.fromOffset(diff.X + radius - 7, diff.Y + radius - 7)
    local angle = math.atan2(diff.Y, diff.X)
    local hue = (angle + math.pi) / (2 * math.pi)
    selectedColor = Color3.fromHSV(math.clamp(hue, 0, 1), 1, 1)
end)

-- ====================== FIXED ESP ======================
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    FOVCircle.Color = Settings.Rainbow.Enabled and Color3.fromHSV(rainbowHue, 1, 1) or Color3.fromRGB(255, 0, 100)
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character then continue end
        local root = plr.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = plr.Character:FindFirstChild("Humanoid")
        
        if not root or not humanoid or humanoid.Health <= 0 then
            if espObjects[plr] then
                for _, obj in pairs(espObjects[plr]) do
                    if obj then obj.Visible = false end
                end
            end
            continue
        end
        
        if not espObjects[plr] then
            espObjects[plr] = {}
            local box = Drawing.new("Square")
            box.Thickness = 2.5; box.Filled = false; box.Transparency = 1
            espObjects[plr].box = box
            
            local healthBar = Drawing.new("Square")
            healthBar.Thickness = 1; healthBar.Filled = true; healthBar.Transparency = 1
            espObjects[plr].healthBar = healthBar
            
            local distText = Drawing.new("Text")
            distText.Size = 16; distText.Center = true; distText.Outline = true; distText.Transparency = 1
            espObjects[plr].distanceText = distText
        end
        
        local objs = espObjects[plr]
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        
        if onScreen and Settings.ESP.Enabled then
            local size = Vector2.new(2200 / pos.Z, 3800 / pos.Z)
            local position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
            
            if Settings.ESP.Boxes then
                objs.box.Visible = true
                objs.box.Size = size
                objs.box.Position = position
                objs.box.Color = Settings.Rainbow.Enabled and Color3.fromHSV(rainbowHue,1,1) or selectedColor
            else
                objs.box.Visible = false
            end
            
            if Settings.ESP.Health then
                local hpPct = humanoid.Health / humanoid.MaxHealth
                objs.healthBar.Visible = true
                objs.healthBar.Size = Vector2.new(5, size.Y * hpPct)
                objs.healthBar.Position = Vector2.new(position.X - 8, position.Y + size.Y * (1 - hpPct))
                objs.healthBar.Color = Color3.fromHSV(hpPct * 0.33, 1, 1)
            else
                objs.healthBar.Visible = false
            end
            
            if Settings.ESP.Distance then
                local dist = (root.Position - Camera.CFrame.Position).Magnitude
                objs.distanceText.Visible = true
                objs.distanceText.Text = math.floor(dist) .. "m"
                objs.distanceText.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 25)
                objs.distanceText.Color = selectedColor
            else
                objs.distanceText.Visible = false
            end
        else
            for _, obj in pairs(objs) do if obj then obj.Visible = false end end
        end
    end
    
    for plr, objs in pairs(espObjects) do
        if not plr or not plr.Parent or not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health <= 0 then
            for _, obj in pairs(objs) do if obj then obj:Remove() end end
            espObjects[plr] = nil
        end
    end
end)

-- Rainbow
local function UpdateRainbow()
    if rainbowConnection then rainbowConnection:Disconnect() end
    if not Settings.Rainbow.Enabled then return end
    rainbowConnection = RunService.Heartbeat:Connect(function(dt)
        rainbowHue = (rainbowHue + dt * 1.8) % 1
    end)
end

-- Auto FFA
local function IsFFA()
    local teams = {}
    for _, p in Players:GetPlayers() do
        if p.Team then teams[p.Team.Name] = true end
    end
    return #Players:GetPlayers() > 2 and (#teams <= 1)
end

if IsFFA() then
    Settings.Aimbot.Enabled = true
    Settings.ESP.Enabled = true
    Settings.SilentAim.Enabled = true
    Settings.Triggerbot.Enabled = true
end

-- Aimbot
local target = nil
RunService.RenderStepped:Connect(function()
    if not Settings.Aimbot.Enabled then return end
    local closest, shortest = nil, Settings.Aimbot.FOV
    for _, plr in Players:GetPlayers() do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(Settings.Aimbot.TargetPart) then
            local part = plr.Character[Settings.Aimbot.TargetPart]
            if not Settings.Aimbot.TeamCheck or plr.Team ~= LocalPlayer.Team then
                local sp, os = Camera:WorldToViewportPoint(part.Position)
                if os then
                    local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if d < shortest then shortest = d; closest = part end
                end
            end
        end
    end
    if closest then
        target = closest
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), Settings.Aimbot.Smoothness)
    end
end)

-- Silent Aim
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    if Settings.SilentAim.Enabled and (self.Name == "FindPartOnRayWithIgnoreList" or self.Name == "Raycast") and target then
        if math.random(100) <= Settings.SilentAim.HitChance then
            args[1] = Ray.new(Camera.CFrame.Position, (target.Position - Camera.CFrame.Position).Unit * 20000)
        end
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

-- Triggerbot
Mouse.Button1Down:Connect(function()
    if Settings.Triggerbot.Enabled then
        spawn(function()
            while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                task.wait()
            end
        end)
    end
end)

-- J KEY MENU TOGGLE
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.J then
        MainFrame.Visible = not MainFrame.Visible
        print("Menu toggled via J - Visible:", MainFrame.Visible)
    end
end)

-- Rainbow toggle
UpdateRainbow()

print("✅ Dandawg7 PRO Cheat FULLY LOADED")
print("Press J to open/close menu | ESP fixed + Health + Distance")
print("Auto FFA support active")

[made by seraph]
