for _, v in pairs(game.CoreGui:GetChildren()) do
    if v.Name == "Library" then
        v:Destroy()
    end
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vep1032/VepStuff/main/Rgb%20Ui"))()

MAINTTL = "Floppa Hub"
local Window = Library:Window("Redwood Prison", Color3.fromRGB(196, 40, 28))
game:GetService("CoreGui").Library.MainFrame.LeftFrame.Circle.CircleName.Text = "F"

local playerTab = Window:Tab("Player")
local combatTab = Window:Tab("Combat")
local rageTab = Window:Tab("Rage")
local miscTab = Window:Tab("Misc")

local runService = game:GetService("RunService")
local players = game:GetService("Players")

local client = players.LocalPlayer
local playerChar = client.Character or client.Character:Wait()

local flags = {}
local oldStates = {}

local function populateOldStates()
    local module = require(game:GetService("ReplicatedStorage").ItemStats)
    for key, itemStats in pairs(module) do
        oldStates[key] = itemStats
    end
end

local function updateGcValues()
    for i, v in pairs(getgc(true)) do
        if type(v) == "function" then
            local b = debug.getupvalues(v)
            for i2, v2 in pairs(b) do
                if type(v2) == "table" and rawget(v2, "maxAmmo") then
                    local oldGunState = oldStates[v2.name]
                    if flags.infAmmo then
                        v2.curAmmo = math.huge
                        v2.maxAmmo = math.huge
                    else
                        v2.maxAmmo = oldGunState.maxAmmo
                        v2.curAmmo = 50
                    end
                    if flags.fastFireRate then
                        v2.coolDown = 0.000000000000001
                        print(v2.fireType)
                    else
                        v2.coolDown = oldGunState.coolDown
                    end

                    v2.fireType = flags.fireMode

                    if flags.noReloadTime then
                    else
                    end
                end
            end
        end
    end
end

local function kill(player)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
    workspace.resources.RemoteEvent:FireServer("becomeHostile")
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
    workspace.resources.RemoteEvent:FireServer("dealMeleeDamage", player.Character.Humanoid, 100)
end

local function killAll()
    local oldpos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    workspace.resources.RemoteFunction:InvokeServer("requestTeam", "police")
    for i, v in pairs(game:GetService("Players"):GetPlayers()) do
        if
            v ~= game.Players.LocalPlayer and v.Team ~= game.Players.LocalPlayer.Team and
                not v.Character:FindFirstChild("ForceField")
         then
            repeat
                wait()
                local start = tick()
                kill(v)
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            until v.Character.Humanoid.Health == 0 or tick() - start >= 6
        end
    end
    workspace.resources.RemoteFunction:InvokeServer("requestTeam", "prisoners")
    for i, v in pairs(game:GetService("Players"):GetPlayers()) do
        if
            v ~= game.Players.LocalPlayer and v.Team ~= game.Players.LocalPlayer.Team and
                not v.Character:FindFirstChild("ForceField")
         then
            repeat
                wait()
                local start = tick()
                kill(v)
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            until v.Character.Humanoid.Health == 0 or tick() - start >= 6
        end
    end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldpos
end

local function getGamePasses(s)
    local t = {
        "hasSwat",
        "hasSpecOps",
        "hasMerc",
        "hasPilot",
        "hasAtv"
    }

    for i, v in pairs(t) do
        workspace.resources.RemoteFunction:InvokeServer("setDataValue", v, s)
    end
end

populateOldStates()

function flags:SetFlag(flagName, value)
    flags[flagName] = value
end

local gunList = {
    "L86A2",
    "M16",
    "M98B",
    "UMP-45",
    "M60",
    "M1014",
    "AK47",
    "Hammer",
    "Fake ID Card",
    "SPAS-12",
    "S&W 638",
    "ACR",
    "Revolver",
    "M14",
    "Makarov",
    "AK47-U",
    "Parachute"
}

--#region Player Tab
do
    playerTab:Label("Player")
    playerTab:Slider(
        "Walkspeed",
        16,
        300,
        31,
        function(value)
            playerChar.Humanoid.WalkSpeed = value
        end
    )

    playerTab:Slider(
        "JumpPower",
        50,
        400,
        50,
        function(value)
            playerChar.Humanoid.JumpPower = value
        end
    )
    playerTab:Slider(
        "HipHeight",
        0,
        300,
        0,
        function(value)
            playerChar.Humanoid.HipHeight = value
        end
    )
    playerTab:Label("Teams")
    playerTab:Dropdown(
        "Change Team",
        {"Inmate", "Police", "Fugitive"},
        function(team)
            if team == "Inmate" then
                workspace.resources.RemoteFunction:InvokeServer("requestTeam", "prisoners")
            elseif team == "Police" then
                workspace.resources.RemoteFunction:InvokeServer("requestTeam", "police")
            elseif team == "Fugitive" then
                local oldPos = playerChar.HumanoidRootPart.CFrame
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                    CFrame.new(-600.429688, -24.2923031, -343.648865)
                wait()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
            end
        end
    )
end
--#endregion

--#region Combat Tab
do
    combatTab:Label("Givers")

    combatTab:Dropdown(
        "Get Item / Gun",
        gunList,
        function(value)
            getGamePasses(true)

            local function get(n)
                for i, v in pairs(workspace:GetChildren()) do
                    if v.Name == n and v:FindFirstChild("gunGiver") then
                        return v
                    end
                end
            end

            local old = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = get(value).CFrame
            wait(0.2)
            workspace.resources.RemoteFunction:InvokeServer("giveItemFromGunGiver", get(value))
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = old
        end
    )
    combatTab:Toggle(
        "Free Gamepasses",
        function(bool)
            getGamePasses(bool)
        end
    )
    combatTab:Label("Gun mods")
    combatTab:Toggle(
        "Infinite Ammo",
        function(bool)
            flags:SetFlag("infAmmo", bool)
            updateGcValues()
        end
    )
    combatTab:Toggle(
        "Fast Fire Rate",
        function(bool)
            flags:SetFlag("fastFireRate", bool)
            updateGcValues()
        end
    )
    combatTab:Toggle(
        "No Reload Time",
        function(bool)
            flags:SetFlag("noReloadTime", bool)
            updateGcValues()
        end
    )
    combatTab:Dropdown(
        "Fire Mode",
        {"shotgun", "automatic", "single"},
        function(value)
            flags:SetFlag("fireMode", value)
            updateGcValues()
        end
    )
end
--#endregion Combat tab

--#region Rage tab
rageTab:Button(
    "Kill All",
    function()
        killAll()
    end
)
--#endregion

runService.Heartbeat:Connect(
    function()
    end
)
