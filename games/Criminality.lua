-- // Dependencies
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua"))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- // Flags
local flags = {
    scrapsColor = Color3.fromRGB(209, 1, 209),
    toolsColor = Color3.fromRGB(87, 2, 246),
    dealersColor = Color3.fromRGB(0, 47, 255),
    robbablesColor = Color3.fromRGB(9, 216, 243),
    atmsColor = Color3.fromRGB(243, 17, 9)
}

-- // ESP Listeners

-- Scraps Listener
ESP:AddObjectListener(
    game:GetService("Workspace").Filter.SpawnedPiles,
    {
        Validator = function(obj)
            return obj:FindFirstChild("MeshPart") and obj:IsA("Model")
        end,
        ColorDynamic = function(obj)
            return flags.scrapsColor
        end,
        CustomName = "Scrap",
        IsEnabled = "Scraps"
    }
)

-- Tools Listener
ESP:AddObjectListener(
    game:GetService("Workspace").Filter.SpawnedTools,
    {
        Validator = function(obj)
            return obj:FindFirstChild("Handle") and obj:IsA("Model")
        end,
        ColorDynamic = function(obj)
            return flags.toolsColor
        end,
        CustomName = "Tool",
        IsEnabled = "Tools"
    }
)

-- Dealers Listener
ESP:AddObjectListener(
    game:GetService("Workspace").Map.Shopz,
    {
        Validator = function(obj)
            return obj:FindFirstChild("MainPart") and obj:IsA("Model")
        end,
        ColorDynamic = function(obj)
            return flags.dealersColor
        end,
        PrimaryPart = function(obj)
            return obj.MainPart
        end,
        CustomName = function(obj)
            return obj.Name
        end,
        IsEnabled = "Dealers"
    }
)

-- Robbables Listener
ESP:AddObjectListener(
    game:GetService("Workspace").Map.BredMakurz,
    {
        Validator = function(obj)
            return obj:FindFirstChild("MainPart") and obj:IsA("Model")
        end,
        ColorDynamic = function(obj)
            return flags.robbablesColor
        end,
        PrimaryPart = function(obj)
            return obj.MainPart
        end,
        CustomName = function(obj)
            ---@type string
            local name = obj.Name
            local splitName = name:split("_")
            local actualName = splitName[1]

            local isBroken = obj.Values.Broken.Value
            if isBroken then
                return string.format("Robbable %s (Broken)", actualName)
            else
                return string.format("Robbable %s (Can Be Robbed)", actualName)
            end
        end,
        IsEnabled = "Robbables"
    }
)

-- Atms Listener
ESP:AddObjectListener(
    game:GetService("Workspace").Map.ATMz,
    {
        Validator = function(obj)
            return obj:FindFirstChild("MainPart") and obj:IsA("Model")
        end,
        ColorDynamic = function(obj)
            return flags.atmsColor
        end,
        PrimaryPart = function(obj)
            return obj.MainPart
        end,
        CustomName = "ATM",
        IsEnabled = "Atms"
    }
)

-- // Initalize ESP
ESP.Players = false
ESP.Scraps = false
ESP.Atms = false
ESP.Robbables = false
ESP.Dealers = false
ESP.Tools = false

ESP:Toggle(true)

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
        mainFolder:AddToggle(
            {
                text = "Players ESP",
                flag = "playersESP",
                callback = function(bool)
                    ESP.Players = bool
                end
            }
        )
        mainFolder:AddToggle(
            {
                text = "Scraps ESP",
                flag = "scrapsEsp",
                callback = function(bool)
                    ESP.Scraps = bool
                end
            }
        )
        mainFolder:AddToggle(
            {
                text = "Tools ESP",
                flag = "toolsEsp",
                callback = function(bool)
                    ESP.Tools = bool
                end
            }
        )
        mainFolder:AddToggle(
            {
                text = "Dealer ESP",
                flag = "dealersESP",
                callback = function(bool)
                    ESP.Dealers = bool
                end
            }
        )
        mainFolder:AddToggle(
            {
                text = "Robbables ESP",
                flag = "robbablesESP",
                callback = function(bool)
                    ESP.Robbables = bool
                end
            }
        )
        mainFolder:AddToggle(
            {
                text = "ATM ESP",
                flag = "atmESP",
                callback = function(bool)
                    ESP.Atms = bool
                end
            }
        )
        mainFolder:AddDivider()
        mainFolder:AddToggle(
            {
                text = "Boxes",
                state = true,
                callback = function(bool)
                    ESP.Boxes = bool
                end
            }
        )
        mainFolder:AddToggle(
            {
                text = "Names",
                state = true,
                callback = function(bool)
                    ESP.Names = bool
                end
            }
        )
        mainFolder:AddToggle(
            {
                text = "Tracers",
                state = false,
                callback = function(bool)
                    ESP.Tracers = bool
                end
            }
        )
        mainFolder:AddDivider()
        mainFolder:AddColor(
            {
                text = "Player ESP Color",
                color = ESP.Color,
                callback = function(color)
                    ESP.Color = color
                end
            }
        )
        mainFolder:AddColor(
            {
                text = "Scraps ESP Color",
                color = flags.scrapsColor,
                callback = function(color)
                    flags.scrapsColor = color
                end
            }
        )
        mainFolder:AddColor(
            {
                text = "Tools ESP Color",
                color = flags.toolsColor,
                callback = function(color)
                    flags.toolsColor = color
                end
            }
        )
        mainFolder:AddColor(
            {
                text = "Dealer ESP Color",
                color = flags.dealersColor,
                callback = function(color)
                    flags.dealersColor = color
                end
            }
        )
        mainFolder:AddColor(
            {
                text = "Robbables ESP Color",
                color = flags.robbablesColor,
                callback = function(color)
                    flags.robbablesColor = color
                end
            }
        )
        mainFolder:AddColor(
            {
                text = "ATM ESP Color",
                color = flags.atmsColor,
                callback = function(color)
                    flags.atmsColor = color
                end
            }
        )
    end
    local infoFolder = window:AddFolder("Info")
    do
        infoFolder:AddLabel({text = "Re-execute if not working"})
        infoFolder:AddLabel({text = "Credit to Kiriot for the ESP!"})
    end
end

-- // Init Library
library:Init()
