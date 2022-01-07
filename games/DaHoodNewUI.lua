-- // Flag System
local flags = {
    sleighColor = Color3.fromRGB(255, 0, 0),
    cashColor = Color3.fromRGB(21, 255, 0)
}
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

-- // Dependencies
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/PTrFUueU"))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- // UI Theme
Library.theme.accentcolor = Color3.new(0.011764, 0.521568, 1)
Library.theme.background = "rbxassetid://2151741365"
Library.theme.tilesize = 0.77

-- // ESP Object Listeners
if game:GetService("Workspace").Ignored:FindFirstChild("WinterMAP") then
    ESP:AddObjectListener(
        game:GetService("Workspace").Ignored.WinterMAP.Sleigh,
        {
            ColorDynamic = function()
                return flags.sleighColor
            end,
            Name = "MeshPart",
            CustomName = "Sleigh",
            IsEnabled = "Sleigh"
        }
    )
end

ESP:AddObjectListener(
    game:GetService("Workspace").Ignored.Drop,
    {
        ColorDynamic = function()
            return flags.cashColor
        end,
        Validator = function(obj)
            return obj.Name == "MeshPart" or obj.Name == "MoneyDrop"
        end,
        PrimaryPart = function(obj)
            local hrp = obj
            return hrp
        end,
        CustomName = function(obj)
            return "Dropped Cash"
        end,
        IsEnabled = "Cash"
    }
)

-- // Disable ESP Players and other stuff on load
ESP.Players = false
ESP.Tracers = false
ESP.Boxes = true
ESP.Names = true

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
    for _, cashier in ipairs(game:GetService("Workspace").Cashiers:GetChildren()) do
        if (cashier.Humanoid.Health > 0) and cashier:FindFirstChild("Head") then
            table.insert(filteredCashiers, cashier)
        end
    end
    return filteredCashiers
end

local function collectNearbyCash()
    local droppedCash = game:GetService("Workspace").Ignored.Drop
    for _, v in ipairs(droppedCash:GetDescendants()) do
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

-- // Functions
local function getToolName(name)
    for i = 1, 100000 do
        if game:GetService("Workspace").Ignored.Shop:FindFirstChild("[" .. name .. "] - $" .. i) then
            return tostring("[" .. name .. "] - $" .. i)
        end
    end
end

local function getAmmoName(name)
    for i = 1, 250 do
        for i2 = 1, 250 do
            if game:GetService("Workspace").Ignored.Shop:FindFirstChild(i .. " [" .. name .. " Ammo] - $" .. i2) then
                return tostring(i .. " [" .. name .. " Ammo] - $" .. i2)
            end
        end
    end
end

local function buyItem(name, amount, rpDelay)
    if not amount then
        amount = 1
    end

    pcall(
        function()
            if workspace.Ignored.Shop:FindFirstChild(name) then
                local oldCf = localPlayer.Character.HumanoidRootPart.CFrame
                task.wait(0.2)
                localPlayer.Character.HumanoidRootPart.CFrame =
                    game.Workspace.Ignored.Shop[name].Head.CFrame * CFrame.new(0, 4, 0)
                task.wait(0.2)
                local i = -1
                repeat
                    print(i, amount)

                    fireclickdetector(game.Workspace.Ignored.Shop[name].ClickDetector)
                    if not rpDelay then
                        task.wait()
                    else
                        task.wait(tonumber(rpDelay))
                    end

                    i = i + 1
                until i == amount + 1
                task.wait()
                localPlayer.Character.HumanoidRootPart.CFrame = oldCf
            end
        end
    )
end

local function tpPlayer(cf)
    playerChar.HumanoidRootPart.CFrame = cf
end

-- // Util Functions
local function __genOrderedIndex(t)
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert(orderedIndex, key)
    end
    table.sort(orderedIndex)
    return orderedIndex
end

local function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    local key = nil
    --print("orderedNext: state = "..tostring(state) )
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex(t)
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1, table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i + 1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

