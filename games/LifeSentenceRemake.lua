-- // Destroy excess GUIS
--for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
--    if v:FindFirstChild("MainFrameHolder") then
--        v:Destroy()
--    end
--end

-- // Flag System
local flags = {
    lootColor = Color3.fromRGB(21, 255, 0)
}
function flags:SetFlag(name, value)
    flags[name] = value
end

-- // ESP Library and UI
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local SolarisLib = loadstring(game:HttpGet("https://solarishub.dev/SolarisLib.lua"))()

-- // ESP Listeners
ESP:AddObjectListener(
    game:GetService("Workspace").Robbable,
    {
        ColorDynamic = function()
            return flags.lootColor
        end,
        Validator = function(obj)
            return obj.Name == "Safe"
        end,
        PrimaryPart = function(obj)
            return obj.HumanoidRootPart
        end,
        IsEnabled = "Loot"
    }
)

-- // Services
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- // Components
local lockerTakeDropdown = nil
local lockerStoreDropdown

-- // Teleports
local teleports = {
    ["Cells"] = CFrame.new(
        93.3441772,
        4.9634347,
        86.6288757,
        0.0192873031,
        8.95967887e-08,
        0.999813974,
        -7.60488561e-09,
        1,
        -8.94667522e-08,
        -0.999813974,
        -5.87789906e-09,
        0.0192873031
    ),
    ["Gym"] = CFrame.new(
        167.23764,
        5.06953669,
        80.5586319,
        0.0309240352,
        -5.96748464e-08,
        -0.999521732,
        -8.46291002e-08,
        1,
        -6.23217247e-08,
        0.999521732,
        8.65158682e-08,
        0.0309240352
    ),
    ["Recreation"] = CFrame.new(
        -16.2303638,
        4.9634347,
        86.3241119,
        0.00209700409,
        1.24492878e-08,
        0.999997795,
        2.62464078e-10,
        1,
        -1.2449866e-08,
        -0.999997795,
        2.88570917e-10,
        0.00209700409
    ),
    ["Guard Hall / Main Hall"] = CFrame.new(
        -65.6404037,
        4.9634347,
        -26.5750847,
        -0.00467414735,
        9.77900783e-09,
        0.999989092,
        1.86495495e-08,
        1,
        -9.69194236e-09,
        -0.999989092,
        1.86040428e-08,
        -0.00467414735
    ),
    ["Laundry Hall"] = CFrame.new(
        -69.4472351,
        4.9634347,
        -78.3069077,
        -0.0233833678,
        -6.99721312e-08,
        0.999726593,
        -9.05602349e-09,
        1,
        6.97794533e-08,
        -0.999726593,
        -7.4218689e-09,
        -0.0233833678
    ),
    ["Laundry Room"] = CFrame.new(
        -106.425659,
        4.9634347,
        -78.114418,
        -0.00977196265,
        1.61204738e-08,
        0.999952257,
        3.47977647e-10,
        1,
        -1.61178431e-08,
        -0.999952257,
        1.9045808e-10,
        -0.00977196265
    ),
    ["Yard"] = CFrame.new(
        -20.4292564,
        3.96373844,
        -25.0898685,
        -0.00749102421,
        1.34022695e-08,
        -0.999971926,
        -2.32825386e-08,
        1,
        1.35770604e-08,
        0.999971926,
        2.3383592e-08,
        -0.00749102421
    ),
    ["Coal Mine"] = CFrame.new(
        -70.6485214,
        4.02302027,
        -163.041122,
        0.999665737,
        2.43288891e-08,
        -0.0258526802,
        -2.41234765e-08,
        1,
        8.25734503e-09,
        0.0258526802,
        -7.63092878e-09,
        0.999665737
    ),
    ["Labour Hall"] = CFrame.new(
        -72.2552719,
        4.9634347,
        -124.690331,
        0.0275639817,
        -9.05634252e-08,
        -0.99962002,
        6.54366232e-08,
        1,
        -8.87934704e-08,
        0.99962002,
        -6.29642543e-08,
        0.0275639817
    ),
    ["Solitary Confinment"] = CFrame.new(
        -16.4650574,
        4.9634347,
        -162.806808,
        0.999902427,
        -2.69807732e-08,
        -0.0139690861,
        2.7804397e-08,
        1,
        5.87663074e-08,
        0.0139690861,
        -5.91489773e-08,
        0.999902427
    ),
    ["Sewage Hall"] = CFrame.new(
        79.3617477,
        4.9634347,
        -127.682693,
        -0.0132725332,
        -4.72952288e-10,
        -0.999911904,
        2.10091375e-08,
        1,
        -7.51863016e-10,
        0.999911904,
        -2.10172661e-08,
        -0.0132725332
    ),
    ["Sewer"] = CFrame.new(
        93.6921463,
        -40.2785301,
        -98.9702759,
        -0.999801934,
        9.19965402e-08,
        0.0199026018,
        9.16262692e-08,
        1,
        -1.95159906e-08,
        -0.0199026018,
        -1.76885226e-08,
        -0.999801934
    ),
    ["Workshop"] = CFrame.new(
        182.666763,
        4.9634347,
        -101.838242,
        -0.0586158931,
        -6.19646823e-09,
        -0.998280585,
        6.51069376e-09,
        1,
        -6.58942811e-09,
        0.998280585,
        -6.88574442e-09,
        -0.0586158931
    ),
    ["Cafeteria"] = CFrame.new(
        138.783356,
        4.9634347,
        -44.2523727,
        -0.999920964,
        8.75553141e-09,
        0.0125744082,
        8.94097951e-09,
        1,
        1.46917882e-08,
        -0.0125744082,
        1.48030539e-08,
        -0.999920964
    ),
    ["Comissary Out"] = CFrame.new(
        35.4358482,
        3.96373844,
        -22.5108376,
        -0.999815941,
        1.22078374e-08,
        -0.0191863962,
        1.18726895e-08,
        1,
        1.75818968e-08,
        0.0191863962,
        1.73508674e-08,
        -0.999815941
    ),
    ["Comissary In"] = CFrame.new(
        34.3421707,
        4.42000389,
        -5.90772438,
        -0.999853551,
        -4.07219325e-08,
        0.017114779,
        -4.14728909e-08,
        1,
        -4.35227392e-08,
        -0.017114779,
        -4.42261623e-08,
        -0.999853551
    )
}
local tpKeys = {}

