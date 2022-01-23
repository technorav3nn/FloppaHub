-- // Fixing protect_gui and removing old GUIS
setreadonly(syn, false)
syn.protect_gui = function(gui)
    gui.Parent = game.CoreGui
end

for _, v in ipairs(game.CoreGui:GetChildren()) do
    if v.Name == "ScreenGui" then
        v:Destroy()
    end
end

-- // Dependencies
local Library =
    loadstring(
    game:HttpGet(
        "https://gist.githubusercontent.com/technorav3nn/034cb2d38524ce2c3da8cda7a936b1ee/raw/b80dfd387ac352a8d68b5db41a3252e977d52fb5/linoria-lib-fix"
    )
)()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- // Services
local runService = game:GetService("RunService")
local marketPlaceService = game:GetService("MarketplaceService")

local players = game:GetService("Players")

-- // RunService Variables
local renderStepped = runService.RenderStepped
local heartBeat = runService.Heartbeat
local stepped = runService.Stepped

-- // Player Variables
local localPlayer = players.LocalPlayer

-- // UI Library Variables
local flags = getgenv().Toggles
local options = getgenv().Options

-- // Targeting Functions / Rage Functions
local function tazePlayer(player)
    if
        player.TeamColor.Name == "Bright blue" or not workspace:FindFirstChild(player.Name) or
            not workspace:FindFirstChild(player.Name):FindFirstChild("Head") or
            player == nil or
            player.Character.Parent ~= workspace
     then
        return
    end
    pcall(
        function()
            local oldCf = localPlayer.Character.HumanoidRootPart.CFrame
            local oldLocalTeam = nil

            local didChangeTeam = false

            local tazer =
                game.Players.LocalPlayer.Backpack:FindFirstChild("Taser") or
                game.Players.LocalPlayer.Character:FindFirstChild("Taser")

            if game.Players.LocalPlayer.TeamColor.Name ~= "Bright blue" or not tazer then
                oldLocalTeam = localPlayer.Team.TeamColor.Name
                workspace.Remote.loadchar:InvokeServer(nil, BrickColor.new("Bright blue").Name)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCf
                didChangeTeam = true
            end

            local tazer =
                game.Players.LocalPlayer.Backpack:FindFirstChild("Taser") or
                game.Players.LocalPlayer.Character:FindFirstChild("Taser")

            local eventArgs = {
                [1] = {
                    ["RayObject"] = Ray.new(Vector3.new(), Vector3.new()),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[player.Name].Torso
                }
            }

            game:GetService("ReplicatedStorage").ShootEvent:FireServer(eventArgs, tazer)
            if didChangeTeam then
                workspace.Remote.loadchar:InvokeServer(nil, BrickColor.new(oldLocalTeam).Name)
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCf
            end
        end
    )
end

local function killPlayer(player)
    pcall(
        function()
            if
                player.Character:FindFirstChild("ForceField") or not workspace:FindFirstChild(player.Name) or
                    not workspace:FindFirstChild(player.Name):FindFirstChild("Head") or
                    not player or
                    player.Character.Parent ~= workspace
             then
                return
            end
            workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP)

            local oldCf = localPlayer.Character.HumanoidRootPart.CFrame

            if player.TeamColor.Name == localPlayer.TeamColor.Name then
                local oldCameraCf = workspace.CurrentCamera.CFrame
                oldCf = localPlayer.Character.HumanoidRootPart.CFrame

                workspace.Remote.loadchar:InvokeServer(nil, BrickColor.random().Name)

                localPlayer.Character.HumanoidRootPart.CFrame = oldCf
                workspace.CurrentCamera.CFrame = oldCameraCf
                workspace.Remote.ItemHandler:InvokeServer(workspace.Prison_ITEMS.giver["Remington 870"].ITEMPICKUP)
            end

            local gun =
                game.Players.LocalPlayer.Character:FindFirstChild("Remington 870") or
                game.Players.LocalPlayer.Backpack:FindFirstChild("Remington 870")

            local eventArgs = {
                [1] = {
                    ["RayObject"] = Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[player.Name].Head
                },
                [2] = {
                    ["RayObject"] = Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[player.Name].Head
                },
                [3] = {
                    ["RayObject"] = Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[player.Name].Head
                },
                [4] = {
                    ["RayObject"] = Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[player.Name].Head
                },
                [5] = {
                    ["RayObject"] = Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[player.Name].Head
                },
                [6] = {
                    ["RayObject"] = Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[player.Name].Head
                },
                [7] = {
                    ["RayObject"] = Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[player.Name].Head
                },
                [8] = {
                    ["RayObject"] = Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0)),
                    ["Distance"] = 0,
                    ["Cframe"] = CFrame.new(),
                    ["Hit"] = workspace[player.Name].Head
                }
            }

            game:GetService("ReplicatedStorage").ShootEvent:FireServer(eventArgs, gun)
            gun.Parent = localPlayer.Character
            gun:Destroy()
        end
    )
