if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/technorav3nn/kavo-fixed/main/Main.lua"))()
local Window = Library.CreateLib("Floppa Hub - Pet Simualtor X", "BloodTheme")

local players = game:GetService("Players")
local client = players.LocalPlayer

local runService = game:GetService("RunService")

local areas = {
    ["VIP"] = {"VIP"},
    ["Town"] = {"Town", "Town FRONT"},
    ["Forest"] = {"Forest", "Forest FRONT"},
    ["Beach"] = {"Beach", "Beach FRONT"},
    ["Mine"] = {"Mine", "Mine FRONT"},
    ["Winter"] = {"Winter", "Winter FRONT"},
    ["Glacier"] = {"Glacier", "Glacier Lake"},
    ["Desert"] = {"Desert", "Desert FRONT"},
    ["Volcano"] = {"Volcano", "Volcano FRONT"},
    ["Enchanted Forest"] = {"Enchanted Forest", "Enchanted Forest FRONT"},
    ["Ancient"] = {"Ancient"},
    ["Samurai"] = {"Samurai", "Samurai FRONT"},
    ["Candy"] = {"Candy"},
    ["Haunted"] = {"Haunted", "Haunted FRONT"},
    ["Hell"] = {"Hell"},
    ["Heaven"] = {"Heaven"},
    ["Ice Tech"] = {"Ice Tech"},
    ["Tech City"] = {"Tech City", "Tech City FRONT"},
    ["Dark Tech"] = {"Dark Tech", "Dark Tech FRONT"},
    ["Steampunk"] = {"Steampunk", "Steampunk FRONT"},
    ["Alien Forest"] = {"Alien Forest", "Alien Forest FRONT"},
    ["Alien Lab"] = {"Alien Forest", "Alien Lab FRONT"}
}

local areaList = {
    "VIP",
    "Town",
    "Forest",
    "Beach",
    "Mine",
    "Winter",
    "Glacier",
    "Desert",
    "Volcano",
    "Enchanted Forest",
    "Ancient",
    "Samurai",
    "Candy",
    "Haunted",
    "Hell",
    "Heaven",
    "Ice Tech",
    "Tech City",
    "Dark Tech",
    "Steampunk",
    "Alien Lab",
    "Alien Forest"
}

local flags = {}
function flags:SetFlag(name, value)
    flags[name] = value
end

-- // Pet Simualtor Functions
--#region Pet Simualtor Functions
-- local area = flags.autoFarmArea

local PetSim = {}

function PetSim:FarmCoin(coinId, petId)
    game.workspace["__THINGS"]["__REMOTES"]["join coin"]:InvokeServer({[1] = coinId, [2] = {[1] = petId}})
    game.workspace["__THINGS"]["__REMOTES"]["farm coin"]:FireServer({[1] = coinId, [2] = petId})
end

function PetSim:LeaveCoin(coinId, petId)
    local ohTable1 = {
        [1] = coinId,
        [2] = {
            [1] = petId
        }
    }

    workspace.__THINGS.__REMOTES["leave coin"]:InvokeServer(ohTable1)
end

function PetSim:GetPetIds()
    local ret = {}
    for _, value in pairs(getgc(true)) do
        if
            type(value) == "table" and rawget(value, "uid") and
                tostring(value.owner) == tostring(game.Players.LocalPlayer)
         then
            table.insert(ret, value.uid)
        end
    end
    return ret
end

function PetSim:GetAllCoinsInArea(area)
    local ret = {}
    local ListCoins = game.workspace["__THINGS"]["__REMOTES"]["get coins"]:InvokeServer({})[1]
    for i, v in pairs(ListCoins) do
        if table.find(areas[flags.autoFarmArea], v.a) then
            local val = v
            val["id"] = i
            table.insert(ret, val)
        end
    end
    return ret
end

function PetSim:GetSmallestCoinTable(area)
    local coins = PetSim:GetAllCoinsInArea(area)
    function getKeys(tbl, func)
        local keys = {}
        for key in pairs(tbl) do
            table.insert(keys, key)
        end
        table.sort(
            keys,
            function(a, b)
                return func(tbl[a].h, tbl[b].h)
            end
        )
        return keys
    end
    local sorted =
        getKeys(
        coins,
        function(a, b)
            return a < b
        end
    )
    local ret = {}

    for _, v in pairs(sorted) do
        table.insert(ret, coins[v])
    end

    return ret
end

