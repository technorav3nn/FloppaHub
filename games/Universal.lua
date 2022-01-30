-- // ESP Library and UI
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/PTrFUueU"))()

-- // UI Theme
Library.theme.accentcolor = Color3.new(0.003921, 0.470588, 1)
Library.theme.background = "rbxassetid://2151741365"
Library.theme.tilesize = 0.77
Library.theme.accentcolor2 = Color3.new(0.003921, 0.470588, 1)
Library.theme.backgroundcolor = Color3.fromRGB(20, 20, 20)

-- // Player Variables
local localPlayer = game.Players.LocalPlayer

-- // Initialize ESP
ESP.Players = false

ESP:Toggle(true)

-- // UI Components
local Window = Library:CreateWindow("Floppa Hub", Vector2.new(492, 598), Enum.KeyCode.RightShift)
do
    local visualsTab = Window:CreateTab("Visuals")
    do
        local espSec = visualsTab:CreateSector("ESP", "left")
        do
            espSec:AddToggle(
                "Player ESP",
                false,
                function(bool)
                    ESP.Players = bool
                end
            ):AddColorpicker(
                ESP.Color,
                function(color)
                    ESP.Color = color
                end
            )
            espSec:AddSeperator("ESP Options")
            espSec:AddToggle(
                "Tracers",
                false,
                function(bool)
                    ESP.Tracers = bool
                end
            )
            espSec:AddToggle(
                "Boxes",
                true,
                function(bool)
                    ESP.Boxes = bool
                end
            )
            espSec:AddToggle(
                "Names",
                true,
                function(bool)
                    ESP.Names = bool
                end
            )
        end
    end
end

-- // Remove gradient
if game:GetService("CoreGui")["Floppa Hub"].main.top:FindFirstChild("UIGradient") then
    game:GetService("CoreGui")["Floppa Hub"].main.top.UIGradient:Destroy()
end
game:GetService("CoreGui")["Floppa Hub"].main.top.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
