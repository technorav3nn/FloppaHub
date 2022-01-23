for _, v in ipairs(game.CoreGui:GetChildren()) do
    if v.Name == "Floppa Hub | Prison Life" then
        v:Destroy()
    end
end

local runService = game:GetService("RunService")

local player = game:GetService("Players").LocalPlayer
local playerChar = player.Character or player.Character:Wait()
local playerHuman = playerChar:FindFirstChild("Humanoid")

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxciaz/VenyxUI/main/Reuploaded"))()
local colors = loadstring(game:HttpGet("https://pastebin.com/raw/Y9mU1DWe", true))()

local colorKeys = {}
for k, _ in pairs(colors) do
    colorKeys[k] = k
end

local venyx = library.new("Floppa Hub | Prison Life", 5013109572)
-- themes
local themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),
    TextColor = Color3.fromRGB(255, 255, 255)
}

-- first page
-- local mainPage = venyx:addPage("Main", 5012544693)
local mainPage = venyx:addPage("Main", 5012544693)
local combatPage = venyx:addPage("Combat", 5012544693)
local ragePage = venyx:addPage("Rage", 5012544693)
local tpPage = venyx:addPage("Teleports", 5012544693)
local themePage = venyx:addPage("Theme", 5012544693)
local settingsPage = venyx:addPage("Settings", 5012544693)

local respawnToggle

local colorSec = themePage:addSection("Colors")

local flags = {
    enableRainbow = true
}

function flags:SetFlag(flagName, value)
    flags[flagName] = value
end

local function killPlayer(Player)
    pcall(
        function()
            if
                Player.Character:FindFirstChild("ForceField") or not workspace:FindFirstChild(Player.Name) or
                    not workspace:FindFirstChild(Player.Name):FindFirstChild("Head") or
                    Player == nil or
                    Player.Character.Parent ~= workspace
             then
                return
            end
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP)

            local Gun =
                game.Players.LocalPlayer.Character:FindFirstChild("Remington 870") or
                game.Players.LocalPlayer.Backpack:FindFirstChild("Remington 870")

            local FireEvent = {
                [1] = {
                    ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[Player.Name].Head
                },
                [2] = {
                    ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[Player.Name].Head
                },
                [3] = {
                    ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[Player.Name].Head
                },
                [4] = {
                    ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[Player.Name].Head
                },
                [5] = {
                    ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[Player.Name].Head
                },
                [6] = {
                    ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[Player.Name].Head
                },
                [7] = {
                    ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[Player.Name].Head
                },
                [8] = {
                    ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[Player.Name].Head
                }
            }

            game:GetService("ReplicatedStorage").ShootEvent:FireServer(FireEvent, Gun)
            Gun.Parent = game.Players.LocalPlayer.Character
        end
    )
end

local function arrestPlayer(player)
    pcall(
        function()
            local targetPlayer = player
            local val = 0

            repeat
                wait(0.1)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                    targetPlayer.Character.HumanoidRootPart.CFrame
                game.Workspace.Remote.arrest:InvokeServer(targetPlayer.Character.Head)
                val = val + 1
            until val == 25 and targetPlayer.Character:FindFirstChild("Head"):FindFirstChild("handcuffedGui")
        end
    )
end

local function tazePlayer(toTaze)
    local Guns = player.Backpack:FindFirstChild("Taser") or playerChar:FindFirstChild("Taser")

    local TaseEvent = {
        [1] = {
            ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
            ["Distance"] = 0,
            ["Cframe"] = CFrame.new(),
            ["Hit"] = workspace[toTaze.Name].Torso
        }
    }

    game:GetService("ReplicatedStorage").ShootEvent:FireServer(TaseEvent, Guns)
end

