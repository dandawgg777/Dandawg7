-- DANDAWG7 Ultimate Roblox Aimbot + ESP GUI Cheat v5 (Protocol Zero)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local aimbotEnabled = true
local silentAimEnabled = true
local triggerbotEnabled = false
local espEnabled = true
local teamCheck = true
local wallCheck = true

local aimbotFOV = 120
local aimbotSmoothness = 0.35
local targetPart = "Head"
local triggerbotDelay = 0.03

local connections = {}
local espDrawings = {}
local configFile = "dandawg7_config_v5.json"

-- === CLEAN & BEAUTIFUL GUI ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Dandawg7CheatGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 650)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -325)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Title
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 70)
TitleBar.BackgroundColor3 = Color3.fromRGB(0, 70, 160)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "DANDAWG7 CHEAT"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBlack
Title.Parent = TitleBar

local function createSection(title, y)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.95, 0, 0, 35)
    label.Position = UDim2.new(0.025, 0, 0, y)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.fromRGB(100, 200, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Parent = MainFrame
    return label
end

createSection("AIMBOT SETTINGS", 80)
createSection("BONE STRUCTURE", 210)
createSection("VISUALS", 380)

local function createToggle(name, yPos, default)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 55)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(45, 45, 50)
    btn.Text = name .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame
    
    btn.MouseButton1Click:Connect(function()
        local varName = name:gsub(" ", "") .. "_var"
        _G[varName] = not _G[varName]
        local state = _G[varName]
        btn.Text = name .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(45, 45, 50)
    end)
    return btn
end

_G["Aimbot_var"] = aimbotEnabled
_G["SilentAim_var"] = silentAimEnabled
_G["Triggerbot_var"] = triggerbotEnabled
_G["ESP_var"] = espEnabled
_G["TeamCheck_var"] = teamCheck
_G["WallCheck_var"] = wallCheck

local btnAimbot = createToggle("Aimbot", 120, aimbotEnabled)
local btnSilent = createToggle("Silent Aim", 185, silentAimEnabled)
local btnTrigger = createToggle("Triggerbot", 250, triggerbotEnabled)

-- Bone Structure (fixed grid, no overlap)
local boneOptions = {"Head", "UpperTorso", "HumanoidRootPart", "LowerTorso", "LeftHand", "RightHand"}
local boneButtons = {}

local function updateBoneButtons(selected)
    for _, b in ipairs(boneButtons) do
        b.BackgroundColor3 = (b.Text == selected) and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(50, 50, 55)
    end
end

for i, bone in ipairs(boneOptions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.28, 0, 0, 45)
    btn.Position = UDim2.new(0.05 + ((i-1)%3) * 0.32, 0, 0, 250 + math.floor((i-1)/3) * 55)
    btn.BackgroundColor3 = (bone == targetPart) and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(50, 50, 55)
    btn.Text = bone
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = MainFrame
    table.insert(boneButtons, btn)
    
    btn.MouseButton1Click:Connect(function()
        targetPart = bone
        updateBoneButtons(bone)
    end)
end

-- Sliders (cleaner)
local function createSlider(labelText, yPos, minVal, maxVal, defaultVal, onChange)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.9, 0, 0, 30)
    label.Position = UDim2.new(0.05, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = labelText .. ": " .. defaultVal
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Parent = MainFrame

    local sliderBG = Instance.new("Frame")
    sliderBG.Size = UDim2.new(0.9, 0, 0, 18)
    sliderBG.Position = UDim2.new(0.05, 0, 0, yPos + 35)
    sliderBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    sliderBG.BorderSizePixel = 0
    sliderBG.Parent = MainFrame

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBG

    local value = defaultVal
    sliderBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local conn = UserInputService.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((Mouse.X - sliderBG.AbsolutePosition.X) / sliderBG.AbsoluteSize.X, 0, 1)
                    value = math.floor(minVal + rel * (maxVal - minVal))
                    label.Text = labelText .. ": " .. value
                    sliderFill.Size = UDim2.new(rel, 0, 1, 0)
                    onChange(value)
                end
            end)
            local endConn; endConn = UserInputService.InputEnded:Connect(function()
                conn:Disconnect()
                endConn:Disconnect()
            end)
        end
    end)
    return label, sliderBG
end

local fovLabel, _ = createSlider("FOV", 410, 30, 500, aimbotFOV, function(v) aimbotFOV = v end)
local smoothLabel, _ = createSlider("Smoothness", 480, 0, 100, math.floor(aimbotSmoothness*100), function(v) aimbotSmoothness = v/100 end)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(255, 60, 60)
fovCircle.Filled = false
fovCircle.Transparency = 0.75
fovCircle.NumSides = 100

-- Rest of the cheat logic (unchanged, just cleaner)
local function isVisible(targetChar)
    if not wallCheck then return true end
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not root or not targetRoot then return false end
    local direction = (targetRoot.Position - root.Position)
    local ray = Ray.new(root.Position, direction)
    local hit, _ = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, targetChar})
    return not hit
end

