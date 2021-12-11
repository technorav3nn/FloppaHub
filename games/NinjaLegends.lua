if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- // Hook for walkspeed
local old
old =
    hookmetamethod(
    game,
    "__index",
    function(t, key, ...)
        if not checkcaller() and (key == "Walkspeed" or key == "JumpPower") then
            return
        end
        return old(t, key, ...)
    end
)

-- // UI Library Variables
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/technorav3nn/kavo-fixed/main/Main.lua"))()
local Window = Library.CreateLib("Floppa Hub - Ninja Legends", "Ocean")

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
local playerTab = Window:NewTab("Player")
do
    local playerSec = playerTab:NewSection("Player")
    do
        playerSec:NewButton(
            "Max Jumps",
            "Gets max jumps",
            function()
                game:GetService("Players").LocalPlayer.multiJumpCount.Value = 50
            end
        )
        playerSec:NewSlider(
            "Walkspeed",
            "Self explanitory",
            500,
            24,
            function(v)
                playerChar.Humanoid.WalkSpeed = v
            end
        )
        playerSec:NewSlider(
            "JumpPower",
            "Self explanitory",
            400,
            50,
            function(v)
                playerChar.Humanoid.JumpPower = v
            end
        )
    end
end

local farmingTab = Window:NewTab("Farming")
do
    local swingSection = farmingTab:NewSection("Swinging")
    do
        swingSection:NewToggle(
            "Auto Swing",
            "Auto swings",
            function(bool)
                for _, v in pairs(localPlayer.Backpack:GetChildren()) do
                    if v:FindFirstChild("attackTime") and v:FindFirstChild("ninjitsuGain") then
                        playerChar.Humanoid:EquipTool(v)
                    end
                end
                flags:SetFlag("autoSwing", bool)
                task.spawn(
                    function()
                        while flags.autoSwing and task.wait(0.1) do
                            local ohString1 = "swingKatana"
                            game:GetService("Players").LocalPlayer.ninjaEvent:FireServer(ohString1)
                        end
                    end
                )
            end
        )
        swingSection:NewToggle(
            "Auto Sell",
            "Automatically sells at the best sell part",
            function(bool)
                flags:SetFlag("autoSell", bool)
                task.spawn(
                    function()
                        while flags.autoSell and task.wait(0.2) do
                            local touchInterestParent =
                                game:GetService("Workspace").sellAreaCircles.sellAreaCircle16.circleInner
                            firetouchinterest(playerChar.HumanoidRootPart, touchInterestParent, 0)
                            task.wait()
                            firetouchinterest(playerChar.HumanoidRootPart, touchInterestParent, 1)
                        end
                    end
                )
            end
        )
    end
    local karmaSection = farmingTab:NewSection("Karma")
    do
        karmaSection:NewButton(
            "Get Light Karma",
            "Light karma",
            function()
                game:GetService("ReplicatedStorage").rEvents.checkChestRemote:InvokeServer("Light Karma Chest")
            end
        )
        karmaSection:NewButton(
            "Get Evil Karma",
            "Evil karma",
            function()
                game:GetService("ReplicatedStorage").rEvents.checkChestRemote:InvokeServer("Evil Karma Chest")
            end
        )
    end
    local hoopsSection = farmingTab:NewSection("Hoops")
    do
        hoopsSection:NewToggle(
            "Auto Hoops",
            "Automatically gets hoops",
            function(bool)
                flags:SetFlag("autoHoops", bool)
                local hoopsPath = game.Workspace.Hoops

                task.spawn(
                    function()
                        while flags.autoHoops and task.wait() do
                            for _, hoop in pairs(hoopsPath:GetChildren()) do
                                if hoop:FindFirstChild("touchPart") then
                                    firetouchinterest(playerChar.HumanoidRootPart, hoop.touchPart, 0)
                                    task.wait()
                                    firetouchinterest(playerChar.HumanoidRootPart, hoop.touchPart, 1)
                                end
                            end
                        end
                    end
                )
            end
        )
    end
end

-- // Event Listeners
runService.Heartbeat:Connect(
    function()
    end
)
