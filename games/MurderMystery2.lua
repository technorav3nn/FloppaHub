for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v:FindFirstChild("Main") then
        v:Destroy()
    end
end

-- // UI Configuration
local Config = {
    WindowName = "Floppa Hub - Murder Mystery 2",
    Color = Color3.fromRGB(111, 0, 238),
    Keybind = Enum.KeyCode.RightControl
}

-- // Anti AFK
game:GetService("Players").LocalPlayer.Idled:Connect(
    function()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
)

-- // Flag System
local flags = {
    rainbow = true
}

-- // MM2 Functions

local function getMurderer()
end

local function getSherrif()
end

function flags:SetFlag(name, value)
    flags[name] = value
end
-- // Services
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // UI Components
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/1201for/V.G-Hub/main/im-retarded-3"))()
local Window = Library:CreateWindow(Config, game:GetService("CoreGui"))

local playerTab = Window:CreateTab("Player")
do
    local movementSection = playerTab:CreateSection("Movement")
    do
        movementSection:CreateSlider(
            "WalkSpeed",
            16,
            200,
            16,
            true,
            function(value)
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
            end
        )
        movementSection:CreateSlider(
            "JumpPower",
            50,
            200,
            50,
            true,
            function(value)
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
            end
        )
        movementSection:CreateToggle(
            "Noclip",
            false,
            function(bool)
                flags.noClip = bool
            end
        )
    end
end

local gameTab = Window:CreateTab("Game")
do
    local rolesSection = gameTab:CreateSection("Roles")
    do
    end
end
local visualsTab = Window:CreateTab("Visuals")
do
end
local settingsTab = Window:CreateTab("Settings")
do
end

-- // Rainbow Config
local t = 10
local r = math.random() * t

-- // Event listeners
runService.Heartbeat:Connect(
    function()
        if flags.rainbow then
            local hue = (tick() + r) % t / t
            local color = Color3.fromHSV(hue, 1, 1)

            Window:ChangeColor(color)
        end
    end
)

runService.Stepped:Connect(
    function()
        if flags.noClip then
            game.Players.LocalPlayer.Character.UpperTorso.CanCollide = flags.noClip
            game.Players.LocalPlayer.Character.LowerTorso.CanCollide = flags.noClip
            game.Players.LocalPlayer.Character.Head.CanCollide = flags.noClip
            game.Players.LocalPlayer.Character.HumanoidRootPart.CanCollide = flags.noClip
        end
    end
)