end

-- // Other Table Variables
local funcs = {}
local connections = {}
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

localPlayer.Backpack.ChildAdded:Connect(
    function(child)
        if child and child.GunStates then
            modules[child.Name] = require(child.GunStates)
        end
    end
)
localPlayer.Character.ChildAdded:Connect(
    function(child)
        if child and child.GunStates then
            modules[child.Name] = require(child.GunStates)
        end
    end
)

-- // Other Variables
local clientInputEnv = getsenv(game.Players.LocalPlayer.Character.ClientInputHandler)
local userOwnsSwatGamepass = marketPlaceService:UserOwnsGamePassAsync(localPlayer.UserId, 96651)

-- // Watermark and Notification
Library:SetWatermark("Floppa Hub")
Library:Notify("Loading UI...")

-- // ESP Functions
-- /// Not done

-- // Initialize ESP
ESP.Players = false

ESP:Toggle(true)

-- // GC
for _, v in pairs(getgc()) do
    if type(v) == "function" and getfenv(v).script == localPlayer.Character.ClientInputHandler then
        if debug.getinfo(v).name == "fight" then
            funcs.doPunch = v
        end
        for _, v2 in pairs(getconstants(v)) do
            if type(v2) == "string" and string.find(v2, "You don't have enough") then
                funcs.staminaFunc = v
            end
        end
        if debug.getinfo(v).name == "taze" then
            funcs.taze = v
        end
        break
    end
end

-- // Silent Aim

-- // Remove annoying messagebox (I credited you dw)
hookfunction(
    messagebox,
    function()
    end
)

-- // Load Aiming Module
-- // Load Aiming Module
local Aiming = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/Aiming/main/Load.lua"))()()
Aiming.Settings.Enabled = false

-- // Services

-- // Vars
local AimingSelected = Aiming.Selected
local AimingChecks = Aiming.Checks

-- // Configure this
local CallingScripts = {
    "GunInterface"
}

-- // Hook
local __namecall
__namecall =
    hookmetamethod(
    game,
    "__namecall",
    function(...)
        -- // Vars
        local args = {...}
        local self = args[1]
        local method = getnamecallmethod()
        local callingscript = getcallingscript()

        -- // Checks
        if
            (not checkcaller() and method == "FindPartOnRay" and table.find(CallingScripts, callingscript.Name) and
                AimingChecks.IsAvailable())
         then
            -- // Vars
            local Origin = args[2].Origin
            local Destination = AimingSelected.Part.Position
            local Direction = (Destination - Origin).Unit * 1000

            -- // Set ray
            args[2] = Ray.new(Origin, Direction)

            -- // Return modified arguments
            return __namecall(unpack(args))
        end

        -- // Return
        return __namecall(...)
    end
)
-- // debug.setupvalue(func, 5, math.huge)

-- // Functions
local function modGun(bool, values)
    pcall(
        function()
            if bool then
                for _, v in pairs(localPlayer.Backpack:GetDescendants()) do
                    if v:IsA("ModuleScript") and v.Name == "GunStates" then
                        modules[v.Parent.Name] = require(v)
                    end
                end
                for _, v in pairs(localPlayer.Character:GetDescendants()) do
                    if v:IsA("ModuleScript") and v.Name == "GunStates" then
                        modules[v.Parent.Name] = require(v)
                    end
                end
                for _, module in pairs(modules) do
                    for key, value in pairs(values) do
                        module[key] = value
                    end
                end
            else
                for _, v in pairs(localPlayer.Backpack:GetDescendants()) do
                    if v:IsA("ModuleScript") and v.Name == "GunStates" then
                        modules[v.Parent.Name] = require(v)
                    end
                end
                for _, v in pairs(localPlayer.Character:GetDescendants()) do
                    if v:IsA("ModuleScript") and v.Name == "GunStates" then
                        modules[v.Parent.Name] = require(v)
                    end
                end
                for i, module in pairs(modules) do
                    local oldMod = oldStates[i]
                    print(oldMod["MaxAmmo"])
                    for key, _ in pairs(values) do
                        module[key] = oldMod[key]
                    end
                end
            end
        end
    )