local function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end

-- // Data
local teleports = {
    AGuns = {
        "Glock",
        "SMG",
        "Silencer",
        "TacticalShotgun",
        "P90",
        "AUG",
        "Shotgun",
        "RPG",
        "AR",
        "Double-Barrel SG",
        "Flamethrower",
        "Revolver",
        "LMG",
        "AK47",
        "DrumGun",
        "Silencer",
        "GrenadeLauncher",
        "Taser",
        "SilencerAR",
        "Grenade"
    },
    Armor = {
        "High-Medium Armor",
        "Medium Armor"
    },
    Food = {
        "Cranberry",
        "Donut",
        "Pizza",
        "Chicken",
        "Popcorn",
        "Hamburger",
        "Taco",
        "Starblox Latte",
        "Lettuce",
        "Lemonade"
    },
    Masks = {
        "Ninja Mask",
        "Surgeon Mask",
        "Riot Mask",
        "Hockey Mask",
        "Breathing Mask",
        "Pumpkin Mask",
        "Skull Mask",
        "Paintball Mask"
    },
    Weights = {
        "Weights",
        "HeavyWeights"
    },
    Melees = {
        "Shovel",
        "Bat",
        "Knife",
        "Pencil",
        "StopSign",
        "Pitchfork"
    },
    Phones = {
        "iPhone",
        "iPhoneB",
        "iPhoneG",
        "iPhoneP",
        "Old Phone",
        "Orange Phone",
        "Original Phone"
    },
    Bikes = {
        "DuoBike",
        "Solo Bike"
    },
    Extras = {
        "PepperSpray",
        "LockPicker",
        "Flashlight",
        "Flowers",
        "Anti Bodies",
        "Money Gun",
        "Brown Bag",
        "Firework"
    },
    Sets = {
        ["DB Shotgun + Revolver"] = {["Double-Barrel SG"] = 5, ["Revolver"] = 5},
        ["Food Set"] = {"Pizza", "Chicken", "Popcorn"}
    }
}

local locations = {
    "Bank",
    "Boxing Place",
    "Police Station",
    "Admin Base",
    "Sewers",
    "Hood Kicks",
    "Hospital",
    "Phone Store",
    "Taco Shack",
    "Casino",
    "UFO",
    "Fire Station",
    "Church",
    "Downhill Gun Shop",
    "Uphill Gun Shop",
    "Carnival",
    "School",
    "Sewer Runoff",
    "Trailer",
    "Radioactive Area"
}

local allAnimations = {
    "Default",
    "Astronaut",
    "Zombie",
    "Bubbly",
    "Cartoony",
    "Elder",
    "Ghost",
    "Knight",
    "Levitation",
    "Mage",
    "Ninja",
    "OldSchool",
    "Pirate",
    "Popstar",
    "Princess",
    "Robot",
    "Stylish",
    "Superhero",
    "Toy",
    "Vampire",
    "Werewolf",
    "Confindent",
    "Cowboy",
    "Rthro",
    "Sneaky",
    "Patrol"
}

