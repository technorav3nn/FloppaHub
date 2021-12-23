-- // Removing duplicate GUIS
for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v:FindFirstChild("MainFrameHolder") then
        v:Destroy()
    end
end

-- // Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- // Dependencies
local SolarisLib = loadstring(game:HttpGet("https://solarishub.dev/SolarisLib.lua"))()
local ESP =
    loadstring(
    game:HttpGet(
        "https://gist.githubusercontent.com/technorav3nn/e01810542055cefa57f8597388116b5e/raw/90c6e2e58483892f322ee6c30feb07fa9421ed3a/ESP.lua"
    )
)()

-- // Variables
local renderStepped = runService.RenderStepped
local heartBeat = runService.Heartbeat
local stepped = runService.Stepped

local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()
local sFlags = SolarisLib.Flags

-- // List of different rocks
local ores = {
    "Silver Node",
    "Gold Node",
    "Adurite Rock",
    "Copper Rock",
    "Stone Node",
    "Iron Rock"
}

local selectedColor = Color3.fromRGB(235, 57, 34)

-- // ESP Object Listeners
local oreEspOther =
    ESP:AddObjectListener(
    game:GetService("Workspace"),
    {
        Validator = function(obj)
            local isInOreTable = table.find(ores, obj.Name)
            return isInOreTable ~= nil and true
        end,
        Color = Color3.fromRGB(34, 111, 235),
        IsEnabled = "Ores"
    }
)

ESP:AddObjectListener(
    game:GetService("Workspace").Resources,
    {
        Validator = function(obj)
            local isInOreTable = table.find(ores, obj.Name)
            return isInOreTable ~= nil and true
        end,
        Color = Color3.fromRGB(34, 111, 235),
        IsEnabled = "Ores"
    }
)

-- // Initializing ESP
ESP.Players = false
ESP.Ores = false
ESP.Gods = false

ESP.Boxes = true
ESP.Names = true
ESP.Distance = true
ESP.Tracers = false

ESP:Toggle(true)

-- // UI
local win =
    SolarisLib:New(
    {
        Name = "Floppa Hub - Booga Booga Hybrid",
        FolderToSave = "floppaHubStuff"
    }
)

local visualsTab = win:Tab("Visuals")
do
    local listenersSec = visualsTab:Section("Listeners")
    do
        listenersSec:Toggle(
            "Player ESP",
            false,
            "plrESP",
            function(bool)
                ESP.Players = bool
            end
        )
        listenersSec:Toggle(
            "Ore ESP",
            false,
            "plrESP",
            function(bool)
                ESP.Ores = bool
            end
        )
    end
    local optionsSec = visualsTab:Section("ESP Options")
    do
        optionsSec:Toggle(
            "Boxes",
            true,
            "boxes",
            function(bool)
                ESP.Boxes = bool
            end
        )
        optionsSec:Toggle(
            "Tracers",
            false,
            "tracers",
            function(bool)
                ESP.Tracers = bool
            end
        )
        optionsSec:Toggle(
            "Names",
            true,
            "names",
            function(bool)
                ESP.Names = bool
            end
        )

        optionsSec:Colorpicker(
            "Player ESP Color",
            Color3.fromRGB(255, 170, 0),
            "espPlayerColor",
            function(color)
                ESP.Color = color
            end
        )
    end
end