end

--#region
local function updateTheme()
    Library.BackgroundColor = options.BackgroundColor.Value
    Library.MainColor = options.MainColor.Value
    Library.AccentColor = options.AccentColor.Value
    Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor)
    Library.OutlineColor = options.OutlineColor.Value
    Library.FontColor = options.FontColor.Value

    Library:UpdateColorsUsingRegistry()
end

local function setDefault()
    options.FontColor:SetValueRGB(Color3.fromRGB(255, 255, 255))
    options.MainColor:SetValueRGB(Color3.fromRGB(28, 28, 28))
    options.BackgroundColor:SetValueRGB(Color3.fromRGB(20, 20, 20))
    options.AccentColor:SetValueRGB(Color3.fromRGB(0, 85, 255))
    options.OutlineColor:SetValueRGB(Color3.fromRGB(50, 50, 50))
    flags.Rainbow:SetValue(false)

    updateTheme()
end
--#endregion

local Window = Library:CreateWindow("Floppa Hub")
do
    local playerTab = Window:AddTab("Player")
    do
        local characterSec = playerTab:AddLeftTabbox():AddTab("Character")
        do
            characterSec:AddSlider(
                "plrWalkspeed",
                {Text = "Walkspeed", Default = 16, Min = 16, Max = 500, Rounding = 1}
            ):OnChanged(
                function()
                    if localPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
                        localPlayer.Character.Humanoid.WalkSpeed = options.plrWalkspeed.Value
                    end
                end
            )

            characterSec:AddToggle("infStamina", {Text = "Infinite Stamina", Default = false}):OnChanged(
                function()
                    for _, v in pairs(getgc()) do
                        if type(v) == "function" and getfenv(v).script == localPlayer.Character.ClientInputHandler then
                            for _, v2 in pairs(getconstants(v)) do
                                if type(v2) == "string" and string.find(v2, "You don't have enough") then
                                    funcs.staminaFunc = v
                                    break
                                end
                            end
                        end
                    end
                    if flags.infStamina.Value then
                        debug.setupvalue(funcs.staminaFunc, 5, math.huge)
                    else
                        debug.setupvalue(funcs.staminaFunc, 5, 12)
                    end
                end
            )
            characterSec:AddToggle("infJump", {Text = "Infinite Jump", Default = false}):OnChanged(
                function()
                    local state = flags.infJump.Value

                    if state then
                        connections.infJump =
                            game:GetService("UserInputService").JumpRequest:Connect(
                            function()
                                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(
                                    "Jumping"
                                )
                            end
                        )
                    else
                        if connections.infJump ~= nil then
                            connections.infJump:Disconnect()
                        end
                    end
                end
            )

            characterSec:AddToggle("noPunchCooldown", {Text = "No Punch Cooldown", Default = false}):OnChanged(
                function()
                    task.spawn(
                        function()
                            while flags.noPunchCooldown.Value do
                                pcall(
                                    function()
                                        clientInputEnv = getsenv(game.Players.LocalPlayer.Character.ClientInputHandler)
                                        clientInputEnv.cs.isFighting = false
                                        task.wait()
                                    end
                                )
                            end
                        end
                    )
                end
            )

            characterSec:AddToggle("instantRespawn", {Text = "Instant Respawn", Default = false})
            characterSec:AddToggle("respawnAtDeath", {Text = "Respawn At Died Position", Default = false})

            local deathPosition
            local function setPos()
                deathPosition = localPlayer.Character.HumanoidRootPart.CFrame
            end

            localPlayer.Character.Humanoid.Died:Connect(setPos)
            localPlayer.CharacterAdded:Connect(
                function(char)
                    char:WaitForChild("Humanoid", 3).Died:Connect(setPos)
                    if flags.respawnAtDeath.Value then
                        char:WaitForChild("HumanoidRootPart", 3).CFrame = deathPosition
                    end
                end
            )

            localPlayer.CharacterAdded:Connect(
                function(character)
                    character:WaitForChild("Humanoid").Died:Connect(
                        function()
                            pcall(
                                function()
                                    if flags.instantRespawn.Value then
                                        game:GetService("Workspace").Remote.loadchar:InvokeServer(
                                            "\66\114\111\121\111\117\98\97\100\100"
                                        )
                                    end
                                end
                            )
                        end
                    )
                end
            )
        end

        local teamTabBox = playerTab:AddRightTabbox()
        do
            local teamChangerSec = teamTabBox:AddTab("Team Changer")
            do
                teamChangerSec:AddDropdown(
                    "selectedTeam",
                    {Text = "Select Team", Values = {"Criminal", "Neutral", "Guard", "Inmate"}}
                )
                teamChangerSec:AddButton(
                    "Change Team",
                    function()
                        local selectedTeam = options.selectedTeam.Value
                        if selectedTeam == "Criminal" then
                            firetouchinterest(
                                localPlayer.Character.HumanoidRootPart,
                                game:GetService("Workspace")["Criminals Spawn"].SpawnLocation,
                                0
                            )
                            firetouchinterest(
                                localPlayer.Character.HumanoidRootPart,
                                game:GetService("Workspace")["Criminals Spawn"].SpawnLocation,
                                1
                            )
                        elseif selectedTeam == "Inmate" then
                            game.Workspace.Remote.TeamEvent:FireServer("Bright orange")
                        elseif selectedTeam == "Guard" then
                            game.Workspace.Remote.TeamEvent:FireServer("Bright blue")
                        elseif selectedTeam == "Neutral" then
                            game.Workspace.Remote.TeamEvent:FireServer("Medium stone grey")
                        end
                    end
                )
            end
            local colorChangeSec = teamTabBox:AddTab("Team Color")
            do
                colorChangeSec:AddLabel("Color"):AddColorPicker("customTeamColor", {Default = Color3.new(1, 0, 0)})
                colorChangeSec:AddButton(
                    "Apply Color",
                    function()
                        local color = BrickColor.new(options.customTeamColor.Value)
                        local oldCf = localPlayer.Character.HumanoidRootPart.CFrame
                        local oldCameraCf = workspace.CurrentCamera.CFrame

                        workspace.Remote.loadchar:InvokeServer(nil, color.Name)
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCf
                        workspace.CurrentCamera.CFrame = oldCameraCf
                    end
                )
            end
        end
        local utilSec = playerTab:AddLeftTabbox():AddTab("Utility")
        do
            utilSec:AddToggle("antiShield", {Text = "Anti Shields", Default = false}):OnChanged(
                function()
                    task.spawn(
                        function()
                            while flags.antiShield.Value do
                                for _, player in ipairs(game.Players:GetPlayers()) do
                                    pcall(
                                        function()
                                            if game.Workspace[player.Name].Torso:FindFirstChild("ShieldFolder") then
                                                game.Workspace[player.Name].Torso.ShieldFolder:Destroy()
                                            end
                                        end
                                    )
                                end
                                task.wait(1)
                            end
                        end
                    )
                end
            )
            local oldTazeFunc
            utilSec:AddToggle("antiTaze", {Text = "Anti Taze", Default = false}):OnChanged(
                function()
                    local state = flags.antiTaze.Value
                    if state then
                        oldTazeFunc = funcs.taze
                        hookfunction(
                            funcs.taze,
                            function()
                            end
                        )
                    else
                        if oldTazeFunc ~= nil then
                            funcs.taze = oldTazeFunc
                        end
                    end
                end
            )

            utilSec:AddToggle("loopDoors", {Text = "Loop Open Doors (Guard)", Default = false}):OnChanged(
                function()
                    task.spawn(
                        function()
                            while flags.loopDoors.Value do
                                for _, v in ipairs(game:GetService("Workspace").Doors:GetDescendants()) do
                                    if v:IsA("TouchTransmitter") or v.Name == "TouchInterest" then
                                        firetouchinterest(game.Players.LocalPlayer.Character["Left Leg"], v.Parent, 0)
                                        firetouchinterest(game.Players.LocalPlayer.Character["Left Leg"], v.Parent, 1)
                                        firetouchinterest(game.Players.LocalPlayer.Character.Torso, v.Parent, 0)
                                        firetouchinterest(game.Players.LocalPlayer.Character.Torso, v.Parent, 1)
                                    end
                                end
                                task.wait(2)
                            end
                        end
                    )
                end
            )

            utilSec:AddButton(
                "Break Cell Toilets",
                function()
                    local giver = game:GetService("Workspace").Prison_ITEMS.single.Hammer.ITEMPICKUP

                    workspace.Remote.ItemHandler:InvokeServer(giver)

                    local hammer =
                        localPlayer.Character:FindFirstChild("Hammer") or localPlayer.Backpack:FindFirstChild("Hammer")
                    if hammer ~= nil then
                        if hammer.Parent == localPlayer.Backpack then
                            hammer.Parent = localPlayer.Character
                        end
                        for _, v in ipairs(game:GetService("Workspace")["Prison_Cellblock"]:GetDescendants()) do
                            if v.Name == "Toilet" and v:FindFirstChild("Health") and v.Health.Value ~= 0 then
                                repeat
                                    if hammer.Parent == localPlayer.Backpack then
                                        hammer.Parent = localPlayer.Character
                                    end
                                    game:GetService("ReplicatedStorage").meleeEvent:FireServer(
                                        v,
                                        workspace[localPlayer.Name].Hammer
                                    )
                                    task.wait()
                                until v.Health.Value == 0
                            end
                        end
                    end
                end
            )
        end
    end

    local combatTab = Window:AddTab("Combat")
    do
        local itemsTabBox = combatTab:AddLeftTabbox()
        do
            local gunsSec = itemsTabBox:AddTab("Guns")
            do
                local avaliableGuns = {"Remington 870", "AK-47", "M9", "M4A1", "Riot Shield"}
                if not userOwnsSwatGamepass then
                    table.remove(avaliableGuns, table.find(avaliableGuns, "M4A1"))
                    table.remove(avaliableGuns, table.find(avaliableGuns, "Riot Shield"))
                end
                gunsSec:AddDropdown(
                    "gunToGet",
                    {
                        Text = "Grab Gun",
                        Default = "M9",
                        Values = avaliableGuns
                    }
                )
                gunsSec:AddButton(
                    "Grab Selected Gun",
                    function()
                        local giver = workspace.Prison_ITEMS.giver[options.gunToGet.Value].ITEMPICKUP

                        workspace.Remote.ItemHandler:InvokeServer(giver)
                    end
                )
                gunsSec:AddButton(
                    "Grab All Guns",
                    function()
                        for _, gun in ipairs(avaliableGuns) do
                            local giver = workspace.Prison_ITEMS.giver[gun].ITEMPICKUP
                            workspace.Remote.ItemHandler:InvokeServer(giver)
                        end
                    end
                )
                gunsSec:AddToggle("autoGiveAllGuns", {Text = "Auto Give All Guns", Default = false}):OnChanged(
                    function()
                        task.spawn(
                            function()
                                while flags.autoGiveAllGuns.Value do
                                    for _, gun in ipairs(avaliableGuns) do
                                        local giver = workspace.Prison_ITEMS.giver[gun].ITEMPICKUP
                                        workspace.Remote.ItemHandler:InvokeServer(giver)
                                    end
                                    task.wait(1)
                                end
                            end
                        )
                    end
                )
            end
            local gunModsSec = itemsTabBox:AddTab("Gun Mods")
            do
                gunModsSec:AddLabel("Toggle off and mods if you die")
                gunModsSec:AddToggle("infAmmo", {Text = "Infinite Ammo", Default = false}):OnChanged(
                    function()
                        local state = flags.infAmmo.Value
                        modGun(state, {StoredAmmo = math.huge, CurrentAmmo = math.huge, MaxAmmo = math.huge})
                    end
                )
                gunModsSec:AddToggle("infRange", {Text = "Infinite Range", Default = false}):OnChanged(
                    function()
                        local state = flags.infRange.Value
                        modGun(state, {Range = math.huge})
                    end
                )
                gunModsSec:AddToggle("automaticGun", {Text = "Automatic", Default = false}):OnChanged(
                    function()
                        local state = flags.automaticGun.Value
                        modGun(state, {AutoFire = true})
                    end
                )
                gunModsSec:AddToggle("fireRate", {Text = "Fast Fire Rate", Default = false}):OnChanged(
                    function()
                        local state = flags.fireRate.Value
                        modGun(state, {FireRate = 0.0000000000000000000001})
                    end
                )
                gunModsSec:AddToggle("multiBullets", {Text = "Multiple Bullets", Default = false}):OnChanged(
                    function()
                        local state = flags.multiBullets.Value
                        modGun(state, {Bullets = 6})
                    end
                )

                gunModsSec:AddToggle("noReloadTime", {Text = "Fast Reload", Default = false}):OnChanged(
                    function()
                        local state = flags.noReloadTime.Value
                        modGun(state, {ReloadTime = 0.000000000000000000001})
                    end
                )
            end
        end
        local giversTabBox = combatTab:AddRightTabbox()
        do
            local giversSec = giversTabBox:AddTab("Givers")
            do
                giversSec:AddDropdown(
                    "clothesToGet",
                    {
                        Text = "Wear Clothes",
                        Default = "Police hat",
                        Values = {"Police hat", "Riot helmet", "Ski mask", "Riot Clothes"}
                    },
                    function(value)
                    end
                )
                giversSec:AddButton(
                    "Wear Selected Clothing",
                    function()
                        local value = options.clothesToGet.Value
                        local newValue = ""

                        if value == "Riot Clothes" then
                            newValue = "Riot Police"
                        else
                            newValue = value
                        end
                        local giver = workspace.Prison_ITEMS.hats[newValue].hat
                        workspace.Remote.ItemHandler:InvokeServer(giver)
                    end
                )
            end
            local droppedItemsSec = giversTabBox:AddTab("Drops")
            do
                local droppedItemsValues = {}

                local function populateItems()
                    droppedItemsValues = {}
                    for _, v in pairs(game.Workspace.Prison_ITEMS.single:GetChildren()) do
                        table.insert(droppedItemsValues, v.Name)
                    end
                end

                local function removeDuplicates(arr)
                    local newArray = {}
                    local checkerTbl = {}
                    for _, element in ipairs(arr) do
                        if not checkerTbl[element] then -- if there is not yet a value at the index of element, then it will be nil, which will operate like false in an if statement
                            checkerTbl[element] = true
                            table.insert(newArray, element)
                        end
                    end
                    return newArray
                end

                populateItems()
                droppedItemsValues = removeDuplicates(droppedItemsValues)

                local droppedItemsDropdown =
                    droppedItemsSec:AddDropdown(
                    "droppedItemSelected",
                    {Text = "Get Dropped Item", Values = droppedItemsValues, Default = droppedItemsValues[1] or ""}
                )
                droppedItemsSec:AddButton(
                    "Grab Item",
                    function()
                        local item = droppedItemsDropdown.Value
                        local giver = workspace.Prison_ITEMS.single[item].ITEMPICKUP

                        workspace.Remote.ItemHandler:InvokeServer(giver)
                    end
                )

                game.Workspace.Prison_ITEMS.single.ChildAdded:Connect(
                    function()
                        populateItems()
                        droppedItemsValues = removeDuplicates(droppedItemsValues)

                        droppedItemsDropdown.Values = droppedItemsValues
                        droppedItemsDropdown:SetValues()
                    end
                )
                game.Workspace.Prison_ITEMS.single.ChildRemoved:Connect(
                    function()
                        populateItems()
                        droppedItemsValues = removeDuplicates(droppedItemsValues)

                        droppedItemsDropdown.Values = droppedItemsValues
                        droppedItemsDropdown:SetValues()
                    end
                )
            end
        end
        local silentAimTabBox = combatTab:AddLeftTabbox()
        do
            local silentAimSec = silentAimTabBox:AddTab("Silent Aim")
            do
                silentAimSec:AddToggle("enabledSilentAim", {Text = "Enabled", Default = false}):OnChanged(
                    function()
                        Aiming.Settings.Enabled = flags.enabledSilentAim.Value
                    end
                )
                silentAimSec:AddDropdown(
                    "targetPart",
                    {Text = "Target Part", Values = {"Head", "HumanoidRootPart", "Torso"}, Default = "Head"}
                ):OnChanged(
                    function()
                        Aiming.Settings.TargetPart = options.targetPart.Value
                    end
                )
            end

            local silentAimConfigSec = silentAimTabBox:AddTab("FOV")
            do
                silentAimConfigSec:AddToggle("showFOV", {Text = "Show FOV", Default = false}):OnChanged(
                    function()
                        Aiming.Settings.FOVSettings.Enabled = flags.showFOV.Value
                    end
                )
                silentAimConfigSec:AddSlider(
                    "aimingFOVSize",
                    {Text = "FOV Size", Default = Aiming.Settings.FOVSettings.Scale, Min = 20, Max = 200, Rounding = 0}
                ):OnChanged(
                    function()
                        local value = options.aimingFOVSize.Value
                        Aiming.Settings.FOVSettings.Scale = value
                    end
                )
                silentAimConfigSec:AddSlider(
                    "fovSides",
                    {Text = "FOV Sides", Default = Aiming.Settings.FOVSettings.Sides, Min = 0, Max = 100, Rounding = 0}
                ):OnChanged(
                    function()
                        local value = options.fovSides.Value
                        Aiming.Settings.FOVSettings.Sides = value
                    end
                )
            end
        end
    end

    local rageTab = Window:AddTab("Rage")
    do
        local rageTabBox = rageTab:AddLeftTabbox()
        do
            local mainSec = rageTabBox:AddTab("Server")
            do
                mainSec:AddButton(
                    "Kill All",
                    function()
                        local oldCf = localPlayer.Character.HumanoidRootPart.CFrame
                        for _, player in ipairs(players:GetPlayers()) do
                            if player.Name ~= localPlayer.Name then
                                killPlayer(player)
                            end
                        end
                        game:GetService("Workspace").Remote.loadchar:InvokeServer(
                            "\66\114\111\121\111\117\98\97\100\100"
                        )
                        localPlayer.Character.HumanoidRootPart.CFrame = oldCf
                    end
                )
                mainSec:AddToggle("loopKillAll", {Text = "Loop Kill All", Default = false}):OnChanged(
                    function()
                        task.spawn(
                            function()
                                while flags.loopKillAll.Value do
                                    local oldCf = localPlayer.Character.HumanoidRootPart.CFrame
                                    for _, player in ipairs(players:GetPlayers()) do
                                        if player.Name ~= localPlayer.Name then
                                            killPlayer(player)
                                        end
                                    end

                                    task.wait(3)
                                end
                            end
                        )
                        if not flags.loopKillAll.Value then
                            game.Workspace.Remote.TeamEvent:FireServer("Bright orange")
                        end
                    end
                )
                mainSec:AddButton(
                    "Taze All",
                    function()
                        for _, player in ipairs(players:GetPlayers()) do
                            if player.Name ~= localPlayer.Name then
                                tazePlayer(player)
                            end
                        end
                        game.Workspace.Remote.TeamEvent:FireServer("Bright orange")
                    end
                )
                mainSec:AddToggle("loopTazeAll", {Text = "Loop Taze All", Default = false}):OnChanged(
                    function()
                        task.spawn(
                            function()
                                while flags.loopTazeAll.Value do
                                    for _, player in ipairs(players:GetPlayers()) do
                                        if player.Name ~= localPlayer.Name then
                                            tazePlayer(player)
                                        end
                                    end
                                    task.wait(4)
                                end
                            end
                        )
                    end
                )
            end
            local selfSec = rageTabBox:AddTab("Self")
            do
                selfSec:AddToggle("killAura", {Text = "Kill Aura", Default = false}):OnChanged(
                    function()
                        task.spawn(
                            function()
                                while flags.killAura.Value do
                                    local meleeEvent = game:GetService("ReplicatedStorage").meleeEvent
                                    for _, plr in pairs(game:GetService("Players"):GetChildren()) do
                                        if plr.Name ~= localPlayer.Name then
                                            meleeEvent:FireServer(plr)
                                        end
                                    end
                                    runService.RenderStepped:Wait()
                                end
                            end
                        )
                    end
                )
            end
        end
    end

    local visualsTab = Window:AddTab("Visuals")
    do
        local espBoxTab = visualsTab:AddLeftTabbox()
        do
            local espSec = espBoxTab:AddTab("ESP")
            do
                espSec:AddToggle("playerESP", {Text = "Player ESP", Default = false}):OnChanged(
                    function()
                        ESP.Players = flags.playerESP.Value
                    end
                )
                flags.playerESP:AddColorPicker("playerESPColor", {Default = ESP.Color})
                options.playerESPColor:OnChanged(
                    function()
                        ESP.Color = options.playerESPColor.Value
                    end
                )
            end
            local espOptionsSec = espBoxTab:AddTab("ESP Options")
            do
                espOptionsSec:AddToggle("boxESP", {Text = "Boxes", Default = true}):OnChanged(
                    function()
                        ESP.Boxes = flags.boxESP.Value
                    end
                )
                espOptionsSec:AddToggle("nameESP", {Text = "Names", Default = true}):OnChanged(
                    function()
                        ESP.Names = flags.nameESP.Value
                    end
                )
                espOptionsSec:AddToggle("tracersESP", {Text = "Tracers", Default = false}):OnChanged(
                    function()
                        ESP.Tracers = flags.tracersESP.Value
                    end
                )
                espOptionsSec:AddToggle("teamMates", {Text = "Show Teammates", Default = true}):OnChanged(
                    function()
                        ESP.TeamMates = flags.teamMates.Value
                    end
                )
                espOptionsSec:AddToggle("teamColor", {Text = "Team Colors", Default = true}):OnChanged(
                    function()
                        ESP.TeamColor = flags.teamColor.Value
                    end
                )
            end
        end
    end
