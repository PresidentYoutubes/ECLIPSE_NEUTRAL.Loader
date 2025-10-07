-- [V2] Build Ur Base 🏠
-- Rayfield UI 
-- By President 444 YT

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "[V2] Build Ur Base 🏠",
    LoadingTitle = "[V2] Build Ur Base",
    LoadingSubtitle = "By President 444 YT",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
})

-- Create Tabs
local Main = Window:CreateTab("Main")
local Event = Window:CreateTab("Event ✨")

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local runningZombies = false
local runningWeapons = false
local runningFast = false
local runningPinata = false

-- Helpers
local function GetChar()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetPlayerPlot()
    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return nil end

    for i = 1, 6 do
        local Plot = Plots:FindFirstChild(tostring(i))
        if Plot then
            for _, prop in ipairs({"Owner_UserId", "Owner_uid", "OwnerId", "OwnerUserId"}) do
                local val
                pcall(function()
                    val = Plot:FindFirstChild(prop) and Plot[prop].Value or Plot[prop]
                end)
                if tonumber(val) == LocalPlayer.UserId then
                    return Plot
                end
            end
            if Plot.GetAttribute then
                for k, v in pairs(Plot:GetAttributes()) do
                    if tostring(k):lower():find("owner") and tonumber(v) == LocalPlayer.UserId then
                        return Plot
                    end
                end
            end
        end
    end
    return nil
end

local function TeleportTo(target)
    local char = GetChar()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not target then return end
    local tPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
    if not tPart then return end
    hrp.CFrame = tPart.CFrame + Vector3.new(0, 3, 0)
end

-- Auto Attack Zombies
local function AutoAttackZombies()
    runningZombies = true
    while runningZombies do
        local Plot = GetPlayerPlot()
        if Plot then
            local Enemies = Plot:FindFirstChild("Enemies") or Plot:FindFirstChild("enimes")
            if Enemies then
                for _, Enemy in pairs(Enemies:GetChildren()) do
                    if not runningZombies then break end
                    if Enemy:IsA("Model") and Enemy:FindFirstChild("Humanoid") then
                        repeat
                            TeleportTo(Enemy)
                            task.wait(0.15)
                        until not runningZombies or not Enemy.Parent
                    end
                end
            end
        end
        task.wait(0.5)
    end
end

-- Auto Attack (Weapons)
local function AutoAttackWeapons()
    runningWeapons = true
    local args = { [1] = true }
    while runningWeapons do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Events.ToolState:FireServer(unpack(args))
        end)
        task.wait() -- small wait to prevent overload
    end
end

-- No Interval (ultra fast but safe)
local function FastInterval()
    runningFast = true
    local args = { [1] = true }
    while runningFast do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Events.ToolState:FireServer(unpack(args))
        end)
        task.wait(0.01) -- ultra fast (100x per second) but safe
    end
end

-- Auto Defeat Pinata Boss
local function AutoDefeatPinata()
    runningPinata = true
    while runningPinata do
        local enemies = workspace:FindFirstChild("Enemies")
        if enemies then
            local pinata = enemies:FindFirstChild("PinataGuy")
            if pinata then
                TeleportTo(pinata)
            end
        end
        task.wait(0.15)
    end
end

-- Toggle 1: Auto Attack (Melee)
Main:CreateToggle({
    Name = "Auto Attack (Melee) ✅",
    CurrentValue = false,
    Flag = "AutoAttackZombies",
    Callback = function(Value)
        if Value then
            task.spawn(AutoAttackZombies)
        else
            runningZombies = false
        end
    end
})

-- Toggle 2: Auto Attack (Weapons)
Main:CreateToggle({
    Name = "Auto Attack (Weapons) ✅",
    CurrentValue = false,
    Flag = "AutoAttackWeapons",
    Callback = function(Value)
        if Value then
            task.spawn(AutoAttackWeapons)
        else
            runningWeapons = false
            local args = { [1] = false }
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.Events.ToolState:FireServer(unpack(args))
            end)
        end
    end
})

-- Toggle 3: No Interval (Use with Auto Attack Melee)
Main:CreateToggle({
    Name = "No Interval (Use with Auto Attack Melee) ✅",
    CurrentValue = false,
    Flag = "FastInterval",
    Callback = function(Value)
        if Value then
            task.spawn(FastInterval)
        else
            runningFast = false
            local args = { [1] = false }
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.Events.ToolState:FireServer(unpack(args))
            end)
        end
    end
})

-- Event Tab Toggle: Auto Defeat Pinata Boss
Event:CreateToggle({
    Name = "Auto Defeat Pinata Boss ✅",
    CurrentValue = false,
    Flag = "AutoDefeatPinata",
    Callback = function(Value)
        if Value then
            task.spawn(AutoDefeatPinata)
        else
            runningPinata = false
        end
    end
})
