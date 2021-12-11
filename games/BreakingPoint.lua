-- // Libraries
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua"))()
local EspLibrary = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- // Silent Aim
loadstring(game:HttpGet("https://pastebin.com/1hWvNxNb"))()

-- // Destroy excess GUIS
for _, v in ipairs(game.CoreGui:GetChildren()) do
    if v.Name == "ScreenGui" then
        v:Destroy()
    end
end

-- // Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // UI Components
local window = Library:CreateWindow("Floppa Hub - BP")
local mainFolder = window:AddFolder("Main")
do
    mainFolder:AddToggle(
        {
            text = "Always Keep Light On",
            flag = "alwaysLight",
            callback = function()
                task.spawn(
                    function()
                        while Library.flags.alwaysLight and task.wait(0.2) do
                            game:GetService("Workspace").light.PointLight.Enabled = true
                        end
                    end
                )
            end
        }
    )
    mainFolder:AddToggle(
        {
            text = "Bright Light",
            callback = function(bool)
                if bool then
                    game:GetService("Workspace").light.PointLight.Brightness = math.huge
                else
                    game:GetService("Workspace").light.PointLight.Brightness = 8
                end
            end
        }
    )
    mainFolder:AddSlider(
        {
            text = "Light Range",
            min = 16,
            max = 60,
            callback = function(v)
                game:GetService("Workspace").light.PointLight.Range = v
            end
        }
    )
end

Library:Init()