end

local SettingsTab = Window:AddTab("Settings")
do
    local themeSec = SettingsTab:AddLeftGroupbox("Theme")
    do
        themeSec:AddLabel("Background Color"):AddColorPicker("BackgroundColor", {Default = Library.BackgroundColor})
        themeSec:AddLabel("Main Color"):AddColorPicker("MainColor", {Default = Library.MainColor})
        themeSec:AddLabel("Accent Color"):AddColorPicker("AccentColor", {Default = Library.AccentColor})
        themeSec:AddLabel("Outline Color"):AddColorPicker("OutlineColor", {Default = Library.OutlineColor})
        themeSec:AddLabel("Font Color"):AddColorPicker("FontColor", {Default = Library.FontColor})
        themeSec:AddButton("Default Theme", setDefault)
        themeSec:AddToggle("Keybinds", {Text = "Show Keybinds Menu", Default = true}):OnChanged(
            function()
                Library.KeybindFrame.Visible = flags.Keybinds.Value
            end
        )
        themeSec:AddToggle("Watermark", {Text = "Show Watermark", Default = true}):OnChanged(
            function()
                Library:SetWatermarkVisibility(flags.Watermark.Value)
            end
        )
        themeSec:AddToggle("Rainbow", {Text = "Rainbow Accent Color", Default = true})
    end
