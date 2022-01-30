-- // Jailbreak

-- // Client Sided Anti Kick
local oldNameCall = nil
oldNameCall =
    hookmetamethod(
    game,
    "__namecall",
    function(...)
        local method = getnamecallmethod()
        if method == "Kick" then
            return nil
        end
        return oldNameCall(...)
    end
)

-- // Dependencies
local SolarisLib =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/TR1V5/TR1V5-scripts/main/ui%20lib%20by%20david"))()
local Keys, Network =
    loadstring(
    game:HttpGet(
        "https://gist.githubusercontent.com/technorav3nn/53b385abeea871dce26b413b6eba63c5/raw/0ea5372431094186339f07dbbab4edb746d381c5/jb_key_dumper_(THANKS%2520Introvert1337).lua"
    )
)()

-- // Setting Keys
Keys.GrabItem = "b34pkmn5"
Keys.UnEquipItem = "q03buto6"
Keys.BuyItem = "eyvnj0ba"
Keys.Cash = "vw5m60vm"
Keys.Give = "er6wb1f5"
Keys.OpenBank = "vq4l40cs"
Keys.Drop = "ex9xtqda"
Keys.Nuke = "gqkf0iai"
Keys.MoneyTruck = "kx1f5omj"

-- // Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- /// Game Services
local notifService = require(game:GetService("ReplicatedStorage").Game.Notification)

-- // Player Variables
local localPlayer = players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- // Solaris UI Library
local win =
    SolarisLib:New(
    {
        Name = "TR1V5 V1",
        FolderToSave = "TR1V5STUFF"
    }
)

-- // Functions and Main

-- // Notification Function
local function sendNotification(message, duration)
    notifService.new(
        {
            Text = message,
            Duration = duration
        }
    )
end -- Notification(text, \n to go down )

sendNotification("Collecting Functions...\nPlease wait until TR1V5 Loads", 3)

local Client = {
    Hashes = Keys,
    Toggles = {
        Walkspeed = false,
        JumpPower = false,
        InfJump = false,
        NoClip = false,
        NoRagdoll = false,
        Godmode = false,
        AutoFarm = false,
        AutoArrest = false, -- i also can make the auto arest but it will be hard since you can no clip
        RainbowCar = false,
        InfNitro = false,
        RainbowNitro = false,
        LoopExplode = false,
        LoopVolcano = false,
        LoopSewer = false,
        NoCarFlip = false,
        OpenAllDoors = false,
        Monstetires = false,
        NoTirePop = false,
        AK47infammo = false,
        Pistolinfammo = false,
        Shotguninfammo = false,
        Uziinfammo = false,
        Rifleinfammo = false
    },
    Values = {
        WalkSpeed = 16,
        JumpPower = 50,
        Method = 1,
        carspeed = 1,
        turnspeed = 1.5,
        suspention = 3
    },
    Teleports = {
        ["Jewelry Out"] = CFrame.new(156.103851, 18.540699, 1353.72388),
        ["Jewelry In"] = CFrame.new(133.300705, 17.9375954, 1316.42407),
        ["Bank Out"] = CFrame.new(11.6854906, 17.8929214, 788.188171),
        ["Bank In"] = CFrame.new(24.6513691, 19.4347649, 853.291687),
        ["Museum Out"] = CFrame.new(1103.53406, 138.152878, 1246.98511),
        ["Donut Shop"] = CFrame.new(
            76.4559402,
            21.0584793,
            -1591.01416,
            0.790199757,
            0.156331331,
            -0.592574954,
            0.015425493,
            0.96153754,
            0.274239838,
            0.612655461,
            -0.225844979,
            0.757395089
        ),
        ["Gas Station"] = CFrame.new(-1584.1051, 18.4732189, 721.38739),
        ["PowerPlant"] = CFrame.new(
            702.740967,
            39.0193367,
            2371.88672,
            -0.998025119,
            -0.00970620103,
            -0.0620610416,
            -0.00215026829,
            0.992689848,
            -0.120674998,
            0.0627786592,
            -0.120303221,
            -0.990750134
        ),
        ["Airport"] = CFrame.new(-1227.47449, 64.4552231, 2787.64233),
        ["Gun Shop"] = CFrame.new(-27.8670673, 17.7929249, -1774.66882),
        ["Volcano Base"] = CFrame.new(1726.72266, 50.4146309, -1745.76196),
        ["City Base"] = CFrame.new(-244.824478, 17.8677788, 1573.81616),
        ["Boat Port"] = CFrame.new(
            -407.957886,
            22.5707016,
            2049.26074,
            -0.976195455,
            0.0327876508,
            -0.214399904,
            0.00279002171,
            0.990324318,
            0.138744399,
            0.216874525,
            0.134843469,
            -0.966841578
        ),
        ["Boat Cave"] = CFrame.new(
            1875.21838,
            32.8055534,
            1909.28687,
            -0.701772571,
            0.0434923843,
            -0.711072326,
            -0.0087880427,
            0.997530222,
            0.0696865618,
            0.712346911,
            0.0551530346,
            -0.699657202
        ),
        ["Prison Cells"] = CFrame.new(-1461.07605, -0.318537951, -1824.14917),
        ["Prison Yard"] = CFrame.new(-1219.36316, 17.7750931, -1760.8584),
        ["Prison Parking"] = CFrame.new(-1173.36951, 18.698061, -1533.47656),
        ["1M Shop"] = CFrame.new(706.598267, 20.5805721, -1573.26294),
        ["Military Base"] = CFrame.new(766.283386, 18.0144463, -324.15921),
        ["Evil Lair"] = CFrame.new(1735.52405, 18.1646328, -1726.05249),
        ["Secret Agent Base"] = CFrame.new(1506.60754, 69.8824005, 1634.42456),
        ["Garage"] = CFrame.new(-384.259521, 19.6279697, 1221.55005),
        ["Lookout"] = CFrame.new(1328.05725, 166.614426, 2609.93457)
    }
}

