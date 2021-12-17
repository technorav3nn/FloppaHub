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

-- // ESP Library
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

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

-- // UI Components
local SolarisLib = loadstring(game:HttpGet("https://solarishub.dev/SolarisLib.lua"))()
local sFlags = SolarisLib.Flags

local win =
    SolarisLib:New(
    {
        Name = "Floppa Hub - Da Hood",
        FolderToSave = "floppaHubStuff"
    }
)

local playerTab = win:Tab("Player")
do
    local playerCombatTab = playerTab:Section("Player Combat")
    do
        playerCombatTab:Toggle(
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
        playerCombatTab:Toggle(
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
        playerCombatTab:Toggle(
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
    end
    local playerJailTab = playerTab:Section("Jail")
    do
        playerJailTab:Button(
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
        playerJailTab:Button(
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
    local playerEffectsTab = playerTab:Section("Effects")
    do
        playerEffectsTab:Toggle(
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
        playerEffectsTab:Toggle(
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
        playerEffectsTab:Toggle(
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
end

local farmingTab = win:Tab("Farming")
do
    local function getCashier()
        local cashiers = game:GetService("Workspace").Cashiers
        return cashiers[math.random(1, #cashiers:GetChildren())]
    end
    local function tpPlayer(cf)
        playerChar.HumanoidRootPart.CFrame = cf
    end

    local farmingSec = farmingTab:Section("Auto farming")
    do
        farmingSec:Toggle(
            "Auto Rob",
            false,
            "autoRob",
            function(bool)
                local cashier = getCashier()
                tpPlayer(cashier.Head.CFrame)
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