local playerSec = mainPage:addSection("Player")
do
    playerSec:addButton(
        "Fly [T]",
        function()
            local flying = true
            repeat
                wait()
            until game.Players.LocalPlayer and game.Players.LocalPlayer.Character and
                game.Players.LocalPlayer.Character:findFirstChild("Torso") and
                game.Players.LocalPlayer.Character:findFirstChild("Humanoid")
            local mouse = game.Players.LocalPlayer:GetMouse()
            repeat
                wait()
            until mouse
            local plr = game.Players.LocalPlayer
            local torso = plr.Character.Torso
            local deb = true
            local ctrl = {f = 0, b = 0, l = 0, r = 0}
            local lastctrl = {f = 0, b = 0, l = 0, r = 0}
            local maxspeed = 100
            local speed = flags["flySpeed"]

            local function Fly()
                local bg = Instance.new("BodyGyro", torso)
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = torso.CFrame
                local bv = Instance.new("BodyVelocity", torso)
                bv.velocity = Vector3.new(0, 0.1, 0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                repeat
                    wait()
                    plr.Character.Humanoid.PlatformStand = true
                    if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
                        speed = speed + .5 + (speed / maxspeed)
                        if speed > maxspeed then
                            speed = maxspeed
                        end
                    elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
                        speed = speed - 1
                        if speed < 0 then
                            speed = 0
                        end
                    end
                    if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                        bv.velocity =
                            ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) +
                            ((game.Workspace.CurrentCamera.CoordinateFrame *
                                CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * .2, 0).p) -
                                game.Workspace.CurrentCamera.CoordinateFrame.p)) *
                            speed
                        lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                    elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
                        bv.velocity =
                            ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f + lastctrl.b)) +
                            ((game.Workspace.CurrentCamera.CoordinateFrame *
                                CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * .2, 0).p) -
                                game.Workspace.CurrentCamera.CoordinateFrame.p)) *
                            speed
                    else
                        bv.velocity = Vector3.new(0, 0.1, 0)
                    end
                    bg.cframe =
                        game.Workspace.CurrentCamera.CoordinateFrame *
                        CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
                until not flying
                ctrl = {f = 0, b = 0, l = 0, r = 0}
                lastctrl = {f = 0, b = 0, l = 0, r = 0}
                speed = 0
                bg:Destroy()
                bv:Destroy()
                plr.Character.Humanoid.PlatformStand = false
            end
            mouse.KeyDown:connect(
                function(key)
                    if key:lower() == "t" then
                        if flying then
                            flying = false
                        else
                            flying = true
                            Fly()
                        end
                    elseif key:lower() == "w" then
                        ctrl.f = 1
                    elseif key:lower() == "s" then
                        ctrl.b = -1
                    elseif key:lower() == "a" then
                        ctrl.l = -1
                    elseif key:lower() == "d" then
                        ctrl.r = 1
                    end
                end
            )
            mouse.KeyUp:connect(
                function(key)
                    if key:lower() == "w" then
                        ctrl.f = 0
                    elseif key:lower() == "s" then
                        ctrl.b = 0
                    elseif key:lower() == "a" then
                        ctrl.l = 0
                    elseif key:lower() == "d" then
                        ctrl.r = 0
                    end
                end
            )
            Fly()
        end
    )
    playerSec:addSlider(
        "Fly Speed",
        1,
        1,
        100,
        function(value)
            flags["flySpeed"] = value
        end
    )
    playerSec:addSlider(
        "Walkspeed",
        16,
        16,
        600,
        function(value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    )
    playerSec:addSlider(
        "JumpPower",
        50,
        50,
        500,
        function(value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    )
    playerSec:addSlider(
        "Hipheight",
        0,
        0,
        300,
        function(value)
            game.Players.LocalPlayer.Character.Humanoid.HipHeight = value
        end
    )
    playerSec:addSlider(
        "Gravity",
        196,
        196,
        0,
        function(value)
            workspace.Gravity = value
        end
    )
    local respawnToggle
    respawnToggle =
        playerSec:addToggle(
        "Respawn where you died",
        false,
        function(bool)
            local deadPosition
            local function log()
                deadPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            end
            if bool then
                flags["respawnDied"] = true

                game.Players.LocalPlayer.Character.Humanoid.Died:Connect(log)
                game.Players.LocalPlayer.CharacterAdded:Connect(
                    function(char)
                        char:WaitForChild("Humanoid", 3).Died:Connect(log)
                        char:WaitForChild("HumanoidRootPart", 3).CFrame = deadPosition
                    end
                )
            else
                flags["respawnDied"] = false
            end
        end
    )
end

local oldDoors = {}

local mapSec = mainPage:addSection("Map")
do
    mapSec:addToggle(
        "No Doors",
        false,
        function(bool)
            if bool then
                for _, v in pairs(game.Workspace.Doors:GetChildren()) do
                    oldDoors[#oldDoors + 1] = v
                    v.Parent = nil
                end
            else
                for _, v in ipairs(oldDoors) do
                    local door = v
                    print(door.Name)
                    door.Parent = game.Workspace.Doors
                end
            end
        end
    )
end
local teamsSec = mainPage:addSection("Teams and Nametags")
do
    teamsSec:addDropdown(
        "Change Team",
        {"Criminal", "Neutral", "Guard", "Inmate"},
        function(v)
            if v == "Criminal" then
                local weld02 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-919.958, 95.327, 2138.189)
                wait(1)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(weld02)
            elseif v == "Inmate" then
                game.Workspace.Remote.TeamEvent:FireServer("Bright orange")
            elseif v == "Guard" then
                game.Workspace.Remote.TeamEvent:FireServer("Bright blue")
            elseif v == "Neutral" then
                game.Workspace.Remote.TeamEvent:FireServer("Medium stone grey")
            end
        end
    )
    teamsSec:addDropdown(
        "Change Nametag Color (FE)",
        colorKeys,
        function(value)
            if not flags["respawnDied"] then
                flags["respawnDied"] = true
                playerSec:updateToggle(respawnToggle, "Respawn where you died", true)
            end
            local oldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            local oldCamPos = game.Workspace.CurrentCamera.CFrame

            workspace.Remote.loadchar:InvokeServer(nil, BrickColor.new(value).Name)

            workspace.CurrentCamera.CFrame = oldCamPos
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldPos
            if flags["respawnDied"] then
                flags["respawnDied"] = false
                playerSec:updateToggle(respawnToggle, "Respawn where you died", false)
            end
        end
    )
end

local gunsSection = combatPage:addSection("Items")
do
    gunsSection:addDropdown(
        "Give Gun",
        {"Remington 870", "AK-47", "M9", "M4A1", "Riot Shield"},
        function(value)
            local giver = workspace.Prison_ITEMS.giver[value].ITEMPICKUP

            workspace.Remote.ItemHandler:InvokeServer(giver)
        end
    )

    gunsSection:addDropdown(
        "Wear Clothes",
        {"Police hat", "Riot helmet", "Ski mask", "Riot Clothes"},
        function(value)
            local newValue
            if value == "Riot Clothes" then
                newValue = "Riot Police"
            else
                newValue = value
            end
            local ohInstance1 = workspace.Prison_ITEMS.hats[newValue].hat
            workspace.Remote.ItemHandler:InvokeServer(ohInstance1)
        end
    )

    local droppedItemsValues = {}
    local droppedItems = {}

    local function populateItems()
        for _, v in pairs(game.Workspace.Prison_ITEMS.single:GetChildren()) do
            droppedItemsValues[v.Name] = v.Name
            droppedItems[v.Name] = v
        end
    end

    populateItems()

    local droppedItemsDropdown =
        gunsSection:addDropdown(
        "Get Dropped Items",
        droppedItemsValues,
        function(value)
            local ohInstance1 = workspace.Prison_ITEMS.single[value].ITEMPICKUP

            workspace.Remote.ItemHandler:InvokeServer(ohInstance1)
        end
    )
    game.Workspace.Prison_ITEMS.single.ChildAdded:Connect(
        function(child)
            droppedItemsValues[child.Name] = child.Name
            droppedItems[child.Name] = child
            gunsSection:updateDropdown(
                droppedItemsDropdown,
                "Get Dropped Items",
                droppedItemsValues,
                function(value)
                    local ohInstance1 = workspace.Prison_ITEMS.single[value].ITEMPICKUP

                    workspace.Remote.ItemHandler:InvokeServer(ohInstance1)
                end
            )
        end
    )
    game.Workspace.Prison_ITEMS.single.ChildRemoved:Connect(
        function(child)
            droppedItemsValues[child.Name] = nil
            droppedItems[child.Name] = nil
            gunsSection:updateDropdown(
                droppedItemsDropdown,
                "Get Dropped Items",
                droppedItemsValues,
                function(value)
                    local ohInstance1 = workspace.Prison_ITEMS.single[value].ITEMPICKUP

                    workspace.Remote.ItemHandler:InvokeServer(ohInstance1)
                end
            )
        end
    )
    local modules = {}
    local oldStates = {
        ["M9"] = {
            -- Decompiled with the Synapse X Luau decompiler.

            Damage = 10,
            Description = "Remember to put a description here BEFORE the game is published -Me",
            MaxAmmo = 15,
            CurrentAmmo = 15,
            StoredAmmo = 100,
            FireRate = 0.08,
            AutoFire = false,
            Range = 600,
            Spread = 11,
            ReloadTime = 2,
            Bullets = 1,
            ReloadAnim = "ReloadMagazine",
            ShootAnim = "ShootBullet",
            HoldAnim = "Hold",
            FireSoundId = "http://www.roblox.com/asset/?id=2934888024",
            SecondarySoundId = nil,
            ReloadSoundId = "http://www.roblox.com/asset/?id=2934887229"
        },
        ["Remington 870"] = {
            -- Decompiled with the Synapse X Luau decompiler.

            Damage = 15,
            Description = "Remember to put a description here BEFORE the game is published -Me",
            MaxAmmo = 6,
            CurrentAmmo = 6,
            StoredAmmo = 600,
            FireRate = 0.8,
            AutoFire = false,
            Range = 400,
            Spread = 3,
            ReloadTime = 4,
            Bullets = 5,
            ReloadAnim = "ReloadShells",
            ShootAnim = "ShootShell",
            HoldAnim = "Hold",
            FireSoundId = "http://www.roblox.com/asset/?id=2934889760",
            SecondarySoundId = "http://www.roblox.com/asset/?id=255061173",
            ReloadSoundId = "http://www.roblox.com/asset/?id=2934888952"
        },
        ["AK-47"] = {
            -- Decompiled with the Synapse X Luau decompiler.

            Damage = 11,
            Description = "Remember to put a description here BEFORE the game is published -Me",
            MaxAmmo = 30,
            CurrentAmmo = 30,
            StoredAmmo = 600,
            FireRate = 0.1,
            AutoFire = true,
            Range = 800,
            Spread = 14,
            ReloadTime = 2,
            Bullets = 1,
            ReloadAnim = "ReloadMagazine",
            ShootAnim = "ShootBullet",
            HoldAnim = "Hold",
            FireSoundId = "http://www.roblox.com/asset/?id=2934888736",
            SecondarySoundId = nil,
            ReloadSoundId = "http://www.roblox.com/asset/?id=2934887229"
        }
    }

    player.Backpack.ChildAdded:Connect(
        function(child)
            if child and child.GunStates then
                modules[child.Name] = require(child.GunStates)
            end
        end
    )
    playerChar.ChildAdded:Connect(
        function(child)
            if child and child.GunStates then
                modules[child.Name] = require(child.GunStates)
            end
        end
    )

    local gunModsSection = combatPage:addSection("Gun mods")
    do
        gunModsSection:addToggle(
            "Infinite Ammo",
            false,
            function(bool)
                if bool then
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        module.StoredAmmo = math.huge
                        module.MaxAmmo = math.huge
                        module.CurrentAmmo = math.huge
                    end
                else
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        local oldMod = oldStates[i]
                        module.StoredAmmo = oldMod.StoredAmmo
                        module.MaxAmmo = oldMod.MaxAmmo
                        module.CurrentAmmo = oldMod.CurrentAmmo
                    end
                end
            end
        )
        gunModsSection:addToggle(
            "Automatic",
            false,
            function(bool)
                if bool then
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        module.AutoFire = true
                    end
                else
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        local oldMod = oldStates[i]
                        module.AutoFire = oldMod.AutoFire
                    end
                end
            end
        )
        gunModsSection:addToggle(
            "Multiple Bullets",
            false,
            function(bool)
                if bool then
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        module.Bullets = 8
                    end
                else
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        local oldMod = oldStates[i]
                        module.Bullets = oldMod.Bullets
                    end
                end
            end
        )
        gunModsSection:addToggle(
            "Infinite Range",
            false,
            function(bool)
                if bool then
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        module.Range = math.huge
                    end
                else
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        local oldMod = oldStates[i]
                        module.Range = oldMod.Range
                    end
                end
            end
        )
        gunModsSection:addToggle(
            "Infinite Damage",
            false,
            function(bool)
                if bool then
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        module.Damage = math.huge
                    end
                else
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        local oldMod = oldStates[i]
                        module.Damage = oldMod.Damage
                    end
                end
            end
        )
        gunModsSection:addToggle(
            "Fast Fire Rate",
            false,
            function(bool)
                if bool then
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        module.FireRate = 0.00000000000000000000000000000000000000000000000000000000001
                    end
                else
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        local oldMod = oldStates[i]
                        module.FireRate = oldMod.FireRate
                    end
                end
            end
        )
        gunModsSection:addToggle(
            "No Reload Time",
            false,
            function(bool)
                if bool then
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        module.ReloadTime = 0
                    end
                else
                    for _, v in pairs(player.Backpack:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for _, v in pairs(playerChar:GetDescendants()) do
                        if v:IsA("ModuleScript") and v.Name == "GunStates" then
                            modules[v.Parent.Name] = require(v)
                        end
                    end
                    for i, module in pairs(modules) do
                        local oldMod = oldStates[i]
                        module.ReloadTime = oldMod.ReloadTime
                    end
                end
            end
        )
    end

    local snipersSection = combatPage:addSection("Item Snipers")
    do
        snipersSection:addToggle(
            "KeyCard Sniper",
            false,
            function(bool)
                flags:SetFlag("keyCardSniper", bool)
            end
        )
        snipersSection:addToggle(
            "M9 Sniper",
            false,
            function(bool)
                flags:SetFlag("m9Sniper", bool)
            end
        )
    end
end

local serverRageSec = ragePage:addSection("Server Rage")
do
    serverRageSec:addToggle(
        "Kill Aura",
        false,
        function(bool)
            flags:SetFlag("killAura", bool)
        end
    )
    serverRageSec:addButton(
        "Kill All",
        function()
            for i, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer or v ~= game.Players.LocalPlayer then
                    killPlayer(v)
                end
            end
        end
    )
end

local targeterRageSec = ragePage:addSection("Player Targeter")
do
    targeterRageSec:addTextbox(
        "Player Name",
        "Enter",
        function(value, focusLost)
            local function getPlayer(str)
                local Found = {}
                local strl = str:lower()
                for i, v in pairs(game.Players:GetPlayers()) do
                    if
                        (v.Name:lower():sub(1, #str) == str:lower()) or
                            (v.DisplayName:lower():sub(1, #str) == str:lower())
                     then
                        table.insert(Found, v.Name)
                    end
                end
                return Found[1]
            end

            if focusLost then
                local playerValue = getPlayer(value)
                if not playerValue then
                    venyx:Notify("Floppa Hub", string.format("Invalid Player: %s", value))
                else
                    flags:SetFlag("playerTarget", playerValue)
                end
            end
        end
    )
    targeterRageSec:addButton(
        "Teleport to",
        function()
            pcall(
                function()
                    local targetPlayer = game.Players[flags.playerTarget]
                    print(targetPlayer.Name)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        targetPlayer.Character.HumanoidRootPart.CFrame
                end
            )
        end
    )
    targeterRageSec:addButton(
        "Arrest",
        function()
            pcall(
                function()
                    local targetPlayer = game.Players[flags.playerTarget]
                    arrestPlayer(targetPlayer)
                end
            )
        end
    )
    targeterRageSec:addButton(
        "Kill",
        function()
            pcall(
                function()
                    local targetPlayer = game.Players[flags.playerTarget]
                    killPlayer(targetPlayer)
                    print("no")
                end
            )
        end
    )
    targeterRageSec:addButton(
        "Taze",
        function()
            pcall(
                function()
                    local targetPlayer = game.Players[flags.playerTarget]
                    tazePlayer(targetPlayer)
                end
            )
        end
    )
end

local tpSection = tpPage:addSection("Teleports")
do
    local teleports = {
        ["Criminal Base"] = CFrame.new(-943, 95, 2055),
        ["Nexus"] = CFrame.new(888, 100, 2388),
        ["Cafe"] = CFrame.new(877, 100, 2256),
        ["Yard"] = CFrame.new(791, 98, 2498),
        ["Armory"] = CFrame.new(789, 100, 2260),
        ["Gate"] = CFrame.new(505, 103, 2250),
        ["Gate Tower"] = CFrame.new(502, 126, 2306),
        ["Sewer"] = CFrame.new(916, 79, 2311)
    }

    local tpValues = {}

    for k, _ in pairs(teleports) do
        table.insert(tpValues, k)
    end

    tpSection:addDropdown(
        "Teleports",
        tpValues,
        function(value)
            local teleportCFrame = teleports[value]
            playerChar.HumanoidRootPart.CFrame = teleportCFrame
        end
    )
end

local settingsSec = settingsPage:addSection("Settings")
do
    settingsSec:addButton(
        "Destroy GUI",
        function()
            for _, v in ipairs(game.CoreGui:GetChildren()) do
                if v.Name == "Floppa Hub | Prison Life" then
                    v:Destroy()
                end
            end
        end
    )
end

local credsSec = settingsPage:addSection("Credits")
do
    credsSec:addButton("Creator - Death_Blows")
    credsSec:addButton("Help - Federal#9999")
end

for theme, color in pairs(themes) do
    colorSec:addColorPicker(
        theme,
        color,
        function(color3)
            venyx:setTheme(theme, color3)
        end
    )
end

venyx:SelectPage(venyx.pages[1], true)

local t = 10
local r = math.random() * t

runService.Heartbeat:Connect(
    function()
        if flags["keyCardSniper"] then
            if game:GetService("Workspace")["Prison_ITEMS"].single:FindFirstChild("Key card", true) then
                local ohInstance1 = workspace.Prison_ITEMS.single["Key card"].ITEMPICKUP

                workspace.Remote.ItemHandler:InvokeServer(ohInstance1)
            end
        end

        if flags["m9Sniper"] then
            if game:GetService("Workspace")["Prison_ITEMS"].single:FindFirstChild("M9", true) then
                local ohInstance1 = workspace.Prison_ITEMS.single["M9"].ITEMPICKUP

                workspace.Remote.ItemHandler:InvokeServer(ohInstance1)
            end
        end
        if flags["killAura"] then
            local meleeEvent = game:GetService("ReplicatedStorage").meleeEvent
            for _, plr in pairs(game:GetService("Players"):GetChildren()) do
                if plr.Name ~= game.Players.LocalPlayer.Name then
                    meleeEvent:FireServer(plr)
                end
            end
        end
    end
)
