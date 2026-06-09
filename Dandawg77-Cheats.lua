-- Advanced Roblox Aimbot + ESP GUI Cheat (Protocol Zero)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local aimbotEnabled = false
local silentAimEnabled = true
local triggerbotEnabled = false
local espEnabled = true
local teamCheck = true

local aimbotFOV = 120
local aimbotSmoothness = 0.4
local targetPart = "Head"
local triggerbotDelay = 0.05

local connections = {}
local espDrawings = {}
local configFile = "cheat_config.json"

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AdvancedCheatGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Title.Text = "ADVANCED ROBLOX CHEAT"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Draggable helper (already enabled via .Draggable = true)

-- Toggle buttons (example layout)
local function createToggle(name, yPos, defaultState)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
    btn.Text = name .. ": " .. (defaultState and "ON" or "OFF")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = MainFrame
    return btn
end

local btnAimbot = createToggle("Aimbot", 60, aimbotEnabled)
local btnSilent = createToggle("Silent Aim", 115, silentAimEnabled)
local btnTrigger = createToggle("Triggerbot", 170, triggerbotEnabled)
local btnESP = createToggle("ESP", 225, espEnabled)
local btnTeam = createToggle("Team Check", 280, teamCheck)

-- GUI Toggle Key (Insert)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Config Save/Load
local function saveConfig()
    local config = {
        aimbotEnabled = aimbotEnabled,
        silentAimEnabled = silentAimEnabled,
        triggerbotEnabled = triggerbotEnabled,
        espEnabled = espEnabled,
        teamCheck = teamCheck,
        aimbotFOV = aimbotFOV,
        aimbotSmoothness = aimbotSmoothness
    }
    writefile(configFile, game:GetService("HttpService"):JSONEncode(config))
end

local function loadConfig()
    if isfile(configFile) then
        local success, config = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(configFile))
        end)
        if success then
            aimbotEnabled = config.aimbotEnabled or false
            silentAimEnabled = config.silentAimEnabled or true
            -- apply other values...
        end
    end
end

loadConfig()

-- Aimbot & Silent Aim
local function getClosestPlayer()
    local closest, dist = nil, aimbotFOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(targetPart) then
            if teamCheck and plr.Team == LocalPlayer.Team then continue end
            local part = plr.Character[targetPart]
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local d = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if d < dist then
                    dist = d
                    closest = plr
                end
            end
        end
    end
    return closest
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if silentAimEnabled and method == "FireServer" and self.Name:lower():find("shoot") or self.Name:lower():find("bullet") then
        local args = {...}
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(targetPart) then
            -- Modify hit position for silent aim (common pattern)
            if args[1] and typeof(args[1]) == "Vector3" then
                args[1] = target.Character[targetPart].Position
            end
        end
        return oldNamecall(self, unpack(args))
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

-- Triggerbot
local function triggerbotLoop()
    if not triggerbotEnabled then return end
    local target = getClosestPlayer()
    if target then
        Mouse1Click() -- or fireclickdetector if needed
        task.wait(triggerbotDelay)
    end
end

-- Enhanced ESP with Health
local function createESP(plr)
    if espDrawings[plr] then return end
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Filled = false
    box.Transparency = 1

    local healthBar = Drawing.new("Square")
    healthBar.Thickness = 1
    healthBar.Filled = true
    healthBar.Color = Color3.fromRGB(0, 255, 0)

    local nameTag = Drawing.new("Text")
    nameTag.Size = 16
    nameTag.Color = Color3.fromRGB(255, 255, 255)
    nameTag.Center = true
    nameTag.Outline = true

    espDrawings[plr] = {box = box, health = healthBar, name = nameTag}
end

local function updateESP()
    if not espEnabled then
        for _, v in pairs(espDrawings) do
            v.box.Visible = false
            v.health.Visible = false
            v.name.Visible = false
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then continue end
        if teamCheck and plr.Team == LocalPlayer.Team then continue end

        if not espDrawings[plr] then createESP(plr) end
        local drawings = espDrawings[plr]
        local root = plr.Character.HumanoidRootPart
        local humanoid = plr.Character:FindFirstChild("Humanoid")
        local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)

        if onScreen then
            local headPos = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
            local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))
            local height = math.abs(headPos.Y - legPos.Y)
            local width = height * 0.6

            drawings.box.Size = Vector2.new(width, height)
            drawings.box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
            drawings.box.Visible = true

            -- Health bar
            if humanoid then
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                drawings.health.Size = Vector2.new(4, height * healthPercent)
                drawings.health.Position = Vector2.new(rootPos.X - width/2 - 6, rootPos.Y - height/2 + (height * (1 - healthPercent)))
                drawings.health.Visible = true
            end

            drawings.name.Text = plr.Name .. " [" .. math.floor((LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart.Position - root.Position).Magnitude or 0) .. "m]"
            drawings.name.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 18)
            drawings.name.Visible = true
        else
            drawings.box.Visible = false
            drawings.health.Visible = false
            drawings.name.Visible = false
        end
    end
end

-- Button connections
btnAimbot.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    btnAimbot.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
    btnAimbot.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
    saveConfig()
end)

btnSilent.MouseButton1Click:Connect(function()
    silentAimEnabled = not silentAimEnabled
    btnSilent.Text = "Silent Aim: " .. (silentAimEnabled and "ON" or "OFF")
    btnSilent.BackgroundColor3 = silentAimEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
    saveConfig()
end)

btnTrigger.MouseButton1Click:Connect(function()
    triggerbotEnabled = not triggerbotEnabled
    btnTrigger.Text = "Triggerbot: " .. (triggerbotEnabled and "ON" or "OFF")
    btnTrigger.BackgroundColor3 = triggerbotEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
    saveConfig()
end)

btnESP.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    btnESP.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    btnESP.BackgroundColor3 = espEnabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
    saveConfig()
end)

btnTeam.MouseButton1Click:Connect(function()
    teamCheck = not teamCheck
    btnTeam.Text = "Team Check: " .. (teamCheck and "ON" or "OFF")
    btnTeam.BackgroundColor3 = teamCheck and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
    saveConfig()
end)

-- Main loops
table.insert(connections, RunService.RenderStepped:Connect(updateAimbot))
table.insert(connections, RunService.RenderStepped:Connect(updateESP))
table.insert(connections, RunService.Heartbeat:Connect(triggerbotLoop))

print("Advanced Cheat Loaded - All features active")
print("Press INSERT to toggle GUI")

-- Cleanup
game:BindToClose(function()
    saveConfig()
end)