-- // Anti AFK
localPlayer.Idled:Connect(
    function()
        local vu = game:GetService("VirtualUser")
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
)

-- // Tables
local Functions = {}
local Connections = {}

-- // Functions
local doors = {}
local doorOpenFunc

for i, v in pairs(getgc()) do
    if type(v) == "function" then
        if getfenv(v).script == localPlayer.PlayerScripts.LocalScript then
            local upvals = debug.getupvalues(v)
            for j, k in pairs(upvals) do
                if type(k) == "table" then
                    if rawget(k, "Nitro") then
                        NitroTable = k -- Gets nitro table
                    end
                end
            end
        end
    end
    if type(v) == "function" and getfenv(v).script == localPlayer.PlayerScripts.LocalScript then
        for i2, v2 in pairs(debug.getupvalues(v)) do
            if
                type(v2) == "table" and v2["Type"] and v2["Model"] and v2["OpenFun"] and v2["CloseFun"] and v2["Tag"] and
                    v2["State"] and
                    v2["Settings"]
             then
                table.insert(doors, v2)
            end
        end
    end
    if type(v) == "function" and getfenv(v).script == game:GetService("ReplicatedStorage").Game.NukeControl then
        local constants = debug.getconstants(v)
        for _, v2 in pairs(constants) do
            if v2 == "Nuke" then
                Functions.launchNuke = v
            end
        end
    end
    if not doorOpenFunc and type(v) == "function" and getfenv(v).script == localPlayer.PlayerScripts.LocalScript then
        local con = debug.getconstants(v)
        if table.find(con, "SequenceRequireState") then
            Functions.openDoor = v
        end
    end
end

-- // Open All Doors
local function openAllDoors()
    for _, door in ipairs(doors) do
        Functions.openDoor(door)
        task.wait()
    end
end

-- // Get item
local validItems = {"ShirtSWAT", "MaskSWAT", "PantsSWAT", "HatPolice", "ShirtPolice", "PantsPolice"}

local function grabItem(itemName)
    if table.find(validItems, itemName) then
        local giversPath = game:GetService("Workspace").Givers
        for _, v in ipairs(giversPath:GetChildren()) do
            if v:FindFirstChildOfClass("StringValue") and v.Item.Value == itemName then
                fireclickdetector(v.ClickDetector, math.huge)
            end
        end
    end
end

-- // Mod Gun
local function modGun(newValues)
    for _, v in pairs(game:GetService("ReplicatedStorage").Game.ItemConfig:GetChildren()) do
        local module = require(v)
        for key, value in pairs(newValues) do
            module[key] = value
        end
    end
end

-- // Click GUI Button
local function clickButton(button)
    for _, v in pairs(getconnections(button.MouseButton1Down)) do
        v:Fire()
    end
end

