-- // Dependencies
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/PTrFUueU"))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- // UI Theme
Library.theme.accentcolor = Color3.new(0.011764, 0.521568, 1)
Library.theme.background = "rbxassetid://2151741365"
Library.theme.tilesize = 0.77

-- [[ INFO: Gun mods by Stefanuk12 and Viktor Reznov on v3rm! ]] --

-- // Initalize ESP
ESP.Players = false
ESP.TeamColor = true

ESP:Toggle(true)

-- // Configuration
local Configuration = {
    AReload = 0,
    RecoilControl = 0,
    EReload = 0,
    SReload = 0,
    ReloadTime = 0,
    EquipTime = 0,
    Spread = 10,
    MaxSpread = 10,
    Range = 1000,
    Auto = true,
    FireRate = 0.8,
    BFireRate = 0.8,
    UnlimitedAmmo = true
}

-- // Services
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local players = game:GetService("Players")

-- // Loop through every weapon
local function modifyWeapons()
    for _, weapon in ipairs(replicatedStorage.Weapons:GetChildren()) do
        -- // lol
        for _, config in ipairs(weapon:GetChildren()) do
            -- // Disable "Anti Cheat"
            for _, conn in ipairs(getconnections(config.Changed)) do
                conn:Disable()
            end

            -- // Set according to Configuration, making sure it exists
            local modConfig = Configuration[config.Name]
            if modConfig then
                config.Value = modConfig
            end
        end
    end
end

-- // Variables
local localPlayer = players.LocalPlayer

local PlayerGui = localPlayer.PlayerGui
local Variables = PlayerGui.GUI.Client.Variables

-- // UI Components
local Window = Library:CreateWindow("Floppa Hub", Vector2.new(492, 598), Enum.KeyCode.RightShift)
do
    local visualsTab = Window:CreateTab("Visuals")
    do
        local espSec = visualsTab:CreateSector("ESP", "left")
        do
            espSec:AddToggle(
                "Enabled",
                false,
                function(bool)
                    ESP.Players = bool
                end
            )
            espSec:AddToggle(
                "Team Color",
                true,
                function(bool)
                    ESP.TeamColor = bool
                end
            )
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
        local mainTab = Window:CreateTab("Arsenal")
        do
            local modsSec = mainTab:CreateSector("Gun Mods", "left")
            do
                modsSec:AddToggle(
                    "Infinite Ammo",
                    false,
                    function(bool)
                        Configuration.UnlimitedAmmo = bool
                        modifyWeapons()
                    end
                )
                modsSec:AddToggle(
                    "Always Automatic",
                    false,
                    function(bool)
                        Configuration.Auto = bool
                        modifyWeapons()
                    end
                )
                modsSec:AddToggle(
                    "Infinite Ammo",
                    false,
                    function(bool)
                        Configuration.UnlimitedAmmo = bool
                        modifyWeapons()
                    end
                )
                modsSec:AddToggle(
                    "Infinite Ammo",
                    false,
                    function(bool)
                        Configuration.UnlimitedAmmo = bool
                        modifyWeapons()
                    end
                )
                modsSec:AddToggle(
                    "Fast Equip",
                    false,
                    function(bool)
                        Configuration.EquipTime = 0
                        modifyWeapons()
                    end
                )
                modsSec:AddToggle(
                    "No Reload Time",
                    false,
                    function(bool)
                        Configuration.ReloadTime = 0
                        modifyWeapons()
                    end
                )
                modsSec:AddToggle(
                    "Fast Fire Rate",
                    false,
                    function(bool)
                        Configuration.FireRate = 0.000001
                        modifyWeapons()
                    end
                )
            end
        end
    end

    local settingsTab = Window:CreateTab("Settings")
    do
        if syn then
            settingsTab:CreateConfigSystem("left")
        else
            print("Your exploit doesnt support this.")
        end
    end
end

task.spawn(
    function()
        while task.wait() do
            -- // Make sure is enabled
            if Configuration.UnlimitedAmmo then
                -- // Set
                Variables.ammocount.Value = 300
                Variables.ammocount2.Value = 300
                Variables.primarystored.Value = 300
                Variables.secondarystored.Value = 300
            end
        end
    end
)