function PetSim:GetHighestCoinTable(area)
    local coins = PetSim:GetAllCoinsInArea(area)
    function getKeys(tbl, func)
        local keys = {}
        for key in pairs(tbl) do
            table.insert(keys, key)
        end
        table.sort(
            keys,
            function(a, b)
                return func(tbl[a].h, tbl[b].h)
            end
        )
        return keys
    end
    local sorted =
        getKeys(
        coins,
        function(a, b)
            return a > b
        end
    )
    local ret = {}

    for _, v in pairs(sorted) do
        table.insert(ret, coins[v])
    end

    return ret
end

function PetSim:GetAllEggs()
    local toReturn = {}
    local toReturnKeys = {}

    local eggsFolder = game:GetService("ReplicatedStorage").Game.Eggs

    for _, v in pairs(eggsFolder:GetDescendants()) do
        if v:IsA("ModuleScript") then
            local module = require(v)
            if module.hatchable and not module.disabled then
                local displayNameOrModuleName = module.displayName or v.Name

                toReturn[displayNameOrModuleName] = displayNameOrModuleName
                table.insert(toReturnKeys, displayNameOrModuleName)
            end
        end
    end
    return toReturn, toReturnKeys
end
--#endregion PetSimFunctions

-- // Pet Sim Variables
local petIds = PetSim:GetPetIds()
local eggs, eggList = PetSim:GetAllEggs()

local currentCoinId = nil

-- // UI Library