-- // Change Team
local teams = {"Prisoner", "Police"}
local function changeTeam(teamName)
    if not table.find(teams, teamName) then
        return
    end
    local teamSideBarButton = localPlayer.PlayerGui.AppUI.Buttons.Sidebar.TeamSwitch.TeamSwitch
    local confirmYesButton =
        localPlayer.PlayerGui.ConfirmationGui.Confirmation.Background.ContainerButtons.ContainerYes.Button

    clickButton(teamSideBarButton)
    clickButton(confirmYesButton)
    Network:FireServer(Keys.SwitchTeam, teamName)
end

-- // Inf Ammo
task.spawn(
    function()
        while true do
            task.wait()
            if Client.Toggles.AK47infammo == true then
                pcall(
                    function()
                        game:GetService("Players").LocalPlayer.Folder.AK47.Reload:FireServer()
                    end
                )
            end
        end
    end
)

task.spawn(
    function()
        while true do
            task.wait()
            if Client.Toggles.Pistolinfammo == true then
                pcall(
                    function()
                        game:GetService("Players").LocalPlayer.Folder.Pistol.Reload:FireServer()
                    end
                )
            end
        end
    end
)

task.spawn(
    function()
        while true do
            task.wait()
            if Client.Toggles.Shotguninfammo == true then
                pcall(
                    function()
                        game:GetService("Players").LocalPlayer.Folder.Shotgun.Reload:FireServer()
                    end
                )
            end
        end
    end
)

task.spawn(
    function()
        while true do
            task.wait()
            if Client.Toggles.Uziinfammo == true then
                pcall(
                    function()
                        game:GetService("Players").LocalPlayer.Folder.Uzi.Reload:FireServer()
                    end
                )
            end
        end
    end
)

task.spawn(
    function()
        while true do
            task.wait()
            if Client.Toggles.Rifleinfammo == true then
                pcall(
                    function()
                        game:GetService("Players").LocalPlayer.Folder.Rifle.Reload:FireServer()
                    end
                )
            end
        end
    end
)

-- // Inf Nitro
task.spawn(
    function()
        while task.wait() do
            if Client.Toggles.InfNitro == true then
                if NitroTable then
                    NitroTable.Nitro = math.huge
                end
            end
        end
    end
)

-- // Utility Slider Function
local function createSlider(section, options)
    return section:Slider(options.text)
end

-- // Grab Gun From GunShop
local allGuns = {}
local mod = require(game:GetService("ReplicatedStorage").Game.GunShop.Data.Held)
for _, tbl in pairs(mod) do
    for _, gun in pairs(tbl) do
        table.insert(allGuns, gun)
    end
end

local function grabGun(gunName)
    for _, tbl in pairs(mod) do
        for _, gun in pairs(tbl) do
            if gun == gunName then
                Network:FireServer(Keys.GrabItem, gunName)
                break
            end
        end
    end
end

-- // UI

-- /// Tabs
local playerTab = win:Tab("Player")
do
    local teamSec = playerTab:Section("Teams")
    do
        teamSec:Dropdown(
            "Change Team",
            teams,
            "",
            "teamSwitch",
            function(team)
                changeTeam(team)
            end
        )
    end
end

local combatTab = win:Tab("Combat")
do
end

