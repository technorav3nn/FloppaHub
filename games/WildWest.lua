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
    oreColor = Color3.fromRGB(0, 217, 255),
    animalColor = Color3.fromRGB(217, 0, 255)
}

-- // ESP Listeners

-- Ore Listeners
ESP:AddObjectListener(
    game:GetService("Workspace")["WORKSPACE_Interactables"].Mining.OreDeposits.Coal,
    {
        Validator = function(obj)
            return obj:IsA("Model") and obj:FindFirstChild("CoalBase")
        end,
        ColorDynamic = function()
            return flags.oreColor
        end,
        PrimaryPart = function(obj)
            return obj.PrimaryPart or obj.CoalBase
        end,
        CustomName = "Coal Deposit",
        IsEnabled = "Coal"
    }
)

ESP:AddObjectListener(
    game:GetService("Workspace")["WORKSPACE_Interactables"].Mining.OreDeposits.Copper,
    {
        Validator = function(obj)
            return obj:IsA("Model")
        end,
        ColorDynamic = function()
            return flags.oreColor
        end,
        PrimaryPart = function(obj)
            return obj.PrimaryPart
        end,
        CustomName = "Copper Deposit",
        IsEnabled = "Copper"
    }
)

ESP:AddObjectListener(
    game:GetService("Workspace")["WORKSPACE_Interactables"].Mining.OreDeposits.Zinc,
    {
        Validator = function(obj)
            return obj:IsA("Model")
        end,
        ColorDynamic = function()
            return flags.oreColor
        end,
        PrimaryPart = function(obj)
            return obj.PrimaryPart
        end,
        CustomName = "Zinc Deposit",
        IsEnabled = "Zinc"
    }
)

ESP:AddObjectListener(
    game:GetService("Workspace")["WORKSPACE_Interactables"].Mining.OreDeposits.Iron,
    {
        Validator = function(obj)
            return obj:IsA("Model")
        end,
        ColorDynamic = function()
            return flags.oreColor
        end,
        PrimaryPart = function(obj)
            return obj.PrimaryPart
        end,
        CustomName = "Iron Deposit",
        IsEnabled = "Iron"
    }
)

ESP:AddObjectListener(
    game:GetService("Workspace")["WORKSPACE_Interactables"].Mining.OreDeposits.Silver,
    {
        Validator = function(obj)
            return obj:IsA("Model")
        end,
        ColorDynamic = function()
            return flags.oreColor
        end,
        PrimaryPart = function(obj)
            return obj.PrimaryPart
        end,
        CustomName = "Silver Deposit",
        IsEnabled = "Silver"
    }
)

ESP:AddObjectListener(
    game:GetService("Workspace")["WORKSPACE_Interactables"].Mining.OreDeposits.Gold,
    {
        Validator = function(obj)
            return obj:IsA("Model")
        end,
        ColorDynamic = function()
            return flags.oreColor
        end,
        PrimaryPart = function(obj)
            return obj.PrimaryPart
        end,
        CustomName = "Gold Deposit",
        IsEnabled = "Gold"
    }
)

ESP:AddObjectListener(
    game:GetService("Workspace")["WORKSPACE_Interactables"].Mining.OreDeposits.Limestone,
    {
        Validator = function(obj)
            return obj:IsA("Model")
        end,
        ColorDynamic = function()
            return flags.oreColor
        end,
        PrimaryPart = function(obj)
            return obj.PrimaryPart
        end,
        CustomName = "Limestone Deposit",
        IsEnabled = "Limestone"
    }
)

-- Animal ESP
ESP:AddObjectListener(
    game:GetService("Workspace")["WORKSPACE_Entities"].Animals,
    {
        Validator = function(obj)
            return obj:IsA("Model") and obj.PrimaryPart ~= nil and not (obj.Health.Value <= 0)
        end,
        ColorDynamic = function()
            return flags.animalColor
        end,
        PrimaryPart = function(obj)
            return obj.PrimaryPart
        end,
        CustomName = function(obj)
            return obj.Name
        end,
        IsEnabled = "Animals"
    }
)

-- //

-- // Initalize ESP
ESP.Players = false

ESP:Toggle(true)

-- // UI Configuration
local Config = {
    WindowName = "Floppa Hub",
    Color = Color3.fromRGB(111, 0, 238),
    Keybind = Enum.KeyCode.RightControl
}

-- // Services
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // Modules
local animalMod = require(game.ReplicatedStorage.Modules.Load)("Animal")

-- // UI Components
local Window = Library:CreateWindow(Config, game:GetService("CoreGui"))

local mainTab = Window:CreateTab("Wild West")
do
    local oreESPSec = mainTab:CreateSection("Ore ESPs")
    do
        oreESPSec:CreateToggle(
            "Coal ESP",
            false,
            function(bool)
                ESP.Coal = bool
            end
        )
        oreESPSec:CreateToggle(
            "Copper ESP",
            false,
            function(bool)
                ESP.Copper = bool
            end
        )
        oreESPSec:CreateToggle(
            "Zinc ESP",
            false,
            function(bool)
                ESP.Zinc = bool
            end
        )
        oreESPSec:CreateToggle(
            "Iron ESP",
            false,
            function(bool)
                ESP.Iron = bool
            end
        )
        oreESPSec:CreateToggle(
            "Silver ESP",
            false,
            function(bool)
                ESP.Silver = bool
            end
        )
        oreESPSec:CreateToggle(
            "Gold ESP",
            false,
            function(bool)
                ESP.Gold = bool
            end
        )
        oreESPSec:CreateToggle(
            "Limestone ESP",
            false,
            function(bool)
                ESP.Limestone = bool
            end
        )
        oreESPSec:CreateColorpicker(
            "Ore ESP Color",
            function(color)
                flags.oreColor = color
            end
        ):UpdateColor(flags.oreColor)
    end
    local animalESPSec = mainTab:CreateSection("Animal ESP")
    do
        animalESPSec:CreateToggle(
            "Animals ESP",
            false,
            function(bool)
                ESP.Animals = bool
            end
        )
        animalESPSec:CreateColorpicker(
            "Animals ESP Color",
            function(color)
                flags.animalColor = color
            end
        ):UpdateColor(flags.animalColor)
    end
    local playerESPSec = mainTab:CreateSection("Player ESP")
    do
        playerESPSec:CreateToggle(
            "Player ESP",
            false,
            function(bool)
                ESP.Players = bool
            end
        )
    end
    local miscSection = mainTab:CreateSection("Misc Cheats")
    do
        miscSection:CreateToggle(
            "Infinite Boosts",
            false,
            function(bool)
                flags.infBoosts = bool
                local oldAnimalBoost
                oldAnimalBoost =
                    hookfunction(
                    animalMod.Boost,
                    function(self)
                        oldAnimalBoost(self)
                        if flags.infBoosts then
                            self.Boosts = self.MaxBoosts
                        end
                    end
                )
            end
        )
        miscSection:CreateToggle(
            "Anti Horse Ragdoll",
            false,
            function(bool)
                flags.noHorseRag = bool
                local oldAnimalRagdoll
                oldAnimalRagdoll =
                    hookfunction(
                    animalMod.Ragdoll,
                    function(self, ...)
                        if flags.noHorseRag then
                            return nil
                        end
                        return oldAnimalRagdoll(self, ...)
                    end
                )
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
        uiSection:CreateToggle(
            "Rainbow UI",
            nil,
            function(bool)
                flags.rainbow = bool
            end
        )
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
    end
)

-- // Anti AFK
game:GetService("Players").LocalPlayer.Idled:Connect(
    function()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
)
