--// Eclipse Neutral Loader
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Eclipse Neutral Loader | Build Ur Base",
    LoadingTitle = "Eclipse Neutral Loader",
    LoadingSubtitle = "By President 444 YT",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local LoaderTab = Window:CreateTab("Loader", 4483362458)

local SelectedMode = nil

local ModeDropdown = LoaderTab:CreateDropdown({
    Name = "Select Version",
    Options = {"Normal", "Beta"},
    CurrentOption = "",
    MultipleOptions = false,
    Flag = "ModeDropdown",
    Callback = function(Value)
        SelectedMode = Value
    end
})

LoaderTab:CreateButton({
    Name = "Load Eclipse Neutral",
    Callback = function()
        if SelectedMode == "Normal" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/PresidentYoutubes/ECLIPSE_NEUTRAL.Loader/refs/heads/main/%E6%97%A5%E9%A3%9F%E4%B8%AD%E7%AB%8B%E9%80%9A%E5%B8%B8.luau"))()
            game.StarterGui:SetCore("SendNotification", {
                Title = "Eclipse Neutral",
                Text = "Normal Loaded . . .",
                Duration = 5
            })
            task.wait(1)
            game.CoreGui:FindFirstChild("RayfieldMain"):Destroy()
            
        elseif SelectedMode == "Beta" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/PresidentYoutubes/ECLIPSE_NEUTRAL.Loader/refs/heads/main/Eclipse%20%E3%83%8B%E3%83%A5%E3%83%BC%E3%83%88%E3%83%A9%E3%83%AB%E3%83%99%E3%83%BC%E3%82%BF.luau"))()
            game.StarterGui:SetCore("SendNotification", {
                Title = "Eclipse Neutral Loader",
                Text = "Beta Version Loaded . . .",
                Duration = 5
            })
            task.wait(1)
            game.CoreGui:FindFirstChild("RayfieldMain"):Destroy()
        else
            game.StarterGui:SetCore("SendNotification", {
                Title = "Eclipse Neutral Loader",
                Text = "Please select a version first!",
                Duration = 5
            })
        end
    end
})
