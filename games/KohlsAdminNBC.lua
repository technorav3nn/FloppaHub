local MaterialUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

-- // Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // Flag System
local flags = {}

-- // Component table
local components = {}

-- // Functions
local function sayMessage(msg)
    game.Players:Chat(msg)
end

local function tpPlayer(x, y, z)
    localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
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
        components["cmdText"] =
            trollingTab.TextField(
            {
                Text = "Command"
            }
        )

        trollingTab.Slider(
            {
                Text = "Interval",
                Min = 0,
                Max = 15,
                Def = 0,
                Callback = function(value)
                    flags.chatInterval = value
                end
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

local tpTab =
    Material.New(
    {
        Title = "Teleports"
    }
)
do
    tpTab.Button(
        {
            Text = "Tp to House",
            Callback = function()
                tpPlayer(
                    -41.0244217,
                    7.21364641,
                    50.0500374,
                    -0.999963284,
                    -6.5356403e-08,
                    0.00856808294,
                    -6.53975434e-08,
                    1,
                    -4.52153381e-09,
                    -0.00856808294,
                    -5.08169906e-09,
                    -0.999963284
                )
            end
        }
    )
end

runService.Heartbeat:Connect(
    function()
        if flags.spamRegen then
            if game:GetService("Workspace").Terrain["_Game"].Admin:FindFirstChild("Regen") then
                fireclickdetector(game:GetService("Workspace").Terrain["_Game"].Admin.Regen.ClickDetector, math.huge)
            end
        end
        if flags.commandSpam and task.wait(flags.chatInterval or 0) then
            sayMessage(components["cmdText"]:GetText())
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
