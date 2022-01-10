-- // Destroy excess GUIS
--for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
--    if v:FindFirstChild("MainFrameHolder") then
--        v:Destroy()
--    end
--end

-- // Flag System
local flags = {
    robbableColor = Color3.fromRGB(21, 255, 0)
}
function flags:SetFlag(name, value)
    flags[name] = value
end

-- // ESP Library and UI
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/PTrFUueU"))()

-- // UI Theme
Library.theme.accentcolor = Color3.new(0.011764, 0.521568, 1)
Library.theme.background = "rbxassetid://2151741365"
Library.theme.tilesize = 0.77
Library.theme.accentcolor2 = Color3.new(0.011764, 0.521568, 1)

-- // Bypass Anti Cheat
pcall(
    function()
        game:GetService("Players").LocalPlayer.Backpack.Local.Dead:Destroy()
    end
)

-- // ESP Listeners
ESP:AddObjectListener(
    game:GetService("Workspace").Robbable,
    {
        ColorDynamic = function()
            return flags.robbableColor
        end,
        PrimaryPart = function(obj)
            return obj.HumanoidRootPart
        end,
        IsEnabled = "Robbables"
    }
)

-- // Services
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- // Components
local lockerTakeDropdown = nil
local lockerStoreDropdown = nil

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

local function refreshDropdown(dropdown, newValues)
    for _, v in ipairs(dropdown:GetOptions()) do
        dropdown:Remove(v)
    end
    for _, v in ipairs(newValues) do
        dropdown:Remove(v)
        dropdown:Add(v)
    end

    dropdown:Set("")
end

-- // Targeting Functions
local function killPlayer(player, stomp)
    local toKill = player.Character

    local disconnected = false
    local connection

    localPlayer.CharacterAdded:Connect(
        function()
            local tool = localPlayer.Character:FindFirstChild("Fists") or localPlayer.Backpack:FindFirstChild("Fists")
            if not disconnected and tool then
                tool.Parent = localPlayer.Character
            end
        end
    )

    connection =
        runService.Heartbeat:Connect(
        function()
            local fistsTool =
                localPlayer.Character:FindFirstChild("Fists") or localPlayer.Backpack:FindFirstChild("Fists")
            if fistsTool.Parent == localPlayer.Backpack then
                fistsTool.Parent = localPlayer.Character
            end
            fistsTool:Activate()
            if
                localPlayer.Character.Humanoid.Health <= 0 or not workspace:FindFirstChild(toKill.Name) or
                    player.Backpack:WaitForChild("Stats").Downed.Value or
                    not player or
                    not game.Players:FindFirstChild(player.Name)
             then
                disconnected = true
                connection:Disconnect()
            end
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                toKill.HumanoidRootPart.CFrame + toKill.HumanoidRootPart.CFrame.lookVector * -1.5
        end
    )
    repeat
        task.wait()
    until disconnected
    if stomp then
        connection =
            runService.Heartbeat:Connect(
            function()
                if
                    player.Backpack:WaitForChild("Stats").Dead.Value or not player or
                        not game.Players:FindFirstChild(player.Name)
                 then
                    localPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    connection:Disconnect()
                end
                if not localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    localPlayer.CharacterAdded:Wait()
                    tpPlayer(toKill.Torso.CFrame)
                end
                game:GetService("ReplicatedStorage").Events.GunEvent:FireServer("EPress")
            end
        )
        repeat
            task.wait()
        until not connection.Connected
    end
end

