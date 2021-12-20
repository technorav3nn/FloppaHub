-- // Loading Check
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- // Remove Duplicate Guis
for _, v in ipairs(game.CoreGui:GetChildren()) do
    if v.Name == "ScreenGui" then
        v:Destroy()
    end
end

-- // Dependencies
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua"))()

-- // Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

local flags = library.flags

-- // UI Components
local window = library:CreateWindow("Floppa Hub - SC")
do
    local farmingFolder = window:AddFolder("Farming")
    do
        farmingFolder:AddToggle({text = "Auto Pollen", flag = "autoPollen"})
        farmingFolder:AddToggle(
            {
                text = "Auto Make Honey",
                flag = "autoHoney",
                callback = function()
                    local args = {
                        [1] = "ToggleHoneyMaking"
                    }

                    game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer(unpack(args))
                end
            }
        )
    end
end

-- // Event Listeners
runService.Heartbeat:Connect(
    function()
        if flags.autoPollen then
            task.wait(1)
            game:GetService("Players").LocalPlayer.Character.Scooper.ClickEvent:FireServer()
        end
    end
)

library:Init()
