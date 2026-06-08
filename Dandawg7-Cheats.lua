-- Dandawg7 Full Cheat by seraph - FIXED LOADING + J Hotkey + Enhanced ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

print("Dandawg7 PRO - Initializing...")

local Settings = {
    Aimbot = {Enabled = true, FOV = 120, Smoothness = 0.15, TargetPart = "Head", TeamCheck = false},
    SilentAim = {Enabled = true, HitChance = 100},
    Triggerbot = {Enabled = true, Delay = 0},
    ESP = {Enabled = true, Boxes = true, Health = true, Distance = true},
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
LoadingFrame.Parent = LoadingGui

Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 16)
Instance.new("UIStroke", LoadingFrame).Color = Color3.fromRGB(255, 0, 100)

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

-- Run loading
spawn(function()
    TweenService:Create(ProgressBar, TweenInfo.new(5, Enum.EasingStyle.Quint), {Size = UDim2.new(1,0,1,0)}):Play()
    for i = 0, 100, 5 do
        ProgressText.Text = i .. "%"
        task.wait(0.25)
    end
    task.wait(0.6)
    LoadingGui:Destroy()
    print("Dandawg7 PRO - Loading screen finished")
end)

-- ====================== MAIN CHEAT ======================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Dandawg7_Pro"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 620, 0, 480)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 0, 100)

-- Title Bar
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -140, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DANDAWG7 PRO CHEAT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -50, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.TextScaled = true
CloseBtn.Font = Enum.Font.GothamBold
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
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Simple Tabs & Toggles (shortened for reliability)
local TabHolder = Instance.new("Frame", MainFrame)
TabHolder.Size = UDim2.new(0, 140, 1, -50)
TabHolder.Position = UDim2.new(0, 0, 0, 50)
TabHolder.BackgroundColor3 = Color3.fromRGB(22, 22, 22)

local VisualsTab = Instance.new("ScrollingFrame", MainFrame)
VisualsTab.Size = UDim2.new(1, -150, 1, -60)
VisualsTab.Position = UDim2.new(0, 150, 0, 60)
VisualsTab.BackgroundTransparency = 1
VisualsTab.CanvasSize = UDim2.new(0,0,0,600)

local function CreateToggle(parent, text, tbl, key, y)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.95, 0, 0, 50)
    f.Position = UDim2.new(0.025, 0, 0, y)
    f.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", f)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.7,0,1,0)
    l.Position = UDim2.new(0.05,0,0,0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1,1,1)
    l.TextScaled = true
    l.Font = Enum.Font.GothamSemibold
    
    local s = Instance.new("TextButton", f)
    s.Size = UDim2.new(0,80,0,30)
    s.Position = UDim2.new(0.85,0,0.5,-15)
    s.BackgroundColor3 = tbl[key] and Color3.fromRGB(0,170,0) or Color3.fromRGB(100,100,100)
    s.Text = tbl[key] and "ON" or "OFF"
    s.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", s)
    
    s.MouseButton1Click:Connect(function()
        tbl[key] = not tbl[key]
        local on = tbl[key]
        s.BackgroundColor3 = on and Color3.fromRGB(0,170,0) or Color3.fromRGB(100,100,100)
        s.Text = on and "ON" or "OFF"
    end)
end

CreateToggle(VisualsTab, "ESP Enabled", Settings.ESP, "Enabled", 10)
CreateToggle(VisualsTab, "ESP Boxes", Settings.ESP, "Boxes", 70)
CreateToggle(VisualsTab, "ESP Health", Settings.ESP, "Health", 130)
CreateToggle(VisualsTab, "ESP Distance", Settings.ESP, "Distance", 190)
CreateToggle(VisualsTab, "Rainbow Mode", Settings.Rainbow, "Enabled", 250)

-- J Hotkey
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.J then
        MainFrame.Visible = not MainFrame.Visible
        print("Menu toggled - Visible:", MainFrame.Visible)
    end
end)

-- ESP
local espObjects = {}
RunService.RenderStepped:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character then continue end
        local root = plr.Character:FindFirstChild("HumanoidRootPart")
        local hum = plr.Character:FindFirstChild("Humanoid")
        if not root or not hum or hum.Health <= 0 then
            if espObjects[plr] then
                for _, v in pairs(espObjects[plr]) do v.Visible = false end
            end
            continue
        end
        
        if not espObjects[plr] then
            espObjects[plr] = {}
            local box = Drawing.new("Square")
            box.Thickness = 2.5; box.Filled = false; box.Transparency = 1
            espObjects[plr].box = box
            
            local hb = Drawing.new("Square")
            hb.Thickness = 1; hb.Filled = true; hb.Transparency = 1
            espObjects[plr].healthBar = hb
            
            local dt = Drawing.new("Text")
            dt.Size = 16; dt.Center = true; dt.Outline = true; dt.Transparency = 1
            espObjects[plr].distanceText = dt
        end
        
        local objs = espObjects[plr]
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        
        if onScreen and Settings.ESP.Enabled then
            local size = Vector2.new(2200 / pos.Z, 3800 / pos.Z)
            local p = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
            
            objs.box.Visible = Settings.ESP.Boxes
            objs.box.Size = size
            objs.box.Position = p
            objs.box.Color = Settings.Rainbow.Enabled and Color3.fromHSV(tick() % 6 / 6, 1, 1) or Color3.fromRGB(255,0,100)
            
            if Settings.ESP.Health then
                local pct = hum.Health / hum.MaxHealth
                objs.healthBar.Visible = true
                objs.healthBar.Size = Vector2.new(5, size.Y * pct)
                objs.healthBar.Position = Vector2.new(p.X - 8, p.Y + size.Y * (1 - pct))
                objs.healthBar.Color = Color3.fromHSV(pct * 0.33, 1, 1)
            else
                objs.healthBar.Visible = false
            end
            
            if Settings.ESP.Distance then
                local dist = (root.Position - Camera.CFrame.Position).Magnitude
                objs.distanceText.Visible = true
                objs.distanceText.Text = math.floor(dist) .. "m"
                objs.distanceText.Position = Vector2.new(pos.X, pos.Y + size.Y/2 + 25)
                objs.distanceText.Color = Color3.fromRGB(255,0,100)
            else
                objs.distanceText.Visible = false
            end
        else
            for _, v in pairs(objs) do v.Visible = false end
        end
    end
end)

print("✅ Dandawg7 PRO Cheat LOADED SUCCESSFULLY")
print("Press J to open the menu")

[made by seraph]
