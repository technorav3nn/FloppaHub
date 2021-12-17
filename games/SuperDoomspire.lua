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
local window = Library:CreateWindow("Floppa Hub - SD")
local mainFolder = window:AddFolder("Main")

do
    mainFolder:AddToggle(
        {
            text = "No Rocket Cooldown",
            flag = "rocketCool",
            callback = function()
                local m = require(game:GetService("ReplicatedStorage").Shared.Data.WeaponConstants)
                for k, v in pairs(m) do
                    if string.find(k, "RELOAD_TIME") and type(v) == "function" then
                        print "Ass"
                        local upval = debug.getupvalues(v)
                        for a, val in pairs(upval) do
                            print(a, val)
                            debug.setupvalue(v, 3, Library.flags.rocketCool and 0.00001 or 6)
                        end
                    end
                end
            end
        }
    )
    mainFolder:AddToggle(
        {
            text = "Super Lunge",
            flag = "superLunge",
            callback = function()
                local m = require(game:GetService("StarterPlayer").StarterPlayerScripts.ToolBehaviors.Sword)
                local upval = debug.getupvalues(m.lunge)

                for valIdx, val in pairs(upval) do
                    print("INDEX: ", valIdx, "| VALUE: ", val)
                end

                debug.setupvalue(m.lunge, 2, Library.flags.superLunge and 0.00001 or 2)
            end
        }
    )
end

Library:Init()
