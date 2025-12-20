local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local durability = LocalPlayer.Stats["2"]

-- Training areas
local Areas = {
    { Name = "BlackFire", Path = workspace.Map.TrainingAreas.BlackFire, Requirement = 100e6 },
    { Name = "Black Hole", Path = workspace.Map.TrainingAreas["Blackhole"], Requirement = 5e12 }, -- 5 trillion
    { Name = "Founder", Path = workspace.Map.TrainingAreas.Founder, Requirement = 250e12 }, -- 250 trillion
    { Name = "King Kais", Path = workspace.Map.TrainingAreas["King Kais"], Requirement = 1e9 },
    { Name = "Time Chamber", Path = workspace.Map.TrainingAreas["Time Chamber"], Requirement = 100e9 },
}

-- Get best unlocked area
local function GetBestArea()
    local current = durability.Value
    local best = nil

    for _, area in ipairs(Areas) do
        if current >= area.Requirement then
            if not best or area.Requirement > best.Requirement then
                best = area
            end
        end
    end

    return best
end

-- Teleport to model center
local function TeleportToModelCenter(model)
    local char = LocalPlayer.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    root.CFrame = model:GetPivot() + Vector3.new(0, 5, 0)
end

-- Autofarm loop
getgenv().AutoDura = false
local connection

function StartAutoFarm()
    if connection then return end
    getgenv().AutoDura = true

    connection = RunService.Heartbeat:Connect(function()
        if not getgenv().AutoDura then return end

        local best = GetBestArea()
        if best then
            TeleportToModelCenter(best.Path)
        end
    end)
end

function StopAutoFarm()
    getgenv().AutoDura = false
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- RAYFIELD UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Pro autofarm",
    LoadingTitle = "Pro autofarm",
    LoadingSubtitle = "Made by XestorIae",
})


local DuraTab = Window:CreateTab("Dura farm thing", 4483362458)

DuraTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(state)
        if state then
            StartAutoFarm()
        else
            StopAutoFarm()
        end
    end,
})

--[[


gap


]]

local DuraUpgradeTab = Window:CreateTab("Auto upgrade durability", 4483362458)

-- Rayfield Toggle
DuraUpgradeTab:CreateToggle({
    Name = "Upgrade durability loop",
    CurrentValue = false,
    Callback = function(state)
        getgenv().AutoUpgrade = state
    end,
})

-- Rayfield Slider
DuraUpgradeTab:CreateSlider({
    Name = "Upgrade Speed",
    Range = {0.2, 5},
    Increment = 0.2,
    Suffix = "s",
    CurrentValue = 0.1,
    Callback = function(value)
        getgenv().UpgradeSpeed = value
    end,
})

-- Pro globals!!
getgenv().AutoUpgrade = false
getgenv().UpgradeSpeed = 0.1 -- default speed

-- Button reference
local btn = game:GetService("Players").LocalPlayer.PlayerGui.Main.Frames.Stats.Container.Stats["2"].Upgrade

-- Loop
while true do
    if getgenv().AutoUpgrade then
        for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do
            conn:Fire()
        end
    end

    task.wait(getgenv().UpgradeSpeed)
end


--[[


gap


]]


-- Global toggle
getgenv().ClickSpam = false
getgenv().JumpSpam = false

local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

-- Spam loop
while true do
    if getgenv().ClickSpam then
        local pos = UIS:GetMouseLocation()

        -- Press
        VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
        -- Release
        VIM:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
    end

    task.wait()
end

-- Spam loop 2
while true do
    if getgenv().JumpSpam then
        -- Press
        VIM:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        -- Release
        VIM:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end

    task.wait()
end

local InputTab = Window:CreateTab("Auto inputs", 4483362458)

InputTab:CreateToggle({
    Name = "Click Spam",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().ClickSpam = Value
    end,
})

InputTab:CreateToggle({
    Name = "JumpSpam",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().JumpSPam = Value
    end,
})
