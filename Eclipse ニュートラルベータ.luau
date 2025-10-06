-- [v1] Build Ur Base 🏠
-- Rayfield UI 
-- By President 444 YT

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "[BETA] Build Ur Base 🏠",
    LoadingTitle = "[BETA] Build Ur Base",
    LoadingSubtitle = "By President 444 YT",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
})

-- Create Main tab
local Main = Window:CreateTab("Main")

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local runningZombies = false
local runningWeapons = false
local runningFast = false

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

local function TeleportToZombie(z)
    local char = GetChar()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local zPart = z:FindFirstChild("HumanoidRootPart") or z:FindFirstChildWhichIsA("BasePart")
    if not zPart then return end

    hrp.CFrame = zPart.CFrame + Vector3.new(0, 3, 0)
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
                            TeleportToZombie(Enemy)
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
        task.wait() -- tiny wait to prevent overload
    end
end

-- Fast Interval (even faster firing)
local function FastInterval()
    runningFast = true
    local args = { [1] = true }
    while runningFast do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.Events.ToolState:FireServer(unpack(args))
        end)
        -- no wait at all for maximum speed
    end
end

-- Toggle 1: Auto Attack Zombies
Main:CreateToggle({
    Name = "Auto Attacked (Melee) ✅",
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

-- Toggle 3: Fast Interval
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
