local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/technorav3nn/kavo-fixed/main/Main.lua"))()
local Window = Library.CreateLib("Floppa Hub - Islands", "Ocean")

-- // Services
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

-- // Flag System
local flags = {}
function flags:SetFlag(name, value)
    flags[name] = value
end

-- // Blocks List
local crops = {
    ["Berry"] = {name = "berryBush", stageToFarm = 2},
    ["Cactus"] = {name = "cactus", stageToFarm = 3}
}
local ores = {
    ["Iron"] = {name = "rockIron", stageToFarm = 1},
    ["Stone"] = {name = "rockStone", stageToFarm = 1},
    ["Coal"] = {name = "rockCoal", stageToFarm = 1}
}

local cropsList = {}
local oresList = {}

for k, _ in pairs(crops) do
    table.insert(cropsList, k)
end
for k, _ in pairs(ores) do
    table.insert(oresList, k)
end

-- // Mobs List
local mobs = {
    ["Slime"] = "slime",
    ["Slime King"] = "slimeKing",
    ["Skorpion"] = "skorpiron",
    ["Spirit"] = "spirit",
    ["Hostile Crab"] = "hostileCrab",
    ["Buffalkor"] = "buffalkor",
    ["Wizard"] = "wizardLizard"
}

local mobKeys = {}
for k, _ in pairs(mobs) do
    table.insert(mobKeys, k)
end

-- // Populating the weapons
local weaponsList = {}
local tools = game.Players.LocalPlayer.Backpack:GetChildren()

for _, tool in pairs(tools) do
    if tool:FindFirstChild("sword") then
        table.insert(weaponsList, tool.Name)
    end
end
-- // Functions for Islands
--#region Islands Functions

local Islands = {}

function Islands:GetLocalPlayerIsland()
    for _, island in pairs(game:GetService("Workspace").Islands:GetChildren()) do
        if island:IsA("Model") then
            local islandOwners = island:FindFirstChild("Owners")
            if islandOwners then
                local localPlayerId = localPlayer.UserId
                for _, id in pairs(islandOwners:GetChildren()) do
                    if id:IsA("NumberValue") and id.Value == localPlayerId then
                        return island, island.Name
                    end
                end
            end
        end
    end
end

function Islands:FarmCrop(cropName)
    local foundCrop = crops[cropName]
    if not foundCrop then
        error("Fatal Error: The Crop wasn't found inside the `blocks` table.")
        return
    end
    local island = Islands:GetLocalPlayerIsland()
    if island then
        local blocksPath = island.Blocks

        for _, block in pairs(blocksPath:GetChildren()) do
            if not flags.farmingToggle then
                return
            end
            if block.Name == foundCrop.name and tonumber(block.stage.Value) == foundCrop.stageToFarm then
                playerChar.HumanoidRootPart.CFrame = block.CFrame
                task.wait(0.1)

                local ohTable1 = {
                    ["player"] = game:GetService("Players").LocalPlayer,
                    ["player_tracking_category"] = "join_from_web",
                    ["model"] = block
                }

                game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_HARVEST_CROP_REQUEST:InvokeServer(
                    ohTable1
                )
                if flags.replaceCrop then
                    local ohTable1 = {
                        ["cframe"] = block.CFrame,
                        ["blockType"] = block.Name,
                        ["player_tracking_category"] = "join_from_web",
                        ["upperSlab"] = false
                    }

                    game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_PLACE_REQUEST:InvokeServer(
                        ohTable1
                    )
                end
            end
        end
    else
        error("Couldn't find local player island")
        return
    end
end

function Islands:FarmOre(oreName)
    local foundOre = ores[oreName]
    if not foundOre then
        warn("Fatal Error: The Crop wasn't found inside the `blocks` table.")
        return
    end
    local island = Islands:GetLocalPlayerIsland()
    if island then
        local blocksPath = island.Blocks

        for _, block in pairs(blocksPath:GetChildren()) do
            if not flags.oreFarmToggle then
                return
            end

            if block.Name == foundOre.name then
                playerChar.HumanoidRootPart.CFrame = block.CFrame + Vector3.new(0, 3, 0)
                local ohTable1 = {
                    ["player_tracking_category"] = "join_from_web",
                    ["part"] = block["1"],
                    ["block"] = block,
                    ["norm"] = Vector3.new(-3498.322265625, 37.062782287598, -3482.3693847656),
                    ["pos"] = block.Position
                }

                game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_BLOCK_HIT_REQUEST:InvokeServer(
                    ohTable1
                )
                task.wait(0.2)
            end
        end
    end