local function getClosestPlayer()
    local closest, shortest = nil, aimbotFOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(targetPart) then
            if teamCheck and plr.Team == LocalPlayer.Team then continue end
            if not isVisible(plr.Character) then continue end
            local part = plr.Character[targetPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local d = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if d < shortest then
                    shortest = d
                    closest = plr
                end
            end
        end
    end
    return closest
end

local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if silentAimEnabled and method == "FireServer" and (self.Name:lower():find("shoot") or self.Name:lower():find("bullet") or self.Name:lower():find("hit")) then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(targetPart) then
            local args = {...}
            if args[1] and typeof(args[1]) == "Vector3" then
                args[1] = target.Character[targetPart].Position + Vector3.new(0, 0.1, 0)
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)

local function updateAimbot()
    if not aimbotEnabled then return end
    local target = getClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild(targetPart) then
        local targetPos = Camera:WorldToViewportPoint(target.Character[targetPart].Position)
        local mousePos = UserInputService:GetMouseLocation()
        local dir = (Vector2.new(targetPos.X, targetPos.Y) - mousePos) * aimbotSmoothness
        mousemoverel(dir.X, dir.Y)
    end
end

local function updateFOVCircle()
    fovCircle.Visible = aimbotEnabled or silentAimEnabled
    fovCircle.Radius = aimbotFOV
    fovCircle.Position = UserInputService:GetMouseLocation()
end

local function createESP(plr)
    if espDrawings[plr] then return end
    local box = Drawing.new("Square"); box.Thickness=2; box.Filled=false; box.Transparency=1
    local healthBarOutline = Drawing.new("Square"); healthBarOutline.Thickness=1; healthBarOutline.Filled=false
    local healthBar = Drawing.new("Square"); healthBar.Filled=true
    local nameTag = Drawing.new("Text"); nameTag.Size=15; nameTag.Center=true; nameTag.Outline=true; nameTag.Color=Color3.new(1,1,1)
    espDrawings[plr] = {box=box, hbar=healthBar, houtline=healthBarOutline, name=nameTag}
end

local function updateESP()
    if not espEnabled then
        for _, d in pairs(espDrawings) do for _, obj in pairs(d) do obj.Visible = false end end
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then continue end
        if teamCheck and plr.Team == LocalPlayer.Team then continue end
        if not isVisible(plr.Character) then 
            if espDrawings[plr] then for _, obj in pairs(espDrawings[plr]) do obj.Visible=false end end
            continue 
        end
        if not espDrawings[plr] then createESP(plr) end
        local d = espDrawings[plr]
        local root = plr.Character.HumanoidRootPart
        local hum = plr.Character:FindFirstChild("Humanoid")
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        if onScreen then
            local top = Camera:WorldToViewportPoint(root.Position + Vector3.new(0,3,0))
            local bot = Camera:WorldToViewportPoint(root.Position - Vector3.new(0,3.5,0))
            local h = math.abs(top.Y - bot.Y)
            local w = h * 0.6

            d.box.Size = Vector2.new(w, h)
            d.box.Position = Vector2.new(pos.X - w/2, pos.Y - h/2)
            d.box.Color = Color3.fromRGB(255, 50, 50)
            d.box.Visible = true

            if hum then
                local hp = hum.Health / hum.MaxHealth
                d.houtline.Size = Vector2.new(4, h)
                d.houtline.Position = Vector2.new(pos.X - w/2 - 8, pos.Y - h/2)
                d.houtline.Visible = true
                d.hbar.Size = Vector2.new(4, h * hp)
                d.hbar.Position = Vector2.new(pos.X - w/2 - 8, pos.Y - h/2 + h * (1-hp))
                d.hbar.Color = Color3.fromRGB(255 - 255*hp, 255*hp, 0)
                d.hbar.Visible = true
            end

            d.name.Text = string.format("%s [%dm]", plr.Name, (root.Position - (LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new())).Magnitude)
            d.name.Position = Vector2.new(pos.X, pos.Y - h/2 - 20)
            d.name.Visible = true
        else
            for _, obj in pairs(d) do obj.Visible = false end
        end
    end
end

local function triggerbotLoop()
    if not triggerbotEnabled then return end
    local target = getClosestPlayer()
    if target then
        mouse1click()
        task.wait(triggerbotDelay)
    end
end

table.insert(connections, RunService.RenderStepped:Connect(updateAimbot))
table.insert(connections, RunService.RenderStepped:Connect(updateESP))
table.insert(connections, RunService.RenderStepped:Connect(updateFOVCircle))
table.insert(connections, RunService.Heartbeat:Connect(triggerbotLoop))

UserInputService.InputBegan:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

print("DANDAWG7 CHEAT v5 LOADED - Press INSERT to toggle GUI")

game:BindToClose(function()
    local config = {aimbotEnabled=aimbotEnabled, silentAimEnabled=silentAimEnabled, triggerbotEnabled=triggerbotEnabled, espEnabled=espEnabled, teamCheck=teamCheck, wallCheck=wallCheck, aimbotFOV=aimbotFOV}
    writefile(configFile, game:GetService("HttpService"):JSONEncode(config))
end)