local animationTbl = {
    Default = {
        "http://www.roblox.com/asset/?id=507766666",
        "http://www.roblox.com/asset/?id=507766951",
        "http://www.roblox.com/asset/?id=507777826",
        "http://www.roblox.com/asset/?id=507767714",
        "http://www.roblox.com/asset/?id=507765000",
        "http://www.roblox.com/asset/?id=507765644",
        "http://www.roblox.com/asset/?id=507767968"
    },
    Elder = {
        "rbxassetid://845397899",
        "rbxassetid://845400520",
        "rbxassetid://845403856",
        "rbxassetid://845386501",
        "rbxassetid://845398858",
        "rbxassetid://845392038",
        "rbxassetid://845396048"
    },
    Ghost = {
        "rbxassetid://616006778",
        "rbxassetid://616008087",
        "rbxassetid://616013216",
        "rbxassetid://616013216",
        "rbxassetid://616008936",
        "rbxassetid://616005863",
        "rbxassetid://616012453",
        "rbxassetid://616011509"
    },
    Astronaut = {
        "rbxassetid://891621366",
        "rbxassetid://891633237",
        "rbxassetid://891667138",
        "rbxassetid://891636393",
        "rbxassetid://891627522",
        "rbxassetid://891609353",
        "rbxassetid://891617961"
    },
    Bubbly = {
        "rbxassetid://910004836",
        "rbxassetid://910009958",
        "rbxassetid://910034870",
        "rbxassetid://910025107",
        "rbxassetid://910016857",
        "rbxassetid://910001910",
        "rbxassetid://910030921",
        "rbxassetid://910028158"
    },
    Cartoony = {
        "rbxassetid://742637544",
        "rbxassetid://742638445",
        "rbxassetid://742640026",
        "rbxassetid://742638842",
        "rbxassetid://742637942",
        "rbxassetid://742636889",
        "rbxassetid://742637151"
    },
    Confindent = {
        "rbxassetid://1069977950",
        "rbxassetid://1069987858",
        "rbxassetid://1070017263",
        "rbxassetid://1070001516",
        "rbxassetid://1069984524",
        "rbxassetid://1069946257",
        "rbxassetid://1069973677"
    },
    Cowboy = {
        "rbxassetid://1014390418",
        "rbxassetid://1014398616",
        "rbxassetid://1014421541",
        "rbxassetid://1014401683",
        "rbxassetid://1014394726",
        "rbxassetid://1014380606",
        "rbxassetid://1014384571"
    },
    Knight = {
        "rbxassetid://657595757",
        "rbxassetid://657568135",
        "rbxassetid://657552124",
        "rbxassetid://657564596",
        "rbxassetid://658409194",
        "rbxassetid://658360781",
        "rbxassetid://657600338"
    },
    Levitation = {
        "rbxassetid://616006778",
        "rbxassetid://616008087",
        "rbxassetid://616013216",
        "rbxassetid://616010382",
        "rbxassetid://616008936",
        "rbxassetid://616003713",
        "rbxassetid://616005863"
    },
    Mage = {
        "rbxassetid://707742142",
        "rbxassetid://707855907",
        "rbxassetid://707897309",
        "rbxassetid://707861613",
        "rbxassetid://707853694",
        "rbxassetid://707826056",
        "rbxassetid://707829716"
    },
    Ninja = {
        "rbxassetid://656117400",
        "rbxassetid://656118341",
        "rbxassetid://656121766",
        "rbxassetid://656118852",
        "rbxassetid://656117878",
        "rbxassetid://656114359",
        "rbxassetid://656115606"
    },
    OldSchool = {
        "rbxassetid://5319828216",
        "rbxassetid://5319831086",
        "rbxassetid://5319847204",
        "rbxassetid://5319844329",
        "rbxassetid://5319841935",
        "rbxassetid://5319839762",
        "rbxassetid://5319852613",
        "rbxassetid://5319850266"
    },
    Patrol = {
        "rbxassetid://1149612882",
        "rbxassetid://1150842221",
        "rbxassetid://1151231493",
        "rbxassetid://1150967949",
        "rbxassetid://1148811837",
        "rbxassetid://1148811837",
        "rbxassetid://1148863382"
    },
    Pirtate = {
        "rbxassetid://750781874",
        "rbxassetid://750782770",
        "rbxassetid://750785693",
        "rbxassetid://750783738",
        "rbxassetid://750782230",
        "rbxassetid://750779899",
        "rbxassetid://750780242"
    },
    Popstar = {
        "rbxassetid://1212900985",
        "rbxassetid://1150842221",
        "rbxassetid://1212980338",
        "rbxassetid://1212980348",
        "rbxassetid://1212954642",
        "rbxassetid://1213044953",
        "rbxassetid://1212900995"
    },
    Princess = {
        "rbxassetid://941003647",
        "rbxassetid://941013098",
        "rbxassetid://941028902",
        "rbxassetid://941015281",
        "rbxassetid://941008832",
        "rbxassetid://940996062",
        "rbxassetid://941000007"
    },
    Robot = {
        "rbxassetid://616088211",
        "rbxassetid://616089559",
        "rbxassetid://616095330",
        "rbxassetid://616091570",
        "rbxassetid://616090535",
        "rbxassetid://616086039",
        "rbxassetid://616087089"
    },
    Rthro = {
        "rbxassetid://2510196951",
        "rbxassetid://2510197257",
        "rbxassetid://2510202577",
        "rbxassetid://2510198475",
        "rbxassetid://2510197830",
        "rbxassetid://2510195892",
        "rbxassetid://02510201162",
        "rbxassetid://2510199791",
        "rbxassetid://2510192778"
    },
    Sneaky = {
        "rbxassetid://1132473842",
        "rbxassetid://1132477671",
        "rbxassetid://1132510133",
        "rbxassetid://1132494274",
        "rbxassetid://1132489853",
        "rbxassetid://1132461372",
        "rbxassetid://1132469004"
    },
    Stylish = {
        "rbxassetid://616136790",
        "rbxassetid://616138447",
        "rbxassetid://616146177",
        "rbxassetid://616140816",
        "rbxassetid://616139451",
        "rbxassetid://616133594",
        "rbxassetid://616134815"
    },
    Superhero = {
        "rbxassetid://782841498",
        "rbxassetid://782845736",
        "rbxassetid://782843345",
        "rbxassetid://782842708",
        "rbxassetid://782847020",
        "rbxassetid://782843869",
        "rbxassetid://782846423"
    },
    Toy = {
        "rbxassetid://782841498",
        "rbxassetid://782845736",
        "rbxassetid://782843345",
        "rbxassetid://782842708",
        "rbxassetid://782847020",
        "rbxassetid://782843869",
        "rbxassetid://782846423"
    },
    Vampire = {
        "rbxassetid://1083445855",
        "rbxassetid://1083450166",
        "rbxassetid://1083473930",
        "rbxassetid://1083462077",
        "rbxassetid://1083455352",
        "rbxassetid://1083439238",
        "rbxassetid://1083443587"
    },
    Werewolf = {
        "rbxassetid://1083195517",
        "rbxassetid://1083214717",
        "rbxassetid://1083178339",
        "rbxassetid://1083216690",
        "rbxassetid://1083218792",
        "rbxassetid://1083182000",
        "rbxassetid://1083189019"
    },
    Zombie = {
        "rbxassetid://616158929",
        "rbxassetid://616160636",
        "rbxassetid://616168032",
        "rbxassetid://616163682",
        "rbxassetid://616161997",
        "rbxassetid://616156119",
        "rbxassetid://616157476"
    }
}