end

task.spawn(
    function()
        while game:GetService("RunService").RenderStepped:Wait() do
            if flags.Rainbow.Value then
                local registry = Window.Holder.Visible and Library.Registry or Library.HudRegistry

                for _, object in pairs(registry) do
                    for Property, colorIdx in next, object.Properties do
                        if colorIdx == "AccentColor" or colorIdx == "AccentColorDark" then
                            local objInstance = object.Instance
                            local yPos = objInstance.AbsolutePosition.Y

                            local mapped = Library:MapValue(yPos, 0, 1080, 0, 0.5) * 1.5
                            local color = Color3.fromHSV((Library.CurrentRainbowHue - mapped) % 1, 0.8, 1)

                            if colorIdx == "AccentColorDark" then
                                color = Library:GetDarkerColor(color)
                            end

                            objInstance[Property] = color
                        end
                    end
                end
            end
        end
    end
)

flags.Rainbow:OnChanged(
    function()
        if not flags.Rainbow.Value then
            updateTheme()
        end
    end
)

options.BackgroundColor:OnChanged(updateTheme)
options.MainColor:OnChanged(updateTheme)
options.AccentColor:OnChanged(updateTheme)
options.OutlineColor:OnChanged(updateTheme)
options.FontColor:OnChanged(updateTheme)

Library:Notify("Loaded UI!")
