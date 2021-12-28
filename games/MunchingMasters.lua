-- // Destroy excess GUIS
for _, v in ipairs(game.CoreGui:GetChildren()) do
    if v.Name == "ScreenGui" then
        v:Destroy()
    end
end

local Library =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua", true))()
local Maid =
    loadstring(
    game:HttpGet(
        "https://raw.githubusercontent.com/Quenty/NevermoreEngine/a8a2d2c1ffcf6288ec8d66f65cea593061ba2cf0/Modules/Shared/Events/Maid.lua"
    )
)()

-- // Services
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- // Variables
local maid = Maid.new()

local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // RunService Variables
local heartBeat = runService.Heartbeat

-- // Do Cleaning
local doCleaning = maid.DoCleaning

-- // UI
local mainWindow = Library:CreateWindow("Floppa Hub")
do
    local farmingFolder = mainWindow:AddFolder("Farming")
    do
        farmingFolder:AddToggle(
            {
                text = "Auto Eat",
                flag = "autoEat",
                callback = function(bool)
                    local tool = nil
                    if bool then
                        for _, v in ipairs(localPlayer.Backpack:GetChildren()) do
                            if v:IsA("Tool") and v:FindFirstChild("Eat") then
                                localPlayer.Character.Humanoid:EquipTool(v)
                                tool = v
                            end
                        end
                        if not tool then
                            for _, v in ipairs(localPlayer.Character:GetChildren()) do
                                if v:IsA("Tool") and v:FindFirstChild("Eat") then
                                    tool = v
                                end
                            end
                        end
                    end
                end
            }
        )
        farmingFolder:AddToggle({text = "Auto Sell", flag = "autoSell", callback = doCleaning})
    end
end

maid:DoCleaning()
maid:GiveTask(
    heartBeat:Connect(
        function()
            if Library.flags.autoEat then
                game:GetService("ReplicatedStorage").Events.Player.Eat:FireServer()
                task.wait(0.4)
            end
        end
    )
)
maid:GiveTask(
    heartBeat:Connect(
        function()
            if Library.flags.autoSell then
                firetouchinterest(localPlayer.Character.HumanoidRootPart, game:GetService("Workspace").SELL.Pad, 0)
                task.wait()
                firetouchinterest(localPlayer.Character.HumanoidRootPart, game:GetService("Workspace").SELL.Pad, 1)
            end
        end
    )
)

Library:Init()