local farmingTab = Window:NewTab("Farming")
do
    local farmingSection = farmingTab:NewSection("Farming")
    do
        farmingSection:NewDropdown(
            "Area",
            "Select the area to use",
            areaList,
            function(selected)
                flags:SetFlag("autoFarmArea", selected)
            end
        )
        farmingSection:NewDropdown(
            "Method",
            "Select the method to use",
            {"Smallest Value", "Highest Value", "Chests", "Random Coin"},
            function(method)
                flags:SetFlag("autoFarmMethod", method)
            end
        )
        farmingSection:NewToggle(
            "Auto Farm",
            "Starts the auto farm",
            function(state)
                flags:SetFlag("autoFarm", state)
                while task.wait() do
                    if flags.autoFarm then
                        -- local coins = PetSim:GetAllCoinsInArea(selectedArea)
                        -- local randomCoin = coins[math.random(1, #coins)].id

                        -- currentCoinId = randomCoin
                        local selectedArea = flags.autoFarmArea
                        local selectedMethod = flags.autoFarmMethod

                        if selectedMethod == "Smallest Value" then
                            local smallestCoins = PetSim:GetSmallestCoinTable(selectedArea)
                            print(selectedArea)
                            local i = 1
                            local currentCoin = smallestCoins[i].id
                            petIds = PetSim:GetPetIds()
                            currentCoinId = currentCoin

                            for _, id in pairs(petIds) do
                                PetSim:FarmCoin(currentCoin, id)
                            end
                            local dummyTable = {[1] = {}}
                            local orbsRemote = game.Workspace["__THINGS"]["__REMOTES"]["claim orbs"]
                            for i, v in pairs(game.workspace["__THINGS"].Orbs:GetChildren()) do
                                dummyTable[1][i] = v.Name
                            end
                            orbsRemote:FireServer(dummyTable)
                            task.wait(0.3)
                        elseif selectedMethod == "Highest Value" then
                            local highestCoins = PetSim:GetHighestCoinTable(selectedArea)
                            print(selectedArea)
                            local i = 1
                            local currentCoin = highestCoins[i].id
                            petIds = PetSim:GetPetIds()
                            currentCoinId = currentCoin

                            for _, id in pairs(petIds) do
                                PetSim:FarmCoin(currentCoin, id)
                            end
                            local dummyTable = {[1] = {}}
                            local orbsRemote = game.Workspace["__THINGS"]["__REMOTES"]["claim orbs"]
                            for i, v in pairs(game.workspace["__THINGS"].Orbs:GetChildren()) do
                                dummyTable[1][i] = v.Name
                            end
                            orbsRemote:FireServer(dummyTable)
                            task.wait(0.3)
                        end
                        repeat
                            runService.RenderStepped:Wait()
                        until (not game:GetService("Workspace")["__THINGS"].Coins:FindFirstChild(currentCoinId) or
                            not flags.autoFarm)
                    else
                        for _, id in pairs(petIds) do
                            PetSim:LeaveCoin(currentCoinId, id)
                        end
                        break
                    end
                end
            end
        )

        farmingSection:NewToggle(
            "Auto Collect Orbs",
            "Automatically Collects all Orbs",
            function(bool)
                flags:SetFlag("autoCollectOrbs", bool)
            end
        )

        farmingSection:NewToggle(
            "Auto Collect Lootbags",
            "Automatically Collects all Lootbags",
            function(bool)
                flags:SetFlag("autoCollectLootbags", bool)
            end
        )
    end
end

local eggsTab = Window:NewTab("Eggs")
do
    local openingSection = eggsTab:NewSection("Opening")
    do
        openingSection:NewDropdown(
            "Egg to Open",
            "The Egg you want to open",
            eggList,
            function(eggSelected)
                flags:SetFlag("eggToOpen", eggSelected)
            end
        )
        openingSection:NewDropdown(
            "Method",
            "The Method to use when you open the egg",
            {"Custom Amount", "Open / Stop opening with toggle"},
            function(methodSelected)
                flags:SetFlag("methodToUse", methodSelected)
            end
        )
        openingSection:NewSlider(
            "Amount of Eggs",
            "The amount of eggs to open (only if you chose the custom amount method)",
            100,
            1,
            function(value)
                flags:SetFlag("amountToOpen", tonumber(value))
            end
        )

        local startOpeningToggle
        startOpeningToggle =
            openingSection:NewToggle(
            "Toggle Opening",
            "Starts / Stops opening eggs",
            function(bool)
                local selectedMethod = flags.methodToUse
                local amountToOpen = flags.amountToOpen
                local eggToOpen = flags.eggToOpen

                flags:SetFlag("toggleEggs", bool)
                task.spawn(
                    function()
                        while flags.toggleEggs do
                            if selectedMethod == "Custom Amount" then
                                local amountOpened = 0
                                repeat
                                    local ohTable1 = {
                                        [1] = eggs[eggToOpen],
                                        [2] = flags.useTripleHatch
                                    }

                                    workspace.__THINGS.__REMOTES["buy egg"]:InvokeServer(ohTable1)
                                    amountOpened = amountOpened + 1
                                    task.wait(0.5)
                                until amountOpened == amountToOpen or not flags.toggleEggs
                                startOpeningToggle:UpdateToggle("Toggle Opening", false)
                                break
                            elseif selectedMethod == "Open / Stop opening with toggle" then
                                if not flags.toggleEggs then
                                    break
                                end
                                local ohTable1 = {
                                    [1] = eggs[eggToOpen],
                                    [2] = flags.useTripleHatch
                                }

                                workspace.__THINGS.__REMOTES["buy egg"]:InvokeServer(ohTable1)
                            end
                        end
                    end
                )
            end
        )
        openingSection:NewToggle(
            "Triple Hatch",
            "Whether to use the triple hatch gamepass (you need to own it)",
            function(bool)
                flags:SetFlag("useTripleHatch", bool)
            end
        )
    end

    local playerTab = Window:NewTab("Player")
    do
        local playerSection = playerTab:NewSection("Player")
        do
            playerSection:NewSlider(
                "Walkspeed",
                "Changes your Walkspeed (re execute if it doesnt work)",
                400,
                16,
                function(value)
                    client.Character.Humanoid.WalkSpeed = value
                end
            )
            playerSection:NewSlider(
                "JumpPower",
                "Changes your Jump power (re execute if it doesnt work)",
                400,
                50,
                function(value)
                    client.Character.Humanoid.JumpPower = value
                end
            )
            playerSection:NewSlider(
                "HipHeight",
                "Changes your Jump power (re execute if it doesnt work)",
                400,
                1,
                function(value)
                    client.Character.Humanoid.HipHeight = value
                end
            )
        end
    end
end

runService.Heartbeat:Connect(
    function()
        if flags.autoCollectOrbs then
            local dummyTable = {[1] = {}}
            local orbsRemote = game.Workspace["__THINGS"]["__REMOTES"]["claim orbs"]
            for i, v in pairs(game.workspace["__THINGS"].Orbs:GetChildren()) do
                dummyTable[1][i] = v.Name
            end
            orbsRemote:FireServer(dummyTable)
            task.wait(0.3)
        end
        if flags.autoCollectLootbags then
            task.wait()
            local lootBagsPath = game:GetService("Workspace")["__THINGS"].Lootbags
            for _, lootbag in pairs(lootBagsPath:GetChildren()) do
                local lootBagCFrame = lootbag.CFrame
                local lootBagId = lootbag.Name

                local ohTable1 = {
                    [1] = lootBagId,
                    [2] = lootBagCFrame
                }

                workspace.__THINGS.__REMOTES["collect lootbag"]:FireServer(ohTable1)
            end
        end
    end
)