--[[
local animationValues = {
    idle = "Default",
    walk = "Default",
    run = "Default",
    jump = "Default",
    climb = "Default",
    fall = "Default"
}
]]
local selectedSets = {}

-- // UI Components
local Window = Library:CreateWindow("Floppa Hub", Vector2.new(492, 598), Enum.KeyCode.RightShift)
do
    local playerTab = Window:CreateTab("Player")
    do
        local animationsSection = playerTab:CreateSector("Animations", "right")
        do
            animationsSection:AddDropdown(
                "Select Animation Pack",
                allAnimations,
                allAnimations[1],
                false,
                function()
                end,
                "selectedAnim"
            )
            animationsSection:AddButton(
                "Apply Animation",
                function()
                    local anims = animationTbl[Library.flags.selectedAnim]
                    if anims then
                        localPlayer.Character.Animate.idle.Animation1.AnimationId = anims[1]
                        localPlayer.Character.Animate.idle.Animation2.AnimationId = anims[2]
                        localPlayer.Character.Animate.walk.WalkAnim.AnimationId = anims[3]
                        localPlayer.Character.Animate.run.RunAnim.AnimationId = anims[4]
                        localPlayer.Character.Animate.jump.JumpAnim.AnimationId = anims[5]
                        localPlayer.Character.Animate.climb.ClimbAnim.AnimationId = anims[6]
                        localPlayer.Character.Animate.fall.FallAnim.AnimationId = anims[7]
                    end
                end
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
                "Cash ESP",
                false,
                function(bool)
                    ESP.Cash = bool
                end
            ):AddColorpicker(
                flags.cashColor,
                function(color)
                    flags.cashColor = color
                end
            )
            if game:GetService("Workspace").Ignored:FindFirstChild("WinterMAP") then
                espSec:AddToggle(
                    "Sleigh ESP",
                    false,
                    function(bool)
                        ESP.Sleigh = bool
                    end
                ):AddColorpicker(
                    flags.sleighColor,
                    function(color)
                        flags.sleighColor = color
                    end
                )
            end

            espSec:AddSeperator("ESP Options")

            espSec:AddToggle(
                "Team Color",
                true,
                function(bool)
                    ESP.TeamColor = bool
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
        local buyingTab = Window:CreateTab("Buying")
        do
            local i = 1

            for teleportName, teleportTbl in orderedPairs(teleports) do
                local isEven = i % 2 == 0
                if teleportName ~= "Locations" then
                    if teleportName == "AGuns" then
                        teleportName = teleportName:sub(2)
                    end

                    local sector = buyingTab:CreateSector(teleportName .. " Buys", isEven and "right" or "left")

                    if teleportName == "Sets" then
                        for set, _ in pairs(teleportTbl) do
                            sector:AddToggle(
                                set,
                                false,
                                function(bool)
                                    local isSetInTbl = table.find(selectedSets, set)
                                    if bool and not isSetInTbl then
                                        print("True toggle, set isnt in table")
                                        table.insert(selectedSets, set)
                                    elseif not bool and isSetInTbl then
                                        print("False toggle, set is in table")
                                        local idx = table.find(selectedSets, set)
                                        if idx then
                                            selectedSets[idx] = nil
                                        end
                                    end
                                end
                            )
                        end
                        sector:AddButton(
                            "Buy Toggled Sets",
                            function()
                                for _, setName in ipairs(selectedSets) do
                                    local set = teleports.Sets[setName]
                                    for itemName, ammo in pairs(set) do
                                        print("Buying " .. itemName)
                                        if type(itemName) == "number" then
                                            buyItem(getToolName(ammo), 1, 0.1)
                                        end

                                        if type(ammo) == "number" then
                                            buyItem(getAmmoName(itemName), ammo + 12, 0.2)
                                        end
                                        task.wait(0.1)
                                    end
                                end
                            end
                        )
                    end

                    if teleportTbl and teleportName ~= "Sets" then
                        sector:AddDropdown(
                            "Item to buy",
                            teleportTbl,
                            teleportTbl[1],
                            false,
                            function()
                            end,
                            teleportName .. "Item"
                        )
                        sector:AddButton(
                            "Buy Chosen",
                            function()
                                buyItem(getToolName(Library.flags[teleportName .. "Item"]), 0)
                            end
                        )
                        if teleportName == "Guns" then
                            sector:AddSeperator("Ammo")
                            sector:AddSlider("Amount To Buy", 1, 1, 25, 1, "amountOfAmmo")
                            sector:AddButton(
                                "Buy Ammo For Gun",
                                function()
                                    local ammoFlag = tonumber(Library.flags.amountOfAmmo or 1)
                                    if Library.flags["GunsItem"] then
                                        buyItem(getAmmoName(Library.flags["GunsItem"]), ammoFlag + 12, 0.2)
                                    end
                                end
                            )
                        end
                    end
                    i = i + 1
                end
            end
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
