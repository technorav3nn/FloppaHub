-- // Libraries
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua"))()
local EspLibrary = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

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
local window = Library:CreateWindow("Floppa Hub - Doomspire")
local mainFolder = window:AddFolder("Main")
do
    mainFolder:AddToggle(
        {
            text = "No Rocket Cooldown",
            flag = "rocketCool",
            callback = function()
                local aux =
                    loadstring(
                    game:HttpGetAsync("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/ohaux.lua")
                )()

                local scriptPath = game:GetService("ReplicatedStorage").Shared.Data.WeaponConstants
                local closureName = "Unnamed function"
                local upvalueIndex = 3
                local closureConstants = {}

                local closure = aux.searchClosure(scriptPath, closureName, upvalueIndex, closureConstants)
                local value = Library.flags.rocketCool and 0.0001 or 4

                -- DO NOT RELY ON THIS FEATURE TO PRODUCE 100% FUNCTIONAL SCRIPTS
                debug.setupvalue(closure, upvalueIndex, value)
            end
        }
    )
    mainFolder:AddToggle(
        {
            text = "Infinite Lunges",
            flag = "infLunge",
            callback = function()
                local aux =
                    loadstring(
                    game:HttpGetAsync("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/ohaux.lua")
                )()

                local scriptPath = game:GetService("StarterPlayer").StarterPlayerScripts.ToolBehaviors.Sword
                local closureName = "lunge"
                local upvalueIndex = 2
                local closureConstants = {
                    [1] = "canAct",
                    [2] = false,
                    [3] = "tool",
                    [4] = "Sword",
                    [6] = "tick",
                    [8] = "lastSpin"
                }

                local closure = aux.searchClosure(scriptPath, closureName, upvalueIndex, closureConstants)
                local value
                if Library.flags.infLunge then
                    value = 0.000001
                else
                    value = 2.4
                end

                debug.setupvalue(closure, upvalueIndex, value)
            end
        }
    )
end

Library:Init()
