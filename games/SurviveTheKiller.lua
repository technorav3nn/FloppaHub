for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v:FindFirstChild("Main") then
        v:Destroy()
    end
end

-- // Dependencies
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/1201for/V.G-Hub/main/im-retarded-3"))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- // Flag System
local flags = {
    rainbow = false,
    lootColor = Color3.fromRGB(0, 255, 55)
}

-- // ESP Listeners
ESP:AddObjectListener(
    game:GetService("Workspace").CurrentMap.Loot,
    {
        Validator = function(obj)
            return obj:IsA("Model") and obj:FindFirstChild("Border")
        end,
        ColorDynamic = function()
            return flags.lootColor
        end,
        PrimaryPart = function(obj)
            return obj.PrimaryPart or obj.Border
        end,
        CustomName = "Loot",
        IsEnabled = "Loot",
        Temporary = true
    }
)

-- // Initalize ESP
ESP.Players = false
ESP.Loot = false

ESP:Toggle(true)

-- // UI Configuration
local Config = {
    WindowName = "Floppa Hub - Survive The Killer",
    Color = Color3.fromRGB(111, 0, 238),
    Keybind = Enum.KeyCode.RightControl
}

-- // Services
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // UI Components
local Window = Library:CreateWindow(Config, game:GetService("CoreGui"))

local playerTab = Window:CreateTab("Player")
do
    local movementSection = playerTab:CreateSection("Movement")
    do
        movementSection:CreateToggle(
            "Speed",
            nil,
            function(bool)
                flags.speedToggle = bool
                for _, v in pairs(getgc(true)) do
                    pcall(
                        function()
                            if type(v) == "table" and v.projectileSource then
                                v.projectileSource.walkSpeedMultiplier = flags.speedToggle and 1 or 0
                            end
                        end
                    )
                end
            end
        ):CreateKeybind(
            "X",
            function(Key)
            end
        )
    end
end

local visualsTab = Window:CreateTab("Visuals")
do
    local espsSec = visualsTab:CreateSection("ESPs")
    do
        espsSec:CreateToggle(
            "Loot ESP",
            false,
            function(bool)
                ESP.Loot = bool
            end
        )
    end
end

local settingsTab = Window:CreateTab("Settings")
do
    local uiSection = settingsTab:CreateSection("Background")
    do
        -- credits to jan for patterns
        local imageDrop = uiSection:CreateDropdown("Image")

        local defaultOpt =
            imageDrop:AddOption(
            "Default",
            function()
                Window:SetBackground("2151741365")
            end
        )

        imageDrop:AddOption(
            "Hearts",
            function()
                Window:SetBackground("6073763717")
            end
        )

        imageDrop:AddOption(
            "Abstract",
            function()
                Window:SetBackground("6073743871")
            end
        )
        imageDrop:AddOption(
            "Hexagon",
            function()
                Window:SetBackground("6073628839")
            end
        )
        imageDrop:AddOption(
            "Circles",
            function()
                Window:SetBackground("6071579801")
            end
        )
        imageDrop:AddOption(
            "Lace With Flowers",
            function()
                Window:SetBackground("6071575925")
            end
        )
        imageDrop:AddOption(
            "Floral",
            function()
                Window:SetBackground("5553946656")
            end
        )
        defaultOpt:SetOption()
        uiSection:CreateColorpicker(
            "Color",
            function(Color)
                Window:SetBackgroundColor(Color)
            end
        ):UpdateColor(Color3.new(1, 1, 1))

        uiSection:CreateSlider(
            "Transparency",
            0,
            1,
            nil,
            false,
            function(Value)
                Window:SetBackgroundTransparency(Value)
            end
        ):SetValue(0)

        uiSection:CreateSlider(
            "Tile Scale",
            0,
            1,
            nil,
            false,
            function(Value)
                Window:SetTileScale(Value)
            end
        ):SetValue(0.5)
    end
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

-- // Anti AFK
game:GetService("Players").LocalPlayer.Idled:Connect(
    function()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
)
