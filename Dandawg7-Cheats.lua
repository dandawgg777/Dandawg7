-- Dandawg7 Full Cheat by seraph - Rainbow + GUI + Aimbot
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Settings = {
    Aimbot = {Enabled = true, FOV = 120, Smoothness = 0.15, TargetPart = "Head", TeamCheck = false},
    SilentAim = {Enabled = true, HitChance = 100},
    Triggerbot = {Enabled = true, Delay = 0},
    ESP = {Enabled = true, Boxes = true},
    Rainbow = {Enabled = false}
}

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Dandawg7"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
Title.Text = "Dandawg7 Cheat"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Radius = Settings.Aimbot.FOV
FOVCircle.Transparency = 0.7
FOVCircle.Visible = true
FOVCircle.NumSides = 64

-- Rainbow System
local rainbowHue = 0
local rainbowConnection

local function UpdateRainbow()
    if not Settings.Rainbow.Enabled then 
        if rainbowConnection then rainbowConnection:Disconnect() end
        return 
    end
    if rainbowConnection then rainbowConnection:Disconnect() end
    rainbowConnection = RunService.Heartbeat:Connect(function()
        rainbowHue = (rainbowHue + 0.015) % 1
        local rainbowColor = Color3.fromHSV(rainbowHue, 1, 1)
        FOVCircle.Color = rainbowColor
        for _, box in pairs(espBoxes or {}) do
            if box then box.Color = rainbowColor end
        end
    end)
end

local function ApplyRainbowGun()
    if not Settings.Rainbow.Enabled then return end
    local character = LocalPlayer.Character
    if character then
        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, part in ipairs(tool:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        part.Color = Color3.fromHSV(rainbowHue, 1, 1)
                    end
                end
            end
        end
    end
end

-- Colour Wheel
local ColorFrame = Instance.new("Frame")
ColorFrame.Size = UDim2.new(0, 200, 0, 200)
ColorFrame.Position = UDim2.new(0.05, 0, 0, 320)
ColorFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
ColorFrame.Parent = MainFrame

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

-- Rainbow Toggle
local rainbowToggle = Instance.new("TextButton")
rainbowToggle.Size = UDim2.new(0.9, 0, 0, 40)
rainbowToggle.Position = UDim2.new(0.05, 0, 0, 270)
rainbowToggle.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
rainbowToggle.Text = "Rainbow Mode (ESP+FOV+Gun): OFF"
rainbowToggle.TextColor3 = Color3.new(1,1,1)
rainbowToggle.Font = Enum.Font.GothamBold
rainbowToggle.TextScaled = true
rainbowToggle.Parent = MainFrame

rainbowToggle.MouseButton1Click:Connect(function()
    Settings.Rainbow.Enabled = not Settings.Rainbow.Enabled
    rainbowToggle.BackgroundColor3 = Settings.Rainbow.Enabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
    rainbowToggle.Text = "Rainbow Mode (ESP+FOV+Gun): " .. (Settings.Rainbow.Enabled and "ON" or "OFF")
    UpdateRainbow()
end)

-- ESP
local espBoxes = {}
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not espBoxes[plr] then
                local box = Drawing.new("Square")
                box.Thickness = 2
                box.Filled = false
                box.Transparency = 1
                espBoxes[plr] = box
            end
            local box = espBoxes[plr]
            if Settings.ESP.Enabled then
                local root = plr.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    box.Visible = true
                    box.Size = Vector2.new(2500 / pos.Z, 4000 / pos.Z)
                    box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
                    if not Settings.Rainbow.Enabled then box.Color = selectedColor end
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        end
    end

    if Settings.Rainbow.Enabled then ApplyRainbowGun() end
end)

-- Aimbot
local target = nil
RunService.RenderStepped:Connect(function()
    if not Settings.Aimbot.Enabled then return end
    local closest = nil
    local shortestDist = Settings.Aimbot.FOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(Settings.Aimbot.TargetPart) then
            local part = plr.Character[Settings.Aimbot.TargetPart]
            if not Settings.Aimbot.TeamCheck or plr.Team ~= LocalPlayer.Team then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closest = part
                    end
                end
            end
        end
    end
    if closest then
        target = closest
        local targetCFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Settings.Aimbot.Smoothness)
    end
end)

-- Silent Aim
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    if Settings.SilentAim.Enabled and (self.Name == "FindPartOnRayWithIgnoreList" or self.Name == "Raycast") then
        if target and math.random(100) <= Settings.SilentAim.HitChance then
            args[1] = Ray.new(Camera.CFrame.Position, (target.Position - Camera.CFrame.Position).Unit * 10000)
        end
    end
    return oldNamecall(self, unpack(args))
end)
setreadonly(mt, true)

-- Triggerbot
Mouse.Button1Down:Connect(function()
    if not Settings.Triggerbot.Enabled then return end
    spawn(function()
        while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
            task.wait(Settings.Triggerbot.Delay / 1000)
        end
    end)
end)

print("Dandawg7 Cheat Loaded Successfully")