local itemsTab = win:Tab("Items")
do
    local grabSec = itemsTab:Section("Grab Items")
    do
        grabSec:Dropdown(
            "Grab Gun",
            allGuns,
            "",
            "grabGuns",
            function(selected)
                grabGun(selected)
            end
        )
        grabSec:Button(
            "Grab All Guns",
            function()
                local ownedGuns = {}
                local ownedItemsPath = game:GetService("Players").LocalPlayer.Items
                for _, v in ipairs(ownedItemsPath:GetChildren()) do
                    if v:IsA("BoolValue") then
                        ownedGuns[v.Name] = v.Name
                    end
                end
                for i, gun in ipairs(allGuns) do
                    local doesPlayerOwnGun = ownedGuns[gun]
                    if doesPlayerOwnGun ~= nil then
                        grabGun(gun)
                        task.wait(1)
                    end
                end
            end
        )
        -- // Grab clothes / items
        grabSec:Dropdown(
            "Grab Clothing",
            validItems,
            "",
            "grabGuns",
            function(selected)
                grabItem(selected)
            end
        )
        grabSec:Button(
            "Grab All Clothes",
            function()
                for _, clothing in ipairs(validItems) do
                    grabItem(clothing)
                end
            end
        )
    end

    local GunModSec = itemsTab:Section("Gun Mods")
    do
        local gunModFlags = {}
        --sec:Slider(title <string>,min <number>,max <number>,default <number>,increment <number>, flag <string>, callback <function>)
        GunModSec:Slider(
            "Bullet Speed",
            50,
            5000,
            100,
            10,
            "Slider",
            function(t)
                gunModFlags.BulletSpeed = t
            end
        )
        GunModSec:Slider(
            "Fire Frequency",
            50,
            10000,
            10,
            10,
            "Slider",
            function(t)
                gunModFlags.FireFreq = t
            end
        )
        GunModSec:Slider(
            "Reload Time",
            0.5,
            10,
            4,
            0.5,
            "Slider",
            function(t)
                gunModFlags.ReloadTime = t
            end
        )
        GunModSec:Slider(
            "Bullets Per Shot",
            1,
            10,
            1,
            1,
            "Slider",
            function(t)
                gunModFlags.BulletsPerShot = t
            end
        )
        GunModSec:Button(
            "Apply Slider Values",
            function()
                modGun(gunModFlags)
            end
        )
        GunModSec:Toggle(
            "Fire Auto",
            false,
            "Toggle",
            function(state)
                modGun({FireAuto = state})
            end
        )

        GunModSec:Toggle(
            "Auto Reload [semi-works]",
            false,
            "Toggle",
            function(state)
                Client.Toggles.AK47infammo = state
                Client.Toggles.Pistolinfammo = state
                Client.Toggles.Shotguninfammo = state
                Client.Toggles.Uziinfammo = state
                Client.Toggles.Rifleinfammo = state
            end
        )
    end
end

local teleportTab = win:Tab("Teleports")
do
end

local vehicleTab = win:Tab("Vehicle")
do
    local vehicleSec = vehicleTab:Section("VehicleMods")
    do
        vehicleSec:Toggle(
            "Inf Nitro",
            false,
            "Toggle",
            function(state)
                Client.Toggles.InfNitro = state
            end
        )

        vehicleSec:Toggle(
            "Rainbow Car",
            false,
            "Toggle",
            function(state)
                Client.Toggles.RainbowCar = state
            end
        )

        vehicleSec:Toggle(
            "Rainbow Nitro",
            false,
            "Toggle",
            function(state)
                Client.Toggles.RainbowNitro = state
            end
        )
        -- // RainbowNitro And RainbowCar
        game:GetService("RunService").Stepped:Connect(
            function()
                for i, v in pairs(workspace.Vehicles:GetChildren()) do
                    if v:FindFirstChild("Seat") then
                        if v.Seat:WaitForChild("PlayerName").Value == game:GetService("Players").LocalPlayer.Name then
                            for a, b in pairs(v.Model:GetChildren()) do
                                if b.Name == "Nitrous" and Client.Toggles.RainbowNitro == true then
                                    currrain = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                                    b.Fire.Color = ColorSequence.new(currrain)
                                    b.Smoke.Color = ColorSequence.new(currrain)
                                end
                                if b:IsA("BasePart") and Client.Toggles.RainbowCar == true then
                                    b.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
                                end
                            end
                        end
                    end
                end
            end
        )

        local FlySpeed = 50
        local function GetCarMain()
            local x = game:GetService("Players").LocalPlayer.Name
            for j, y in pairs(workspace.Vehicles:GetChildren()) do
                if y:FindFirstChild("Seat") and y:FindFirstChild("Engine") then
                    if y.Seat.PlayerName.Value == x then
                        return y.Engine, false
                    end
                elseif y:FindFirstChild("Seat") and y:FindFirstChild("Model") then
                    if y.Seat.PlayerName.Value == x then
                        if y.Model:FindFirstChild("Body") then
                            return y.Model.Body, true
                        end
                    end
                end
            end
        end
        local function FlyPart(z, A)
            local B = Instance.new("Folder")
            B.Name = "Storage"
            for j, C in pairs(z:GetChildren()) do
                if C:IsA("BodyGyro") then
                    C.Parent = B
                end
            end
            local D = Instance.new("BodyPosition", z)
            D.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            D.Name = "Position"
            local E = Instance.new("BodyGyro", z)
            E.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            E.Name = "Rotate"
            workspace.CurrentCamera.CameraSubject = z
            local f = game:GetService("Players").LocalPlayer:GetMouse()
            local F = 0
            local G =
                f.KeyDown:Connect(
                function(H)
                    if H == "w" then
                        if A then
                            F = FlySpeed
                        else
                            F = tonumber("-" .. tostring(FlySpeed))
                        end
                    elseif H == "s" then
                        if A then
                            F = tonumber("-" .. tostring(FlySpeed))
                        else
                            F = FlySpeed
                        end
                    end
                end
            )
            f.KeyUp:Connect(
                function(H)
                    if H == "w" then
                        F = 0
                    elseif H == "s" then
                        F = 0
                    end
                end
            )
            local I = {}
            I.IsRunning = true
            I.Part = z
            I.Storage = B
            I.MT = G
            coroutine.resume(
                coroutine.create(
                    function()
                        repeat
                            local J = workspace.CurrentCamera.CFrame
                            local K = z.Position
                            local L = (K - J.p).Magnitude
                            D.Position =
                                (J * CFrame.new(0, 0, tonumber("-" .. tostring(L)) + F)).p + Vector3.new(0, 0.2225, 0)
                            E.CFrame = J
                            wait()
                        until I.IsRunning == false or workspace.CurrentCamera.CameraSubject ~= z
                        D:Remove()
                        E:Remove()
                        for j, M in pairs(I.Storage:GetChildren()) do
                            M.Parent = I.Part
                        end
                        I.MT:Disconnect()
                        I.Storage:Remove()
                    end
                )
            )
            return I
        end

        vehicleSec:Button(
            "Car Fly",
            function()
                if GetCarMain() ~= nil then
                    local O, A = GetCarMain()
                    local P = FlyPart(O, A)
                    if A then
                        repeat
                            wait()
                        until O.Parent.Parent.Seat.PlayerName.Value ~= game:GetService("Players").LocalPlayer.Name
                    else
                        repeat
                            wait()
                        until O.Parent.Seat.PlayerName.Value ~= game:GetService("Players").LocalPlayer.Name
                    end
                    wait(0.1)
                    workspace.CurrentCamera.CameraSubject = d
                end
            end
        )

        vehicleSec:Slider(
            "Fly Speed",
            0,
            150,
            50,
            1,
            "Slider",
            function(value)
                FlySpeed = value
            end
        )
    end
