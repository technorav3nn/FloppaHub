local MaterialUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

-- // Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // Library Components
local cmdText = nil

-- // Flag System
local flags = {}

-- // Say Message Function
local function sayMessage(msg)
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(msg, "All")
end

local Material =
    MaterialUI.Load(
    {
        Title = "Floppa Hub",
        Style = 4,
        SizeX = 500,
        SizeY = 350,
        Theme = "Dark"
    }
)

local trollingTab =
    Material.New(
    {
        Title = "Trolling"
    }
)
do
    trollingTab.Label({Text = "Spammer"})
    do
        cmdText =
            trollingTab.TextField(
            {
                Text = "Command"
            }
        )
        trollingTab.Toggle(
            {
                Text = "Spam",
                Enabled = false,
                Callback = function(bool)
                    flags.commandSpam = bool
                end
            }
        )
    end
    trollingTab.Label({Text = "Admin"})
    do
        trollingTab.Toggle(
            {
                Text = "Spam Regen",
                Callback = function(bool)
                    flags.spamRegen = bool
                end,
                Enabled = false
            }
        )
        trollingTab.Toggle(
            {
                Text = "Loop Get Admin",
                Callback = function(bool)
                    flags.loopGetAdmin = bool
                end,
                Enabled = false
            }
        )
    end
end

runService.Heartbeat:Connect(
    function()
        if flags.spamRegen then
            if game:GetService("Workspace").Terrain["_Game"].Admin:FindFirstChild("Regen") then
                fireclickdetector(game:GetService("Workspace").Terrain["_Game"].Admin.Regen.ClickDetector, math.huge)
            end
        end
        if flags.commandSpam then
            sayMessage(cmdText:GetText())
            localPlayer.Chatted:Wait()
        end
        if flags.loopGetAdmin then
            if game:GetService("Workspace").Terrain["_Game"].Admin:FindFirstChild("Pads") then
                for _, v in pairs(game:GetService("Workspace").Terrain["_Game"].Admin.Pads:GetDescendants()) do
                    if v:IsA("TouchTransmitter") then
                        firetouchinterest(localPlayer.Character.HumanoidRootPart, v.Parent, 0)
                        task.wait()
                        firetouchinterest(localPlayer.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end
        end
    end
)
