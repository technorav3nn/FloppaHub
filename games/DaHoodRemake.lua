for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
    if v:FindFirstChild("MainFrameHolder") then
        v:Destroy()
    end
end

local function getAllShopItems()
    local returnTable = {} -- { func: function }
    local returnKeys = {}

    local shopPath = game:GetService("Workspace").Ignored.Shop
    for _, item in pairs(shopPath:GetChildren()) do
        if item:IsA("Model") and item:FindFirstChildOfClass("ClickDetector") then
            returnTable[item.Name] = {
                func = function(humanoidRootPart)
                    local clickDetector = item.ClickDetector
                    local itemCFrame = item.Head.CFrame

                    local oldHrpCf = humanoidRootPart.CFrame
                    humanoidRootPart.CFrame = itemCFrame
                    task.wait(0.2)
                    fireclickdetector(clickDetector, 0)
                    task.wait(0.4)
                    humanoidRootPart.CFrame = oldHrpCf
                end
            }
            table.insert(returnKeys, item.Name)
        end
    end
    return returnTable, returnKeys
end

local items, itemsList = getAllShopItems()

-- // Function to remove duplicate items in an array
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
itemsList = removeDuplicates(itemsList)

-- // Getting items that are only ammo
local function getAllItemsOnlyWithAmmo()
    local ret = {}
    for itemName, _ in pairs(items) do
        if string.find(itemName, "Ammo") then
            table.insert(ret, itemName)
        end
    end
    print(#ret)
    return ret
end

-- // Ammo items only table
local ammoItems = getAllItemsOnlyWithAmmo()

-- // Sorting items
table.sort(itemsList)

-- // Flag System
local flags = {}
function flags:SetFlag(name, value)
    flags[name] = value
end

-- // Services
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- // RunService Variables
local renderStepped = runService.RenderStepped
local heartBeat = runService.Heartbeat
local stepped = runService.Stepped

-- // Player Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // Solaris Loading
local SolarisLib = loadstring(game:HttpGet("https://solarishub.dev/SolarisLib.lua"))()
local sFlags = SolarisLib.Flags

-- // ESP Library
local ESP =
    loadstring(
    game:HttpGet(
        "https://gist.githubusercontent.com/technorav3nn/e01810542055cefa57f8597388116b5e/raw/9cd4e5f949906d51ee0cd667f4c545a1e6ebb151/ESP.lua"
    )
)()

-- // ESP Object Listeners
if game:GetService("Workspace").Ignored:FindFirstChild("WinterMAP") then
    ESP:AddObjectListener(
        game:GetService("Workspace").Ignored.WinterMAP.Sleigh,
        {
            Name = "MeshPart",
            CustomName = "Sleigh",
            Color = Color3.fromRGB(235, 57, 34),
            IsEnabled = "Sleigh"
        }
    )
end

ESP:AddObjectListener(
    game:GetService("Workspace").Ignored.Drop,
    {
        Color = Color3.new(0, 1, 0.050980),
        Validator = function(obj)
            return obj.Name == "MeshPart" or obj.Name == "MoneyDrop"
        end,
        PrimaryPart = function(obj)
            local hrp = obj
            return hrp
        end,
        CustomName = function(obj)
            return (obj.Name == "MeshPart" and "Dropped Cash") or (obj.Name == "MoneyDrop" and "Wallet Dropped Cash")
        end,
        IsEnabled = "Cash"
    }
)

-- // Disable ESP Players and other stuff on load
ESP.Players = false
ESP.Tracers = false
ESP.Boxes = true
ESP.Names = true

ESP.Sleigh = false

ESP:Toggle(true)

-- // Anti Cheat Bypass Loaded
local acBypassLoaded = false

-- // Player Target Functions
local Targeter = {}

function Targeter:BagPlayer(playerName)
    local function buyBag()
        local bag = game:GetService("Workspace").Ignored.Shop["[BrownBag] - $25"]
        localPlayer.Character.HumanoidRootPart.CFrame = bag.Head.CFrame
        task.wait(0.1)
        fireclickdetector(bag.ClickDetector, math.huge)
        task.wait()
    end
    local targetPlayer = game.Players[playerName]
    if targetPlayer then
        if not localPlayer.Character:FindFirstChild("[BrownBag]") then
            buyBag()
        end
        local tool =
            localPlayer.Backpack:FindFirstChild("[BrownBag]") or localPlayer.Character:FindFirstChild("[BrownBag]")

        tool.Parent = localPlayer.Character
        repeat
            localPlayer.Character["[BrownBag]"]:Activate()
            targetPlayer.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame
            task.wait()
        until targetPlayer.Character:FindFirstChild("Christmas_Sock")
    end
end

-- // Auto Rob Functions
local function getCashiers()
    local filteredCashiers = {}
    for _, cashier in pairs(game:GetService("Workspace").Cashiers:GetChildren()) do
        if (cashier.Humanoid.Health > 0) and cashier:FindFirstChild("Head") then
            table.insert(filteredCashiers, cashier)
        end
    end
    return filteredCashiers
end

local function collectNearbyCash()
    local droppedCash = game:GetService("Workspace").Ignored.Drop
    for _, v in pairs(droppedCash:GetDescendants()) do
        if
            v:IsA("ClickDetector") and
                (v.Parent.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 18
         then
            repeat
                task.wait()
                fireclickdetector(v)
            until not v or not v.Parent.Parent
        end
    end
end

local function tpPlayer(cf)
    playerChar.HumanoidRootPart.CFrame = cf
end

-- // Aiming Module

-- // UI Components
local win =
    SolarisLib:New(
    {
        Name = "Floppa Hub - Da Hood",
        FolderToSave = "floppaHubStuff"
    }
)

local playerTab = win:Tab("Player")
do
    local playerCombatSec = playerTab:Section("Player Combat")
    do
        playerCombatSec:Toggle(
            "Auto Stomp",
            false,
            "autoStomp",
            function(bool)
                flags["autoStomp"] = bool
                renderStepped:Connect(
                    function()
                        if flags.autoStomp then
                            task.wait()
                            game:GetService("ReplicatedStorage").MainEvent:FireServer("Stomp")
                        end
                    end
                )
            end
        )
        playerCombatSec:Toggle(
            "Anti Jump Cooldown",
            false,
            "antiJump",
            function(bool)
                if bool then
                    playerChar:FindFirstChildWhichIsA("Humanoid").Name = "Humz"
                    playerChar:FindFirstChildWhichIsA("Humanoid").WalkSpeed = 17
                else
                    playerChar:FindFirstChildWhichIsA("Humanoid").Name = "Humanoid"
                    playerChar:FindFirstChildWhichIsA("Humanoid").WalkSpeed = 16
                end
            end
        )
        playerCombatSec:Toggle(
            "Anti Slow",
            false,
            "antiSlow",
            function(bool)
                flags.antiSlow = bool
                playerChar.BodyEffects.Movement.ChildAdded:Connect(
                    function(child)
                        if flags.antiSlow then
                            child:Destroy()
                        end
                    end
                )
            end
        )
        playerCombatSec:Toggle(
            "Anti Grab",
            false,
            "antiGrab",
            function(bool)
                flags.antiGrab = bool
                local function onChildAdded()
                    if game.Players.LocalPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT") and flags.antiGrab then
                        game.Players.LocalPlayer.Character.GRABBING_CONSTRAINT:Destroy()
                    end
                end
                if flags.antiGrab then
                    onChildAdded()
                end
                playerChar.ChildAdded:Connect(onChildAdded)
            end
        )
    end
    local playerJailSec = playerTab:Section("Jail")
    do
        playerJailSec:Button(
            "Unjail",
            function()
                if localPlayer.DataFolder.Information.Jail.Value ~= 0 then
                    SolarisLib:Notification("Info", "You cannot unjail yourself if you arent in jail!")
                    return
                elseif localPlayer.DataFolder.Officer.Value == 0 then
                    SolarisLib:Notification("Info", "You cannot unjail yourself if you are a Police Officer!")
                    return
                end
                local keyTool = game:GetService("Workspace").Ignored.Shop["[Key] - $125"]
                local oldCf = playerChar.HumanoidRootPart.CFrame

                playerChar.HumanoidRootPart.CFrame = keyTool.Head.CFrame + Vector3.new(0, 2, 0)
                task.wait(0.4)
                fireclickdetector(keyTool.ClickDetector, math.huge)
                task.wait(0.1)
                if localPlayer.Backpack:FindFirstChild("[Key]") then
                    playerChar.Humanoid:EquipTool(localPlayer.Backpack:FindFirstChild("[Key]"))
                end
            end
        )
        playerJailSec:Button(
            "Unban",
            function()
                game.Players.LocalPlayer.Character.Humanoid.Health = 0
                game.Players.LocalPlayer.Character:Destroy()
                local function Unban()
                    repeat
                        task.wait()
                    until game.Players.LocalPlayer.Character:FindFirstChild("BodyEffects") and
                        game.Players.LocalPlayer.Character.BodyEffects:FindFirstChild("SpecialParts") and
                        not game.Players.LocalPlayer.Character:FindFirstChild("ForceField_TESTING")
                    local loaded = Instance.new("Folder")
                    loaded.Name = "FULLY_LOADED_CHAR"
                    loaded.Parent = game.Players.LocalPlayer.Character
                    game.Players.LocalPlayer.Character.BodyEffects.SpecialParts:Destroy()
                    game:GetService("Players").LocalPlayer.PlayerGui.MainScreenGui.TimerJail:Destroy()
                end
                task.wait(5.3)
                game.Players.LocalPlayer.CharacterAdded:Connect(Unban)
                Unban()
            end
        )
    end
    local playerEffectsSec = playerTab:Section("Effects")
    do
        playerEffectsSec:Toggle(
            "Anti Flashbang",
            false,
            "antiFlash",
            function(bool)
                flags.antiFlash = bool
                local function onChildAdded(child)
                    if flags.antiFlash and child.Name == "whiteScreen" then
                        child:Destroy()
                    end
                end
                localPlayer.PlayerGui.MainScreenGui.ChildAdded:Connect(onChildAdded)
            end
        )
        playerEffectsSec:Toggle(
            "Anti Pepper Spray",
            false,
            "antiPepper",
            function(bool)
                flags.antiPepper = bool
                local function onChildAdded(child)
                    if flags.antiPepper and child.Name == "PepperSpray" then
                        child:Destroy()
                    end
                end
                localPlayer.PlayerGui.MainScreenGui.ChildAdded:Connect(onChildAdded)
            end
        )
        playerEffectsSec:Toggle(
            "Anti Snowball Effect",
            false,
            "antiSnow",
            function(bool)
                flags.antiSnow = bool
                local function onChildAdded(child)
                    if flags.antiSnow and child.Name == "SNOWBALLFRAME" then
                        child:Destroy()
                    end
                end
                localPlayer.PlayerGui.MainScreenGui.ChildAdded:Connect(onChildAdded)
            end
        )
    end
    local playerMovementSec = playerTab:Section("Movement")
    do
        playerMovementSec:Slider(
            "WalkSpeed",
            16,
            300,
            16,
            1,
            "walkspeedSlider",
            function(t)
                if not acBypassLoaded then
                    loadstring(
                        game:HttpGet(
                            "https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Games/Da%20Hood/AntiCheatBypass.lua"
                        )
                    )()
                    acBypassLoaded = true
                end
                localPlayer.Character.Humanoid.WalkSpeed = t
            end
        )
        playerMovementSec:Slider(
            "JumpPower",
            50,
            250,
            50,
            1,
            "jumpPowerSlider",
            function(t)
                if not acBypassLoaded then
                    loadstring(
                        game:HttpGet(
                            "https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Games/Da%20Hood/AntiCheatBypass.lua"
                        )
                    )()
                    acBypassLoaded = true
                end
                localPlayer.Character.Humanoid.JumpPower = t
            end
        )
    end
    local playerCameraSec = playerTab:Section("Camera")
    do
        playerCameraSec:Toggle(
            "Infinite Zoom",
            false,
            "infZoom",
            function(bool)
                flags.infZoom = bool
                localPlayer.CameraMaxZoomDistance = flags.infZoom and 9e9 or 100
            end
        )
        playerCameraSec:Slider(
            "FOV",
            70,
            200,
            70,
            1,
            "fovSlider",
            function(value)
                --- @type Camera
                local cam = game.Workspace.Camera
                cam.FieldOfView = value
            end
        )
    end
end

local worldTab = win:Tab("World")
do
    local worldViewingSec = worldTab:Section("View")
    do
        worldViewingSec:Toggle(
            "No Fog",
            false,
            "noFog",
            function(bool)
                if bool then
                    game:GetService("Lighting").FogEnd = 10000000000
                else
                    game:GetService("Lighting").FogEnd = 400
                end
            end
        )
        worldViewingSec:Button(
            "Full Bright",
            function()
                local lighting = game:GetService("Lighting")
                local function doLighting()
                    if flags.fullBright then
                        lighting.TimeOfDay = "14:00:00"
                        lighting.Brightness = 2
                        lighting.ColorCorrection.Brightness = 0.1
                        lighting.ColorCorrection.Saturation = 0.1
                        lighting.Bloom.Intensity = 0.1
                    end
                end
                doLighting()
                lighting.Changed:Connect(doLighting)
            end
        )
    end
end

local farmingTab = win:Tab("Farming")
do
    local farmingSec = farmingTab:Section("Auto farming")
    do
        farmingSec:Toggle(
            "Auto Rob",
            false,
            "autoRob",
            function(bool)
                flags.autoRob = bool

                if flags.autoRob then
                    repeat
                        if not flags.autoRob then
                            break
                        end
                        task.wait()
                        local cashiers = getCashiers()
                        if #cashiers == 0 then
                            repeat
                                cashiers = getCashiers()

                                task.wait()
                            until #cashiers ~= 0
                        end

                        local randomCashier = cashiers[math.random(1, #cashiers)]

                        local combatTool = nil
                        tpPlayer(randomCashier.Head.CFrame * CFrame.new(1, -0.7, 3))
                        if localPlayer.Backpack:FindFirstChild("Combat") then
                            playerChar.Humanoid:EquipTool(localPlayer.Backpack.Combat)
                            combatTool = playerChar.Combat
                        elseif playerChar:FindFirstChild("Combat") then
                            combatTool = playerChar.Combat
                        end
                        repeat
                            task.wait()
                            tpPlayer(randomCashier.Head.CFrame * CFrame.new(1, -0.7, 3))
                            combatTool:Activate()
                        until randomCashier.Humanoid.Health < 0 or not randomCashier
                        collectNearbyCash()
                        task.wait(0.4)
                    until not flags.autoRob
                end
            end
        )
    end
end

local visualsTab = win:Tab("Visuals")
do
    local espObjectSec = visualsTab:Section("ESP Listeners")
    do
        espObjectSec:Toggle(
            "Player ESP",
            false,
            "plrESP",
            function(bool)
                ESP.Players = bool
            end
        )
        if game:GetService("Workspace").Ignored:FindFirstChild("WinterMAP") then
            espObjectSec:Toggle(
                "Sleigh ESP",
                false,
                "sEESP",
                function(bool)
                    ESP.Sleigh = bool
                end
            )
        end

        espObjectSec:Toggle(
            "Dropped Cash ESP",
            false,
            "dcESP",
            function(bool)
                ESP.Cash = bool
            end
        )
    end
    local espOptionsSec = visualsTab:Section("ESP Options")
    do
        espOptionsSec:Toggle(
            "Boxes",
            true,
            "boxes",
            function(bool)
                ESP.Boxes = bool
            end
        )
        espOptionsSec:Toggle(
            "Tracers",
            false,
            "tracers",
            function(bool)
                ESP.Tracers = bool
            end
        )
        espOptionsSec:Toggle(
            "Names",
            true,
            "names",
            function(bool)
                ESP.Names = bool
            end
        )
    end
end

local aimingTab = win:Tab("Aiming")
do
    local silentAimSec = aimingTab:Section("Silent Aim")
    do
        silentAimSec:Toggle(
            "Toggle Silent Aim",
            false,
            "toggleSilentAim",
            function(bool)
                flags.silentAimToggle = bool
            end
        )
    end
end

local autoBuyTab = win:Tab("Auto Buys")
do
    local abSingleSelect = autoBuyTab:Section("Auto Buying (Single Select)")
    do
        abSingleSelect:Dropdown(
            "Select items to buy",
            itemsList,
            "",
            "autoSingle",
            function(v)
                flags["autoBuySingleSelected"] = v
            end
        )

        abSingleSelect:Button(
            "Buy Item Selected",
            function()
                local itemsSelected = flags.autoBuySingleSelected
                local itemFromTable = items[itemsSelected]

                if itemFromTable then
                    print("Got item from table")
                    itemFromTable.func(players.LocalPlayer.Character.HumanoidRootPart)
                end
            end
        )
    end
    local abSec = autoBuyTab:Section("Auto Buying (Multi Select)")
    do
        abSec:MultiDropdown(
            "Select items to buy",
            itemsList,
            {},
            "autoBuySelected",
            function(selectedList)
                flags["autoBuySelected"] = selectedList
            end
        )

        abSec:Button(
            "Buy Items Selected",
            function()
                local itemsSelected = flags.autoBuySelected
                for _, v in pairs(itemsSelected) do
                    print("Here1")
                    print(v)
                    local itemFromTable = items[v]

                    if itemFromTable then
                        print("Got item from table")
                        itemFromTable.func(players.LocalPlayer.Character.HumanoidRootPart)
                    end
                end

                sFlags.autoBuySelected.Value = {}
            end
        )
    end

    local ammoSec = autoBuyTab:Section("Auto Buying Ammo")
    do
        ammoSec:Dropdown(
            "Ammo Chosen",
            ammoItems,
            "",
            "ammoChosen",
            function(t)
                flags["ammoChosen"] = t
            end
        )
        ammoSec:Slider(
            "Amount To Buy",
            0,
            25,
            0,
            1,
            "amountOfAmmo",
            function(t)
                flags["amountToBuy"] = t
            end
        )
        ammoSec:Button(
            "Buy",
            function()
                local idx = 0
                repeat
                    task.wait(0.3)
                    items[flags.ammoChosen].func(players.LocalPlayer.Character.HumanoidRootPart)
                    idx = idx + 1
                until idx == flags.amountToBuy
            end
        )
    end
end

players.LocalPlayer.CharacterAdded:Connect(
    function(char)
        playerChar = char
    end
)

--#region Docs
--[[
--sec:Button(title <string>, callback <function>)
sec:Button(
    "Button",
    function()
        SolarisLib:Notification("Test", "This is a notification test.")
    end
)

--sec:Toggle(title <string>,default <boolean>, flag <string>, callback <function>)
local toggle =
    sec:Toggle(
    "Toggle",
    false,
    "Toggle",
    function(t)
        print(t)
    end
)


toggle:Set(state <boolean>)

--sec:Slider(title <string>,default <number>,max <number>,minimum <number>,increment <number>, flag <string>, callback <function>)
local slider =
    sec:Slider(
    "Slider",
    0,
    25,
    0,
    2.5,
    "Slider",
    function(t)
        print(t)
    end
)


slider:Set(state <number>)

--sec:Dropdown(title <string>,options <table>,default <string>, flag <string>, callback <function>)
local dropdown =
    sec:Dropdown(
    "Dropdown",
    {"a", "b", "c", "d", "e"},
    "",
    "Dropdown",
    function(t)
        print(t)
    end
)


Dropdown:Refresh(options <table>, deletecurrent <boolean>)
Dropdown:Set(option <string>)

--sec:MultiDropdown(title <string>,options <table>,default <table>, flag <string>, callback <function>)
local multidropdown =
    sec:MultiDropdown(
    "Multi Dropdown",
    {"a", "b", "c", "d", "e"},
    {"b", "c"},
    "Dropdown",
    function(t)
        print(table.concat(t, ", "))
    end
)

Dropdown:Refresh(options <table>, deletecurrent <boolean>)
Dropdown:Set(option <table>)

--sec:Colorpicker(title <string>, default <color3>, flag <string>, callback <function>)
sec:Colorpicker(
    "Colorpicker",
    Color3.fromRGB(255, 255, 255),
    "Colorpicker",
    function(t)
        print(t)
    end
)

--sec:Textbox(title <string> ,disappear <boolean>, callback <function>)
sec:Textbox(
    "Textbox",
    true,
    function(t)
        print(t)
    end
)

--sec:Bind(title <string>, default <keycode>, hold <boolean>, flag <string>, callback <function>)
sec:Bind(
    "Hold Bind",
    Enum.KeyCode.E,
    true,
    "BindHold",
    function(t)
        print(t)
    end
)

sec:Bind(
    "Normal Bind",
    Enum.KeyCode.F,
    false,
    "BindNormal",
    function()
        print("Bind pressed")
    end
)

bind:Set(state <keycode>)
--sec:Label(text <string>)
local label = sec:Label("Label")

label:Set(text <string>)
--]]
--#endregion