end

local visualsTab = win:Tab("Visuals")
do
end

local miscTab = win:Tab("Miscellaneous")
do
    local trollingSec = miscTab:Section("Trolling")
    do
        trollingSec:Button(
            "Open All Doors [SS]",
            function()
                openAllDoors()
            end
        )

        trollingSec:Toggle(
            "Loop Open All Doors [SS]",
            false,
            "openAllDoors",
            function(bool)
                Client.Toggles.LoopDoors = bool
                task.spawn(
                    function()
                        while Client.Toggles.LoopDoors and task.wait(0.5) do
                            openAllDoors()
                        end
                    end
                )
            end
        )
        trollingSec:Button(
            "Ear Rape [SS]",
            function()
                for _, v in pairs(getgc(true)) do
                    if
                        not PlayFunc and type(v) == "function" and
                            getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript
                     then
                        local con = getconstants(v)
                        if table.find(con, "Play") and table.find(con, "Source") and table.find(con, "FireServer") then
                            PlayFunc = v
                        end
                    end
                end

                for i, v in pairs(require(game:GetService("ReplicatedStorage").Resource.Settings).Sounds) do
                    PlayFunc(
                        i,
                        {
                            Source = workspace,
                            Volume = math.huge,
                            Multi = true,
                            MaxTime = 10 -- time how long
                        },
                        false
                    )
                end
            end
        )
        trollingSec:Toggle(
            "Click Nuke [CS]",
            false,
            "clickNuke",
            function(bool)
                Client.Toggles.clickNuke = bool
                local function onMouseButton1Down()
                    local nukeArguments = {
                        Nuke = {
                            Origin = Vector3.new(0, 0, 0),
                            Speed = 1000,
                            Duration = 10,
                            Target = mouse.Hit.p,
                            TimeDilation = 1.5
                        },
                        Shockwave = {
                            Duration = 10,
                            MaxRadius = 1000
                        }
                    }
                    Functions.launchNuke(nukeArguments)
                end
                if Client.Toggles.clickNuke then
                    connections.clickNuke = mouse.Button1Down:Connect(onMouseButton1Down)
                else
                    if not Client.Toggles.clickNuke then
                        connections.clickNuke:Disconnect()
                    end
                end
            end
        )
    end
end