for tp, _ in pairs(teleports) do
    table.insert(tpKeys, tp)
end

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

local tools = {}
local toolKeys = {}

--#region Game Funcs
local function getAllBuyables()
    local ret = {}
    local buttonsPath = game:GetService("Workspace").Buttons
    for _, button in ipairs(buttonsPath:GetChildren()) do
        if button:FindFirstChild("Button") then
            table.insert(ret, button)
        end
    end
    return ret
end

local function getAllGunNames()
    local gunNamesRet = {}
    local gunConstants = require(game:GetService("ReplicatedStorage").GunConfigs)
    for gunName, _ in pairs(gunConstants) do
        table.insert(gunNamesRet, gunName)
    end
    table.sort(gunNamesRet)
    return gunNamesRet
end

local function getAllLockerItems()
    local ret = {}
    local lockerFolder = game:GetService("ReplicatedStorage").PlayerStats[localPlayer.Name].LockerFolder
    for _, item in ipairs(lockerFolder:GetChildren()) do
        table.insert(ret, item.ToolName.Value)
    end
    return ret
end

-- // Control Variables
local buyables = getAllBuyables()
local lockerItems = getAllLockerItems()

for _, buyable in ipairs(buyables) do
    tools[buyable.ToolName.Value] = buyable
    table.insert(toolKeys, buyable.ToolName.Value)
end

local function firePrompt(prompt)
    prompt.RequiresLineOfSight = false

    prompt:InputHoldBegin()
    task.wait(prompt.HoldDuration)
    prompt:InputHoldEnd()

    prompt.RequiresLineOfSight = true
end

local function getAllRobbables()
    local robbables = game:GetService("Workspace").Robbable
    local ret = {}
    for _, v in ipairs(robbables:GetChildren()) do
        if v:FindFirstChild("Door") and v.Door.Attachment.ProximityPrompt.Enabled then
            table.insert(ret, v)
        end
    end
    return ret
end

local function collectNearCash()
    for _, v in ipairs(game.Workspace:GetChildren()) do
        if v.Name == "DroppedCash" and v:FindFirstChild("ProximityPrompt") and v.ProximityPrompt.Enabled then
            v.ProximityPrompt.RequiresLineOfSight = false
            fireproximityprompt(v.ProximityPrompt)
            task.wait(0.1)
        end
    end