-- // Get Player From String Function
local function getPlayerFromString(str, useDisplayName)
    for _, v in pairs(players:GetPlayers()) do
        if useDisplayName then
            if v.DisplayName:lower():sub(1, #str) == str:lower() then
                return v
            end
        else
            if v.Name:lower():sub(1, #str) == str:lower() then
                return v
            end
        end
    end
end

local items, itemNames = getAllItemsInBackpackAndCharacter()

--#endregion

-- // Initialize ESP
ESP.Players = false
ESP.Loot = false
ESP.Robbables = false

ESP:Toggle(true)

-- // UI Components

-- // UI Components
local Window = Library:CreateWindow("Floppa Hub", Vector2.new(492, 598), Enum.KeyCode.RightShift)
do
    local playerTab = Window:CreateTab("Player")
    do
        local playerCombatSec = playerTab:CreateSector("Combat", "left")
        do
            playerCombatSec:AddToggle(
                "Auto Stomp",
                false,
                function(bool)
                    task.spawn(
                        function()
                            while Library.flags.autoStomp and task.wait() do
                                game:GetService("ReplicatedStorage").Events.GunEvent:FireServer("EPress")
                            end
                        end
                    )
                end
            )
        end

        local playerMovementSec = playerTab:CreateSector("Movement", "left")
        do
            playerMovementSec:AddSlider(
                "WalkSpeed",
                16,
                16,
                400,
                1,
                function(value)
                    localPlayer.Character.Humanoid.WalkSpeed = value
                end,
                "playerWalkspeed"
            )
            playerMovementSec:AddSlider(
                "JumpPower",
                50,
                50,
                200,
                1,
                function(value)
                    localPlayer.Character.Humanoid.JumpPower = value
                end,
                "playerJumpPower"
            )
        end
        local targetSec = playerTab:CreateSector("Targeter", "left")
        do
            local currentTarget = targetSec:AddLabel("Target - None")

            targetSec:AddTextbox(
                "Target Name",
                players:GetPlayers()[math.random(1, #players:GetPlayers())].Name,
                function(value)
                    local target = getPlayerFromString(value, Library.flags.useDisplayName)
                    flags.target = target
                    if target then
                        currentTarget:Set("Target - " .. target.Name)
                    end
                end,
                "targetPlayer"
            )
            targetSec:AddToggle(
                "Use Display Name",
                false,
                function()
                end,
                "useDisplayName"
            )
            targetSec:AddSeperator("Target Functions")
            targetSec:AddButton(
                "Goto",
                function()
                    local target = flags.target
                    if target and target.Character:FindFirstChild("HumanoidRootPart") then
                        tpPlayer(target.Character:FindFirstChild("HumanoidRootPart").CFrame)
                    end
                end
            )
            targetSec:AddButton(
                "Knock",
                function()
                    local target = flags.target
                    if target then
                        killPlayer(target, Library.flags.stompTarget)
                    end
                end
            )
            targetSec:AddSeperator("Knock Options")

            targetSec:AddToggle(
                "Stomp Target",
                false,
                function()
                end,
                "stompTarget"
            )
            targetSec:AddToggle(
                "Arrest Target",
                false,
                function()
                end,
                "arrestTarget"
            )
        end
        local lockerTakeSec = playerTab:CreateSector("Taking from Locker", "right")
        do
            lockerTakeDropdown =
                lockerTakeSec:AddDropdown(
                "Item to get from Locker",
                lockerItems,
                "",
                false,
                function()
                end,
                "lockerItem"
            )
            lockerTakeSec:AddButton(
                "Get Item",
                function()
                    for _, item in ipairs(
                        game:GetService("ReplicatedStorage").PlayerStats[localPlayer.Name].LockerFolder:GetChildren()
                    ) do
                        if Library.flags.lockerItem and item.ToolName.Value == Library.flags.lockerItem then
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
            lockerTakeSec:AddButton(
                "Refresh Locker Items",
                function()
                    lockerItems = getAllLockerItems()
                    refreshDropdown(lockerTakeDropdown, lockerItems)
                end
            )
        end
        local lockerStoreSec = playerTab:CreateSector("Storing to Locker", "right")
        do
            lockerStoreDropdown =
                lockerStoreSec:AddDropdown(
                "Item to store to Locker",
                itemNames,
                "",
                false,
                function()
                end,
                "lockerStoreItem"
            )
            lockerStoreSec:AddButton(
                "Store Item",
                function()
                    local tool = localPlayer.Backpack:FindFirstChild(Library.flags.lockerStoreItem)
                    if tool then
                        storeItem(tool)
                    elseif localPlayer.Character:FindFirstChild(Library.flags.lockerStoreItem) then
                        storeItem(localPlayer.Character:FindFirstChild(Library.flags.lockerStoreItem))
                    end
                end
            )
            lockerStoreSec:AddButton(
                "Refresh Items",
                function()
                    items, itemNames = getAllItemsInBackpackAndCharacter()
                    refreshDropdown(lockerStoreDropdown, itemNames)
                end
            )
        end
        local trollingSec = playerTab:CreateSector("Trolling", "left")
        do
            trollingSec:AddButton(
                "Kill All",
                function()
                    for _, player in ipairs(players:GetPlayers()) do
                        if player.Name ~= localPlayer.Name then
                            killPlayer(player, true)
                        end
                    end
                end
            )
        end
    end
    local farmingTab = Window:CreateTab("Farming")
    do
        local moneyFarmingSec = farmingTab:CreateSector("Money Farming", "left")
        do
            moneyFarmingSec:AddToggle(
                "Auto Money Press",
                false,
                function()
                    if Library.flags.autoPress then
                        --- @type ProximityPrompt
                        local prompt = game:GetService("Workspace").MoneyBench.MainPart.Attachment.ProximityPrompt
                        tpPlayer(prompt.Parent.Parent.CFrame)
                        task.wait(0.2)
                        task.spawn(
                            function()
                                while Library.flags.autoPress and task.wait() do
                                    if not Library.flags.autoPress then
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
                end,
                "autoPress"
            )
            moneyFarmingSec:AddToggle(
                "Auto Rob",
                false,
                function()
                    if Library.flags.autoRob then
                        repeat
                            if not Library.flags.autoRob then
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

                                if not Library.flags.autoRob then
                                    break
                                end
                            end
                            task.wait(3)
                        until not flags.autoRob
                    end
                end,
                "autoRob"
            )
            local lootFarmingSec = farmingTab:CreateSector("Loot Farming", "right")
            do
                lootFarmingSec:AddToggle(
                    "Auto Collect Loot",
                    false,
                    function()
                        task.spawn(
                            function()
                                while Library.flags.autoLoot and task.wait() do
                                    getAllLoot()
                                end
                            end
                        )
                    end,
                    "autoLoot"
                )
            end
        end
    end
    local itemsTab = Window:CreateTab("Items")
    do
        local itemBuySec = itemsTab:CreateSector("Item Buys", "left")
        do
            itemBuySec:AddDropdown(
                "Choose Item",
                toolKeys,
                "",
                false,
                function()
                end,
                "itemChosen"
            )
            itemBuySec:AddButton(
                "Buy Chosen Item",
                function()
                    local chosen = Library.flags.itemChosen
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

        local ammoBuySec = itemsTab:CreateSector("Ammo Buys", "right")
        do
            ammoBuySec:AddDropdown(
                "Choose Item",
                getAllGunNames(),
                "",
                false,
                function()
                end,
                "ammoChosen"
            )
            ammoBuySec:AddButton(
                "Buy Ammo",
                function()
                    if not Library.flags.ammoChosen then
                        return
                    end
                    local oldCf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(53.302879333496, -36.932140350342, -160.31660461426)
                    task.wait(0.2)
                    fireproximityprompt(game:GetService("Workspace").Dummy.HumanoidRootPart.ProximityPrompt, math.huge)
                    task.wait(0.3)
                    game:GetService("ReplicatedStorage").Events.GunEvent:FireServer("BuyAmmo", Library.flags.ammoChosen)
                    task.wait(0.3)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCf
                end
            )
        end

        local craftingSec = itemsTab:CreateSector("Crafting Items", "left")
        do
            craftingSec:AddDropdown(
                "Choose Gun to Craft",
                {"Spaz", "Glock", "AR", "Sawed", "Uzi", "Flare", "Revolver"},
                "",
                false,
                function(value)
                end,
                "gunToCraft"
            )
            craftingSec:AddButton(
                "Begin Craft",
                function()
                    if not Library.flags.gunToCraft then
                        return
                    end
                    local oldCf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(186.46301269531, 7.7288360595703, -113.45082092285)
                    task.wait(0.3)
                    fireproximityprompt(
                        game:GetService("Workspace").WorkBench.MainPart.Attachment.ProximityPrompt,
                        math.huge
                    )
                    task.wait(0.3)
                    game:GetService("ReplicatedStorage").Events.CraftEvent:FireServer(
                        Library.flags.gunToCraft .. "Frame"
                    )
                    task.wait(0.3)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCf
                end
            )
        end
    end

    local teleportsTab = Window:CreateTab("Teleports")
    do
        local locationsSec = teleportsTab:CreateSector("Locations", "left")
        do
            locationsSec:AddDropdown(
                "TP To Location",
                tpKeys,
                "",
                false,
                function(tp)
                    local teleport = teleports[tp]
                    if teleport then
                        local success, err =
                            pcall(
                            function()
                                players.LocalPlayer.Character.HumanoidRootPart.CFrame = teleport
                            end
                        )
                        if not success then
                            error(err)
                        end
                    end
                end,
                "tpChosen"
            )
        end
    end

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
            espSec:AddToggle(
                "Robbables ESP",
                false,
                function(bool)
                    ESP.Robbables = bool
                end
            ):AddColorpicker(
                flags.robbableColor,
                function(color)
                    flags.robbableColor = color
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
        while task.wait(10) do
            lockerItems = getAllLockerItems()
            refreshDropdown(lockerTakeDropdown, lockerItems)
            items, itemNames = getAllItemsInBackpackAndCharacter()
            refreshDropdown(lockerStoreDropdown, itemNames)
        end
    end
)

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