end
function Islands:SelectMob(mobName)
    for _, mob in pairs(game.Workspace.WildernessIsland.Entities:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
            if string.find(mob.Name:lower(), mobName) then
                return mob
            end
        end
    end
end

function Islands:AttackMob(mob, mobName)
    repeat
        if workspace.WildernessIsland.Entities:FindFirstChild(mobName) ~= mob then
            break
        end

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, 1, 0)
        task.wait()
        local ohTable1 = {
            ["crit"] = true,
            ["hitUnit"] = mob
        }
        game:GetService("ReplicatedStorage").rbxts_include.node_modules.net.out._NetManaged.CLIENT_SWING_SWORD:InvokeServer(
            ohTable1
        )
    until workspace.WildernessIsland.Entities:FindFirstChild(mobName) ~= mob
end

--#endregion

local farmingTab = Window:NewTab("Farming")
do
    local cropFarmingSection = farmingTab:NewSection("Crop Farming")
    do
        cropFarmingSection:NewDropdown(
            "Select Crop / Bush",
            "Selects a crop / bush to farm",
            cropsList,
            function(value)
                flags:SetFlag("selectedCrop", value)
            end
        )
        cropFarmingSection:NewToggle(
            "Replant Crop",
            "Whether to replant the crop or not once it is farmed",
            function(bool)
                flags:SetFlag("replaceCrop", bool)
            end
        )
        cropFarmingSection:NewToggle(
            "Start Farming",
            "Starts farming",
            function(bool)
                flags:SetFlag("farmingToggle", bool)

                task.spawn(
                    function()
                        while task.wait(0.1) and flags.farmingToggle do
                            if not flags.farmingToggle then
                                break
                            end
                            Islands:FarmCrop(flags.selectedCrop)
                        end
                    end
                )
            end
        )
    end
    local oreFarmingSection = farmingTab:NewSection("Ore Farming")
    do
        oreFarmingSection:NewDropdown(
            "Ore",
            "The ore to farm",
            oresList,
            function(value)
                flags:SetFlag("oreToFarm", value)
            end
        )
        oreFarmingSection:NewToggle(
            "Start Farming",
            "Starts farming the ore(s)",
            function(bool)
                flags:SetFlag("oreFarmToggle", bool)
                task.spawn(
                    function()
                        while task.wait(0.1) and flags.oreFarmToggle do
                            if not flags.oreFarmToggle then
                                break
                            end
                            Islands:FarmOre(flags.oreToFarm)
                        end
                    end
                )
            end
        )
    end
    local mobFarmingSection = farmingTab:NewSection("Mob Farming (Hub or VIP required)")
    do
        mobFarmingSection:NewDropdown(
            "Select Mob",
            "Selects the mob to farm",
            mobKeys,
            function(value)
                flags:SetFlag("selectedMob", mobs[value])
            end
        )
        mobFarmingSection:NewDropdown(
            "Select Weapon",
            "Selects the weapon to use",
            weaponsList,
            function(value)
                flags:SetFlag("selectedWeapon", value)
            end
        )
        mobFarmingSection:NewToggle(
            "Start Farming",
            "Starts farming the mob selected",
            function(bool)
                flags:SetFlag("mobFarmToggle", bool)
                local tool = localPlayer.Backpack[flags.selectedWeapon]

                playerChar.Humanoid:EquipTool(tool)
                task.spawn(
                    function()
                        while flags.mobFarmToggle and task.wait(0.4) do
                            local mob = Islands:SelectMob(flags.selectedMob)
                            if mob then
                                Islands:AttackMob(mob, flags.selectedMob)
                            end
                        end
                    end
                )
            end
        )
    end
end
