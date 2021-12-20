-- // Remove Duplicate GUIS
for _, v in ipairs(game.CoreGui:GetChildren()) do
    if v.Name == "ScreenGui" then
        v:Destroy()
    end
end

-- // UI Library Depedency
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua"))()

-- // Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // UI Components
local window = library:CreateWindow("Floppa Hub")
do
    local mainFolder = window:AddFolder("Main")
    do
        mainFolder:AddToggle({text = "Spam Toilets Flush", flag = "spamFlush"})
        mainFolder:AddToggle({text = "Spam Toilets Seats", flag = "spamSeat"})
        mainFolder:AddToggle({text = "Spam Sinks", flag = "spamSinks"})
        mainFolder:AddToggle({text = "Spam Dryers", flag = "spamSinks"})
        mainFolder:AddToggle({text = "Spam All", flag = "spamAll"})
    end
end

-- // Heartbeat Listener
runService.Heartbeat:Connect(
    function()
        for _, v in pairs(game.Workspace:GetDescendants()) do
            if v:IsA("ClickDetector") then
                if v.Parent.Name == "Push" and library.flags.spamFlush then
                    fireclickdetector(v, math.huge)
                end
                if string.find(v.Parent.Name, "ToiletSeat") and library.flags.spamSeat then
                    fireclickdetector(v, math.huge)
                end
                if v.Parent.Name == "Faucet" and library.flags.spamSinks then
                    fireclickdetector(v, math.huge)
                end
                if v.Parent.Name == "Button" and v.Parent.Parent.Name == "Hand Dryer" and library.flags.spamDryer then
                    fireclickdetector(v, math.huge)
                end
                if library.flags.spamAll then
                    fireclickdetector(v, math.huge)
                end
            end
        end
    end
)

-- // Init Library
library:Init()
