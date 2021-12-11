-- // UI Library Variables
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/technorav3nn/kavo-fixed/main/Main.lua"))()
local Window = Library.CreateLib("Floppa Hub - Mortem Mettallum", "Ocean")

-- // Varaibles
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // Services
local runService = game:GetService("RunService")

-- // Flag System
local flags = {}
function flags:SetFlag(name, value)
    flags[name] = value
end

-- // UI Components
local mainTab = Window:NewTab("Main")
do
    local mainSec = mainTab:NewSection("Main")
    do
        mainSec:NewToggle(
            "No Roll Cooldown",
            "No Roll cooldown lol (dont spam or you'll die)",
            function(bool)
                flags:SetFlag("rollCool", bool)
                task.spawn(
                    function()
                        while flags.rollCool and task.wait(0.3) do
                            playerChar.IST.cooldown.Value = false
                        end
                    end
                )
            end
        )
        mainSec:NewToggle(
            "Infinite Stanima",
            "Infinite Stanima lol",
            function(bool)
                flags:SetFlag("infStamina", bool)
                task.spawn(
                    function()
                        while flags.infStamina and task.wait() do
                            playerChar.Runscript.Stamina.Value = 100
                        end
                    end
                )
            end
        )
        mainSec:NewToggle(
            "No Jump Cooldown",
            "No Jump Cooldown lol",
            function(bool)
                flags:SetFlag("noJumpCd", bool)
                local old = nil
                old =
                    hookfunction(
                    ---@diagnostic disable-next-line: deprecated
                    wait,
                    function(secs)
                        if secs == 1 and flags.noJumpCd then
                            return
                        end
                        return old(secs)
                    end
                )
            end
        )
        mainSec:NewToggle(
            "No Cooldown",
            "No cooldown for weapons",
            function(bool)
                flags:SetFlag("noCooldown", bool)
                local cooldown
                cooldown =
                    hookfunction(
                    ---@diagnostic disable-next-line: deprecated
                    delay,
                    function(time, callback)
                        if time > 0 and flags.noCooldown then
                            time = 0
                        end
                        return cooldown(time, callback)
                    end
                )
            end
        )
        mainSec:NewToggle(
            "Auto Get Crates",
            "Automatically gets crates",
            function(bool)
                flags:SetFlag("autoCrate", bool)
                task.spawn(
                    function()
                        while flags.autoCrate and task.wait(1) do
                            for _, v in pairs(game.Workspace.Explosions:GetDescendants()) do
                                if v.Name == "Click" then
                                    local prompt = v.ProximityPrompt
                                    local oldCf = playerChar.HumanoidRootPart.CFrame

                                    playerChar.HumanoidRootPart.CFrame = v.Model.Click.CFrame
                                    fireproximityprompt(prompt, math.huge)

                                    playerChar.HumanoidRootPart.CFrame = oldCf
                                end
                            end
                        end
                    end
                )
            end
        )
    end
end
