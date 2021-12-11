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

-- // Teleports Table
local teleports = {
    ["Core Enterance"] = CFrame.new(-325, 471, -162),
    ["Inside Core (Need Suit)"] = CFrame.new(-282, 369, -151),
    ["Admin Control"] = CFrame.new(-191, 731, -182),
    Fans = CFrame.new(-465, 707, -300),
    ["Cargo Train Spawn"] = CFrame.new(-667, 447, 84),
    ["Core Station"] = CFrame.new(-565, 449, -84),
    ["Computer Science Labs"] = CFrame.new(-515, 500, -232),
    ["PET Headquarters"] = CFrame.new(-112, 500, -340),
    ["Medical Headquarters"] = CFrame.new(-66, 500, -222),
    ["Main Facility Center"] = CFrame.new(-79, 471, 13),
    ["Backup Power Main"] = CFrame.new(63, 465, 14),
    ["Cargo Bay 1A"] = CFrame.new(180, 427, 204),
    ["Cargo Bay 1A Parking Lot"] = CFrame.new(270, 423, 396),
    ["Launch Silos"] = CFrame.new(736, 449, -324),
    ["Launch Control Room"] = CFrame.new(912, 449, -396),
    ["Escape Rockets"] = CFrame.new(848, 449, -476),
    ["Coolant Sector"] = CFrame.new(-53, 448, -735)
}

-- // TP Function
local function teleportLocalPlayer(cframe)
    playerChar.HumanoidRootPart.CFrame = cframe
end

-- // UI Components
local window = Library:CreateWindow("Floppa Hub - PCC")
local playerFolder = window:AddFolder("Player")

do
    playerFolder:AddSlider(
        {
            text = "WalkSpeed",
            min = 16,
            max = 400,
            default = 16,
            callback = function(v)
                playerChar.Humanoid.WalkSpeed = v
            end
        }
    )
    playerFolder:AddSlider(
        {
            text = "JumpPower",
            min = 50,
            max = 400,
            default = 50,
            callback = function(v)
                playerChar.Humanoid.JumpPower = v
            end
        }
    )
end
local teleportsFolder = window:AddFolder("Teleports")
do
    for name, tp in pairs(teleports) do
        teleportsFolder:AddButton(
            {
                text = name,
                callback = function()
                    teleportLocalPlayer(tp)
                end
            }
        )
    end
end

Library:Init()