end

local function tpPlayer(cf)
    localPlayer.Character.HumanoidRootPart.CFrame = cf
end

local function getAllLoot()
    local lootSpawners = game:GetService("Workspace").LootSpawns
    for _, loot in ipairs(lootSpawners:GetChildren()) do
        if loot.Part.Attachment.ProximityPrompt.Enabled then
            local prompt = loot.Part.Attachment.ProximityPrompt
            prompt.RequiresLineOfSight = false
            tpPlayer(loot.Part.CFrame)
            task.wait(0.4)
            fireproximityprompt(prompt, math.huge)
        end
    end
end

local function getAllItemsInBackpackAndCharacter()
    local ret = {}
    local retNames = {}
    for _, tool in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") then
            if not tool:FindFirstChild("CantStore") then
                table.insert(ret, tool)
                table.insert(retNames, tool.Name)
            end
        end
    end
    for _, v in ipairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") then
            if not v:FindFirstChild("CantStore") then
                table.insert(ret, v)
                table.insert(retNames, v.Name)
            end
        end
    end
    return ret, retNames
end

local function storeItem(tool)
    local oldCf = localPlayer.Character.HumanoidRootPart.CFrame
    localPlayer.Character.HumanoidRootPart.CFrame =
        game:GetService("Workspace").Locker.HumanoidRootPart.CFrame + Vector3.new(0, 0, -3)
    task.wait(0.2)
    fireproximityprompt(game:GetService("Workspace").Locker.HumanoidRootPart.Attachment.ProximityPrompt)
    task.wait(0.3)
    if not localPlayer.Character:FindFirstChild(tool.Name) then
        localPlayer.Character.Humanoid:EquipTool(tool)
    end
    game:GetService("ReplicatedStorage").Events.LockerEvent:FireServer("Store", tool)
    task.wait(0.2)
    localPlayer.Character.HumanoidRootPart.CFrame = oldCf
end

local items, itemNames = getAllItemsInBackpackAndCharacter()

--#endregion

-- // Initialize ESP
ESP.Players = false
ESP.Loot = false
ESP.Robbables = false

ESP:Toggle(true)

