-- // Load Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Floppa Hub - Dead Winter", "BloodTheme")

-- // Module Path
local gunModules = game:GetService("ReplicatedStorage").Framework.Modules["1 | Directory"].Guns

-- // ESP Library
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- // Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- // Player Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // Flag System
local flags = {}

function flags:SetFlag(name, value)
    flags[name] = value
end

-- // Functions
local oldStates = {}

local function populateOldStates()
    for _, gun in pairs(getgc(true)) do
        if type(gun) == "table" and rawget(gun, "displayName") then
            oldStates[gun.displayName] = gun
        end
    end
end

populateOldStates()

local function doGunMods()
    task.spawn(
        function()
            for _, gun in pairs(getgc(true)) do
                if type(gun) == "table" and rawget(gun, "displayName") then
                    gun.automatic = flags.automaticGun
                    if flags.fastFireRate then
                        gun.shotrate = 0.00000000000000000000000000000000000000000000000000001
                    else
                        if
                            oldStates[gun.displayName].shotrate ==
                                0.00000000000000000000000000000000000000000000000000001
                         then
                            gun.shotrate = 0.1
                        end
                        gun.shotrate =
                            oldStates[gun.displayName].shotrate and oldStates[gun.displayName].shotrate or 0.1
                    end
                    if flags.fastVelocity then
                        gun.velocity = 750
                    else
                        if oldStates[gun.displayName].velocity == 750 then
                            gun.velocity = 250
                        else
                            gun.velocity =
                                oldStates[gun.displayName].velocity and oldStates[gun.displayName].velocity or 250
                        end
                    end
                    if flags.infDamage then
                        gun.damage = 300
                    else
                        if oldStates[gun.displayName].damage == 300 then
                            gun.damage = 100
                        else
                            gun.damage = oldStates[gun.displayName].damage and oldStates[gun.displayName].damage or 100
                        end
                    end
                    if flags.zoomValue then
                        gun.zoomAmount = flags.zoomValue
                    else
                        gun.zoomAmount = 1
                    end
                    if flags.additonalSpeedValue then
                        gun.additonalSpeed = flags.additonalSpeedValue
                    else
                        gun.additonalSpeed = 0
                    end
                end
            end
        end
    )
end

-- // Init Library
local combatTab = Window:NewTab("Combat")
do
    local gunModsSection = combatTab:NewSection("Gun Mods")
    do
        gunModsSection:NewToggle(
            "Automatic",
            "Makes The Guns Automatic",
            function(bool)
                flags["automaticGun"] = bool
                doGunMods()
            end
        )
        gunModsSection:NewToggle(
            "Fast Fire Rate",
            "Makes all guns have an extremely fast fire rate",
            function(bool)
                flags["fastFireRate"] = bool
            end
        )
        gunModsSection:NewToggle(
            "Fast Velocity",
            "Makes the guns velocity extremely fast (fast bullets)",
            function(bool)
                flags["fastVelocity"] = bool
            end
        )
        gunModsSection:NewToggle(
            "Infinite Damage",
            "Makes The Guns Damage Infinite",
            function(bool)
                flags["infDamage"] = bool
            end
        )
        gunModsSection:NewSlider(
            "Zoom",
            "The Zoom of all guns",
            50,
            1,
            function(value)
                flags.zoomValue = value
            end
        )
        gunModsSection:NewSlider(
            "Additonal Speed",
            "Additonal Speed to grant for all guns",
            100,
            0,
            function(value)
                flags.additonalSpeedValue = value
            end
        )
        gunModsSection:NewButton(
            "Apply Values",
            "Applies all slider values",
            function()
                doGunMods()
            end
        )
    end
    local visualsTab = Window:NewTab("Visuals")
    do
        local visualsMainSection = visualsTab:NewSection("Player ESP")
        do
            ESP.TeamColor = true
            ESP.Boxes = false
            ESP.Tracers = false
            ESP.Names = false

            visualsMainSection:NewToggle(
                "Toggle ESP",
                "Toggles ESP",
                function(bool)
                    spawn(
                        function()
                            ESP:Toggle(bool)
                        end
                    )
                end
            )
            visualsMainSection:NewToggle(
                "Toggle Names",
                "Toggles ESP",
                function(bool)
                    spawn(
                        function()
                            ESP.Names = bool
                        end
                    )
                end
            )
            visualsMainSection:NewToggle(
                "Toggle Tracers",
                "Toggles ESP",
                function(bool)
                    spawn(
                        function()
                            ESP.Tracers = bool
                        end
                    )
                end
            )
            visualsMainSection:NewToggle(
                "Toggle Boxes",
                "Toggles ESP",
                function(bool)
                    spawn(
                        function()
                            ESP.Boxes = bool
                        end
                    )
                end
            )
        end
    end
end