-- // UI Components
local win =
    SolarisLib:New(
    {
        Name = "Floppa Hub - Life Sentence",
        FolderToSave = "floppaHubStuff"
    }
)
do
    local playerTab = win:Tab("Player")
    do
        local playerCombatSec = playerTab:Section("Player Combat")
        do
            playerCombatSec:Toggle(
                "Auto Stomp",
                false,
                "autoStomp",
                function(bool)
                    flags.autoStomp = bool
                    task.spawn(
                        function()
                            while flags.autoStomp and task.wait() do
                                game:GetService("ReplicatedStorage").Events.GunEvent:FireServer("EPress")
                            end
                        end
                    )
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
                    localPlayer.Character.Humanoid.JumpPower = t
                end
            )
        end
        local lockerTakeSec = playerTab:Section("Taking From Locker")
        do
            lockerTakeDropdown =
                lockerTakeSec:Dropdown(
                "Item to get from Locker",
                lockerItems,
                "",
                "lockerItem",
                function(value)
                    flags.lockerItem = value
                end
            )
            lockerTakeSec:Button(
                "Get Item",
                function()
                    for _, item in ipairs(
                        game:GetService("ReplicatedStorage").PlayerStats[localPlayer.Name].LockerFolder:GetChildren()
                    ) do
                        if flags.lockerItem and item.ToolName.Value == flags.lockerItem then
                            local oldCf = localPlayer.Character.HumanoidRootPart.CFrame
                            localPlayer.Character.HumanoidRootPart.CFrame =
                                game:GetService("Workspace").Locker.HumanoidRootPart.CFrame + Vector3.new(0, 0, -3)
                            task.wait(0.2)
                            fireproximityprompt(
                                game:GetService("Workspace").Locker.HumanoidRootPart.Attachment.ProximityPrompt
                            )
                            task.wait(0.4)
                            game:GetService("ReplicatedStorage").Events.LockerEvent:FireServer("Take", item)
                            task.wait(0.2)
                            localPlayer.Character.HumanoidRootPart.CFrame = oldCf
                        end
                    end
                end
            )
            lockerTakeSec:Button(
                "Refresh Locker Items",
                function()
                    lockerItems = getAllLockerItems()
                    lockerTakeDropdown:Refresh(lockerItems, true)
                end
            )
        end
        local lockerStoreSec = playerTab:Section("Store to Locker")
        do
            lockerStoreDropdown =
                lockerStoreSec:Dropdown(
                "Item to store to Locker",
                itemNames,
                "",
                "lockerStoreItem",
                function(value)
                    flags.lockerStoreItem = value
                end
            )
            lockerStoreSec:Button(
                "Store Item",
                function()
                    local tool = localPlayer.Backpack:FindFirstChild(flags.lockerStoreItem)
                    if tool then
                        storeItem(tool)
                    end
                end
            )
            lockerStoreSec:Button(
                "Refresh Items",
                function()
                    items, itemNames = getAllItemsInBackpackAndCharacter()
                    lockerStoreDropdown:Refresh(itemNames, true)
                end
            )
        end
    end
    local farmingTab = win:Tab("Farming")
    do
        local moneyFarmingSec = farmingTab:Section("Money Farming")
        do
            moneyFarmingSec:Toggle(
                "Auto Money Press",
                false,
                "autoPress",
                function(bool)
                    flags.autoPress = bool
                    if flags.autoPress then
                        --- @type ProximityPrompt
                        local prompt = game:GetService("Workspace").MoneyBench.MainPart.Attachment.ProximityPrompt
                        tpPlayer(prompt.Parent.Parent.CFrame)
                        task.wait(0.2)
                        task.spawn(
                            function()
                                while flags.autoPress and task.wait() do
                                    if not flags.autoPress then
                                        break
                                    end
                                    prompt:InputHoldBegin()
                                    task.wait(prompt.HoldDuration + 0.5)
                                    prompt:InputHoldEnd()
                                    print("prompt ended")
                                    prompt.MaxActivationDistance = 100
                                    task.wait(0.5)
                                end
                            end
                        )
                    end
                end
            )
            moneyFarmingSec:Toggle(
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
                            local robbables = getAllRobbables()

                            for _, v in ipairs(robbables) do
                                print("ROBBABLE " .. v.Name)
                                local camera = workspace.CurrentCamera

                                camera.CFrame = v.Door.CFrame

                                task.wait()
                                tpPlayer(v.Door.CFrame)
                                task.wait(0.2)
                                firePrompt(v.Door.Attachment.ProximityPrompt)
                                task.wait(0.3)
                                collectNearCash()
                                task.wait(0.3)

                                if not flags.autoRob then
                                    break
                                end
                            end
                            task.wait(3)
                        until not flags.autoRob
                    end
                end
            )
        end
        local lootFarmingSec = farmingTab:Section("Loot Farming")
        do
            lootFarmingSec:Toggle(
                "Auto Collect Loot",
                false,
                "autoRob",
                function(bool)
                    flags.autoLoot = bool
                    task.spawn(
                        function()
                            while flags.autoLoot and task.wait() do
                                getAllLoot()
                            end
                        end
                    )
                end
            )
        end
    end
    local trollingTab = win:Tab("Trolling")
    do
        local doorsSection = trollingTab:Section("Door Trolling")
        do
            doorsSection:Button(
                "Spam Doors Aura",
                function()
                    for _, v in ipairs(game:GetService("Workspace").Doors:GetChildren()) do
                        fireproximityprompt(v.OpenPart1.ProximityPrompt)
                        task.wait()
                        fireproximityprompt(v.OpenPart2.ProximityPrompt)
                    end
                end
            )
        end
        local otherTrollingSection = trollingTab:Section("Other Trolling Stuff")
        do
            if game:GetService("ReplicatedStorage").Events:FindFirstChild("SnowBreath") then
                otherTrollingSection:Toggle(
                    "Snow Head / Heavy Breathing",
                    false,
                    "heavyBreath",
                    function(bool)
                        flags.heavyBreath = bool
                        task.spawn(
                            function()
                                while flags.heavyBreath and task.wait(0.1) do
                                    game:GetService("ReplicatedStorage").Events.SnowBreath:FireServer("SnowBreath")
                                end
                            end
                        )
                    end
                )
            end
        end
    end

    local tpsTab = win:Tab("Teleports")
    do
        local teleportsSection = tpsTab:Section("Teleports")
        do
            for tpName, cf in pairs(teleports) do
                teleportsSection:Button(
                    tpName,
                    function()
                        local success, err =
                            pcall(
                            function()
                                players.LocalPlayer.Character.HumanoidRootPart.CFrame = cf
                            end
                        )
                        if not success and err then
                            SolarisLib:Notification("Info", "Error Occured: %s")
                        end
                    end
                )
            end
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

            espObjectSec:Toggle(
                "Robbable ESP",
                false,
                "sEESP",
                function(bool)
                    ESP.Loot = bool
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

            espOptionsSec:Colorpicker(
                "Loot ESP Color",
                flags.lootColor,
                "plrEspColorr",
                function(v)
                    flags.lootColor = v
                end
            )
        end
    end
    local buyingTab = win:Tab("Buying")
    do
        local itemBuySec = buyingTab:Section("Auto Buy Items")
        do
            itemBuySec:Dropdown(
                "Choose Item and Buy",
                toolKeys,
                "",
                "itemChosen",
                function(value)
                    flags.chosenItem = value
                    local chosen = flags.chosenItem
                    if chosen then
                        pcall(
                            function()
                                local tool = tools[chosen]
                                --- @type ProximityPrompt
                                local prompt = tool.Button.ProximityPrompt
                                local oldCframe = localPlayer.Character.HumanoidRootPart.CFrame
                                prompt.RequiresLineOfSight = false
                                tpPlayer(prompt.Parent.CFrame + Vector3.new(0, 3, 0))
                                task.wait(0.3)
                                fireproximityprompt(prompt, math.huge)
                                task.wait()
                                tpPlayer(oldCframe)
                                localPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

                                prompt.RequiresLineOfSight = true
                            end
                        )
                    end
                end
            )
        end
        local ammoBuySec = buyingTab:Section("Auto Buy Ammo")
        do
            ammoBuySec:Dropdown(
                "Choose Gun",
                getAllGunNames(),
                "",
                "ammoChosen",
                function(value)
                    flags.ammoChosen = value
                end
            )
            ammoBuySec:Button(
                "Buy Ammo",
                function()
                    local oldCf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(53.302879333496, -36.932140350342, -160.31660461426)
                    task.wait(0.2)
                    fireproximityprompt(game:GetService("Workspace").Dummy.HumanoidRootPart.ProximityPrompt, math.huge)
                    task.wait(0.3)
                    game:GetService("ReplicatedStorage").Events.GunEvent:FireServer("BuyAmmo", flags.ammoChosen)
                    task.wait(0.3)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCf
                end
            )
        end
    end
    local craftingTab = win:Tab("Crafting")
    do
        local craftingSec = craftingTab:Section("Crafting")
        do
            craftingSec:Dropdown(
                "Choose Gun to Craft",
                {"Spaz", "Glock", "AR", "Sawed", "Uzi", "Flare", "Revolver"},
                "",
                "gunToCraft",
                function(value)
                    flags.gunToCraft = value
                end
            )
            craftingSec:Button(
                "Begin Craft",
                function()
                    local oldCf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(186.46301269531, 7.7288360595703, -113.45082092285)
                    task.wait(0.1)
                    fireproximityprompt(
                        game:GetService("Workspace").WorkBench.MainPart.Attachment.ProximityPrompt,
                        math.huge
                    )
                    task.wait(0.2)
                    game:GetService("ReplicatedStorage").Events.CraftEvent:FireServer(flags.gunToCraft .. "Frame")
                    task.wait(0.3)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCf
                end
            )
        end
    end
    local miscTab = win:Tab("Misc")
    do
    end
end

task.spawn(
    function()
        local vu = game:GetService("VirtualUser")
        localPlayer.Idled:Connect(
            function()
                vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
            end
        )
        while task.wait(1) do
            pcall(
                function()
                    game:GetService("Players").LocalPlayer.Backpack.Local.Dead:Destroy()
                end
            )
        end
    end
)

task.spawn(
    function()
        while task.wait(10) do
            local oldItems = lockerItems
            lockerItems = getAllLockerItems()
            lockerTakeDropdown:Refresh(lockerItems, true)
            items, itemNames = getAllItemsInBackpackAndCharacter()
            lockerStoreDropdown:Refresh(itemNames, true)
        end
    end
)
